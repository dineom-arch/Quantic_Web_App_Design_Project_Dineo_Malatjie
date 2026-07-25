# PostgreSQL implementation notes

- The schema follows the requested entity set: customers, reservations, newsletter_subscribers, menu_categories, menu_items, orders, order_items, gallery_images, and testimonials.
- UUID primary keys are used throughout.
- The design is normalized to Third Normal Form by keeping descriptive data in separate lookup/tables and storing transactional relationships in join tables.
- Assumption: testimonials are linked to customers, and every testimonial is associated with a known customer record.
- Assumption: orders are customer-initiated transactional records and use a business-facing order number.
- Assumption: menu item pricing is stored per item and order item pricing is stored as a snapshot of the unit price at purchase time.
