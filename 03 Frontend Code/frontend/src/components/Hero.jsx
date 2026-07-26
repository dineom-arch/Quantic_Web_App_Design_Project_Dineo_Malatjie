import React from "react";
import { Link } from "react-router-dom";

import heroImage from "../assets/images/hero-banner.jpg";

export default function Hero() {
  return (
    <section className="hero container">
      <div className="hero-content">
        <span>CONTEMPORARY FINE DINING</span>

        <h1>
          Experience Culinary Excellence at Café Fausse
        </h1>

        <p>
          Discover refined seasonal cuisine, handcrafted cocktails and
          exceptional hospitality in an elegant contemporary setting.
          Whether you're celebrating a special occasion, enjoying an intimate
          dinner or meeting friends over exceptional food and wine,
          Café Fausse offers a memorable dining experience inspired by
          modern European cuisine and locally sourced ingredients.
        </p>

        <div className="hero-buttons">
          <Link to="/reservations" className="btn">
            Reserve a Table
          </Link>

          <Link to="/menu" className="btn btn-outline">
            View Menu
          </Link>
        </div>
      </div>

      <div className="hero-image">
        <img
          src={heroImage}
          alt="Elegant dining room at Café Fausse"
        />
      </div>
    </section>
  );
}