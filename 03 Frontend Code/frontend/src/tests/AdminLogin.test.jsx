import { render, screen, fireEvent } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import AdminLogin from '../pages/AdminLogin'
import api from '../api'

vi.mock('../api')

describe('AdminLogin', () => {
  it('renders and submits form', async () => {
    api.post = vi.fn().mockResolvedValue({data:{access_token:'tok'}})
    render(<MemoryRouter><AdminLogin /></MemoryRouter>)
    const username = screen.getByLabelText(/Username/i)
    const password = screen.getByLabelText(/Password/i)
    fireEvent.change(username, {target:{value:'admin'}})
    fireEvent.change(password, {target:{value:'pass'}})
    const btn = screen.getByText(/Sign in/i)
    fireEvent.click(btn)
    expect(api.post).toHaveBeenCalledWith('/admin/login', {username:'admin', password:'pass'})
  })
})
