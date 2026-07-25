import React, {useEffect, useState} from 'react'
import api from '../api'
import Button from '../components/Button'

export default function Order(){
  const [menu,setMenu] = useState([])
  const [cart,setCart] = useState([])

  useEffect(()=>{api.get('/menu').then(r=>setMenu(r.data)).catch(()=>{})},[])

  function add(item){
    setCart(prev => {
      const found = prev.find(p=>p.menu_item_id===item.id)
      if(found) return prev.map(p=> p.menu_item_id===item.id?{...p,quantity:p.quantity+1}:p)
      return [...prev,{menu_item_id:item.id,quantity:1}]
    })
  }

  function remove(item){
    setCart(prev => prev.filter(p=>p.menu_item_id!==item.id))
  }

  return (
    <div className="container">
      <h1>Order Online</h1>
      <div style={{display:'flex',gap:16}}>
        <div style={{flex:2}}>
          <div className="cards">
            {menu.map(i=> (
              <div className="card" key={i.id}>
                <h3>{i.name} — ${(i.price_cents/100).toFixed(2)}</h3>
                <div style={{color:'var(--muted)'}}>{i.description}</div>
                <div style={{marginTop:8}}>
                  <Button onClick={()=>add(i)}>Add</Button>
                </div>
              </div>
            ))}
          </div>
        </div>
        <div style={{flex:1}}>
          <h3>Your Cart</h3>
          {cart.map(c=>{
            const m = menu.find(x=>x.id===c.menu_item_id) || {}
            return <div key={c.menu_item_id} style={{display:'flex',justifyContent:'space-between',alignItems:'center'}}>
              <div>{m.name} x {c.quantity}</div>
              <div>
                <Button onClick={()=>remove(m)}>Remove</Button>
              </div>
            </div>
          })}
          <div style={{marginTop:8}}>
            <Button onClick={()=>localStorage.setItem('cafecart',JSON.stringify(cart))}>Proceed to Checkout</Button>
          </div>
        </div>
      </div>
    </div>
  )
}
