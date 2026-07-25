import { render, screen } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import Menu from '../pages/Menu'
import api from '../api'

vi.mock('../api')

describe('Menu page', () => {
  it('renders menu items from API', async () => {
    const items = [
      { id: 1, name: 'Latte', description: 'Smooth', price_cents: 400 },
      { id: 2, name: 'Espresso', description: 'Bold', price_cents: 250 }
    ]
    api.get = vi.fn().mockResolvedValue({ data: items })
    render(<MemoryRouter><Menu /></MemoryRouter>)
    // wait for items to appear
    const first = await screen.findByText(/Latte/i)
    expect(first).toBeInTheDocument()
    expect(screen.getByText(/Espresso/i)).toBeInTheDocument()
  })
})
