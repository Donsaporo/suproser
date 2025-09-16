import React, { createContext, useContext, useEffect, useState } from 'react';
import { User, Session } from '@supabase/supabase-js';
import { supabase } from '../lib/supabase';
import type { UserProfile } from '../types/auth';
import { useNavigate } from 'react-router-dom';

// Demo users for when Supabase is not available
const DEMO_USERS = [
  {
    email: 'admin.demo@suproser.app',
    password: 'Demo123$!',
    profile: {
      user_id: 'admin-demo-id',
      display_name: 'Admin Demo',
      role_app: 'admin' as const,
      phone: null,
      created_at: new Date().toISOString()
    }
  },
  {
    email: 'master.demo@clientedemo.app', 
    password: 'Demo123$!',
    profile: {
      user_id: 'master-demo-id',
      display_name: 'Master Demo',
      role_app: 'cliente_master' as const,
      phone: null,
      created_at: new Date().toISOString()
    }
  },
  {
    email: 'gerente.rioabajo.demo@clientedemo.app',
    password: 'Demo123$!', 
    profile: {
      user_id: 'gerente-demo-id',
      display_name: 'Gerente Río Abajo Demo',
      role_app: 'cliente_gerente_sucursal' as const,
      phone: null,
      created_at: new Date().toISOString()
    }
  }
];

interface AuthContextType {
  user: User | null;
  profile: UserProfile | null;
  session: Session | null;
  loading: boolean;
  isInitialized: boolean;
  signUp: (email: string, password: string, displayName?: string) => Promise<{ error: any }>;
  signIn: (email: string, password: string) => Promise<{ error: any }>;
  signOut: () => Promise<{ error: any }>;
  resetPassword: (email: string) => Promise<{ error: any }>;
  refreshProfile: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}

interface AuthProviderProps {
  children: React.ReactNode;
}

export function AuthProvider({ children }: AuthProviderProps) {
  const [user, setUser] = useState<User | null>(null);
  const [profile, setProfile] = useState<UserProfile | null>(null);
  const [session, setSession] = useState<Session | null>(null);
  const [loading, setLoading] = useState(true);
  const [isInitialized, setIsInitialized] = useState(false);
  const [isDemoMode, setIsDemoMode] = useState(false);

  useEffect(() => {
    if (isInitialized) return;
    
    const initAuth = () => {
      console.debug('auth:init:start', 'Checking existing session...');
      setLoading(true);
      
      // Try Supabase first, but with quick timeout
      const timeoutPromise = new Promise((_, reject) => {
        setTimeout(() => reject(new Error('Init timeout')), 3000);
      });
      
      const supabasePromise = supabase.auth.getSession();
      
      Promise.race([supabasePromise, timeoutPromise])
        .then(({ data: { session } }) => {
          console.debug('auth:init:supabase-ok', { hasSession: !!session, userId: session?.user?.id });
          setSession(session);
          setUser(session?.user ?? null);
          if (session?.user) {
            loadProfile(session.user.id).finally(() => {
              setIsInitialized(true);
            });
          } else {
            console.debug('auth:init:no-user');
            setIsInitialized(true);
            setLoading(false);
          }
        })
        .catch((error) => {
          console.debug('auth:init:demo-mode', error.message);
          setIsDemoMode(true);
          setUser(null);
          setSession(null);
          setProfile(null);
          setIsInitialized(true);
          setLoading(false);
        });
    };
    
    initAuth();

    // Only set up auth listener if not in demo mode
    let subscription: any = null;
    
    // Set up auth state listener
    const setupAuthListener = () => {
      if (isDemoMode) return;
      
      supabase.auth.onAuthStateChange(async (event, session) => {
        console.debug('auth:state-change', { event, hasSession: !!session });
        
        if (event === 'SIGNED_IN') {
          console.debug('auth:signed-in', session?.user?.email);
          setSession(session);
          setUser(session?.user ?? null);
          
          if (session?.user) {
            await loadProfile(session.user.id);
            // Redirect after successful sign in
            redirectAfterSignIn();
          } else {
            setProfile(null);
          }
        } else if (event === 'SIGNED_OUT') {
          console.debug('auth:signed-out');
          setSession(null);
          setUser(null);
          setProfile(null);
        }
        
        setLoading(false);
      }).then(({ data: { subscription: sub } }) => {
        subscription = sub;
      }).catch((error) => {
        console.debug('auth:listener-failed', error);
        setLoading(false);
      });
    };
    
    if (isInitialized && !isDemoMode) {
      setupAuthListener();
    }

    return () => {
      if (subscription) {
        try {
          subscription.unsubscribe();
        } catch (error) {
          console.debug('auth:cleanup-error', error);
        }
      }
    };
  }, [isInitialized, isDemoMode]);

  const redirectAfterSignIn = () => {
    if (!profile?.role_app) return;
    
    console.debug('auth:redirect', { role: profile.role_app });
    
    const dashboardMap = {
      'admin': '/admin/resumen',
      'cliente_master': '/cliente/master/resumen', 
      'cliente_gerente_sucursal': '/cliente/gerente/resumen'
    };
    
    const targetPath = dashboardMap[profile.role_app];
    if (targetPath) {
      window.location.href = targetPath;
    }
  };

  const loadProfile = async (userId: string) => {
    if (isDemoMode) {
      setLoading(false);
      return;
    }
    
    try {
      console.debug('auth:profile:load:start', userId);
      const { data, error } = await supabase
        .from('user_profiles')
        .select('*')
        .eq('user_id', userId)
        .single();

      if (error && error.code === 'PGRST116') {
        console.debug('auth:profile:create:start', 'Profile not found, creating...');
        const { data: newProfile, error: createError } = await supabase
          .from('user_profiles')
          .insert({
            user_id: userId,
            display_name: null,
            role_app: 'cliente_gerente_sucursal' // Default role
          })
          .select()
          .single();

        if (createError) {
          console.error('auth:profile:create:err', createError);
        } else {
          console.debug('auth:profile:create:ok', newProfile.role_app);
          setProfile(newProfile);
        }
      } else if (error) {
        console.error('auth:profile:load:err', error);
      } else {
        console.debug('auth:profile:load:ok', data.role_app);
        setProfile(data);
      }
    } catch (error) {
      console.error('auth:profile:unexpected:err', error);
    } finally {
      setLoading(false);
    }
  };

  const refreshProfile = async () => {
    if (user) {
      // In demo mode, profile is already set
      if (isDemoMode) {
        return;
      }
      
      // Normal Supabase profile refresh
      await loadProfile(user.id);
    }
  };

  const signUp = async (email: string, password: string, displayName?: string) => {
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
    });

    if (!error && data.user) {
      // Create profile with display name
      const { error: profileError } = await supabase
        .from('user_profiles')
        .insert({
          user_id: data.user.id,
          display_name: displayName || null,
          role_app: 'cliente_gerente_sucursal'
        });

      if (profileError) {
        console.error('Error creating profile:', profileError);
      }
    }

    return { error };
  };

  const signIn = async (email: string, password: string) => {
    console.debug('auth:signin:start', { email });
    
    // Demo mode - check credentials immediately
    if (isDemoMode) {
      console.debug('auth:signin:demo-mode');
      const demoUser = DEMO_USERS.find(u => u.email === email && u.password === password);
      
      if (demoUser) {
        console.debug('auth:signin:demo-ok');
        const mockUser = { id: demoUser.profile.user_id, email } as User;
        const mockSession = { user: mockUser } as Session;
        
        setUser(mockUser);
        setSession(mockSession);
        setProfile(demoUser.profile);
        setLoading(false);
        
        // Redirect after demo login
        setTimeout(() => {
          setTimeout(() => redirectAfterSignIn(), 100);
        }, 100);
        
        return { error: null };
      } else {
        console.debug('auth:signin:demo-failed');
        return { error: { message: 'Credenciales inválidas' } as any };
      }
    }
    
    try {
      console.debug('auth:signin:supabase-attempt');
      
      // Shorter timeout for login attempts
      const timeoutPromise = new Promise<any>((_, reject) => {
        setTimeout(() => reject(new Error('Login timeout')), 5000);
      });
      
      const loginPromise = supabase.auth.signInWithPassword({ 
        email, 
        password 
      });
      
      const result = await Promise.race([loginPromise, timeoutPromise]);
      
      console.debug('auth:signin:supabase-ok', { hasUser: !!result.data?.user });
      
      // Note: Redirection will be handled by the auth state change listener
      return result;
    } catch (error) {
      console.debug('auth:signin:timeout', error.message);
      
      // If timeout or network error, switch to demo mode for this session
      if (error instanceof Error && 
          (error.message.includes('timeout') || error.message.includes('Failed to fetch'))) {
        console.debug('auth:signin:fallback-to-demo');
        setIsDemoMode(true);
        
        // Retry with demo mode
        return await signIn(email, password);
      }
      return { error: error as any };
    }
  };

  const signOut = async () => {
    try {
      console.debug('auth:signout:start');
      // Demo mode signout
      if (isDemoMode) {
        console.debug('auth:signout:demo');
        setProfile(null);
        setUser(null);
        setSession(null);
        setLoading(false);
        // Redirect to home
        window.location.href = '/';
        return { error: null };
      }
      
      // Normal Supabase signout
      const { error } = await supabase.auth.signOut();
      
      if (!error) {
        console.debug('auth:signout:ok');
        // Clear all auth state immediately
        setProfile(null);
        setUser(null);
        setSession(null);
        // Redirect to home
        window.location.href = '/';
      } else {
        console.error('auth:signout:err', error);
      }
      
      return { error };
    } catch (error) {
      console.error('auth:signout:unexpected', error);
      return { error: error as any };
    }
  };

  const resetPassword = async (email: string) => {
    // Demo mode - just return success
    if (isDemoMode) {
      return { error: null };
    }
    
    // Normal Supabase password reset
    return await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: `${window.location.origin}/reset-password`
    });
  };

  const value = {
    user,
    profile,
    session,
    loading,
    isInitialized,
    signUp,
    signIn,
    signOut,
    resetPassword,
    refreshProfile
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}