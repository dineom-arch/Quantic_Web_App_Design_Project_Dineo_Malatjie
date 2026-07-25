import React, {useEffect, useState} from 'react'
import Hero from '../components/Hero'
import Card from '../components/Card'
import Testimonial from '../components/Testimonial'
import Newsletter from '../components/Newsletter'
import api from '../api'

export default function Home(){
  const [testimonials,setTestimonials] = useState([])
  useEffect(()=>{
    api.get('/testimonials').then(r=>setTestimonials(r.data)).catch(()=>{})
  },[])

  return (
    <div>
      <Hero title="Welcome to Café Fausse" subtitle="A modern café experience with classic flavours">
        <a href="/menu" className="btn">View Menu</a>
      </Hero>

      <section className="container">
        <h2>Our Specials</h2>
        <div className="cards">
          <Card title="Brunch">House favorites for a slow morning</Card>
          <Card title="Coffee">Single origin espresso and more</Card>
          <Card title="Bakery">Daily baked croissants and pastries</Card>
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
