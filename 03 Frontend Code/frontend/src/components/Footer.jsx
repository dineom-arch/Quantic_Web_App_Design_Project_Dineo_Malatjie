import React from 'react'

export default function Footer(){
  return (
    <footer className="footer">
      <div className="container">
        <div style={{display:'flex',justifyContent:'space-between',alignItems:'center'}}>
          <div>© {new Date().getFullYear()} Café Fausse</div>
          <div style={{color:'var(--muted)'}}>Built with care · Contact: hello@cafefausse.example</div>
        </div>
      </div>
    </footer>
  )
}
