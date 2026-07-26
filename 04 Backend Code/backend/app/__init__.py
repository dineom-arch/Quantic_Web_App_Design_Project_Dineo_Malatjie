from flask import Flask
from flask_cors import CORS

from .config import Config
from .extensions import db, ma, migrate, jwt


def create_app(test_config=None):
    app = Flask(__name__)
    app.config.from_object(Config)

    if test_config:
        app.config.update(test_config)

    # Enable CORS for the React frontend
    CORS(app)

    # Initialize extensions
    db.init_app(app)
    ma.init_app(app)
    migrate.init_app(app, db)
    jwt.init_app(app)

    # Register blueprints
    from .reservations.routes import reservations_bp
    from .menu.routes import menu_bp
    from .orders.routes import orders_bp
    from .newsletter.routes import newsletter_bp
    from .gallery.routes import gallery_bp
    from .testimonials.routes import testimonials_bp
    from .admin.routes import admin_bp

    app.register_blueprint(
        reservations_bp,
        url_prefix="/api/reservations"
    )

    app.register_blueprint(
        menu_bp,
        url_prefix="/api/menu"
    )

    app.register_blueprint(
        orders_bp,
        url_prefix="/api/orders"
    )

    app.register_blueprint(
        newsletter_bp,
        url_prefix="/api/newsletter"
    )

    app.register_blueprint(
        gallery_bp,
        url_prefix="/api/gallery"
    )

    app.register_blueprint(
        testimonials_bp,
        url_prefix="/api/testimonials"
    )

    app.register_blueprint(
        admin_bp,
        url_prefix="/api/admin"
    )

    @app.route("/")
    def index():
        return {"message": "Café Fausse Backend API"}, 200

    return app