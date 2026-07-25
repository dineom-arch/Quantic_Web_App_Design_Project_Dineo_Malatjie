from flask import Blueprint, request
from ..extensions import db
from ..models import MenuItem
from ..schemas import MenuItemSchema

menu_bp = Blueprint('menu', __name__)
schema = MenuItemSchema()


@menu_bp.route('', methods=['POST'])
def create_item():
    payload = request.get_json() or {}
    errors = schema.validate(payload)
    if errors:
        return {'errors': errors}, 400
    item = MenuItem(
        name=payload['name'],
        description=payload.get('description'),
        price_cents=payload['price_cents'],
        category=payload.get('category'),
        available=payload.get('available', True)
    )
    db.session.add(item)
    db.session.commit()
    return schema.dump(item), 201


@menu_bp.route('', methods=['GET'])
def list_items():
    items = MenuItem.query.order_by(MenuItem.category.asc().nullsfirst(), MenuItem.name.asc()).all()
    return schema.dump(items, many=True), 200


@menu_bp.route('/<int:item_id>', methods=['GET'])
def get_item(item_id):
    item = MenuItem.query.get_or_404(item_id)
    return schema.dump(item), 200


@menu_bp.route('/<int:item_id>', methods=['PUT'])
def update_item(item_id):
    item = MenuItem.query.get_or_404(item_id)
    payload = request.get_json() or {}
    errors = schema.validate(payload, partial=True)
    if errors:
        return {'errors': errors}, 400
    for k, v in payload.items():
        setattr(item, k, v)
    db.session.commit()
    return schema.dump(item), 200


@menu_bp.route('/<int:item_id>', methods=['DELETE'])
def delete_item(item_id):
    item = MenuItem.query.get_or_404(item_id)
    db.session.delete(item)
    db.session.commit()
    return {}, 204
