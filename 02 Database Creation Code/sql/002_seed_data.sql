-- Seed data for the Café Fausse Restaurant Platform

INSERT INTO customers (id, first_name, last_name, email, phone) VALUES
    ('11111111-1111-1111-1111-111111111111', 'Ava', 'Nguyen', 'ava.nguyen@example.com', '+27 82 111 1111'),
    ('22222222-2222-2222-2222-222222222222', 'Liam', 'Peters', 'liam.peters@example.com', '+27 83 222 2222'),
    ('33333333-3333-3333-3333-333333333333', 'Maya', 'Dlamini', 'maya.dlamini@example.com', '+27 84 333 3333');

INSERT INTO reservations (id, customer_id, reservation_date, party_size, status, notes) VALUES
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', '2026-08-10 19:00:00+00', 4, 'confirmed', 'Window table requested.'),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '22222222-2222-2222-2222-222222222222', '2026-08-12 20:30:00+00', 2, 'pending', 'Vegetarian menu preference.'),
    ('cccccccc-cccc-cccc-cccc-cccccccccccc', '33333333-3333-3333-3333-333333333333', '2026-08-14 18:30:00+00', 6, 'confirmed', 'Celebration dinner.');

INSERT INTO newsletter_subscribers (id, email, is_active) VALUES
    ('44444444-4444-4444-4444-444444444444', 'ava.nguyen@example.com', TRUE),
    ('55555555-5555-5555-5555-555555555555', 'liam.peters@example.com', TRUE),
    ('66666666-6666-6666-6666-666666666666', 'newsletter@sample.com', FALSE);

INSERT INTO menu_categories (id, name, description, sort_order, is_active) VALUES
    ('77777777-7777-7777-7777-777777777777', 'Starters', 'Small plates and appetizers.', 1, TRUE),
    ('88888888-8888-8888-8888-888888888888', 'Mains', 'Signature mains and comfort dishes.', 2, TRUE),
    ('99999999-9999-9999-9999-999999999999', 'Desserts', 'Sweet finishes and pastries.', 3, TRUE);

INSERT INTO menu_items (id, category_id, name, description, price, is_available) VALUES
    ('12121212-1212-1212-1212-121212121212', '77777777-7777-7777-7777-777777777777', 'Truffle Arancini', 'Crispy risotto balls with truffle aioli.', 95.00, TRUE),
    ('13131313-1313-1313-1313-131313131313', '77777777-7777-7777-7777-777777777777', 'Roasted Tomato Bruschetta', 'Toasted sourdough with herbs and balsamic.', 75.00, TRUE),
    ('14141414-1414-1414-1414-141414141414', '88888888-8888-8888-8888-888888888888', 'Braised Beef Short Rib', 'Slow-cooked with red wine jus.', 220.00, TRUE),
    ('15151515-1515-1515-1515-151515151515', '88888888-8888-8888-8888-888888888888', 'Wild Mushroom Risotto', 'Creamy arborio with roasted mushrooms.', 185.00, TRUE),
    ('16161616-1616-1616-1616-161616161616', '99999999-9999-9999-9999-999999999999', 'Dark Chocolate Tart', 'Rich ganache with sea salt caramel.', 110.00, TRUE),
    ('17171717-1717-1717-1717-171717171717', '99999999-9999-9999-9999-999999999999', 'Lemon Posset', 'Citrus cream with berry compote.', 95.00, TRUE);

INSERT INTO orders (id, customer_id, order_number, order_status, order_date, total_amount, delivery_address) VALUES
    ('18181818-1818-1818-1818-181818181818', '11111111-1111-1111-1111-111111111111', 'ORD-1001', 'confirmed', '2026-08-01 19:45:00+00', 315.00, '14 Orchid Road, Johannesburg'),
    ('19191919-1919-1919-1919-191919191919', '22222222-2222-2222-2222-222222222222', 'ORD-1002', 'preparing', '2026-08-02 13:20:00+00', 185.00, '8 Willow Avenue, Cape Town');

INSERT INTO order_items (id, order_id, menu_item_id, quantity, unit_price, line_total) VALUES
    ('20202020-2020-2020-2020-202020202020', '18181818-1818-1818-1818-181818181818', '12121212-1212-1212-1212-121212121212', 2, 95.00, 190.00),
    ('21212121-2121-2121-2121-212121212121', '18181818-1818-1818-1818-181818181818', '14141414-1414-1414-1414-141414141414', 1, 125.00, 125.00),
    ('22222222-2222-2222-2222-222222222222', '19191919-1919-1919-1919-191919191919', '15151515-1515-1515-1515-151515151515', 1, 185.00, 185.00);

INSERT INTO gallery_images (id, title, image_url, alt_text, caption, is_published, sort_order) VALUES
    ('23232323-2323-2323-2323-232323232323', 'Dining Room', 'https://example.com/images/dining-room.jpg', 'Warm dining room interior', 'A cozy view of the main dining room.', TRUE, 1),
    ('24242424-2424-2424-2424-242424242424', 'Chef Station', 'https://example.com/images/chef-station.jpg', 'Chef preparing a dish', 'The open kitchen in action.', TRUE, 2),
    ('25252525-2525-2525-2525-252525252525', 'Dessert Display', 'https://example.com/images/dessert-display.jpg', 'Dessert display', 'Seasonal desserts on display.', TRUE, 3),
    ('26262626-2626-2626-2626-262626262626', 'Outdoor Terrace', 'https://example.com/images/outdoor-terrace.jpg', 'Outdoor terrace seating', 'Evening seating on the terrace.', TRUE, 4);

INSERT INTO testimonials (id, customer_id, testimonial_text, rating, is_approved) VALUES
    ('27272727-2727-2727-2727-272727272727', '11111111-1111-1111-1111-111111111111', 'The service was impeccable and the food was outstanding.', 5, TRUE),
    ('28282828-2828-2828-2828-282828282828', '22222222-2222-2222-2222-222222222222', 'A beautiful venue for a special occasion.', 4, TRUE),
    ('29292929-2929-2929-2929-292929292929', '33333333-3333-3333-3333-333333333333', 'Everything felt polished, from the ambiance to the dessert course.', 5, TRUE);
