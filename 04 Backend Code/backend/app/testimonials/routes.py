from flask import Blueprint, request
from ..extensions import db
from ..models import Testimonial
from ..schemas import TestimonialSchema

testimonials_bp = Blueprint('testimonials', __name__)
schema = TestimonialSchema()


@testimonials_bp.route('', methods=['POST'])
def create_testimonial():
    payload = request.get_json() or {}
    errors = schema.validate(payload)
    if errors:
        return {'errors': errors}, 400
    t = Testimonial(author=payload['author'], content=payload['content'], visible=payload.get('visible', True))
    db.session.add(t)
    db.session.commit()
    return schema.dump(t), 201


@testimonials_bp.route('', methods=['GET'])
def list_testimonials():
    items = Testimonial.query.filter_by(visible=True).order_by(Testimonial.created_at.desc()).all()
    return schema.dump(items, many=True), 200


@testimonials_bp.route('/<int:id>', methods=['DELETE'])
def delete_testimonial(id):
    t = Testimonial.query.get_or_404(id)
    db.session.delete(t)
    db.session.commit()
    return {}, 204
