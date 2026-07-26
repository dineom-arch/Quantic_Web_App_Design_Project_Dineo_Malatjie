import React, {
  useEffect,
  useMemo,
  useRef,
  useState,
} from "react";

import { useNavigate, useSearchParams } from "react-router-dom";

import api from "../api";
import Card from "../components/Card";
import { formatRandFromCents } from "../utils/currency";
import { readCart, writeCart } from "../utils/cart";

export default function Order() {
  const [menu, setMenu] = useState([]);
  const [cart, setCart] = useState(() =>
    readCart().map(({ menu_item_id, quantity }) => ({ menu_item_id, quantity }))
  );
  const [cartOpen, setCartOpen] = useState(false);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const selectedItemId = Number(searchParams.get("item"));
  const cartContainerRef = useRef(null);

  useEffect(() => {
    api
      .get("/menu")
      .then((response) => {
        setMenu(response.data);
        setError("");
      })
      .catch((error) => {
        console.error("Unable to load menu.", error);

        setError(
          "The menu could not be loaded. Please make sure the backend server is running."
        );
      })
      .finally(() => {
        setLoading(false);
      });
  }, []);

  useEffect(() => {
    if (!loading && selectedItemId) {
      document.getElementById(`menu-item-${selectedItemId}`)?.scrollIntoView({
        behavior: "smooth",
        block: "center",
      });
    }
  }, [loading, selectedItemId]);

  useEffect(() => {
    const handleOutsideClick = (event) => {
      if (
        cartContainerRef.current &&
        !cartContainerRef.current.contains(event.target)
      ) {
        setCartOpen(false);
      }
    };

    document.addEventListener("mousedown", handleOutsideClick);

    return () => {
      document.removeEventListener(
        "mousedown",
        handleOutsideClick
      );
    };
  }, []);

  const addToCart = (item) => {
    setCart((currentCart) => {
      const existingItem = currentCart.find(
        (cartItem) => cartItem.menu_item_id === item.id
      );

      if (existingItem) {
        return currentCart.map((cartItem) =>
          cartItem.menu_item_id === item.id
            ? {
                ...cartItem,
                quantity: cartItem.quantity + 1,
              }
            : cartItem
        );
      }

      return [
        ...currentCart,
        {
          menu_item_id: item.id,
          quantity: 1,
        },
      ];
    });
  };

  const increaseQuantity = (itemId) => {
    setCart((currentCart) =>
      currentCart.map((cartItem) =>
        cartItem.menu_item_id === itemId
          ? {
              ...cartItem,
              quantity: cartItem.quantity + 1,
            }
          : cartItem
      )
    );
  };

  const decreaseQuantity = (itemId) => {
    setCart((currentCart) =>
      currentCart
        .map((cartItem) =>
          cartItem.menu_item_id === itemId
            ? {
                ...cartItem,
                quantity: cartItem.quantity - 1,
              }
            : cartItem
        )
        .filter((cartItem) => cartItem.quantity > 0)
    );
  };

  const removeFromCart = (itemId) => {
    setCart((currentCart) =>
      currentCart.filter(
        (cartItem) => cartItem.menu_item_id !== itemId
      )
    );
  };

  const cartItems = useMemo(() => {
    return cart
      .map((cartItem) => {
        const menuItem = menu.find(
          (item) => item.id === cartItem.menu_item_id
        );

        if (!menuItem) {
          return null;
        }

        return {
          ...cartItem,
          name: menuItem.name,
          price_cents: menuItem.price_cents,
          line_total_cents:
            menuItem.price_cents * cartItem.quantity,
        };
      })
      .filter(Boolean);
  }, [cart, menu]);

  const totalQuantity = useMemo(() => {
    return cart.reduce(
      (total, item) => total + item.quantity,
      0
    );
  }, [cart]);

  const cartTotalCents = useMemo(() => {
    return cartItems.reduce(
      (total, item) => total + item.line_total_cents,
      0
    );
  }, [cartItems]);

  const toggleCart = () => {
    setCartOpen((currentValue) => !currentValue);
  };

  const proceedToCheckout = () => {
    if (cart.length === 0) {
      return;
    }

    writeCart(cartItems);

    navigate("/checkout", {
      state: {
        cart,
        cartTotalCents,
      },
    });
  };

  return (
    <main className="online-order-page">
      <div className="container">
        {/* =====================================================
            Page heading and compact cart button
        ===================================================== */}

        <div className="online-order-topbar">
          <div className="online-order-heading">
            <span className="section-label">
              CAFÉ FAUSSE
            </span>

            <h1>Order Online</h1>

            <p>
              Select your favourites and review your order before
              proceeding to checkout.
            </p>
          </div>

          <div
            className="compact-cart-container"
            ref={cartContainerRef}
          >
            <button
              type="button"
              className="compact-cart-button"
              aria-label={`Open cart containing ${totalQuantity} ${
                totalQuantity === 1 ? "item" : "items"
              }`}
              aria-expanded={cartOpen}
              onClick={toggleCart}
            >
              <svg
                className="compact-cart-icon"
                viewBox="0 0 24 24"
                aria-hidden="true"
              >
                <path
                  d="M3 4h2l2.2 9.1a2 2 0 0 0 2 1.5h7.7a2 2 0 0 0 1.9-1.4L20.5 7H6"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="1.8"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />

                <circle
                  cx="9.5"
                  cy="19"
                  r="1.2"
                  fill="currentColor"
                />

                <circle
                  cx="17.5"
                  cy="19"
                  r="1.2"
                  fill="currentColor"
                />
              </svg>

              <span className="compact-cart-label">
                Cart
              </span>

              <span className="compact-cart-count">
                {totalQuantity}
              </span>
            </button>

            {/* =================================================
                Expandable cart summary
            ================================================= */}

            {cartOpen && (
              <aside
                className="cart-popover"
                aria-labelledby="cart-summary-heading"
              >
                <div className="cart-popover-header">
                  <div>
                    <span className="cart-popover-eyebrow">
                      ORDER SUMMARY
                    </span>

                    <h2 id="cart-summary-heading">
                      Your Cart
                    </h2>
                  </div>

                  <button
                    type="button"
                    className="cart-close-button"
                    aria-label="Close cart"
                    onClick={() => setCartOpen(false)}
                  >
                    ×
                  </button>
                </div>

                {cartItems.length === 0 ? (
                  <div className="cart-empty-state">
                    <svg
                      className="cart-empty-icon"
                      viewBox="0 0 24 24"
                      aria-hidden="true"
                    >
                      <path
                        d="M3 4h2l2.2 9.1a2 2 0 0 0 2 1.5h7.7a2 2 0 0 0 1.9-1.4L20.5 7H6"
                        fill="none"
                        stroke="currentColor"
                        strokeWidth="1.6"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      />

                      <circle
                        cx="9.5"
                        cy="19"
                        r="1.2"
                        fill="currentColor"
                      />

                      <circle
                        cx="17.5"
                        cy="19"
                        r="1.2"
                        fill="currentColor"
                      />
                    </svg>

                    <h3>Your cart is empty</h3>

                    <p>
                      Add an item from the menu to begin your
                      order.
                    </p>
                  </div>
                ) : (
                  <>
                    <div className="cart-popover-items">
                      {cartItems.map((item) => (
                        <article
                          className="cart-popover-item"
                          key={item.menu_item_id}
                        >
                          <div className="cart-item-information">
                            <h3>{item.name}</h3>

                            <span className="cart-item-unit-price">
                              {formatRandFromCents(
                                item.price_cents
                              )}{" "}
                              each
                            </span>

                            <div
                              className="cart-quantity-control"
                              aria-label={`Quantity for ${item.name}`}
                            >
                              <button
                                type="button"
                                aria-label={`Decrease ${item.name} quantity`}
                                onClick={() =>
                                  decreaseQuantity(
                                    item.menu_item_id
                                  )
                                }
                              >
                                −
                              </button>

                              <span>{item.quantity}</span>

                              <button
                                type="button"
                                aria-label={`Increase ${item.name} quantity`}
                                onClick={() =>
                                  increaseQuantity(
                                    item.menu_item_id
                                  )
                                }
                              >
                                +
                              </button>
                            </div>
                          </div>

                          <div className="cart-item-summary">
                            <strong>
                              {formatRandFromCents(
                                item.line_total_cents
                              )}
                            </strong>

                            <button
                              type="button"
                              className="cart-remove-button"
                              onClick={() =>
                                removeFromCart(
                                  item.menu_item_id
                                )
                              }
                            >
                              Remove
                            </button>
                          </div>
                        </article>
                      ))}
                    </div>

                    <div className="cart-popover-totals">
                      <div className="cart-summary-row">
                        <span>Subtotal</span>

                        <span>
                          {formatRandFromCents(
                            cartTotalCents
                          )}
                        </span>
                      </div>

                      <div className="cart-summary-row">
                        <span>Collection</span>
                        <span>Free</span>
                      </div>

                      <div className="cart-total-row">
                        <span>Order Total</span>

                        <strong>
                          {formatRandFromCents(
                            cartTotalCents
                          )}
                        </strong>
                      </div>
                    </div>

                    <button
                      type="button"
                      className="btn cart-checkout-button"
                      onClick={proceedToCheckout}
                    >
                      Proceed to Checkout
                    </button>
                  </>
                )}
              </aside>
            )}
          </div>
        </div>

        <section className="fulfilment-options" aria-labelledby="fulfilment-heading">
          <div className="fulfilment-copy">
            <span className="section-label">CHOOSE HOW TO ORDER</span>
            <h2 id="fulfilment-heading">Collection or delivery</h2>
          </div>
          <article className="fulfilment-card active">
            <span className="fulfilment-badge">ON THIS WEBSITE</span>
            <h3>Click &amp; Collect</h3>
            <p>Order from our menu, choose a collection time and pay when you collect.</p>
            <a className="text-link" href="#available-items-heading">Browse collection menu →</a>
          </article>
          <article className="fulfilment-card">
            <span className="fulfilment-badge">DELIVERY PARTNER</span>
            <h3>Uber Eats delivery</h3>
            <p>For delivery, continue securely to Café Fausse on Uber Eats.</p>
            <a
              className="btn btn-outline"
              href={import.meta.env.VITE_UBER_EATS_URL || "https://www.ubereats.com/"}
              target="_blank"
              rel="noreferrer"
            >
              Continue to Uber Eats
            </a>
          </article>
        </section>

        {/* =====================================================
            Menu state messages
        ===================================================== */}

        {loading && (
          <p className="order-status-message">
            Loading menu...
          </p>
        )}

        {!loading && error && (
          <p
            className="order-status-message"
            role="alert"
          >
            {error}
          </p>
        )}

        {/* =====================================================
            Menu items
        ===================================================== */}

        {!loading && !error && (
          <section
            className="online-order-menu"
            aria-labelledby="available-items-heading"
          >
            <h2 id="available-items-heading">
              Available Items
            </h2>

            <div className="online-order-grid">
              {menu.map((item) => (
                <div
                  id={`menu-item-${item.id}`}
                  key={item.id}
                  className={item.id === selectedItemId ? "featured-order-item" : ""}
                >
                  <Card title={item.name}>
                    <div className="online-order-card-content">
                    <p className="online-order-description">
                      {item.description ||
                        "Description coming soon."}
                    </p>

                    <div className="online-order-card-footer">
                      <span className="online-order-price">
                        {formatRandFromCents(
                          item.price_cents
                        )}
                      </span>

                      <button
                        type="button"
                        className="btn"
                        onClick={() => addToCart(item)}
                      >
                        Add to Cart
                      </button>
                    </div>
                    </div>
                  </Card>
                </div>
              ))}
            </div>
          </section>
        )}
      </div>
    </main>
  );
}
