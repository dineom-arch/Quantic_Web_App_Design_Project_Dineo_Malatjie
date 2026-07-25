import React, {useEffect, useState} from 'react'
import api from '../api'
import Card from '../components/Card'

export default function Menu(){
  const [items,setItems] = useState([])
  useEffect(()=>{api.get('/menu').then(r=>setItems(r.data)).catch(()=>{})},[])

  return (
    <div className="container">
      <h1>Menu</h1>
      <div className="cards">
        {items.map(i=> (
          <Card key={i.id} title={`${i.name} — $${(i.price_cents/100).toFixed(2)}`}>
            <div style={{color:'var(--muted)'}}>{i.description}</div>
          </Card>
        ))}
      </div>
    </div>
  )
}
