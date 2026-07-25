import React, {useState, useEffect} from 'react'
import api from '../api'
import FormInput from '../components/FormInput'
import Button from '../components/Button'

export default function Checkout(){
  const [cart,setCart] = useState([])
  const [name,setName] = useState('')
  const [phone,setPhone] = useState('')
  const [msg,setMsg] = useState('')

  useEffect(()=>{
    const raw = localStorage.getItem('cafecart')
    if(raw) setCart(JSON.parse(raw))
  },[])

  async function submit(e){
    e.preventDefault()
    try{
      await api.post('/orders',{customer_name:name,customer_phone:phone,items:cart})
      setMsg('Order placed')
      localStorage.removeItem('cafecart')
    }catch(err){setMsg('Error placing order')}
  }

  return (
    <div className="container">
      <h1>Checkout</h1>
      <form onSubmit={submit} style={{maxWidth:600}}>
        <FormInput label="Name" value={name} onChange={e=>setName(e.target.value)} />
        <FormInput label="Phone" value={phone} onChange={e=>setPhone(e.target.value)} />
        <div style={{marginTop:8}}>
          <Button type="submit">Place Order</Button>
          <div style={{color:'var(--muted)',marginTop:8}}>{msg}</div>
        </div>
      </form>
    </div>
  )
}
