# PostgreSQL implementation notes

## Important application alignment note

The running Flask application is upgraded using the Alembic files in the
top-level `migrations` folder. Run `flask db upgrade` before reseeding it.
`005_running_app_upgrade.sql` documents the equivalent PostgreSQL changes for
the current integer-key Flask tables.

The UUID-based scripts in this folder are retained as the reviewed database
design coursework. Do not execute them over the Flask-managed database because
they describe a separate, normalized target schema.

- The schema follows the requested entity set: customers, reservations, newsletter_subscribers, menu_categories, menu_items, orders, order_items, gallery_images, and testimonials.
- UUID primary keys are used throughout.
- The design is normalized to Third Normal Form by keeping descriptive data in separate lookup/tables and storing transactional relationships in join tables.
- Assumption: testimonials are linked to customers, and every testimonial is associated with a known customer record.
- Assumption: orders are customer-initiated transactional records and use a business-facing order number.
- Assumption: menu item pricing is stored per item and order item pricing is stored as a snapshot of the unit price at purchase time.
