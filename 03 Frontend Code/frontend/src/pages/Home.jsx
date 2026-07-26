import React, {useEffect, useState} from 'react'
import {Link} from 'react-router-dom'
import Hero from '../components/Hero'
import Card from '../components/Card'
import Testimonial from '../components/Testimonial'
import Newsletter from '../components/Newsletter'
import api from '../api'
import {formatRandFromCents} from '../utils/currency'

export default function Home(){
  const [testimonials,setTestimonials] = useState([])
  const [specials,setSpecials] = useState([])
  const [specialsLoading,setSpecialsLoading] = useState(true)
  useEffect(()=>{
    api.get('/testimonials').then(r=>setTestimonials(r.data)).catch(()=>{})
    api.get('/menu', {params: {featured: true}})
      .then(r=>setSpecials(r.data))
      .catch(()=>setSpecials([]))
      .finally(()=>setSpecialsLoading(false))
  },[])

  return (
    <div>
      <Hero title="Welcome to Café Fausse" subtitle="A modern café experience with classic flavours">
        <Link to="/menu" className="btn">View Menu</Link>
      </Hero>

      <section className="container">
        <h2>Our Specials</h2>
        <div className="cards">
          {specials.map(item => (
            <Card key={item.id} title={item.name}>
              <div className="special-card-content">
                <p>{item.description}</p>
                <div className="special-card-footer">
                  <strong>{formatRandFromCents(item.price_cents)}</strong>
                  <Link className="btn" to={`/order?item=${item.id}`}>
                    Order special
                  </Link>
                </div>
              </div>
            </Card>
          ))}
          {specialsLoading && <p className="loading-inline">Loading specials…</p>}
          {!specialsLoading && specials.length === 0 && (
            <p className="empty-message">No specials are currently available.</p>
          )}
        </div>
      </section>

      <section className="container">
        <h2>What Guests Say</h2>
        <div className="cards">
          {testimonials.map(t=> <Testimonial key={t.id} author={t.author} content={t.content} />)}
        </div>
      </section>

      <section className="container" style={{marginTop:20}}>
        <h3>Newsletter</h3>
        <Newsletter />
      </section>
    </div>
  )
}
