import React, {useEffect, useState} from 'react'
import {useNavigate} from 'react-router-dom'
import api from '../api'
import {formatRandFromCents} from '../utils/currency'

export default function AdminDashboard(){
  const [orders,setOrders] = useState([])
  const navigate = useNavigate()

  useEffect(()=>{
    const token = localStorage.getItem('admin_token')
    if(!token){
      navigate('/admin/login')
      return
    }
    api.setToken(token)
    api.get('/admin/orders').then(r=>setOrders(r.data.orders)).catch(()=>{})
  },[])

  return (
    <div className="container">
      <h1>Admin Dashboard</h1>
      <h3>Orders</h3>
      <div className="cards">
        {orders.map(o=> (
          <div className="card" key={o.id}>
            <div><strong>{o.customer_name}</strong></div>
            <div style={{color:'var(--muted)'}}>Status: {o.status}</div>
            <div style={{color:'var(--muted)'}}>Total: {formatRandFromCents(o.total_cents)}</div>
          </div>
        ))}
      </div>
    </div>
  )
}
