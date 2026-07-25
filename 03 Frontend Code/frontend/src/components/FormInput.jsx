import React from 'react'

export default function FormInput({label, ...props}){
  return (
    <label style={{display:'block',marginBottom:8}}>
      {label && <div style={{fontSize:14,marginBottom:4}}>{label}</div>}
      <input {...props} />
    </label>
  )
}
