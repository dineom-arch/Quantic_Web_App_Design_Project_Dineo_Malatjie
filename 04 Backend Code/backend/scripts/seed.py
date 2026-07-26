import os
from app import create_app
from app.extensions import db
from app.models import MenuItem, AdminUser, Testimonial, GalleryImage, NewsletterSubscriber

def seed(target_app=None):
    active_app = target_app or create_app()
    with active_app.app_context():
        db.create_all()

        admin_password = os.getenv('ADMIN_PASSWORD')
        admin_username = os.getenv('ADMIN_USERNAME', 'admin')
        if admin_password and not AdminUser.query.filter_by(username=admin_username).first():
            a = AdminUser(username=admin_username)
            a.set_password(admin_password)
            db.session.add(a)

        menu_data = [
            ('Truffle Eggs Benedict', 'Poached eggs, toasted brioche and truffle hollandaise', 12500, 'Brunch', True),
            ('Café Latte', 'Rich espresso with silky steamed milk', 4500, 'Beverages', True),
            ('Espresso', 'Classic single-origin double shot', 3200, 'Beverages', False),
            ('Butter Croissant', 'Daily baked, flaky all-butter pastry', 4200, 'Bakery', True),
            ('Wild Mushroom Risotto', 'Parmesan, herbs and truffle oil', 14800, 'Mains', False),
            ('Herb-Crusted Salmon', 'Seasonal vegetables and lemon beurre blanc', 18200, 'Mains', False),
            ('Roasted Pumpkin Ravioli', 'Sage butter, hazelnut and pecorino', 14200, 'Mains', False),
            ('Chocolate Fondant', 'Dark chocolate centre and vanilla crème anglaise', 7800, 'Desserts', False),
            ('Citrus Crème Brûlée', 'Orange, vanilla and almond tuile', 7200, 'Desserts', False),
        ]
        for name, description, price_cents, category, featured in menu_data:
            item = MenuItem.query.filter_by(name=name).first()
            if item is None:
                item = MenuItem(name=name)
                db.session.add(item)
            item.description = description
            item.price_cents = price_cents
            item.category = category
            item.available = True
            item.featured = featured

        if Testimonial.query.count() == 0:
            t = Testimonial(author='Alice', content='Lovely cafe with great service!', visible=True)
            db.session.add(t)

        if GalleryImage.query.count() == 0:
            g = GalleryImage(url='https://example.com/cafe-front.jpg', caption='Café Fausse exterior')
            db.session.add(g)

        if NewsletterSubscriber.query.count() == 0:
            ns = NewsletterSubscriber(email='hello@cafefausse.example')
            db.session.add(ns)

        db.session.commit()
        print('Seeding complete')


if __name__ == '__main__':
    seed()
