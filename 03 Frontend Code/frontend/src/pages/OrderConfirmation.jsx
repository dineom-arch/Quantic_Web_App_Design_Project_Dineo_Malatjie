import React from "react";
import { Link, Navigate, useLocation } from "react-router-dom";
import { formatRandFromCents } from "../utils/currency";

export default function OrderConfirmation() {
  const { state } = useLocation();
  const order = state?.order;

  if (!order) {
    return <Navigate to="/order" replace />;
  }

  return (
    <main className="confirmation-page">
      <section className="confirmation-card">
        <span className="confirmation-mark" aria-hidden="true">✓</span>
        <span className="section-label">ORDER CONFIRMED</span>
        <h1>Thank you, {order.customer_name}</h1>
        <p>
          Your collection order <strong>#{order.id}</strong> has been received.
          We will contact you on {order.customer_phone} if anything changes.
        </p>
        <dl className="confirmation-details">
          <div><dt>Collection time</dt><dd>{order.collection_time || "As soon as possible"}</dd></div>
          <div><dt>Payment</dt><dd>Pay on collection</dd></div>
          <div><dt>Total</dt><dd>{formatRandFromCents(order.total_cents)}</dd></div>
        </dl>
        <div className="confirmation-actions">
          <Link className="btn" to="/">Return home</Link>
          <Link className="btn btn-outline" to="/menu">Browse menu</Link>
        </div>
      </section>
    </main>
  );
}
