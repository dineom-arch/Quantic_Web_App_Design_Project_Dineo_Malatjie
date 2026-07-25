from flask import Blueprint, request
from ..extensions import db
from ..models import NewsletterSubscriber
from ..schemas import NewsletterSchema

newsletter_bp = Blueprint('newsletter', __name__)
schema = NewsletterSchema()


@newsletter_bp.route('/subscribe', methods=['POST'])
def subscribe():
    payload = request.get_json() or {}
    errors = schema.validate(payload)
    if errors:
        return {'errors': errors}, 400
    email = payload['email']
    existing = NewsletterSubscriber.query.filter_by(email=email).first()
    if existing:
        return {'message': 'Already subscribed'}, 200
    sub = NewsletterSubscriber(email=email)
    db.session.add(sub)
    db.session.commit()
    return schema.dump(sub), 201


@newsletter_bp.route('', methods=['GET'])
def list_subscribers():
    subs = NewsletterSubscriber.query.order_by(NewsletterSubscriber.subscribed_at.desc()).all()
    return schema.dump(subs, many=True), 200


@newsletter_bp.route('/unsubscribe', methods=['POST'])
def unsubscribe():
    payload = request.get_json() or {}
    email = payload.get('email')
    if not email:
        return {'error': 'email required'}, 400
    sub = NewsletterSubscriber.query.filter_by(email=email).first()
    if not sub:
        return {'message': 'not found'}, 404
    db.session.delete(sub)
    db.session.commit()
    return {}, 204
