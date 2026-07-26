# Café Fausse coordinated refactor

This package aligns the React frontend, Flask API, Alembic migrations and the
database reference scripts.

## What changed

1. Homepage specials now come from `menu_items.featured` and link to the same
   orderable item used by Menu and Order Online.
2. Menu, specials and ordering share `/api/menu` as their single source.
3. Admin remains available to staff at `/admin/login`, but is absent from
   customer navigation. Public admin registration and public order-list access
   have been removed.
4. Order Online now separates internal Click & Collect from the external Uber
   Eats delivery handoff.
5. Checkout now includes a cart summary, quantities, subtotal, collection
   details, pay-on-collection information and an order-confirmation screen.

## Apply on Windows

Keep a backup of the current project, then replace its matching folders with
the folders in this package.

### 1. Configure the backend

Copy `.env.example` to `.env` and set the database URL, JWT secret and a strong
admin password.

```powershell
cd "C:\Users\dineo\Web_App_Project_Dineo_Malatjie\04 Backend Code\backend"
python manage.py db_upgrade
python scripts\seed.py
python run.py
```

The seed is idempotent: it adds or updates the supplied menu data instead of
duplicating it.

The corrected `run.py` also applies pending migrations and runs the idempotent
seed before starting the local development server. This prevents Menu and Click
& Collect from failing when the code expects a newer database column.

## Second correction package

- The old `cafecart` browser key is removed and the collection cart now uses
  tab-scoped session storage, so historical test items cannot silently return.
- Gallery content now uses the bundled project imagery instead of the seeded
  `example.com` placeholder URL.
- About Us now contains a complete, explicitly fictional Chef Amara Laurent
  biography and uses the bundled chef photograph.
- The non-functional Contact form has been replaced by a Follow Us hub. Social
  profile URLs are configured through the frontend `.env` file, while the old
  `/contact` address safely redirects to `/socials`.

### 2. Configure the frontend

Copy `.env.example` to `.env`. Replace `VITE_UBER_EATS_URL` with Café Fausse's
actual Uber Eats storefront URL when it is available.

```powershell
cd "C:\Users\dineo\Web_App_Project_Dineo_Malatjie\03 Frontend Code\frontend"
npm install
npm run dev
```

Vite is configured to prefer port 3000 and proxy `/api` to Flask on port 5000.

## Payment scope

The internal workflow records a collection order with payment pending and uses
pay on collection. No card data is accepted or stored. Uber Eats owns the
delivery and delivery-payment journey after the external handoff.
