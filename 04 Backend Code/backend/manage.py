"""
Database migration management commands for the Café Fausse Restaurant Platform.

This script provides a simple command-line interface (CLI) for managing
Flask-Migrate database migrations during development.

Available commands:
    python manage.py db_init
    python manage.py db_migrate -m "Create customer table"
    python manage.py db_upgrade
    python manage.py db_revision -m "Manual revision"

Author:
    Café Fausse MSc AI Engineering Project
"""

import click
from flask_migrate import (
    init as mig_init,
    migrate as mig_migrate,
    upgrade as mig_upgrade,
    revision as mig_revision,
)

from app import create_app

# ---------------------------------------------------------------------
# Create the Flask application using the Application Factory pattern.
# ---------------------------------------------------------------------
app = create_app()


# ---------------------------------------------------------------------
# Create the root Click command group.
# All database commands will belong to this group.
# ---------------------------------------------------------------------
@click.group()
def cli() -> None:
    """Management commands for database migrations."""
    pass


# ---------------------------------------------------------------------
# Initialise the Alembic migrations folder.
# This should only be run once when creating the project.
# ---------------------------------------------------------------------
@cli.command("db_init")
def db_init() -> None:
    """Initialise the migrations directory."""

    try:
        with app.app_context():
            mig_init()
            click.echo("✓ Migrations directory initialised successfully.")

    except Exception as exc:
        raise click.ClickException(
            f"Failed to initialise migrations: {exc}"
        )


# ---------------------------------------------------------------------
# Generate a migration automatically by comparing the SQLAlchemy models
# with the current database schema.
# ---------------------------------------------------------------------
@cli.command("db_migrate")
@click.option(
    "--message",
    "-m",
    default="Auto-generated migration",
    help="Migration description."
)
def db_migrate(message: str) -> None:
    """Generate a new database migration."""

    try:
        with app.app_context():
            mig_migrate(message=message)
            click.echo("✓ Migration created successfully.")

    except Exception as exc:
        raise click.ClickException(
            f"Migration failed: {exc}"
        )


# ---------------------------------------------------------------------
# Apply all pending migrations to the database.
# ---------------------------------------------------------------------
@cli.command("db_upgrade")
def db_upgrade() -> None:
    """Upgrade the database to the latest revision."""

    try:
        with app.app_context():
            mig_upgrade()
            click.echo("✓ Database upgraded successfully.")

    except Exception as exc:
        raise click.ClickException(
            f"Database upgrade failed: {exc}"
        )


# ---------------------------------------------------------------------
# Create a blank Alembic revision.
# This is useful when writing migrations manually.
# ---------------------------------------------------------------------
@cli.command("db_revision")
@click.option(
    "--message",
    "-m",
    default="Manual revision",
    help="Revision description."
)
def db_revision(message: str) -> None:
    """Create an empty database revision."""

    try:
        with app.app_context():
            mig_revision(message=message)
            click.echo("✓ Revision created successfully.")

    except Exception as exc:
        raise click.ClickException(
            f"Revision creation failed: {exc}"
        )


# ---------------------------------------------------------------------
# Entry point.
# ---------------------------------------------------------------------
if __name__ == "__main__":
    cli()