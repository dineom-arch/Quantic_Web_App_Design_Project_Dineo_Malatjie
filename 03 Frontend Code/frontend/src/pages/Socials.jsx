import React from "react";
import { Link } from "react-router-dom";

const socialProfiles = [
  {
    name: "Instagram",
    handle: "@cafefausse",
    description: "New dishes, service moments and a closer look inside the kitchen.",
    url: import.meta.env.VITE_INSTAGRAM_URL || "https://www.instagram.com/cafefausse/",
    mark: "IG",
  },
  {
    name: "Facebook",
    handle: "Café Fausse",
    description: "Restaurant news, seasonal menus and upcoming dining events.",
    url: import.meta.env.VITE_FACEBOOK_URL || "https://www.facebook.com/cafefausse/",
    mark: "f",
  },
  {
    name: "TikTok",
    handle: "@cafefausse",
    description: "Behind-the-scenes preparation, plating and stories from our team.",
    url: import.meta.env.VITE_TIKTOK_URL || "https://www.tiktok.com/@cafefausse",
    mark: "♪",
  },
];

export default function Socials() {
  return (
    <main className="socials-page">
      <header className="socials-hero container">
        <span className="section-label">STAY CONNECTED</span>
        <h1>Follow Café Fausse</h1>
        <p>
          Join us beyond the dining room for seasonal inspiration, new menu
          announcements and stories from behind the pass.
        </p>
      </header>

      <section className="social-grid container" aria-label="Café Fausse social profiles">
        {socialProfiles.map((profile) => (
          <a
            className="social-card"
            href={profile.url}
            key={profile.name}
            target="_blank"
            rel="noreferrer"
            aria-label={`Follow Café Fausse on ${profile.name}`}
          >
            <span className="social-mark" aria-hidden="true">{profile.mark}</span>
            <div>
              <span className="social-platform">{profile.name}</span>
              <h2>{profile.handle}</h2>
              <p>{profile.description}</p>
              <strong>Visit profile →</strong>
            </div>
          </a>
        ))}
      </section>

      <section className="social-contact container">
        <p>
          For reservations, use our <Link to="/reservations">online reservation form</Link>.
          For general enquiries, email <a href="mailto:hello@cafefausse.example">hello@cafefausse.example</a>.
        </p>
      </section>
    </main>
  );
}
