import React from 'react'

export default function GalleryGrid({images=[]}){
  return (
    <div className="gallery-mosaic container">
      {images.map((img, index) => (
        <figure className={`gallery-tile gallery-tile-${index + 1}`} key={img.id}>
          <img src={img.url} alt={img.caption}/>
          <figcaption>{img.caption}</figcaption>
        </figure>
      ))}
    </div>
  )
}
