from flask import Blueprint, request, jsonify
from ..extensions import db
from ..models import Reservation
from ..schemas import ReservationSchema
from datetime import datetime

reservations_bp = Blueprint('reservations', __name__)
schema = ReservationSchema()


@reservations_bp.route('', methods=['POST'])
def create_reservation():
    payload = request.get_json() or {}
    errors = schema.validate(payload)
    if errors:
        return {'errors': errors}, 400

    r = Reservation(
        name=payload['name'],
        email=payload['email'],
        phone=payload.get('phone'),
        party_size=payload['party_size'],
        reserved_at=datetime.fromisoformat(payload['reserved_at']),
        notes=payload.get('notes')
    )
    db.session.add(r)
    db.session.commit()
    return schema.dump(r), 201


@reservations_bp.route('', methods=['GET'])
def list_reservations():
    items = Reservation.query.order_by(Reservation.reserved_at.asc()).all()
    return jsonify(schema.dump(items, many=True)), 200


@reservations_bp.route('/<int:reservation_id>', methods=['GET'])
def get_reservation(reservation_id):
    r = Reservation.query.get_or_404(reservation_id)
    return schema.dump(r), 200


@reservations_bp.route('/<int:reservation_id>', methods=['PUT'])
def update_reservation(reservation_id):
    r = Reservation.query.get_or_404(reservation_id)
    payload = request.get_json() or {}
    errors = schema.validate(payload, partial=True)
    if errors:
        return {'errors': errors}, 400

    for k, v in payload.items():
        if k == 'reserved_at':
            v = datetime.fromisoformat(v)
        setattr(r, k, v)
    db.session.commit()
    return schema.dump(r), 200


@reservations_bp.route('/<int:reservation_id>', methods=['DELETE'])
def delete_reservation(reservation_id):
    r = Reservation.query.get_or_404(reservation_id)
    db.session.delete(r)
    db.session.commit()
    return {}, 204
