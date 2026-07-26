import { render, screen, fireEvent } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import Order from '../pages/Order'
import Checkout from '../pages/Checkout'
import api from '../api'

vi.mock('../api')

describe('Order -> Checkout flow', () => {
  it('adds items to cart and places order', async () => {
    const items = [ { id: 1, name: 'Latte', description: 'Smooth', price_cents: 400 } ]
    api.get = vi.fn().mockResolvedValue({ data: items })
    // render order page
    const { rerender } = render(<MemoryRouter><Order /></MemoryRouter>)
    // wait for menu item
    const addBtn = await screen.findByText(/Add/i)
    fireEvent.click(addBtn)
    // simulate proceed to checkout button which writes localStorage
    const proceed = await screen.findByText(/Proceed to Checkout/i)
    fireEvent.click(proceed)

    // render checkout which reads localStorage
    rerender(<MemoryRouter><Checkout /></MemoryRouter>)
    // fill checkout form
    const nameInput = screen.getByLabelText(/Name/i)
    fireEvent.change(nameInput, { target: { value: 'Test User' } })
    fireEvent.change(screen.getByLabelText(/Mobile/i), { target: { value: '0820000000' } })
    fireEvent.change(screen.getByLabelText(/Email/i), { target: { value: 'test@example.com' } })
    fireEvent.change(screen.getByLabelText(/Preferred collection time/i), { target: { value: '2026-12-01T12:30' } })
    const placeBtn = screen.getByText(/Place Order/i)

    // mock post
    api.post = vi.fn().mockResolvedValue({ data: { id: 1, customer_name: 'Test User', customer_phone: '0820000000', total_cents: 400 } })
    fireEvent.click(placeBtn)
    // expect API called
    expect(api.post).toHaveBeenCalledWith('/orders', expect.objectContaining({ customer_name: 'Test User' }))
  })
})
