from datetime import datetime
from flask import Blueprint, request
from flask_jwt_extended import jwt_required
from ..extensions import db
from ..models import Order, OrderItem, MenuItem
from ..schemas import OrderSchema

orders_bp = Blueprint('orders', __name__)
schema = OrderSchema()


def calculate_total(items):
    total = 0
    for it in items:
        menu = MenuItem.query.get(it['menu_item_id'])
        if not menu or not menu.available:
            return None, f"Menu item {it['menu_item_id']} is not available"
        total += menu.price_cents * it['quantity']
    return total, None


@orders_bp.route('', methods=['POST'])
def create_order():
    payload = request.get_json() or {}
    errors = schema.validate(payload)
    if errors:
        return {'errors': errors}, 400

    total, err = calculate_total(payload['items'])
    if err:
        return {'error': err}, 400

    order = Order(
        customer_name=payload['customer_name'],
        customer_phone=payload.get('customer_phone'),
        customer_email=payload['customer_email'],
        order_type=payload['order_type'],
        payment_method=payload['payment_method'],
        payment_status='pending',
        collection_time=datetime.fromisoformat(payload['collection_time']),
        notes=payload.get('notes'),
        total_cents=total
    )
    db.session.add(order)
    db.session.flush()

    for it in payload['items']:
        menu_item = db.session.get(MenuItem, it['menu_item_id'])
        oi = OrderItem(
            order_id=order.id,
            menu_item_id=it['menu_item_id'],
            quantity=it['quantity'],
            unit_price_cents=menu_item.price_cents
        )
        db.session.add(oi)

    db.session.commit()
    return schema.dump(order), 201


@orders_bp.route('', methods=['GET'])
@jwt_required()
def list_orders():
    orders = Order.query.order_by(Order.created_at.desc()).all()
    return schema.dump(orders, many=True), 200


@orders_bp.route('/<int:order_id>', methods=['GET'])
@jwt_required()
def get_order(order_id):
    order = Order.query.get_or_404(order_id)
    return schema.dump(order), 200


@orders_bp.route('/<int:order_id>/status', methods=['PUT'])
@jwt_required()
def update_status(order_id):
    order = Order.query.get_or_404(order_id)
    payload = request.get_json() or {}
    status = payload.get('status')
    if not status:
        return {'error': 'status field required'}, 400
    order.status = status
    db.session.commit()
    return schema.dump(order), 200
