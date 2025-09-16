import type { ToastData } from '../components/UI/Toast';

export function showToast(data: Omit<ToastData, 'id'>) {
  const event = new CustomEvent('toast', {
    detail: data
  });
  window.dispatchEvent(event);
}

export function showSuccess(title: string, message?: string) {
  showToast({
    type: 'success',
    title,
    message,
    duration: 4000
  });
}

export function showError(title: string, message?: string) {
  showToast({
    type: 'error',
    title,
    message,
    duration: 6000
  });
}

export function showInfo(title: string, message?: string) {
  showToast({
    type: 'info',
    title,
    message,
    duration: 4000
  });
}

export function showWarning(title: string, message?: string) {
  showToast({
    type: 'warning',
    title,
    message,
    duration: 5000
  });
}