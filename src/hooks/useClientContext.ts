import { useEffect, useRef, useState } from 'react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import type { ClientUser, Client, ClientBranch } from '../types/auth';

interface ClientContextData {
  clientUsers: ClientUser[];
  clients: Client[];
  branches: ClientBranch[];
  selectedClientId: string | null;
  selectedBranchId: string | null;
  isLoading: boolean;
  error: string | null;
  setSelectedClientId: (clientId: string | null) => void;
  setSelectedBranchId: (branchId: string | null) => void;
}

const LS_KEY = 'clientCtx_v1';

export function useClientContext(): ClientContextData {
  const { user, profile } = useAuth();

  const [clientUsers, setClientUsers] = useState<ClientUser[]>([]);
  const [clients, setClients] = useState<Client[]>([]);
  const [branches, setBranches] = useState<ClientBranch[]>([]);

  const [selectedClientId, setSelectedClientId] = useState<string | null>(null);
  const [selectedBranchId, setSelectedBranchId] = useState<string | null>(null);

  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Evitar setState después de unmount
  const mountedRef = useRef(true);
  useEffect(() => {
    mountedRef.current = true;
    return () => {
      mountedRef.current = false;
    };
  }, []);

  // Restaurar última selección guardada (mejora UX entre páginas)
  useEffect(() => {
    const raw = localStorage.getItem(LS_KEY);
    if (raw) {
      try {
        const parsed = JSON.parse(raw);
        if (parsed?.clientId) setSelectedClientId(parsed.clientId);
        if (parsed?.branchId) setSelectedBranchId(parsed.branchId);
      } catch {}
    }
  }, []);

  // Guardar selección cuando cambie
  useEffect(() => {
    localStorage.setItem(
      LS_KEY,
      JSON.stringify({ clientId: selectedClientId, branchId: selectedBranchId })
    );
  }, [selectedClientId, selectedBranchId]);

  useEffect(() => {
    // Cargar contexto solo para Master/Gerente
    if (
      user &&
      (profile?.role_app === 'cliente_master' || profile?.role_app === 'cliente_gerente_sucursal')
    ) {
      loadClientContext();
    } else {
      // roles que no necesitan contexto
      setIsLoading(false);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [user?.id, profile?.role_app]);

  const safeSet = <T,>(setter: (v: T) => void, v: T) => {
    if (mountedRef.current) setter(v);
  };

  const loadClientContext = async () => {
    if (!user) return;

    try {
      safeSet(setIsLoading, true);
      safeSet(setError, null);

      console.debug('useClientContext:load:start', { userId: user.id, role: profile?.role_app });

      // 1) client_users (sin embeds para evitar choques con RLS)
      const { data: cuRows, error: cuErr } = await supabase
        .from('client_users')
        .select('id, client_id, branch_id, user_id, role_in_client, created_at')
        .eq('user_id', user.id)
        .order('created_at', { ascending: false });

      if (cuErr) throw cuErr;

      const myClientUsers: ClientUser[] = (cuRows || []).map((r: any) => ({
        ...r,
        user_profiles: null,
        client_branches: null,
      }));

      safeSet(setClientUsers, myClientUsers);

      if (myClientUsers.length === 0) {
        // Usuario sin asignaciones
        safeSet(setClients, []);
        safeSet(setBranches, []);
        safeSet(setSelectedClientId, null);
        safeSet(setSelectedBranchId, null);
        return;
      }

      // 2) obtener clients + branches para los client_ids involucrados
      const clientIds = Array.from(new Set(myClientUsers.map((cu) => cu.client_id).filter(Boolean)));

      const [clientsRes, branchesRes] = await Promise.all([
        supabase.from('clients').select('id, name, tax_id, billing_email').in('id', clientIds as string[]),
        supabase
          .from('client_branches')
          .select('id, client_id, name, code, address, created_at')
          .in('client_id', clientIds as string[]),
      ]);

      if (clientsRes.error) throw clientsRes.error;
      if (branchesRes.error) throw branchesRes.error;

      const clientsData = (clientsRes.data || []) as Client[];
      const branchesData = (branchesRes.data || []) as ClientBranch[];

      safeSet(setClients, clientsData);
      safeSet(setBranches, branchesData);

      // 3) Calcular selección inicial con LOS DATOS RECIÉN TRAÍDOS (no con el estado aún vacío)
      let nextClientId: string | null = selectedClientId;
      let nextBranchId: string | null = selectedBranchId;

      if (profile?.role_app === 'cliente_gerente_sucursal') {
        const ger = myClientUsers.find((cu) => cu.role_in_client === 'gerente_sucursal') || myClientUsers[0];
        nextClientId = ger?.client_id ?? null;
        nextBranchId = ger?.branch_id ?? null;
      } else {
        // Master
        const firstCU = myClientUsers[0];
        // Si no hay client seleccionado o el actual no existe en clientsData, tomar el primero válido
        if (!nextClientId || !clientsData.some((c) => c.id === nextClientId)) {
          nextClientId = firstCU?.client_id ?? null;
        }
        // Branch: si no hay o no pertenece al cliente, tomar la primera del cliente (o null si no hay)
        const branchBelongs =
          nextClientId && nextBranchId
            ? branchesData.some((b) => b.id === nextBranchId && b.client_id === nextClientId)
            : false;

        if (!branchBelongs) {
          const firstBranch = nextClientId
            ? branchesData.find((b) => b.client_id === nextClientId)
            : undefined;
          nextBranchId = firstBranch?.id ?? null;
        }
      }

      safeSet(setSelectedClientId, nextClientId);
      safeSet(setSelectedBranchId, nextBranchId);

      console.debug('useClientContext:select', { nextClientId, nextBranchId });
    } catch (err: any) {
      console.error('useClientContext:load:error', err);
      safeSet(setError, err?.message || 'Error cargando contexto de cliente');
      safeSet(setClientUsers, []);
      safeSet(setClients, []);
      safeSet(setBranches, []);
      safeSet(setSelectedClientId, null);
      safeSet(setSelectedBranchId, null);
    } finally {
      safeSet(setIsLoading, false);
    }
  };

  return {
    clientUsers,
    clients,
    branches,
    selectedClientId,
    selectedBranchId,
    isLoading,
    error,
    setSelectedClientId,
    setSelectedBranchId,
  };
}