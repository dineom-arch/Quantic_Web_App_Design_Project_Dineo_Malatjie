from app import create_app
from app.extensions import db
from app.models import MenuItem, AdminUser, Testimonial, GalleryImage, NewsletterSubscriber

app = create_app()


def seed():
    with app.app_context():
        db.create_all()

        if not AdminUser.query.filter_by(username='admin').first():
            a = AdminUser(username='admin')
            a.set_password('adminpass')
            db.session.add(a)

        if MenuItem.query.count() == 0:
            items = [
                MenuItem(name='Café Latte', description='Rich espresso with steamed milk', price_cents=450, category='Beverages'),
                MenuItem(name='Espresso', description='Classic single shot', price_cents=250, category='Beverages'),
                MenuItem(name='Croissant', description='Buttery flaky pastry', price_cents=300, category='Pastries')
            ]
            db.session.add_all(items)

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
