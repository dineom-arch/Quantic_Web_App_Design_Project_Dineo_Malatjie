import React, {useState} from 'react'
import FormInput from '../components/FormInput'
import Button from '../components/Button'
import api from '../api'

export default function Contact(){
  const [form,setForm] = useState({name:'',email:'',message:''})
  const [msg,setMsg] = useState('')

  async function submit(e){
    e.preventDefault()
    // For now we simply echo — implement server endpoint if desired
    setMsg('Thanks, we will be in touch')
  }

  return (
    <div className="container">
      <h1>Contact Us</h1>
      <form onSubmit={submit} style={{maxWidth:600}}>
        <FormInput label="Name" value={form.name} onChange={e=>setForm({...form,name:e.target.value})} />
        <FormInput label="Email" value={form.email} onChange={e=>setForm({...form,email:e.target.value})} />
        <label style={{display:'block',marginBottom:8}}>
          Message
          <textarea rows={6} value={form.message} onChange={e=>setForm({...form,message:e.target.value})} />
        </label>
        <div style={{marginTop:8}}>
          <Button type="submit">Send</Button>
          <div style={{color:'var(--muted)',marginTop:8}}>{msg}</div>
        </div>
      </form>
    </div>
  )
}
