import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

import api from "../api";
import Card from "../components/Card";
import { formatRandFromCents } from "../utils/currency";

export default function Menu() {
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const navigate = useNavigate();

  useEffect(() => {
    api
      .get("/menu")
      .then((response) => {
        setItems(response.data);
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

  const handleOrderNow = (itemId) => {
    navigate(`/order?item=${itemId}`);
  };

  return (
    <>
      {/* =========================================================
          Menu Hero Section
      ========================================================= */}

      <section className="page-hero">
        <div className="container">
          <span className="section-label">CAFÉ FAUSSE</span>

          <h1>Our Menu</h1>

          <p>
            Every dish is thoughtfully prepared using fresh, seasonal
            ingredients and presented with contemporary elegance.
          </p>
        </div>
      </section>

      {/* =========================================================
          Menu Items Section
      ========================================================= */}

      <section className="container menu-section">
        {loading && (
          <div className="loading-message">
            <p>Loading menu...</p>
          </div>
        )}

        {!loading && error && (
          <div className="error-message" role="alert">
            <p>{error}</p>
          </div>
        )}

        {!loading && !error && items.length === 0 && (
          <div className="empty-message">
            <p>No menu items are currently available.</p>
          </div>
        )}

        {!loading && !error && items.length > 0 && (
          <div className="menu-grid">
            {items.map((item) => (
              <Card key={item.id} title={item.name}>
                <div className="menu-card">
                  <p className="menu-description">
                    {item.description || "Description coming soon."}
                  </p>

                  <div className="menu-footer">
                    <span className="menu-price">
                      {formatRandFromCents(item.price_cents)}
                    </span>

                    <button
                      type="button"
                      className="btn"
                      onClick={() => handleOrderNow(item.id)}
                    >
                      Order Now
                    </button>
                  </div>
                </div>
              </Card>
            ))}
          </div>
        )}
      </section>
    </>
  );
}
