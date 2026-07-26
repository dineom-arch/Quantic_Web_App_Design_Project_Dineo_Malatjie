import React, { useState } from "react";
import { Link, NavLink } from "react-router-dom";

export default function Navbar() {
  const [isOpen, setIsOpen] = useState(false);

  const toggleMenu = () => {
    setIsOpen(!isOpen);
  };

  const closeMenu = () => {
    setIsOpen(false);
  };

  const navItems = [
    { path: "/", label: "Home" },
    { path: "/about", label: "About Us" },
    { path: "/menu", label: "Menu" },
    { path: "/reservations", label: "Reservations" },
    { path: "/order", label: "Order Online" },
    { path: "/gallery", label: "Gallery" },
    { path: "/socials", label: "Follow Us" },
  ];

  return (
    <header className="navbar-wrapper">
      <div className="container">
        <nav className="navbar" aria-label="Primary Navigation">

          {/* Logo */}

          <Link
            to="/"
            className="brand-link"
            onClick={closeMenu}
          >
            <span className="brand-name">
              Café Fausse
            </span>

            <span className="brand-tagline">
              Fine Dining &amp; Seasonal Elegance
            </span>
          </Link>

          {/* Mobile Hamburger */}

          <button
            className="navbar-toggle"
            type="button"
            aria-label="Toggle navigation menu"
            aria-expanded={isOpen}
            aria-controls="primary-navigation"
            onClick={toggleMenu}
          >
            <span className="hamburger">
              <span></span>
              <span></span>
              <span></span>
            </span>
          </button>

          {/* Navigation */}

          <div
            id="primary-navigation"
            className={`navbar-links ${isOpen ? "open" : ""}`}
          >
            <ul>

              {navItems.map((item) => (
                <li key={item.path}>
                  <NavLink
                    to={item.path}
                    onClick={closeMenu}
                    className={({ isActive }) =>
                      isActive
                        ? "nav-item active"
                        : "nav-item"
                    }
                  >
                    {item.label}
                  </NavLink>
                </li>
              ))}

            </ul>
          </div>

        </nav>
      </div>
    </header>
  );
}
