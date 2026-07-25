import json
import pytest
from app import create_app
from app.extensions import db


@pytest.fixture
def client():
    config = {
        'TESTING': True,
        'SQLALCHEMY_DATABASE_URI': 'sqlite:///:memory:',
        'JWT_SECRET_KEY': 'test-secret'
    }
    app = create_app(test_config=config)
    with app.test_client() as client:
        with app.app_context():
            db.create_all()
        yield client
        with app.app_context():
            db.drop_all()


def test_menu_and_order_flow(client):
    # Create menu item
    res = client.post('/api/menu', json={'name': 'Test Coffee', 'price_cents': 500})
    assert res.status_code == 201
    item = res.get_json()
    item_id = item['id']

    # Create order
    order_payload = {'customer_name': 'Bob', 'items': [{'menu_item_id': item_id, 'quantity': 2}]}
    res = client.post('/api/orders', json=order_payload)
    assert res.status_code == 201
    order = res.get_json()
    assert order['customer_name'] == 'Bob'


def test_reservations_and_newsletter(client):
    # Reservation
    payload = {
        'name': 'Jane',
        'email': 'jane@example.com',
        'party_size': 2,
        'reserved_at': '2026-12-01T19:00:00'
    }
    res = client.post('/api/reservations', json=payload)
    assert res.status_code == 201

    # Newsletter subscribe
    res = client.post('/api/newsletter/subscribe', json={'email': 'jane@example.com'})
    assert res.status_code in (200, 201)
