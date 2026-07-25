from flask import Blueprint, request
from ..extensions import db
from ..models import Order, OrderItem, MenuItem
from ..schemas import OrderSchema

orders_bp = Blueprint('orders', __name__)
schema = OrderSchema()


def calculate_total(items):
    total = 0
    for it in items:
        menu = MenuItem.query.get(it['menu_item_id'])
        if not menu:
            return None, f"Menu item {it['menu_item_id']} not found"
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

    order = Order(customer_name=payload['customer_name'], customer_phone=payload.get('customer_phone'), total_cents=total)
    db.session.add(order)
    db.session.flush()

    for it in payload['items']:
        oi = OrderItem(order_id=order.id, menu_item_id=it['menu_item_id'], quantity=it['quantity'])
        db.session.add(oi)

    db.session.commit()
    return schema.dump(order), 201


@orders_bp.route('', methods=['GET'])
def list_orders():
    orders = Order.query.order_by(Order.created_at.desc()).all()
    return schema.dump(orders, many=True), 200


@orders_bp.route('/<int:order_id>', methods=['GET'])
def get_order(order_id):
    order = Order.query.get_or_404(order_id)
    return schema.dump(order), 200


@orders_bp.route('/<int:order_id>/status', methods=['PUT'])
def update_status(order_id):
    order = Order.query.get_or_404(order_id)
    payload = request.get_json() or {}
    status = payload.get('status')
    if not status:
        return {'error': 'status field required'}, 400
    order.status = status
    db.session.commit()
    return schema.dump(order), 200
