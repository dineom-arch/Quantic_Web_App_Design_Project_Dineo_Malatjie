import React from 'react'

export default function Hero({title, subtitle, children}){
  return (
    <section className="hero container">
      <div>
        <h1>{title}</h1>
        <p style={{color:'var(--muted)'}}>{subtitle}</p>
        <div style={{marginTop:8}}>{children}</div>
      </div>
      <div className="cta card">
        <img src="/hero.jpg" alt="hero" style={{width:'100%',borderRadius:6}}/>
      </div>
    </section>
  )
}
