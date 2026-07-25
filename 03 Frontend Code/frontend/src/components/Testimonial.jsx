import React from 'react'

export default function Testimonial({author, content}){
  return (
    <div className="card">
      <blockquote style={{margin:0}}>{content}</blockquote>
      <div style={{marginTop:8,fontWeight:700}}>- {author}</div>
    </div>
  )
}
