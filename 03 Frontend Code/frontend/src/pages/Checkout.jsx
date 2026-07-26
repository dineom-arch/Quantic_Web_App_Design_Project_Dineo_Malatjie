import React, { useEffect, useMemo, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import api from "../api";
import { formatRandFromCents } from "../utils/currency";
import { clearCart, readCart } from "../utils/cart";

const initialForm = {
  customer_name: "",
  customer_phone: "",
  customer_email: "",
  collection_time: "",
  notes: "",
};

export default function Checkout() {
  const [cart, setCart] = useState([]);
  const [form, setForm] = useState(initialForm);
  const [error, setError] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    setCart(readCart());
  }, []);

  const totalCents = useMemo(
    () => cart.reduce(
      (sum, item) => sum + (item.line_total_cents ?? item.price_cents * item.quantity),
      0
    ),
    [cart]
  );

  const updateField = (event) => {
    setForm((current) => ({ ...current, [event.target.name]: event.target.value }));
  };

  async function submit(event) {
    event.preventDefault();
    setError("");
    setSubmitting(true);

    try {
      const response = await api.post("/orders", {
        ...form,
        order_type: "collection",
        payment_method: "pay_on_collection",
        items: cart.map(({ menu_item_id, quantity }) => ({ menu_item_id, quantity })),
      });
      clearCart();
      navigate("/order-confirmation", { replace: true, state: { order: response.data } });
    } catch (requestError) {
      setError(
        requestError.response?.data?.error ||
        "We could not place your order. Please check your details and try again."
      );
    } finally {
      setSubmitting(false);
    }
  }

  if (cart.length === 0) {
    return (
      <main className="checkout-page">
        <section className="empty-checkout">
          <h1>Your cart is empty</h1>
          <p>Add at least one menu item before checking out.</p>
          <Link className="btn" to="/order">Return to Order Online</Link>
        </section>
      </main>
    );
  }

  return (
    <main className="checkout-page">
      <div className="checkout-shell">
        <section className="checkout-form-panel">
          <Link className="checkout-back-link" to="/order">← Return to cart</Link>
          <span className="section-label">CAFÉ FAUSSE</span>
          <h1>Checkout</h1>

          <div className="checkout-steps" aria-label="Checkout progress">
            <span className="complete">Cart</span><span>›</span>
            <span className="current">Information</span><span>›</span>
            <span>Confirmation</span>
          </div>

          <form onSubmit={submit} className="checkout-form">
            <h2>Contact information</h2>
            <label>
              Full name
              <input name="customer_name" value={form.customer_name} onChange={updateField} required />
            </label>
            <div className="checkout-field-row">
              <label>
                Mobile number
                <input name="customer_phone" type="tel" value={form.customer_phone} onChange={updateField} required />
              </label>
              <label>
                Email
                <input name="customer_email" type="email" value={form.customer_email} onChange={updateField} required />
              </label>
            </div>

            <h2>Collection details</h2>
            <label>
              Preferred collection time
              <input name="collection_time" type="datetime-local" value={form.collection_time} onChange={updateField} required />
            </label>
            <label>
              Order notes <span className="optional">(optional)</span>
              <textarea name="notes" rows="3" value={form.notes} onChange={updateField} />
            </label>

            <div className="payment-method">
              <div>
                <strong>Pay on collection</strong>
                <p>No card details are collected on this website.</p>
              </div>
              <span aria-hidden="true">✓</span>
            </div>

            {error && <p className="form-error" role="alert">{error}</p>}
            <button className="btn checkout-submit" disabled={submitting}>
              {submitting ? "Placing order…" : `Place order · ${formatRandFromCents(totalCents)}`}
            </button>
          </form>
        </section>

        <aside className="checkout-summary" aria-labelledby="summary-heading">
          <div className="checkout-summary-inner">
            <span className="section-label">YOUR CART</span>
            <h2 id="summary-heading">Order summary</h2>
            <div className="checkout-items">
              {cart.map((item) => (
                <article className="checkout-item" key={item.menu_item_id}>
                  <span className="checkout-quantity">{item.quantity}</span>
                  <div><strong>{item.name}</strong><p>{formatRandFromCents(item.price_cents)} each</p></div>
                  <strong>{formatRandFromCents(item.line_total_cents ?? item.price_cents * item.quantity)}</strong>
                </article>
              ))}
            </div>
            <dl className="checkout-totals">
              <div><dt>Subtotal</dt><dd>{formatRandFromCents(totalCents)}</dd></div>
              <div><dt>Collection</dt><dd>Free</dd></div>
              <div className="grand-total"><dt>Total</dt><dd>{formatRandFromCents(totalCents)}</dd></div>
            </dl>
          </div>
        </aside>
      </div>
    </main>
  );
}
