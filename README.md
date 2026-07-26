# Café Fausse Restaurant Platform

Café Fausse is a fictional fine-dining restaurant web application created for the Quantic Web Application and Interface Design project. The repository contains a React/Vite frontend, a Flask REST API, PostgreSQL database scripts and migrations, automated tests, and the project’s supporting design artifacts.

## Important grading note

This repository contains source code, not a permanently hosted public website. The GitHub repository URL displays the code; the application URL becomes available only after the grader starts the backend and frontend locally.

- Frontend: `http://localhost:3000/`
- Backend API: `http://127.0.0.1:5000/`

If port 3000 is already occupied, Vite will display another address such as `http://localhost:3001/`. Use the exact **Local** address printed in the frontend terminal.

## Implemented features

- Responsive restaurant website with consistent Café Fausse branding
- Database-backed menu, testimonials, newsletter subscriptions, reservations, orders, and staff accounts
- Homepage specials that open the corresponding orderable menu item
- Menu and Order Online pages driven by the same menu-item records
- Internal Click & Collect cart, checkout summary, collection details, order total, and confirmation page
- Pay-on-collection workflow; no card details are collected
- Configurable external Uber Eats delivery hand-off
- Local bundled gallery images
- Fictional Michelin-star-inspired chef story on the About Us page
- Social-media hub in place of the former contact form
- Staff login hidden from customer navigation and available only by direct route
- Protected staff order dashboard and no public admin-registration endpoint

## Technology stack

| Layer | Technology |
|---|---|
| Frontend | React, React Router, Vite, Axios, CSS |
| Backend | Python, Flask, Flask-SQLAlchemy, Flask-Migrate, Flask-JWT-Extended |
| Database | PostgreSQL |
| Testing | Vitest, React Testing Library, Pytest |

## Repository structure

| Path | Purpose |
|---|---|
| `01 Software Requirements Specification` | Baseline project requirements |
| `02 Database Creation Code` | Database creation/reference SQL |
| `03 Frontend Code/frontend` | React/Vite customer and staff interface |
| `04 Backend Code/backend` | Flask API, models, seed script, and backend tests |
| `05 AI Imagery` | Original image-generation assets and prompts |
| `migrations` | Alembic/Flask-Migrate database migrations |

## Prerequisites

Install the following before grading:

- Git
- Node.js 18 or newer and npm
- Python 3.10 or newer
- PostgreSQL 15 or newer

pgAdmin is optional; it is only a graphical tool for managing PostgreSQL.

## 1. Download the repository

Open PowerShell and run:

```powershell
git clone https://github.com/dineom-arch/Quantic_Web_App_Design_Project_Dineo_Malatjie.git
cd Quantic_Web_App_Design_Project_Dineo_Malatjie
```

Alternatively, download the repository ZIP from GitHub, extract it, and open PowerShell in the extracted root folder.

## 2. Create the PostgreSQL database

Create a local PostgreSQL database named `cafefausse`. The default development connection expects:

```text
Database: cafefausse
Host: localhost
Port: 5432
Username: postgres
Password: password
```

If your PostgreSQL username or password is different, configure it in the backend environment file in the next step.

## 3. Configure and start the backend

From the repository root:

```powershell
python -m venv .venv
Set-ExecutionPolicy -Scope Process Bypass
.\.venv\Scripts\Activate.ps1
cd "04 Backend Code\backend"
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
Copy-Item ".env.example" ".env"
```

Open `04 Backend Code\backend\.env` and confirm these values:

```dotenv
DATABASE_URL=postgresql://postgres:password@localhost:5432/cafefausse
JWT_SECRET_KEY=replace-with-a-long-random-value
ADMIN_USERNAME=admin
ADMIN_PASSWORD=replace-with-a-strong-password
```

Do not commit the populated `.env` file.

Start the API:

```powershell
python run.py
```

Keep this terminal open. On startup, the application applies the supplied migrations and runs the idempotent seed script. A successful start includes:

```text
Running on http://127.0.0.1:5000
```

Open `http://127.0.0.1:5000/` to verify the backend. Seeing a small JSON response such as `{"message":"Café Fausse Backend API"}` is correct. A `/favicon.ico` 404 in this backend terminal is harmless.

## 4. Configure and start the frontend

Open a **second** PowerShell window. From the repository root:

```powershell
cd "03 Frontend Code\frontend"
npm install
Copy-Item ".env.example" ".env"
npm run dev
```

Keep this terminal open too. Vite will print an address similar to:

```text
Local: http://localhost:3000/
```

Hold `Ctrl` and click that address, or copy it into a browser. The frontend terminal must remain running while the site is being graded.

The Vite development server proxies `/api` requests to the Flask API at `http://127.0.0.1:5000`, so both terminal windows must remain open.

## Optional external links

The application works without live commercial or social accounts. To demonstrate external hand-offs, replace the placeholder values in `03 Frontend Code\frontend\.env`:

```dotenv
VITE_UBER_EATS_URL=https://www.ubereats.com/
VITE_INSTAGRAM_URL=https://www.instagram.com/
VITE_FACEBOOK_URL=https://www.facebook.com/
VITE_TIKTOK_URL=https://www.tiktok.com/
```

These are external links only. Uber Eats payment and delivery are not processed by this coursework application.

## Grading walkthrough

Use the following sequence after both servers are running:

1. **Home** (`/`) — inspect the hero, featured specials, testimonial, and newsletter form. Select a special and confirm that the matching item is highlighted on the Order Online page.
2. **Menu** (`/menu`) — confirm that database-backed menu items, categories, descriptions, and prices load.
3. **Reservations** (`/reservations`) — submit a valid future booking and confirm the success response.
4. **Order Online** (`/order`) — choose Click & Collect, add and adjust items, and verify that a new browser session starts with an empty cart.
5. **Checkout** (`/checkout`) — confirm the cart summary, quantities, subtotal/total, customer details, collection time, notes, and pay-on-collection disclosure.
6. **Order confirmation** (`/order-confirmation`) — place the order and confirm that the reference and summary are displayed.
7. **Uber Eats** — use the delivery button to verify the configurable external hand-off.
8. **Gallery** (`/gallery`) — confirm that bundled restaurant images load without depending on remote image hosts.
9. **About Us** (`/about`) — review the explicitly fictional chef biography and career timeline.
10. **Follow Us** (`/socials`) — verify the configurable Instagram, Facebook, and TikTok links.
11. **Staff access** (`/admin/login`) — this route is intentionally absent from customer navigation. Sign in with the `ADMIN_USERNAME` and `ADMIN_PASSWORD` configured in the backend `.env`, then inspect protected order management at `/admin`.

## Useful API checks

| URL | Expected result |
|---|---|
| `http://127.0.0.1:5000/` | Backend health JSON |
| `http://127.0.0.1:5000/api/menu` | Seeded menu JSON |
| `http://127.0.0.1:5000/api/testimonials` | Visible testimonial JSON |

## Run the tests

Frontend:

```powershell
cd "03 Frontend Code\frontend"
npm test -- --run
npm run build
```

Backend, with the virtual environment active:

```powershell
cd "04 Backend Code\backend"
python -m pip install pytest
python -m pytest
```

## Troubleshooting

| Symptom | Resolution |
|---|---|
| Browser shows JSON at port 5000 | The backend is working. Open the Vite address, normally port 3000, for the website. |
| `localhost:3000` refuses to connect | Start `npm run dev` in `03 Frontend Code/frontend` and keep that terminal open. |
| Vite says port 3000 is in use | Use the alternate **Local** URL printed by Vite. |
| Menu says it could not be loaded | Confirm PostgreSQL and `python run.py` are running; then open `/api/menu` directly to inspect the API. |
| PostgreSQL authentication error | Correct `DATABASE_URL` in the backend `.env`. |
| `ModuleNotFoundError` | Activate `.venv` and rerun `python -m pip install -r requirements.txt`. |
| PowerShell blocks activation | Run `Set-ExecutionPolicy -Scope Process Bypass`, then activate the environment again. |
| Old items appear in the cart | Open a new browser session or clear session storage for localhost. The current build does not seed the cart. |

## Scope and limitations

- Café Fausse, its chef, awards, testimonials, addresses, and social accounts are fictional coursework content.
- The project is designed for local assessment and has no permanent production deployment.
- Checkout uses **pay on collection** and deliberately does not collect card information.
- Uber Eats and social-media functions are configurable external links, not embedded third-party integrations.
- Customer account creation, customer login, and online card payment are outside the implemented scope.

## AI-use disclosure

AI tools were used to support ideation, image generation, debugging, refactoring, test planning, and documentation. The submitted repository remains the assessable implementation and should be evaluated by running the source and tests described above.
