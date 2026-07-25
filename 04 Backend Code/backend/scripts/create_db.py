import os
from urllib.parse import urlparse, urlunparse
from sqlalchemy import create_engine, text

def create_database_if_missing():
    db_url = os.getenv('DATABASE_URL')
    if not db_url:
        raise SystemExit('DATABASE_URL not set')

    p = urlparse(db_url)
    # replace path with /postgres for admin connection
    admin_path = '/postgres'
    admin_url = urlunparse((p.scheme, p.netloc, admin_path, p.params, p.query, p.fragment))

    # target db name
    db_name = p.path.lstrip('/')
    if not db_name:
        raise SystemExit('No database name found in DATABASE_URL')

    engine = create_engine(admin_url)
    with engine.connect() as raw_conn:
        conn = raw_conn.execution_options(isolation_level='AUTOCOMMIT')
        res = conn.execute(text("SELECT 1 FROM pg_database WHERE datname = :d"), {'d': db_name}).fetchone()
        if res:
            print(f"Database '{db_name}' already exists")
        else:
            print(f"Creating database '{db_name}'")
            conn.execute(text(f'CREATE DATABASE "{db_name}"'))
            print('Created')


if __name__ == '__main__':
    create_database_if_missing()
