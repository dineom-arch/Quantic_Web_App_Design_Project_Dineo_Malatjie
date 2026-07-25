from flask import Blueprint, request
from ..extensions import db
from ..models import GalleryImage
from ..schemas import GallerySchema

gallery_bp = Blueprint('gallery', __name__)
schema = GallerySchema()


@gallery_bp.route('', methods=['POST'])
def add_image():
    payload = request.get_json() or {}
    errors = schema.validate(payload)
    if errors:
        return {'errors': errors}, 400
    img = GalleryImage(url=payload['url'], caption=payload.get('caption'))
    db.session.add(img)
    db.session.commit()
    return schema.dump(img), 201


@gallery_bp.route('', methods=['GET'])
def list_images():
    imgs = GalleryImage.query.order_by(GalleryImage.created_at.desc()).all()
    return schema.dump(imgs, many=True), 200


@gallery_bp.route('/<int:image_id>', methods=['DELETE'])
def delete_image(image_id):
    img = GalleryImage.query.get_or_404(image_id)
    db.session.delete(img)
    db.session.commit()
    return {}, 204
