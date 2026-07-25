import React from 'react'

export default function Button({children, onClick, type='button'}){
  return <button className="btn" type={type} onClick={onClick}>{children}</button>
}
