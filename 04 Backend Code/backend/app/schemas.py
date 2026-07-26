from marshmallow import Schema, fields, validate, validates_schema, ValidationError


class ReservationSchema(Schema):
    id = fields.Int(dump_only=True)
    name = fields.Str(required=True, validate=validate.Length(min=1))
    email = fields.Email(required=True)
    phone = fields.Str(required=False, allow_none=True)
    party_size = fields.Int(required=True, validate=validate.Range(min=1))
    reserved_at = fields.DateTime(required=True)
    notes = fields.Str(required=False, allow_none=True)
    created_at = fields.DateTime(dump_only=True)


class MenuItemSchema(Schema):
    id = fields.Int(dump_only=True)
    name = fields.Str(required=True)
    description = fields.Str(required=False, allow_none=True)
    price_cents = fields.Int(required=True)
    category = fields.Str(required=False, allow_none=True)
    available = fields.Bool()
    featured = fields.Bool()
    created_at = fields.DateTime(dump_only=True)


class OrderItemSchema(Schema):
    menu_item_id = fields.Int(required=True)
    quantity = fields.Int(required=True, validate=validate.Range(min=1))
    unit_price_cents = fields.Int(dump_only=True)
    name = fields.Function(
        serialize=lambda obj: obj.menu_item.name if obj.menu_item else None,
        dump_only=True
    )


class OrderSchema(Schema):
    id = fields.Int(dump_only=True)
    customer_name = fields.Str(required=True)
    customer_phone = fields.Str(required=False, allow_none=True)
    customer_email = fields.Email(required=True)
    status = fields.Str(dump_only=True)
    order_type = fields.Str(
        required=True,
        validate=validate.OneOf(['collection'])
    )
    payment_method = fields.Str(
        required=True,
        validate=validate.OneOf(['pay_on_collection'])
    )
    payment_status = fields.Str(dump_only=True)
    collection_time = fields.DateTime(required=True)
    notes = fields.Str(required=False, allow_none=True)
    items = fields.List(fields.Nested(OrderItemSchema), required=True)
    total_cents = fields.Int(dump_only=True)
    created_at = fields.DateTime(dump_only=True)


class NewsletterSchema(Schema):
    id = fields.Int(dump_only=True)
    email = fields.Email(required=True)
    subscribed_at = fields.DateTime(dump_only=True)


class GallerySchema(Schema):
    id = fields.Int(dump_only=True)
    url = fields.Url(required=True)
    caption = fields.Str(required=False, allow_none=True)
    created_at = fields.DateTime(dump_only=True)


class TestimonialSchema(Schema):
    id = fields.Int(dump_only=True)
    author = fields.Str(required=True)
    content = fields.Str(required=True)
    visible = fields.Bool()
    created_at = fields.DateTime(dump_only=True)


class AdminRegisterSchema(Schema):
    username = fields.Str(required=True)
    password = fields.Str(required=True, validate=validate.Length(min=6))


class AdminLoginSchema(Schema):
    username = fields.Str(required=True)
    password = fields.Str(required=True)
