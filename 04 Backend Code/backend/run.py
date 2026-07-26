from pathlib import Path
from app import create_app
from flask_migrate import upgrade
from scripts.seed import seed

app = create_app()

if __name__ == '__main__':
    migrations_directory = Path(__file__).resolve().parents[2] / "migrations"
    with app.app_context():
        upgrade(directory=str(migrations_directory))
    seed(app)
    app.run(host='0.0.0.0', port=5000)
