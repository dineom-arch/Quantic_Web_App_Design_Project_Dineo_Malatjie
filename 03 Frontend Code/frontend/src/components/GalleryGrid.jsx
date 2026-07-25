import React from 'react'

export default function GalleryGrid({images=[]}){
  return (
    <div className="cards container">
      {images.map(img => (
        <div className="card" key={img.id}>
          <img src={img.url} alt={img.caption} style={{width:'100%',borderRadius:6}}/>
          <div style={{color:'var(--muted)'}}>{img.caption}</div>
        </div>
      ))}
    </div>
  )
}
