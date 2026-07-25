import React from 'react'
import { Link, NavLink } from 'react-router-dom'

export default function Navbar(){
  const token = typeof window !== 'undefined' && localStorage.getItem('admin_token')
  function logout(){
    localStorage.removeItem('admin_token')
    window.location.href = '/'
  }
  return (
    <nav className="nav" role="navigation" aria-label="main navigation">
      <div className="nav-inner container">
        <Link to="/" style={{fontWeight:700}}>Café Fausse</Link>
        <div className="nav-links">
          <NavLink to="/">Home</NavLink>
          <NavLink to="/menu">Menu</NavLink>
          <NavLink to="/reservations">Reservations</NavLink>
          <NavLink to="/order">Order Online</NavLink>
          <NavLink to="/gallery">Gallery</NavLink>
          <NavLink to="/about">About</NavLink>
          <NavLink to="/contact">Contact</NavLink>
          {token ? (<button className="btn" onClick={logout}>Logout</button>) : (<NavLink to="/admin/login">Admin</NavLink>)}
        </div>
      </div>
    </nav>
  )
}
