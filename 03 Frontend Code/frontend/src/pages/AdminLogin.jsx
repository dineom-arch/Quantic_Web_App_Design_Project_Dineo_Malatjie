import React, {useState} from 'react'
import {useNavigate} from 'react-router-dom'
import api from '../api'
import FormInput from '../components/FormInput'
import Button from '../components/Button'

export default function AdminLogin(){
  const [form,setForm] = useState({username:'',password:''})
  const [msg,setMsg] = useState('')
  const navigate = useNavigate()

  async function submit(e){
    e.preventDefault()
    try{
      const res = await api.post('/admin/login', form)
      const token = res.data.access_token
      localStorage.setItem('admin_token', token)
      api.setToken(token)
      navigate('/admin')
    }catch(err){
      setMsg('Invalid credentials')
    }
  }

  return (
    <div className="container">
      <h1>Admin Login</h1>
      <form onSubmit={submit} style={{maxWidth:400}} aria-label="admin-login-form">
        <FormInput label="Username" value={form.username} onChange={e=>setForm({...form,username:e.target.value})} />
        <FormInput label="Password" type="password" value={form.password} onChange={e=>setForm({...form,password:e.target.value})} />
        <div style={{marginTop:8}}>
          <Button type="submit">Sign in</Button>
        </div>
        <div style={{color:'var(--muted)',marginTop:8}} role="status">{msg}</div>
      </form>
    </div>
  )
}
