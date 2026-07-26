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
    res = client.post('/api/menu', json={
        'name': 'Test Coffee',
        'price_cents': 500,
        'featured': True
    })
    assert res.status_code == 201
    item = res.get_json()
    item_id = item['id']

    # Create order
    featured = client.get('/api/menu?featured=true').get_json()
    assert [menu_item['id'] for menu_item in featured] == [item_id]

    order_payload = {
        'customer_name': 'Bob',
        'customer_phone': '0820000000',
        'customer_email': 'bob@example.com',
        'order_type': 'collection',
        'payment_method': 'pay_on_collection',
        'collection_time': '2026-12-01T12:30:00',
        'items': [{'menu_item_id': item_id, 'quantity': 2}]
    }
    res = client.post('/api/orders', json=order_payload)
    assert res.status_code == 201
    order = res.get_json()
    assert order['customer_name'] == 'Bob'
    assert order['total_cents'] == 1000
    assert order['order_type'] == 'collection'
    assert order['items'][0]['unit_price_cents'] == 500


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
