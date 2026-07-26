# Café Fausse Backend

## Staff access

The customer navigation intentionally does not expose the admin login. Staff
can open `/admin/login` directly. Set `ADMIN_USERNAME` and a strong
`ADMIN_PASSWORD` before running `python scripts/seed.py`; the public admin
registration endpoint has been removed.

## Updating an existing database

From the backend directory, apply the supplied migration and reseed the menu:

```powershell
python manage.py db_upgrade
python scripts/seed.py
```

This is the Flask backend for the Café Fausse Restaurant Platform.

Quick start (Windows PowerShell):

1. Create and activate a virtual environment

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r "04 Backend Code/backend/requirements.txt"
```

2. Configure environment variables (see `.env.example`)

3. Initialize the database and run the app

```powershell
setx DATABASE_URL "postgresql://postgres:password@localhost:5432/cafefausse"
setx JWT_SECRET_KEY "your-secret"
python "04 Backend Code/backend/run.py"
```

Endpoints are mounted under `/api/`:

- `/api/reservations`
- `/api/menu`
- `/api/orders`
- `/api/newsletter`
- `/api/gallery`
- `/api/testimonials`
- `/api/admin`
