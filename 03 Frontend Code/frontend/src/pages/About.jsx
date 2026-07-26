import React from "react";
import { Link } from "react-router-dom";
import chefImage from "../assets/images/Chef.jpg";

export default function About() {
  return (
    <main className="about-page">
      <section className="about-hero container">
        <div className="about-hero-copy">
          <span className="section-label">OUR STORY</span>
          <h1>Modern dining, guided by a remarkable culinary journey.</h1>
          <p className="about-lead">
            Café Fausse is the signature restaurant of Chef Amara
            Laurent, where precise European technique meets the ingredients,
            warmth and generous spirit of the southern African table.
          </p>
          <div className="about-actions">
            <Link className="btn" to="/reservations">Reserve a table</Link>
            <Link className="btn btn-outline" to="/menu">Explore the menu</Link>
          </div>
        </div>
        <figure className="chef-portrait">
          <img src={chefImage} alt="Chef Amara Laurent in the Café Fausse kitchen" />
          <figcaption>
            <strong>Chef Amara Laurent</strong>
            <span>Founder &amp; Executive Chef</span>
          </figcaption>
        </figure>
      </section>

      <section className="chef-story">
        <div className="container chef-story-grid">
          <div>
            <span className="section-label">THE CHEF</span>
            <h2>A career shaped in celebrated kitchens</h2>
          </div>
          <div className="chef-story-copy">
            <p>
              Laurent began his career in Cape Town before refining his craft
              in Paris, Copenhagen and San Sebastián. He rose through some of
              Europe’s most exacting kitchens, becoming known for elegant,
              ingredient-led plates and a calm, collaborative style of
              leadership.
            </p>
            <p>
              His career includes earning a Michelin star as head
              chef of Maison Élan in Paris, retaining it for four consecutive
              years, and receiving a Michelin Green Star for a low-waste
              kitchen programme built around seasonal producers.
            </p>
            <p>
              Café Fausse is his return home: polished without being
              intimidating, contemporary without losing memory, and designed
              to make every guest feel genuinely looked after.
            </p>
          </div>
        </div>
      </section>

      <section className="career-highlights container">
        <span className="section-label">SELECTED MILESTONES</span>
        <h2>Award-winning craft, thoughtfully reimagined</h2>
        <div className="milestone-grid">
          <article><strong>2008</strong><h3>Cape Town beginnings</h3><p>Classical training and her first professional kitchen appointment.</p></article>
          <article><strong>2015</strong><h3>European kitchens</h3><p>Senior roles across Paris, Copenhagen and Spain’s Basque Country.</p></article>
          <article><strong>2019</strong><h3>Michelin recognition</h3><p>A fictional first star as head chef at Maison Élan in Paris.</p></article>
          <article><strong>2026</strong><h3>Café Fausse</h3><p>A homecoming expressed through seasonal menus and gracious hospitality.</p></article>
        </div>
        <p className="concept-note">
          Chef Amara Laurent and this career history were created as fictional
          content for the Café Fausse academic project.
        </p>
      </section>
    </main>
  );
}
