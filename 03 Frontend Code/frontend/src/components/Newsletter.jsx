import React, {useState} from 'react'
import api from '../api'

export default function Newsletter(){
  const [email,setEmail] = useState('')
  const [msg,setMsg] = useState('')

  async function submit(e){
    e.preventDefault()
    try{
      const res = await api.post('/newsletter/subscribe',{email})
      setMsg('Subscribed')
    }catch(err){
      setMsg(err?.response?.data?.message || 'Error')
    }
  }

  return (
    <form onSubmit={submit} style={{display:'flex',gap:8,alignItems:'center'}}>
      <input placeholder="Your email" value={email} onChange={e=>setEmail(e.target.value)} />
      <button className="btn">Subscribe</button>
      <div style={{color:'var(--muted)',marginLeft:8}}>{msg}</div>
    </form>
  )
}
