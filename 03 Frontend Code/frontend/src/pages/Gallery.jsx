import React from "react";
import GalleryGrid from "../components/GalleryGrid";
import interior from "../assets/images/Interior.jpg";
import dishes from "../assets/images/Dishes.jpg";
import chef from "../assets/images/Chef.jpg";
import desserts from "../assets/images/Desserts.jpg";
import cocktails from "../assets/images/Cocktails.jpg";
import gallery from "../assets/images/Gallery.jpg";

const galleryImages = [
  { id: "interior", url: interior, caption: "An intimate evening at Café Fausse" },
  { id: "dishes", url: dishes, caption: "Seasonal dishes composed with precision" },
  { id: "chef", url: chef, caption: "The craft behind every service" },
  { id: "desserts", url: desserts, caption: "A refined finish to the tasting menu" },
  { id: "cocktails", url: cocktails, caption: "Handcrafted cocktails at the bar" },
  { id: "gallery", url: gallery, caption: "Moments from the Café Fausse experience" },
];

export default function Gallery() {
  return (
    <main className="gallery-page">
      <header className="gallery-heading container">
        <span className="section-label">INSIDE CAFÉ FAUSSE</span>
        <h1>Gallery</h1>
        <p>
          A glimpse of our dining room, culinary craft and the details that
          shape each evening.
        </p>
      </header>
      <GalleryGrid images={galleryImages} />
    </main>
  );
}
