export const CART_STORAGE_KEY = "cafefausse_collection_cart_v3";

export function readCart() {
  localStorage.removeItem("cafecart");
  try {
    return JSON.parse(sessionStorage.getItem(CART_STORAGE_KEY) || "[]");
  } catch {
    sessionStorage.removeItem(CART_STORAGE_KEY);
    return [];
  }
}

export function writeCart(items) {
  sessionStorage.setItem(CART_STORAGE_KEY, JSON.stringify(items));
}

export function clearCart() {
  sessionStorage.removeItem(CART_STORAGE_KEY);
  // Remove the legacy key that caused old test items to reappear.
  localStorage.removeItem("cafecart");
}
