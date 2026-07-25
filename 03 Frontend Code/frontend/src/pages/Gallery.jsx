import React, {useEffect, useState} from 'react'
import api from '../api'
import GalleryGrid from '../components/GalleryGrid'

export default function Gallery(){
  const [images,setImages] = useState([])
  useEffect(()=>{api.get('/gallery').then(r=>setImages(r.data)).catch(()=>{})},[])

  return (
    <div>
      <div className="container">
        <h1>Gallery</h1>
      </div>
      <GalleryGrid images={images} />
    </div>
  )
}
