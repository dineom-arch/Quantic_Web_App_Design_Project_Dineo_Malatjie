from flask import Blueprint, request
from ..extensions import db
from ..models import AdminUser, Order
from ..schemas import AdminRegisterSchema, AdminLoginSchema
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity

admin_bp = Blueprint('admin', __name__)
reg_schema = AdminRegisterSchema()
login_schema = AdminLoginSchema()


@admin_bp.route('/register', methods=['POST'])
def register():
    payload = request.get_json() or {}
    errors = reg_schema.validate(payload)
    if errors:
        return {'errors': errors}, 400
    if AdminUser.query.filter_by(username=payload['username']).first():
        return {'error': 'username taken'}, 400
    a = AdminUser(username=payload['username'])
    a.set_password(payload['password'])
    db.session.add(a)
    db.session.commit()
    return {'message': 'admin created'}, 201


@admin_bp.route('/login', methods=['POST'])
def login():
    payload = request.get_json() or {}
    errors = login_schema.validate(payload)
    if errors:
        return {'errors': errors}, 400
    a = AdminUser.query.filter_by(username=payload['username']).first()
    if not a or not a.check_password(payload['password']):
        return {'error': 'invalid credentials'}, 401
    access = create_access_token(identity=a.username)
    return {'access_token': access}, 200


@admin_bp.route('/orders', methods=['GET'])
@jwt_required()
def admin_list_orders():
    # admin-only listing of all orders
    orders = Order.query.order_by(Order.created_at.desc()).all()
    out = []
    for o in orders:
        out.append({'id': o.id, 'customer_name': o.customer_name, 'status': o.status, 'total_cents': o.total_cents, 'created_at': o.created_at.isoformat()})
    return {'orders': out}, 200
