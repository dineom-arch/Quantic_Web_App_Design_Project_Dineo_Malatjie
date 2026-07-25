import React, {useState} from 'react'
import api from '../api'
import FormInput from '../components/FormInput'
import Button from '../components/Button'

export default function Reservations(){
  const [form,setForm] = useState({name:'',email:'',phone:'',party_size:2,reserved_at:''})
  const [msg,setMsg] = useState('')

  async function submit(e){
    e.preventDefault()
    try{
      await api.post('/reservations', form)
      setMsg('Reservation created')
    }catch(err){setMsg('Error creating reservation')}
  }

  return (
    <div className="container">
      <h1>Make a Reservation</h1>
      <form onSubmit={submit} style={{maxWidth:600}}>
        <FormInput label="Name" value={form.name} onChange={e=>setForm({...form,name:e.target.value})} />
        <FormInput label="Email" value={form.email} onChange={e=>setForm({...form,email:e.target.value})} />
        <div className="row">
          <FormInput label="Phone" value={form.phone} onChange={e=>setForm({...form,phone:e.target.value})} />
          <FormInput label="Party Size" type="number" value={form.party_size} onChange={e=>setForm({...form,party_size:Number(e.target.value)})} />
        </div>
        <FormInput label="Date & Time" type="datetime-local" value={form.reserved_at} onChange={e=>setForm({...form,reserved_at:e.target.value})} />
        <div style={{marginTop:8}}>
          <Button type="submit">Reserve</Button>
          <div style={{marginTop:8,color:'var(--muted)'}}>{msg}</div>
        </div>
      </form>
    </div>
  )
}
