/**
 * QA Utilities for functional testing
 */

interface QACheck {
  name: string;
  route: string;
  role: 'admin' | 'cliente_master' | 'cliente_gerente_sucursal';
  checks: Array<{
    description: string;
    test: () => boolean | Promise<boolean>;
  }>;
}

export const QA_CHECKS: QACheck[] = [
  {
    name: 'Admin Dashboard',
    route: '/admin/resumen',
    role: 'admin',
    checks: [
      {
        description: 'KPIs load without errors',
        test: () => document.querySelector('[data-testid="stat-card"]') !== null
      },
      {
        description: 'Navigation sidebar visible',
        test: () => document.querySelector('nav') !== null
      }
    ]
  },
  {
    name: 'Admin Products',
    route: '/admin/productos',
    role: 'admin',
    checks: [
      {
        description: 'Products table loads',
        test: () => document.querySelector('table') !== null
      },
      {
        description: 'Create button available',
        test: () => document.querySelector('button:contains("Nuevo Producto")') !== null
      }
    ]
  },
  {
    name: 'Master Dashboard',
    route: '/mi-empresa/resumen',
    role: 'cliente_master',
    checks: [
      {
        description: 'Company stats visible',
        test: () => document.querySelector('[data-testid="stat-card"]') !== null
      },
      {
        description: 'Recent orders section exists',
        test: () => document.querySelector('h3:contains("Órdenes Recientes")') !== null
      }
    ]
  },
  {
    name: 'Gerente New Order',
    route: '/mi-sucursal/nuevo-pedido',
    role: 'cliente_gerente_sucursal',
    checks: [
      {
        description: 'Product catalog loads',
        test: () => document.querySelector('[data-testid="product-grid"]') !== null
      },
      {
        description: 'Order cart is visible',
        test: () => document.querySelector('[data-testid="order-cart"]') !== null
      }
    ]
  }
];

export function runQACheck(check: QACheck): Promise<boolean> {
  return new Promise(async (resolve) => {
    console.log(`🧪 Running QA check: ${check.name}`);
    
    try {
      for (const test of check.checks) {
        console.log(`  ✓ Testing: ${test.description}`);
        const result = await test.test();
        if (!result) {
          console.error(`  ❌ Failed: ${test.description}`);
          resolve(false);
          return;
        }
      }
      console.log(`  ✅ All tests passed for: ${check.name}`);
      resolve(true);
    } catch (error) {
      console.error(`  ❌ Error in QA check: ${check.name}`, error);
      resolve(false);
    }
  });
}

export function logPageLoad(pageName: string, role?: string) {
  console.debug(`qa:page:${pageName}`, role ? `role:${role}` : 'public');
}

export function logUserAction(action: string, entity?: string, success: boolean = true) {
  console.debug(`qa:action:${action}`, entity ? `entity:${entity}` : '', success ? 'ok' : 'err');
}