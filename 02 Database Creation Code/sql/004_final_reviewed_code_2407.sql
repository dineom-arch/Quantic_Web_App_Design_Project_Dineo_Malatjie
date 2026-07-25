-- ============================================================================
-- CAFÉ FAUSSE RESTAURANT PLATFORM
-- PostgreSQL Database Schema
-- ============================================================================
--
-- PURPOSE
-- -------
-- This script creates the relational database used by the Café Fausse
-- Restaurant Platform.
--
-- It demonstrates several core database design principles taught in
-- software engineering and database modules:
--
-- • Relational database design
-- • Primary Keys
-- • Foreign Keys
-- • Entity relationships
-- • Data integrity
-- • Constraints
-- • Indexing
-- • Audit columns
-- • Database triggers
-- • Normalisation (1NF, 2NF and 3NF)
--
-- The tables are created in dependency order.
-- Parent tables are created before child tables so that foreign key
-- relationships can be created successfully.
--
-- ============================================================================



-- ============================================================================
-- PostgreSQL Extension
-- ============================================================================

-- PostgreSQL supports extensions that add additional functionality.
--
-- pgcrypto provides cryptographic functions.
--
-- In this project we use:
--
--     gen_random_uuid()
--
-- which automatically generates a universally unique identifier (UUID)
-- whenever a new record is inserted.
--
-- UUIDs are preferred over sequential integers because:
--
-- • every record receives a globally unique identifier
-- • IDs cannot easily be guessed
-- • multiple systems can generate IDs without collisions
-- • suitable for modern web applications and APIs
--
-- Example UUID:
--
--     5d9a5bfa-86fd-40e4-a4e7-b2d5fb6b2fd0
--

CREATE EXTENSION IF NOT EXISTS pgcrypto;



-- ============================================================================
-- Audit Trigger Function
-- ============================================================================

-- Most business systems need to know:
--
-- • when a record was created
-- • when it was last modified
--
-- Every table in this database therefore contains:
--
--     created_at
--     updated_at
--
-- created_at
-- ----------
-- Automatically populated when the record is first inserted.
--
-- updated_at
-- ----------
-- Automatically updated every time the record changes.
--
-- Instead of writing separate update logic inside the application,
-- PostgreSQL can do this automatically using a trigger.
--
-- A trigger executes automatically whenever a specified database event
-- occurs.
--
-- In this case:
--
-- BEFORE UPDATE
--
-- means:
--
-- "Before a row is updated, execute this function."
--
-- The function simply replaces the value of updated_at with the current
-- timestamp.
--
-- This improves:
--
-- • consistency
-- • maintainability
-- • reliability
--
-- because developers never need to remember to update the timestamp
-- themselves.
--

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS
$$
BEGIN

    -- Replace the old timestamp with the current time.
    NEW.updated_at = CURRENT_TIMESTAMP;

    -- Return the modified record.
    RETURN NEW;

END;
$$
LANGUAGE plpgsql;



-- ============================================================================
-- Drop Existing Tables
-- ============================================================================

-- During development it is common to recreate the database many times.
--
-- Rather than manually deleting tables,
-- this script removes them automatically.
--
-- IF EXISTS
-- ---------
-- Prevents an error if the table does not yet exist.
--
-- CASCADE
-- -------
-- Removes dependent objects such as foreign key relationships.
--
-- IMPORTANT
-- ---------
-- Tables must be dropped in the reverse order in which they depend on
-- each other.
--
-- Example
--
-- orders
--     ↓
-- order_items
--
-- order_items must be removed BEFORE orders.
--
-- Otherwise PostgreSQL would reject the operation because
-- order_items depends on orders.
--

DROP TABLE IF EXISTS order_items CASCADE;

DROP TABLE IF EXISTS testimonials CASCADE;

DROP TABLE IF EXISTS reservations CASCADE;

DROP TABLE IF EXISTS orders CASCADE;

DROP TABLE IF EXISTS gallery_images CASCADE;

DROP TABLE IF EXISTS menu_items CASCADE;

DROP TABLE IF EXISTS menu_categories CASCADE;

DROP TABLE IF EXISTS newsletter_subscribers CASCADE;

DROP TABLE IF EXISTS customers CASCADE;



-- ============================================================================
-- END OF PART 1
-- ============================================================================
--
-- The next section begins creating the actual entities.
--
-- The first table will be:
--
--     customers
--
-- This is called a parent (or master) table because several other
-- tables will reference it using foreign keys.
--
-- Those tables include:
--
-- • reservations
-- • orders
-- • testimonials
--
-- Together they form one-to-many relationships.
--
-- Customer (1)
--      │
--      ├──────── Reservations (Many)
--      ├──────── Orders (Many)
--      └──────── Testimonials (Many)
--
-- This is one of the most common relationship patterns used in
-- relational database design.
--
-- ============================================================================
-- ============================================================================
-- TABLE: customers
-- ============================================================================
--
-- PURPOSE
-- -------
-- This table stores information about every customer who interacts with
-- Café Fausse.
--
-- Examples:
--
-- • Someone making a reservation
-- • Someone placing an online order
-- • Someone writing a testimonial
--
-- This table represents a real-world business entity:
--
--      Customer
--
-- In relational database design, each real-world object usually becomes
-- its own table.
--
-- ============================================================================
--
-- DATABASE DESIGN PRINCIPLES
-- ============================================================================
--
-- This is known as a MASTER TABLE or PARENT TABLE.
--
-- Why?
--
-- Because several other tables will reference it.
--
-- Relationship Diagram
--
--               customers
--                    │
--        ┌───────────┼────────────┐
--        │           │            │
--        ▼           ▼            ▼
-- reservations     orders    testimonials
--
-- Notice something important:
--
-- A customer can have MANY reservations.
--
-- A customer can have MANY orders.
--
-- A customer can write MANY testimonials.
--
-- Therefore these are ONE-TO-MANY relationships.
--
-- Relationship notation:
--
-- Customer (1)
--      │
--      ├──────── Reservation (Many)
--      ├──────── Order (Many)
--      └──────── Testimonial (Many)
--
-- ============================================================================
--
-- NORMALISATION
-- ============================================================================
--
-- This table satisfies First Normal Form (1NF):
--
-- ✓ Every row represents one customer.
--
-- ✓ Every column stores ONE value only.
--
-- Examples
--
-- GOOD
--
-- first_name = 'Sarah'
--
-- BAD
--
-- first_name = 'Sarah, John'
--
-- A column should never contain multiple values.
--
--
-- Second Normal Form (2NF)
--
-- Every attribute depends entirely on the primary key.
--
-- The customer's email belongs only to that customer.
--
--
-- Third Normal Form (3NF)
--
-- There are no unnecessary dependencies.
--
-- Example:
--
-- We DO NOT store reservation details here.
--
-- We DO NOT store menu items here.
--
-- We DO NOT store order totals here.
--
-- Those belong in their own tables.
--
-- This reduces duplicated information and prevents update anomalies.
--
-- ============================================================================

CREATE TABLE customers (

    --------------------------------------------------------------------------
    -- Primary Key
    --------------------------------------------------------------------------
    --
    -- Every table should have a primary key.
    --
    -- A PRIMARY KEY uniquely identifies every row.
    --
    -- Think of it as a customer's identity number inside the database.
    --
    -- PostgreSQL automatically creates a unique index on the primary key,
    -- making searches extremely fast.
    --
    -- UUID stands for Universally Unique Identifier.
    --
    -- Example:
    --
    -- 8ef5bb4e-88d2-45d6-90d7-8c22b376d72f
    --
    -- DEFAULT gen_random_uuid()
    --
    -- tells PostgreSQL:
    --
    -- "If the application doesn't provide an ID,
    -- automatically generate one."
    --
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    --------------------------------------------------------------------------
    -- First Name
    --------------------------------------------------------------------------
    --
    -- Stores the customer's first name.
    --
    -- VARCHAR(100)
    --
    -- VARCHAR means Variable Character String.
    --
    -- Unlike CHAR,
    -- VARCHAR only stores the number of characters required.
    --
    -- Maximum length:
    --
    -- 100 characters
    --
    -- NOT NULL means
    --
    -- "This value is compulsory."
    --
    -- A customer cannot exist without a first name.
    --
    first_name VARCHAR(100) NOT NULL,

    --------------------------------------------------------------------------
    -- Last Name
    --------------------------------------------------------------------------
    --
    -- Stores the customer's surname.
    --
    -- Also compulsory.
    --
    last_name VARCHAR(100) NOT NULL,

    --------------------------------------------------------------------------
    -- Email Address
    --------------------------------------------------------------------------
    --
    -- Email is used for:
    --
    -- • reservations
    -- • order confirmations
    -- • customer communication
    -- • account identification
    --
    -- UNIQUE
    --
    -- prevents duplicate email addresses.
    --
    -- Example
    --
    -- Allowed
    --
    -- jane@example.com
    -- peter@example.com
    --
    -- Not Allowed
    --
    -- jane@example.com
    -- jane@example.com
    --
    -- PostgreSQL automatically creates an index for UNIQUE columns.
    --
    -- Therefore searching by email is very efficient.
    --
    email VARCHAR(255) NOT NULL UNIQUE,

    --------------------------------------------------------------------------
    -- Phone Number
    --------------------------------------------------------------------------
    --
    -- Why VARCHAR instead of INTEGER?
    --
    -- Telephone numbers are identifiers,
    -- not numbers used for mathematical calculations.
    --
    -- Examples that INTEGER cannot store correctly:
    --
    -- +27 82 555 1234
    --
    -- Leading zeros
    --
    -- 0825551234
    --
    -- International prefixes
    --
    -- +44
    --
    -- Spaces
    --
    -- Hyphens
    --
    -- VARCHAR preserves the phone number exactly as entered.
    --
    -- Phone numbers are optional because some customers may choose not
    -- to provide one.
    --
    phone VARCHAR(30),

    --------------------------------------------------------------------------
    -- Record Creation Timestamp
    --------------------------------------------------------------------------
    --
    -- TIMESTAMPTZ
    --
    -- Timestamp With Time Zone
    --
    -- Why use this instead of DATE?
    --
    -- DATE
    --
    -- 2026-07-25
    --
    -- TIMESTAMP
    --
    -- 2026-07-25 18:42:15
    --
    -- TIMESTAMPTZ
    --
    -- 2026-07-25 18:42:15+02
    --
    -- Using time zones is considered best practice for modern web
    -- applications because customers may access the system from different
    -- locations.
    --
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    --------------------------------------------------------------------------
    -- Record Last Updated Timestamp
    --------------------------------------------------------------------------
    --
    -- Initially receives the same value as created_at.
    --
    -- Afterwards,
    -- the database trigger created earlier automatically updates it every
    -- time this record changes.
    --
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP

);

-- ============================================================================
-- WHY THIS TABLE DOES NOT STORE EVERYTHING
-- ============================================================================
--
-- New database designers often ask:
--
-- "Why not put reservations and orders in this table?"
--
-- Imagine one customer visits the restaurant ten times.
--
-- If reservation information were stored here,
-- we would have to duplicate the customer's name, email and phone number
-- ten times.
--
-- Example
--
-- Customer Name
-- Email
-- Phone
-- Reservation Date
--
-- Sarah
-- sarah@email.com
-- 082...
-- Monday
--
-- Sarah
-- sarah@email.com
-- 082...
-- Friday
--
-- Sarah
-- sarah@email.com
-- 082...
-- Saturday
--
-- This is called DATA REDUNDANCY.
--
-- Problems caused by redundancy include:
--
-- • wasted storage
-- • inconsistent information
-- • update anomalies
-- • delete anomalies
--
-- Instead,
-- the customer is stored ONCE.
--
-- Reservations simply store:
--
-- customer_id
--
-- which points back to this table.
--
-- This is the foundation of relational databases.
--
-- ============================================================================
-- END OF CUSTOMERS TABLE
-- ============================================================================
-- ============================================================================
-- TABLE: reservations
-- ============================================================================
--
-- PURPOSE
-- -------
-- This table stores every reservation made at Café Fausse.
--
-- A reservation represents a booking for one specific date and time.
--
-- Unlike the customers table, this table stores EVENTS.
--
-- Think of it this way:
--
-- customers
--     Who is visiting?
--
-- reservations
--     When are they visiting?
--
-- ============================================================================
--
-- DATABASE DESIGN PRINCIPLES
-- ============================================================================
--
-- This table introduces our first FOREIGN KEY.
--
-- Foreign keys are one of the defining features of relational databases.
--
-- They allow tables to be connected together.
--
-- Relationship
--
-- customers
--      │
--      │ 1
--      │
--      ▼
-- reservations
--      *
--
-- Read this as:
--
-- One customer
--
-- can have
--
-- Many reservations.
--
-- Examples
--
-- Sarah
--
-- Reservation
-- Friday
--
-- Reservation
-- Saturday
--
-- Reservation
-- Anniversary Dinner
--
-- Instead of storing Sarah's name repeatedly,
-- each reservation stores only her customer_id.
--
-- This avoids duplication and keeps the database normalised.
--
-- ============================================================================

CREATE TABLE reservations (

    --------------------------------------------------------------------------
    -- Primary Key
    --------------------------------------------------------------------------
    --
    -- Every reservation receives its own unique identifier.
    --
    -- Even if the same customer books multiple times,
    -- every reservation remains unique.
    --
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    --------------------------------------------------------------------------
    -- Customer Foreign Key
    --------------------------------------------------------------------------
    --
    -- This is the most important column in this table.
    --
    -- customer_id links this reservation back to the customer who made it.
    --
    -- REFERENCES customers(id)
    --
    -- tells PostgreSQL:
    --
    -- "The value stored here MUST already exist inside
    -- the customers table."
    --
    -- Example
    --
    -- customers
    --
    -- ID
    -- A123
    --
    -- reservations
    --
    -- customer_id
    -- A123
    --
    -- PostgreSQL checks this automatically.
    --
    -- If someone attempts to insert
    --
    -- customer_id = XYZ999
    --
    -- and that customer does not exist,
    --
    -- PostgreSQL rejects the INSERT.
    --
    -- This is called
    --
    -- REFERENTIAL INTEGRITY.
    --
    -- ON DELETE RESTRICT
    --
    -- means:
    --
    -- "A customer cannot be deleted while reservations still exist."
    --
    -- Why?
    --
    -- Imagine deleting a customer who has ten upcoming bookings.
    --
    -- Those reservations would become "orphan records"
    -- because they would no longer belong to anyone.
    --
    -- RESTRICT prevents this problem.
    --
    customer_id UUID NOT NULL
        REFERENCES customers(id)
        ON DELETE RESTRICT,

    --------------------------------------------------------------------------
    -- Reservation Date and Time
    --------------------------------------------------------------------------
    --
    -- Stores BOTH the date and the time.
    --
    -- Example
    --
    -- 2026-08-10 19:00
    --
    -- Why TIMESTAMPTZ?
    --
    -- Restaurants do not only care about dates.
    --
    -- They also need
    --
    -- • lunch bookings
    -- • dinner bookings
    -- • evening reservations
    --
    -- Time is therefore essential.
    --
    reservation_date TIMESTAMPTZ NOT NULL,

    --------------------------------------------------------------------------
    -- Party Size
    --------------------------------------------------------------------------
    --
    -- Number of guests expected.
    --
    -- INTEGER
    --
    -- is appropriate because party size is a whole number.
    --
    -- CHECK constraints allow PostgreSQL to enforce business rules.
    --
    -- Instead of allowing:
    --
    -- -5 guests
    --
    -- or
    --
    -- 0 guests
    --
    -- the database ensures every reservation has a sensible value.
    --
    -- In this project we also place an upper limit of 20.
    --
    -- This reflects a realistic business rule and prevents accidental
    -- data entry errors such as:
    --
    -- 200 guests
    --
    party_size INTEGER NOT NULL
        CHECK (party_size BETWEEN 1 AND 20),

    --------------------------------------------------------------------------
    -- Reservation Status
    --------------------------------------------------------------------------
    --
    -- Every reservation progresses through a lifecycle.
    --
    -- pending
    --     Customer has submitted the booking.
    --
    -- confirmed
    --     Restaurant has accepted it.
    --
    -- cancelled
    --     Booking cancelled.
    --
    -- completed
    --     Customer has already dined.
    --
    -- CHECK prevents invalid values.
    --
    -- Example
    --
    -- accepted
    --
    -- waiting
    --
    -- almost confirmed
    --
    -- would all be rejected.
    --
    status VARCHAR(30)
        NOT NULL
        DEFAULT 'pending'
        CHECK
        (
            status IN
            (
                'pending',
                'confirmed',
                'cancelled',
                'completed'
            )
        ),

    --------------------------------------------------------------------------
    -- Reservation Notes
    --------------------------------------------------------------------------
    --
    -- Allows staff to record special requests.
    --
    -- Examples
    --
    -- Window table
    --
    -- Birthday celebration
    --
    -- Wheelchair access
    --
    -- Vegetarian menu
    --
    -- TEXT has no practical length limit and is therefore more suitable
    -- than VARCHAR for free-form notes.
    --
    notes TEXT,

    --------------------------------------------------------------------------
    -- Audit Columns
    --------------------------------------------------------------------------
    --
    -- These work exactly like the customers table.
    --
    -- created_at
    --
    -- Records when the reservation was first created.
    --
    -- updated_at
    --
    -- Automatically updated by the trigger whenever the reservation changes.
    --
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP

);

-- ============================================================================
-- WHY RESERVATIONS ARE STORED IN THEIR OWN TABLE
-- ============================================================================
--
-- Imagine Café Fausse has a loyal customer called Sarah.
--
-- Sarah visits every Friday.
--
-- If reservation information were stored inside the customers table,
-- Sarah's row would have to be updated every week,
-- overwriting previous bookings.
--
-- Alternatively, Sarah's customer information would have to be duplicated.
--
-- Neither option is correct.
--
-- Instead, the database stores:
--
-- customers
--
-- Sarah
--
-- once.
--
-- Then stores:
--
-- Reservation 1
--
-- Reservation 2
--
-- Reservation 3
--
-- each as separate rows.
--
-- The relationship is maintained through customer_id.
--
-- ============================================================================
-- REFERENTIAL INTEGRITY
-- ============================================================================
--
-- The foreign key guarantees:
--
-- ✓ Every reservation belongs to a real customer.
--
-- ✓ A reservation cannot reference a customer that does not exist.
--
-- ✓ Customers with existing reservations cannot accidentally be deleted.
--
-- This is one of the most important advantages of relational databases.
--
-- ============================================================================
-- END OF RESERVATIONS TABLE
-- ============================================================================
-- ============================================================================
-- TABLE: newsletter_subscribers
-- ============================================================================
--
-- PURPOSE
-- -------
-- This table stores everyone who has subscribed to Café Fausse's newsletter.
--
-- The newsletter is part of the restaurant's marketing strategy.
--
-- Subscribers may receive:
--
-- • New menu announcements
-- • Seasonal promotions
-- • Special events
-- • Discount offers
--
-- Notice something important:
--
-- A newsletter subscriber is NOT necessarily a customer.
--
-- Someone may subscribe to the newsletter without:
--
-- • making a reservation
-- • placing an order
-- • creating an account
--
-- This is why the newsletter is stored separately instead of inside the
-- customers table.
--
-- ============================================================================
--
-- DATABASE DESIGN PRINCIPLES
-- ============================================================================
--
-- This table represents a completely different business process.
--
-- customers
--     Stores people who interact with the restaurant.
--
-- newsletter_subscribers
--     Stores marketing subscriptions.
--
-- Although some people may exist in both tables,
-- they represent different business concepts.
--
-- Keeping them separate makes the database more flexible.
--
-- ============================================================================

CREATE TABLE newsletter_subscribers (

    --------------------------------------------------------------------------
    -- Primary Key
    --------------------------------------------------------------------------
    --
    -- Every subscription receives its own UUID.
    --
    -- Why not use the email address as the primary key?
    --
    -- Because email addresses can sometimes change.
    --
    -- Primary keys should ideally remain stable for the lifetime of a record.
    --
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    --------------------------------------------------------------------------
    -- Email Address
    --------------------------------------------------------------------------
    --
    -- Stores the subscriber's email address.
    --
    -- UNIQUE ensures the same person cannot subscribe twice using the
    -- same email address.
    --
    -- PostgreSQL automatically creates an index because the field is UNIQUE.
    --
    -- This makes lookups very efficient.
    --
    email VARCHAR(255) NOT NULL UNIQUE,

    --------------------------------------------------------------------------
    -- Active Subscription Flag
    --------------------------------------------------------------------------
    --
    -- BOOLEAN stores only two possible values:
    --
    -- TRUE
    -- FALSE
    --
    -- Instead of deleting subscribers,
    -- many organisations simply mark them as inactive.
    --
    -- Advantages:
    --
    -- • preserves historical data
    -- • supports reporting
    -- • allows reactivation later
    -- • provides an audit trail
    --
    -- Example
    --
    -- TRUE
    -- Customer currently receives newsletters.
    --
    -- FALSE
    -- Customer has unsubscribed.
    --
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    --------------------------------------------------------------------------
    -- Subscription Date
    --------------------------------------------------------------------------
    --
    -- Records when the customer subscribed.
    --
    -- This is useful for:
    --
    -- • reporting
    -- • marketing analytics
    -- • measuring campaign effectiveness
    -- • understanding subscriber growth
    --
    subscribed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    --------------------------------------------------------------------------
    -- Audit Columns
    --------------------------------------------------------------------------
    --
    -- created_at
    --
    -- Records when this database record was created.
    --
    -- updated_at
    --
    -- Automatically updated whenever the record changes.
    --
    -- These fields are managed by the database trigger created earlier.
    --
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP

);

-- ============================================================================
-- WHY THIS TABLE IS SEPARATE FROM CUSTOMERS
-- ============================================================================
--
-- A common beginner question is:
--
-- "Why not simply add this column?"
--
-- newsletter_subscribed BOOLEAN
--
-- inside the customers table?
--
-- There are several reasons.
--
-- Example 1
--
-- Alice subscribes to the newsletter.
--
-- She has never visited the restaurant.
--
-- She is not a customer.
--
-- Therefore she should not exist in the customers table.
--
--
-- Example 2
--
-- Ben places an order.
--
-- He does NOT want marketing emails.
--
-- He belongs in customers.
--
-- He does NOT belong in newsletter_subscribers.
--
--
-- Example 3
--
-- Chloe unsubscribes.
--
-- We should not delete her customer account simply because she no longer
-- wants marketing emails.
--
-- These examples show that "being a customer" and
-- "being a newsletter subscriber" are two different business concepts.
--
-- ============================================================================
-- NORMALISATION
-- ============================================================================
--
-- This design follows Third Normal Form (3NF).
--
-- Each table stores information about ONE business entity.
--
-- customers
--     Customer information
--
-- reservations
--     Booking information
--
-- newsletter_subscribers
--     Marketing subscription information
--
-- Separating responsibilities like this is called
-- "Separation of Concerns."
--
-- It is one of the key principles of good software engineering and
-- database design.
--
-- ============================================================================
-- FUTURE ENHANCEMENTS
-- ============================================================================
--
-- In a production system, this table could be expanded to include:
--
-- • source of subscription
--      (Website, QR Code, Social Media)
--
-- • preferred language
--
-- • marketing consent version
--
-- • unsubscribe reason
--
-- • double opt-in confirmation
--
-- For the Café Fausse assignment, however,
-- the current design is appropriately simple while still demonstrating
-- good relational database practice.
--
-- ============================================================================
-- END OF NEWSLETTER_SUBSCRIBERS TABLE
-- ============================================================================
-- ============================================================================
-- TABLE: menu_categories
-- ============================================================================
--
-- PURPOSE
-- -------
-- This table stores the categories used to organise the restaurant menu.
--
-- Examples include:
--
-- • Starters
-- • Mains
-- • Desserts
-- • Beverages
--
-- Instead of typing these words repeatedly for every menu item,
-- they are stored once and referenced by the menu_items table.
--
-- ============================================================================
--
-- DATABASE DESIGN PRINCIPLES
-- ============================================================================
--
-- This is known as a LOOKUP TABLE or REFERENCE TABLE.
--
-- A lookup table stores information that changes infrequently and is
-- referenced by many other records.
--
-- Relationship
--
-- menu_categories
--        │
--        │ 1
--        ▼
-- menu_items
--        *
--
-- Read this as:
--
-- One category
--
-- can contain
--
-- Many menu items.
--
-- Example
--
-- Starters
--
-- • Truffle Arancini
-- • Bruschetta
-- • Soup of the Day
--
-- Notice that the word "Starters" is stored only once.
--
-- ============================================================================

CREATE TABLE menu_categories (

    --------------------------------------------------------------------------
    -- Primary Key
    --------------------------------------------------------------------------
    --
    -- Every menu category receives a UUID.
    --
    -- The UUID will later be stored inside the menu_items table as a
    -- foreign key.
    --
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    --------------------------------------------------------------------------
    -- Category Name
    --------------------------------------------------------------------------
    --
    -- Examples
    --
    -- Starters
    -- Mains
    -- Desserts
    --
    -- UNIQUE prevents duplicate categories.
    --
    -- Without UNIQUE, someone could accidentally create:
    --
    -- Starters
    -- Starters
    --
    -- which would make menu management confusing.
    --
    name VARCHAR(100) NOT NULL UNIQUE,

    --------------------------------------------------------------------------
    -- Description
    --------------------------------------------------------------------------
    --
    -- Provides additional information about the category.
    --
    -- Example
    --
    -- "Small plates and appetisers."
    --
    -- TEXT is used because descriptions vary in length.
    --
    description TEXT,

    --------------------------------------------------------------------------
    -- Sort Order
    --------------------------------------------------------------------------
    --
    -- Determines the order in which categories appear on the website.
    --
    -- Example
    --
    -- 1  Starters
    -- 2  Mains
    -- 3  Desserts
    -- 4  Drinks
    --
    -- Without this column, categories would usually be displayed in
    -- alphabetical order.
    --
    -- By storing an explicit sort order, restaurant staff can control the
    -- menu layout without changing the application code.
    --
    sort_order INTEGER NOT NULL DEFAULT 0,

    --------------------------------------------------------------------------
    -- Active Flag
    --------------------------------------------------------------------------
    --
    -- Indicates whether the category should currently be displayed.
    --
    -- TRUE
    -- Display the category.
    --
    -- FALSE
    -- Hide the category.
    --
    -- Example
    --
    -- The restaurant temporarily removes "Winter Specials".
    --
    -- Instead of deleting the category,
    -- simply set:
    --
    -- is_active = FALSE
    --
    -- This preserves historical information.
    --
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    --------------------------------------------------------------------------
    -- Audit Columns
    --------------------------------------------------------------------------
    --
    -- created_at
    --
    -- Records when the category was created.
    --
    -- updated_at
    --
    -- Automatically updated by the database trigger whenever the category
    -- changes.
    --
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP

);

-- ============================================================================
-- WHY USE A SEPARATE CATEGORY TABLE?
-- ============================================================================
--
-- Consider two possible designs.
--
-- --------------------------------------------------------------------------
-- Option 1 (Poor Design)
-- --------------------------------------------------------------------------
--
-- menu_items
--
-- Name                      Category
-- ------------------------  ----------
-- Truffle Arancini          Starters
-- Bruschetta                Starters
-- Soup                      Starters
-- Rib Eye                   Mains
-- Risotto                   Mains
--
-- Notice that the words:
--
-- Starters
-- Mains
--
-- are repeated many times.
--
-- Problems:
--
-- • Wasted storage
-- • Typing mistakes
-- • Difficult to rename categories
-- • Harder to maintain
--
-- Someone could accidentally enter:
--
-- Starter
-- starters
-- Starters
-- starter
--
-- PostgreSQL would treat all four as different categories.
--
--
-- --------------------------------------------------------------------------
-- Option 2 (Good Design)
-- --------------------------------------------------------------------------
--
-- menu_categories
--
-- 1  Starters
-- 2  Mains
-- 3  Desserts
--
--
-- menu_items
--
-- Truffle Arancini    Category 1
-- Bruschetta          Category 1
-- Risotto             Category 2
--
-- Now the category name exists only once.
--
-- If the restaurant changes:
--
-- Starters
--
-- to
--
-- Appetisers
--
-- only ONE row needs to be updated.
--
-- Every linked menu item automatically reflects the change.
--
-- ============================================================================
-- NORMALISATION
-- ============================================================================
--
-- This table demonstrates Third Normal Form (3NF).
--
-- Category information is stored separately from menu item information.
--
-- The menu_items table will store:
--
-- • item name
-- • description
-- • price
--
-- The category table stores only category-related information.
--
-- Each table has one clear responsibility.
--
-- ============================================================================
-- BUSINESS RULES
-- ============================================================================
--
-- UNIQUE(name)
--
-- prevents duplicate category names.
--
-- NOT NULL
--
-- ensures every category has a name.
--
-- DEFAULT values
--
-- reduce the amount of information the application must supply when
-- inserting new records.
--
-- ============================================================================
-- REAL-WORLD EXAMPLE
-- ============================================================================
--
-- Imagine Café Fausse introduces a new category:
--
-- "Chef's Specials"
--
-- Without changing any application code, staff simply insert:
--
-- Name:
-- Chef's Specials
--
-- Sort Order:
-- 2
--
-- Active:
-- TRUE
--
-- The frontend can immediately display the new category because it reads
-- the categories directly from the database.
--
-- This is an example of a DATA-DRIVEN APPLICATION.
--
-- Behaviour is controlled by the database rather than hard-coded into
-- the software.
--
-- ============================================================================
-- END OF MENU_CATEGORIES TABLE
-- ============================================================================
-- ============================================================================
-- TABLE: menu_items
-- ============================================================================
--
-- PURPOSE
-- -------
-- This table stores every food and beverage item sold by Café Fausse.
--
-- Examples
--
-- • Truffle Arancini
-- • Braised Beef Short Rib
-- • Wild Mushroom Risotto
-- • Dark Chocolate Tart
--
-- Every menu item belongs to exactly ONE category.
--
-- Examples
--
-- Truffle Arancini
--        ↓
--     Starters
--
-- Beef Short Rib
--        ↓
--      Mains
--
-- Lemon Posset
--        ↓
--     Desserts
--
-- ============================================================================
--
-- DATABASE DESIGN PRINCIPLES
-- ============================================================================
--
-- Relationship
--
-- menu_categories
--        │
--        │ 1
--        ▼
-- menu_items
--        *
--
-- Read this as:
--
-- One menu category
--
-- contains
--
-- Many menu items.
--
-- Every menu item MUST belong to one existing category.
--
-- ============================================================================

CREATE TABLE menu_items (

    --------------------------------------------------------------------------
    -- Primary Key
    --------------------------------------------------------------------------
    --
    -- Every menu item receives a UUID.
    --
    -- This UUID is later referenced by:
    --
    -- order_items
    --
    -- allowing customer orders to identify exactly which product was
    -- purchased.
    --
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    --------------------------------------------------------------------------
    -- Category Foreign Key
    --------------------------------------------------------------------------
    --
    -- Every menu item belongs to one category.
    --
    -- Examples
    --
    -- Truffle Arancini
    -- Category → Starters
    --
    -- Risotto
    -- Category → Mains
    --
    -- PostgreSQL guarantees that the referenced category already exists.
    --
    -- ON DELETE RESTRICT
    --
    -- prevents someone deleting a category while menu items still belong
    -- to it.
    --
    -- Without this protection:
    --
    -- Menu Item
    -- Beef Short Rib
    --
    -- Category
    -- (deleted)
    --
    -- would leave invalid data.
    --
    category_id UUID NOT NULL
        REFERENCES menu_categories(id)
        ON DELETE RESTRICT,

    --------------------------------------------------------------------------
    -- Menu Item Name
    --------------------------------------------------------------------------
    --
    -- Stores the product name exactly as customers see it.
    --
    -- Example
    --
    -- Wild Mushroom Risotto
    --
    -- Maximum length:
    --
    -- 150 characters.
    --
    name VARCHAR(150) NOT NULL,

    --------------------------------------------------------------------------
    -- Description
    --------------------------------------------------------------------------
    --
    -- Longer explanation displayed on the website.
    --
    -- Example
    --
    -- "Creamy arborio rice with roasted wild mushrooms and parmesan."
    --
    -- TEXT is used because descriptions vary greatly in length.
    --
    description TEXT,

    --------------------------------------------------------------------------
    -- Price
    --------------------------------------------------------------------------
    --
    -- This is one of the most important columns in the database.
    --
    -- Why NUMERIC instead of FLOAT?
    --
    -- FLOAT stores approximate values.
    --
    -- Example
    --
    -- £10.10 (or R10.10) may actually become
    --
    -- 10.0999999997
    --
    -- after calculations.
    --
    -- Financial systems should NEVER use floating-point numbers for money.
    --
    -- NUMERIC stores decimal values exactly.
    --
    -- NUMERIC(10,2)
    --
    -- means:
    --
    -- Maximum digits:
    -- 10
    --
    -- Digits after the decimal:
    -- 2
    --
    -- Examples
    --
    -- R95.00
    -- R220.00
    -- R1,250.50
    --
    -- CHECK prevents negative prices.
    --
    price NUMERIC(10,2)
        NOT NULL
        CHECK (price >= 0),

    --------------------------------------------------------------------------
    -- Availability Flag
    --------------------------------------------------------------------------
    --
    -- Indicates whether the item can currently be ordered.
    --
    -- TRUE
    --
    -- Display on the menu.
    --
    -- FALSE
    --
    -- Hide from ordering.
    --
    -- Examples
    --
    -- Seasonal dishes
    --
    -- Sold out items
    --
    -- Limited-time specials
    --
    -- Instead of deleting the item,
    -- simply mark it unavailable.
    --
    is_available BOOLEAN NOT NULL DEFAULT TRUE,

    --------------------------------------------------------------------------
    -- Audit Columns
    --------------------------------------------------------------------------
    --
    -- created_at
    --
    -- Records when the menu item was added.
    --
    -- updated_at
    --
    -- Automatically maintained by the database trigger.
    --
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    --------------------------------------------------------------------------
    -- Composite Unique Constraint
    --------------------------------------------------------------------------
    --
    -- This is different from a normal UNIQUE constraint.
    --
    -- Rather than checking one column,
    -- PostgreSQL checks TWO columns together.
    --
    -- (category_id, name)
    --
    -- Examples
    --
    -- Allowed
    --
    -- Starters
    -- Soup
    --
    -- Mains
    -- Soup
    --
    -- because they are different categories.
    --
    -- Not Allowed
    --
    -- Starters
    -- Soup
    --
    -- Starters
    -- Soup
    --
    -- because the combination is duplicated.
    --
    CONSTRAINT uq_menu_items_category_name
        UNIQUE (category_id, name)

);

-- ============================================================================
-- WHY PRICE BELONGS HERE
-- ============================================================================
--
-- Prices describe the PRODUCT.
--
-- Therefore they belong inside menu_items.
--
-- Example
--
-- Truffle Arancini
--
-- Price
-- R95.00
--
-- Notice that orders DO NOT determine menu prices.
--
-- They simply record what the customer purchased.
--
-- ============================================================================
-- WHY ORDERS STORE UNIT_PRICE AS WELL
-- ============================================================================
--
-- Beginners often ask:
--
-- "If the price is already stored here,
-- why is it stored again in order_items?"
--
-- Imagine this scenario.
--
-- July
--
-- Truffle Arancini
--
-- R95.00
--
-- August
--
-- Restaurant increases the price.
--
-- New price:
--
-- R110.00
--
-- If historical orders always looked up the current menu price,
-- every old invoice would suddenly change.
--
-- That would be incorrect.
--
-- Therefore:
--
-- menu_items.price
--
-- stores today's selling price.
--
-- order_items.unit_price
--
-- stores the price paid at the time of purchase.
--
-- Historical accuracy is preserved.
--
-- ============================================================================
-- NORMALISATION
-- ============================================================================
--
-- menu_categories stores:
--
-- • category information
--
-- menu_items stores:
--
-- • product information
--
-- order_items stores:
--
-- • purchased products
--
-- Each table has one responsibility.
--
-- This is another example of Third Normal Form (3NF).
--
-- ============================================================================
-- BUSINESS RULES
-- ============================================================================
--
-- NOT NULL
--
-- Every menu item must have:
--
-- • a category
-- • a name
-- • a price
--
-- CHECK(price >= 0)
--
-- prevents impossible values.
--
-- UNIQUE(category_id, name)
--
-- prevents duplicate product names inside the same category.
--
-- ============================================================================
-- END OF MENU_ITEMS TABLE
-- ============================================================================
-- ============================================================================
-- TABLE: orders
-- ============================================================================
--
-- PURPOSE
-- -------
-- This table stores every order placed at Café Fausse.
--
-- Unlike the menu tables, which describe products,
-- this table records BUSINESS EVENTS.
--
-- Examples
--
-- Customer places an online order.
--
-- Customer orders while dining in.
--
-- Customer orders food for collection.
--
-- Each of these becomes ONE record in this table.
--
-- ============================================================================
--
-- DATABASE DESIGN PRINCIPLES
-- ============================================================================
--
-- Relationship
--
-- customers
--      │
--      │ 1
--      ▼
-- orders
--      *
--
-- One customer
--
-- can place
--
-- Many orders.
--
-- Every order belongs to exactly ONE customer.
--
-- ============================================================================

CREATE TABLE orders (

    --------------------------------------------------------------------------
    -- Primary Key
    --------------------------------------------------------------------------
    --
    -- Every order receives a unique UUID.
    --
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    --------------------------------------------------------------------------
    -- Customer Foreign Key
    --------------------------------------------------------------------------
    --
    -- Identifies who placed the order.
    --
    -- PostgreSQL guarantees that the referenced customer already exists.
    --
    -- ON DELETE RESTRICT prevents deleting customers that still have
    -- order history.
    --
    customer_id UUID NOT NULL
        REFERENCES customers(id)
        ON DELETE RESTRICT,

    --------------------------------------------------------------------------
    -- Order Number
    --------------------------------------------------------------------------
    --
    -- Human-friendly order number.
    --
    -- Customers and restaurant staff are far more likely to quote:
    --
    -- ORD-1001
    --
    -- than:
    --
    -- b34cb2b8-65a4-48...
    --
    -- UNIQUE prevents duplicate order numbers.
    --
    order_number VARCHAR(50) NOT NULL UNIQUE,

    --------------------------------------------------------------------------
    -- Order Status
    --------------------------------------------------------------------------
    --
    -- Represents where the order is within the kitchen workflow.
    --
    -- pending
    --     Order received.
    --
    -- confirmed
    --     Order accepted.
    --
    -- preparing
    --     Kitchen is preparing the food.
    --
    -- served
    --     Customer has received the meal.
    --
    -- cancelled
    --     Order cancelled.
    --
    order_status VARCHAR(30)
        NOT NULL
        DEFAULT 'pending'
        CHECK
        (
            order_status IN
            (
                'pending',
                'confirmed',
                'preparing',
                'served',
                'cancelled'
            )
        ),

    --------------------------------------------------------------------------
    -- Order Type
    --------------------------------------------------------------------------
    --
    -- Engineering Improvement
    -- -----------------------
    --
    -- The original schema treated every order as identical.
    --
    -- The Café Fausse requirements include:
    --
    -- • Dine-in
    -- • Click & Collect
    -- • Delivery
    --
    -- This column allows the application to distinguish between them.
    --
    order_type VARCHAR(20)
        NOT NULL
        DEFAULT 'dine_in'
        CHECK
        (
            order_type IN
            (
                'dine_in',
                'collection',
                'delivery'
            )
        ),

    --------------------------------------------------------------------------
    -- Payment Status
    --------------------------------------------------------------------------
    --
    -- Engineering Improvement
    -- -----------------------
    --
    -- Notice that kitchen progress and payment are two different things.
    --
    -- Example
    --
    -- An order may already be:
    --
    -- preparing
    --
    -- but payment could still be:
    --
    -- pending
    --
    -- Separating these concepts makes reporting much easier.
    --
    payment_status VARCHAR(20)
        NOT NULL
        DEFAULT 'pending'
        CHECK
        (
            payment_status IN
            (
                'pending',
                'paid',
                'refunded',
                'failed'
            )
        ),

    --------------------------------------------------------------------------
    -- Order Date
    --------------------------------------------------------------------------
    --
    -- Stores when the order was placed.
    --
    order_date TIMESTAMPTZ
        NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    --------------------------------------------------------------------------
    -- Total Amount
    --------------------------------------------------------------------------
    --
    -- Stores the total value of the order.
    --
    -- Example
    --
    -- Starter
    -- R95.00
    --
    -- Main
    -- R220.00
    --
    -- Total
    -- R315.00
    --
    -- Although this value can be calculated from order_items,
    -- storing it improves reporting performance and simplifies invoices.
    --
    -- The application should ensure that this value always equals the
    -- sum of the associated line items.
    --
    total_amount NUMERIC(10,2)
        NOT NULL
        CHECK (total_amount >= 0),

    --------------------------------------------------------------------------
    -- Delivery Address
    --------------------------------------------------------------------------
    --
    -- Only required for delivery orders.
    --
    -- Dine-in and collection orders may leave this field empty.
    --
    delivery_address TEXT,

    --------------------------------------------------------------------------
    -- Audit Columns
    --------------------------------------------------------------------------
    --
    created_at TIMESTAMPTZ
        NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMPTZ
        NOT NULL
        DEFAULT CURRENT_TIMESTAMP

);

-- ============================================================================
-- WHY STORE TOTAL_AMOUNT?
-- ============================================================================
--
-- Beginners often ask:
--
-- "Why store the total if it can be calculated?"
--
-- Consider an order containing:
--
-- Starter
-- R95.00
--
-- Main
-- R220.00
--
-- Dessert
-- R110.00
--
-- Every time a receipt or sales report is generated,
-- the database would need to recalculate the total.
--
-- Storing the total makes:
--
-- • invoices faster
-- • reports faster
-- • dashboards faster
--
-- The important rule is:
--
-- total_amount must always agree with the sum of the associated
-- order_items.
--
-- ============================================================================
-- TRANSACTION TABLES
-- ============================================================================
--
-- Orders are an example of a TRANSACTION TABLE.
--
-- Characteristics:
--
-- • grows continuously
-- • records business events
-- • rarely deletes records
-- • heavily queried
--
-- Compare this with:
--
-- menu_categories
--
-- which changes only occasionally.
--
-- ============================================================================
-- NORMALISATION
-- ============================================================================
--
-- This table stores only order-level information.
--
-- Examples:
--
-- ✓ customer
-- ✓ order number
-- ✓ order date
-- ✓ order status
-- ✓ payment status
-- ✓ order type
-- ✓ total amount
--
-- Notice what is NOT stored here:
--
-- Product names
-- Product quantities
-- Individual prices
--
-- Those belong in the order_items table.
--
-- Separating an order into a header (orders)
-- and line items (order_items)
-- is one of the most common patterns in database design.
--
-- ============================================================================
-- BUSINESS RULES
-- ============================================================================
--
-- Every order:
--
-- ✓ belongs to one customer
--
-- ✓ has one order number
--
-- ✓ has one status
--
-- ✓ has one payment status
--
-- ✓ has one order type
--
-- ✓ has a non-negative total
--
-- ============================================================================
-- END OF ORDERS TABLE
-- ============================================================================
-- ============================================================================
-- TABLE: order_items
-- ============================================================================
--
-- PURPOSE
-- -------
-- This table stores the individual products that make up an order.
--
-- Think of the orders table as the receipt itself.
--
-- The order_items table stores the individual lines printed on that receipt.
--
-- Example
--
-- Receipt
--
-- Order Number
-- ORD-1001
--
-- --------------------------------
-- Truffle Arancini      2
-- Beef Short Rib        1
-- Lemon Posset          1
-- --------------------------------
--
-- Total
-- R505.00
--
-- The receipt is ONE order.
--
-- The three products are THREE order_items.
--
-- ============================================================================
--
-- DATABASE DESIGN PRINCIPLES
-- ============================================================================
--
-- Relationship
--
-- orders
--    │
--    │ 1
--    ▼
-- order_items
--      *
--
-- One order
--
-- contains
--
-- Many order items.
--
--
-- Relationship
--
-- menu_items
--      │
--      │ 1
--      ▼
-- order_items
--      *
--
-- One menu item
--
-- can appear
--
-- in many different customer orders.
--
-- Therefore order_items sits between:
--
-- orders
--
-- and
--
-- menu_items
--
-- ============================================================================
--
-- ASSOCIATIVE ENTITY
-- ============================================================================
--
-- order_items is known as an ASSOCIATIVE ENTITY.
--
-- It connects:
--
-- orders
--
-- and
--
-- menu_items
--
-- while storing additional information about that relationship.
--
-- Specifically:
--
-- • quantity
-- • unit_price
-- • line_total
--
-- ============================================================================
--
-- ENGINEERING NOTE
-- ============================================================================
--
-- The original schema prevented the same menu item from appearing more
-- than once in an order using:
--
-- UNIQUE(order_id, menu_item_id)
--
-- This is appropriate for Café Fausse because the application simply
-- increases the quantity rather than inserting duplicate lines.
--
-- Example
--
-- Correct
--
-- Truffle Arancini
-- Quantity = 3
--
-- Instead of
--
-- Truffle Arancini
--
-- Truffle Arancini
--
-- Truffle Arancini
--
-- Both designs are valid.
--
-- This assignment uses the first approach.
--
-- ============================================================================

CREATE TABLE order_items (

    --------------------------------------------------------------------------
    -- Primary Key
    --------------------------------------------------------------------------
    --
    -- Every order line receives its own UUID.
    --
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    --------------------------------------------------------------------------
    -- Order Foreign Key
    --------------------------------------------------------------------------
    --
    -- Identifies which order this line belongs to.
    --
    -- Example
    --
    -- Order
    -- ORD-1001
    --
    -- may contain:
    --
    -- Truffle Arancini
    --
    -- Beef Short Rib
    --
    -- Lemon Posset
    --
    -- ON DELETE CASCADE
    --
    -- means:
    --
    -- If an order is deleted,
    -- PostgreSQL automatically deletes all associated order_items.
    --
    -- This prevents orphan records.
    --
    order_id UUID
        NOT NULL
        REFERENCES orders(id)
        ON DELETE CASCADE,

    --------------------------------------------------------------------------
    -- Menu Item Foreign Key
    --------------------------------------------------------------------------
    --
    -- Identifies which menu product was purchased.
    --
    -- PostgreSQL guarantees that the menu item exists.
    --
    -- ON DELETE RESTRICT
    --
    -- prevents deleting menu items that appear in historical orders.
    --
    -- Historical sales records therefore remain valid.
    --
    menu_item_id UUID
        NOT NULL
        REFERENCES menu_items(id)
        ON DELETE RESTRICT,

    --------------------------------------------------------------------------
    -- Quantity
    --------------------------------------------------------------------------
    --
    -- Number of units purchased.
    --
    -- Examples
    --
    -- 1
    --
    -- 2
    --
    -- 4
    --
    -- CHECK prevents zero or negative quantities.
    --
    quantity INTEGER
        NOT NULL
        CHECK (quantity > 0),

    --------------------------------------------------------------------------
    -- Unit Price
    --------------------------------------------------------------------------
    --
    -- Stores the selling price AT THE TIME THE ORDER WAS PLACED.
    --
    -- This is one of the most important concepts in transaction systems.
    --
    -- Example
    --
    -- Today
    --
    -- Truffle Arancini
    -- R95.00
    --
    -- Next Month
    --
    -- Restaurant increases the price.
    --
    -- New price
    -- R110.00
    --
    -- Historical orders must continue showing:
    --
    -- R95.00
    --
    -- NOT
    --
    -- R110.00
    --
    -- Therefore the price is copied into the transaction.
    --
    unit_price NUMERIC(10,2)
        NOT NULL
        CHECK (unit_price >= 0),

    --------------------------------------------------------------------------
    -- Line Total
    --------------------------------------------------------------------------
    --
    -- Engineering Improvement
    -- -----------------------
    --
    -- In the original schema this column accepted any value.
    --
    -- Example
    --
    -- Quantity
    -- 2
    --
    -- Unit Price
    -- R95.00
    --
    -- Line Total
    -- R999.00
    --
    -- PostgreSQL would accept it because only CHECK(line_total >= 0)
    -- existed.
    --
    -- To eliminate inconsistent data,
    -- PostgreSQL can calculate the value automatically.
    --
    -- GENERATED ALWAYS AS
    --
    -- creates a stored computed column.
    --
    -- The database now guarantees:
    --
    -- line_total = quantity × unit_price
    --
    line_total NUMERIC(10,2)
        GENERATED ALWAYS AS
        (
            quantity * unit_price
        )
        STORED,

    --------------------------------------------------------------------------
    -- Audit Columns
    --------------------------------------------------------------------------
    --
    created_at TIMESTAMPTZ
        NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMPTZ
        NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    --------------------------------------------------------------------------
    -- Composite Unique Constraint
    --------------------------------------------------------------------------
    --
    -- Prevents duplicate products within the same order.
    --
    -- Example
    --
    -- Allowed
    --
    -- Order 1001
    -- Beef Short Rib
    --
    -- Order 1002
    -- Beef Short Rib
    --
    -- Not Allowed
    --
    -- Order 1001
    -- Beef Short Rib
    --
    -- Order 1001
    -- Beef Short Rib
    --
    -- Instead,
    -- the application increases the quantity.
    --
    CONSTRAINT uq_order_items_order_menu
        UNIQUE (order_id, menu_item_id)

);

-- ============================================================================
-- WHY DO WE NEED THIS TABLE?
-- ============================================================================
--
-- Imagine we tried storing menu_item_id directly inside orders.
--
-- Order
--
-- ORD-1001
--
-- Menu Item
-- Truffle Arancini
--
-- What happens when the customer also orders:
--
-- Beef Short Rib?
--
-- There is nowhere to store it.
--
-- We'd need:
--
-- menu_item_1
-- menu_item_2
-- menu_item_3
--
-- That design quickly becomes impossible to maintain.
--
-- Instead,
-- each product becomes a separate row.
--
-- ============================================================================
-- HEADER–DETAIL DESIGN
-- ============================================================================
--
-- orders
--
-- Order Number
-- Customer
-- Date
-- Total
--
--          │
--          │
--          ▼
--
-- order_items
--
-- Product
-- Quantity
-- Unit Price
-- Line Total
--
-- This Header–Detail pattern is one of the most common relational database
-- designs used in ERP, POS, accounting and e-commerce systems.
--
-- ============================================================================
-- NORMALISATION
-- ============================================================================
--
-- orders stores:
--
-- • information about the order itself
--
-- order_items stores:
--
-- • information about each product purchased
--
-- menu_items stores:
--
-- • information about the product catalogue
--
-- Each table has one clear responsibility.
--
-- This satisfies Third Normal Form (3NF).
--
-- ============================================================================
-- END OF ORDER_ITEMS TABLE
-- ============================================================================
-- ============================================================================
-- TABLE: gallery_images
-- ============================================================================
--
-- PURPOSE
-- -------
-- This table stores the images displayed throughout the Café Fausse website.
--
-- Examples
--
-- • Restaurant interior
-- • Signature dishes
-- • Chef preparing food
-- • Dining atmosphere
--
-- These images help communicate the restaurant's brand and enhance the
-- customer's browsing experience.
--
-- ============================================================================
--
-- DATABASE DESIGN PRINCIPLES
-- ============================================================================
--
-- Notice that the database does NOT store the actual image.
--
-- Instead, it stores information ABOUT the image.
--
-- This information is called METADATA.
--
-- Metadata describes another piece of data.
--
-- Examples
--
-- • Image filename
-- • Alt text
-- • Display order
-- • Whether the image is active
--
-- The actual image file is stored separately on the server or in cloud
-- storage.
--
-- This keeps the database much smaller and improves performance.
--
-- ============================================================================

CREATE TABLE gallery_images (

    --------------------------------------------------------------------------
    -- Primary Key
    --------------------------------------------------------------------------
    --
    -- Every image receives its own UUID.
    --
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    --------------------------------------------------------------------------
    -- Image URL
    --------------------------------------------------------------------------
    --
    -- Stores the location of the image file.
    --
    -- Examples
    --
    -- /images/gallery/interior.jpg
    --
    -- https://cdn.example.com/gallery/interior.jpg
    --
    -- The image itself is NOT stored here.
    --
    image_url VARCHAR(500) NOT NULL,

    --------------------------------------------------------------------------
    -- Alternative Text
    --------------------------------------------------------------------------
    --
    -- Alternative (Alt) text is used by:
    --
    -- • Screen readers
    -- • Search engines
    -- • Browsers when images cannot load
    --
    -- Example
    --
    -- "Elegant restaurant dining room with warm lighting."
    --
    -- Good alt text improves accessibility and SEO.
    --
    alt_text VARCHAR(255) NOT NULL,

    --------------------------------------------------------------------------
    -- Display Order
    --------------------------------------------------------------------------
    --
    -- Controls the order in which images appear on the website.
    --
    -- Lower numbers appear first.
    --
    -- Example
    --
    -- 1 Hero Banner
    -- 2 Dining Room
    -- 3 Signature Dish
    -- 4 Dessert
    --
    display_order INTEGER NOT NULL DEFAULT 0,

    --------------------------------------------------------------------------
    -- Active Flag
    --------------------------------------------------------------------------
    --
    -- TRUE
    -- Display this image.
    --
    -- FALSE
    -- Hide this image.
    --
    -- Instead of deleting seasonal or promotional images,
    -- they can simply be deactivated.
    --
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    --------------------------------------------------------------------------
    -- Audit Columns
    --------------------------------------------------------------------------
    --
    created_at TIMESTAMPTZ
        NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMPTZ
        NOT NULL
        DEFAULT CURRENT_TIMESTAMP

);

-- ============================================================================
-- WHY STORE IMAGE METADATA?
-- ============================================================================
--
-- The database is responsible for storing information about the image,
-- not the image itself.
--
-- Storing large binary image files directly inside the database would:
--
-- • increase database size
-- • slow backups
-- • reduce query performance
--
-- Instead,
-- applications usually store images in:
--
-- • a web server
-- • cloud storage
-- • a content delivery network (CDN)
--
-- while the database stores only the file location and related metadata.
--
-- ============================================================================
-- END OF GALLERY_IMAGES TABLE
-- ============================================================================
-- ============================================================================
-- TABLE: testimonials
-- ============================================================================
--
-- PURPOSE
-- -------
-- This table stores customer testimonials displayed on the website.
--
-- Examples
--
-- "Amazing service and fantastic food."
--
-- "The best dining experience we've had this year."
--
-- Testimonials provide social proof that encourages new customers to
-- visit the restaurant.
--
-- ============================================================================
--
-- DATABASE DESIGN PRINCIPLES
-- ============================================================================
--
-- Testimonials are another example of CONTENT DATA.
--
-- Unlike orders or reservations,
-- testimonials are published to enhance the customer experience.
--
-- They are not financial transactions.
--
-- ============================================================================

CREATE TABLE testimonials (

    --------------------------------------------------------------------------
    -- Primary Key
    --------------------------------------------------------------------------
    --
    -- Every testimonial receives its own UUID.
    --
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    --------------------------------------------------------------------------
    -- Customer Name
    --------------------------------------------------------------------------
    --
    -- Stores the name shown with the testimonial.
    --
    -- This could be:
    --
    -- • Full name
    -- • First name only
    -- • Initials
    --
    -- depending on the restaurant's privacy policy.
    --
    customer_name VARCHAR(150) NOT NULL,

    --------------------------------------------------------------------------
    -- Testimonial Text
    --------------------------------------------------------------------------
    --
    -- Stores the customer's written review.
    --
    -- TEXT allows reviews of varying lengths.
    --
    testimonial TEXT NOT NULL,

    --------------------------------------------------------------------------
    -- Rating
    --------------------------------------------------------------------------
    --
    -- Stores the customer's rating.
    --
    -- Values are limited to:
    --
    -- 1
    -- 2
    -- 3
    -- 4
    -- 5
    --
    -- CHECK guarantees that invalid ratings cannot be stored.
    --
    rating INTEGER
        NOT NULL
        CHECK (rating BETWEEN 1 AND 5),

    --------------------------------------------------------------------------
    -- Active Flag
    --------------------------------------------------------------------------
    --
    -- TRUE
    -- Display on the website.
    --
    -- FALSE
    -- Hide from the website.
    --
    -- This allows administrators to moderate testimonials without deleting
    -- historical data.
    --
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    --------------------------------------------------------------------------
    -- Audit Columns
    --------------------------------------------------------------------------
    --
    created_at TIMESTAMPTZ
        NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMPTZ
        NOT NULL
        DEFAULT CURRENT_TIMESTAMP

);

-- ============================================================================
-- WHY USE A CHECK CONSTRAINT?
-- ============================================================================
--
-- Ratings should only be between 1 and 5.
--
-- Without a CHECK constraint,
-- invalid values could be entered:
--
-- 0
-- 8
-- -3
-- 25
--
-- PostgreSQL prevents these invalid ratings from being stored.
--
-- This is another example of enforcing BUSINESS RULES at the database level.
--
-- ============================================================================
-- CONTENT MANAGEMENT
-- ============================================================================
--
-- This table allows Café Fausse staff to:
--
-- • publish testimonials
-- • hide testimonials
-- • update testimonials
--
-- without modifying the React frontend.
--
-- The website simply queries the database and displays all active
-- testimonials.
--
-- This is another example of a DATA-DRIVEN APPLICATION.
--
-- ============================================================================
-- END OF TESTIMONIALS TABLE
-- ============================================================================
-- ============================================================================
-- DATABASE PERFORMANCE
-- ============================================================================
--
-- Up to this point we have created the database structure.
--
-- The next step is improving PERFORMANCE.
--
-- PostgreSQL searches tables using indexes.
--
-- Think of an index as being similar to the index at the back of a textbook.
--
-- Without an index:
--
-- You read every page until you find the topic.
--
-- With an index:
--
-- You immediately jump to the correct page.
--
-- Databases work in exactly the same way.
--
-- ============================================================================
-- WHY INDEXES MATTER
-- ============================================================================
--
-- Imagine Café Fausse has:
--
-- 10 customers.
--
-- PostgreSQL can scan all 10 rows very quickly.
--
-- Now imagine:
--
-- 500,000 customers.
--
-- Reading every row for every search would become very slow.
--
-- An index allows PostgreSQL to locate matching records much more
-- efficiently.
--
-- ============================================================================
-- NOTE
-- ============================================================================
--
-- PostgreSQL automatically creates indexes for:
--
-- • PRIMARY KEY
-- • UNIQUE
--
-- Therefore we only create additional indexes for columns that are
-- frequently searched, filtered or joined.
--
-- ============================================================================


-- ============================================================================
-- INDEX: Reservations by Date
-- ============================================================================
--
-- Used when searching for bookings on a particular day.
--
-- Example
--
-- Show all reservations for:
--
-- 15 August
--
-- Instead of scanning every reservation,
-- PostgreSQL jumps directly to the relevant date.
--
CREATE INDEX idx_reservations_date
ON reservations(reservation_date);


-- ============================================================================
-- INDEX: Orders by Customer and Date
-- ============================================================================
--
-- Composite Index
-- ---------------
--
-- This index contains TWO columns.
--
-- PostgreSQL can efficiently answer questions such as:
--
-- Show all orders
-- for Customer X
-- ordered by date.
--
-- This is more useful than indexing each column separately because
-- these values are frequently used together.
--
CREATE INDEX idx_orders_customer_date
ON orders(customer_id, order_date);


-- ============================================================================
-- INDEX: Menu Items by Category
-- ============================================================================
--
-- Used when displaying menu sections.
--
-- Example
--
-- Show all:
--
-- Starters
--
-- or
--
-- Desserts
--
-- PostgreSQL quickly finds every menu item belonging to the selected
-- category.
--
CREATE INDEX idx_menu_items_category
ON menu_items(category_id);


-- ============================================================================
-- INDEX: Gallery Display Order
-- ============================================================================
--
-- Used when displaying the website gallery.
--
-- Images are commonly retrieved in display order.
--
CREATE INDEX idx_gallery_display_order
ON gallery_images(display_order);


-- ============================================================================
-- INDEX: Testimonials Active Status
-- ============================================================================
--
-- The website usually displays only active testimonials.
--
-- This index speeds up queries such as:
--
-- SELECT *
-- FROM testimonials
-- WHERE is_active = TRUE;
--
CREATE INDEX idx_testimonials_active
ON testimonials(is_active);


-- ============================================================================
-- TRIGGERS
-- ============================================================================
--
-- A trigger automatically executes a function whenever a particular
-- database event occurs.
--
-- Our trigger updates:
--
-- updated_at
--
-- every time a record is modified.
--
-- Without a trigger,
-- every UPDATE statement would need to remember to change updated_at.
--
-- That is repetitive and easy to forget.
--
-- PostgreSQL performs it automatically.
--
-- ============================================================================


-- ============================================================================
-- Attach Trigger to CUSTOMERS
-- ============================================================================
CREATE TRIGGER trg_customers_updated_at
BEFORE UPDATE ON customers
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();


-- ============================================================================
-- Attach Trigger to RESERVATIONS
-- ============================================================================
CREATE TRIGGER trg_reservations_updated_at
BEFORE UPDATE ON reservations
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();


-- ============================================================================
-- Attach Trigger to NEWSLETTER_SUBSCRIBERS
-- ============================================================================
CREATE TRIGGER trg_newsletter_updated_at
BEFORE UPDATE ON newsletter_subscribers
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();


-- ============================================================================
-- Attach Trigger to MENU_CATEGORIES
-- ============================================================================
CREATE TRIGGER trg_menu_categories_updated_at
BEFORE UPDATE ON menu_categories
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();


-- ============================================================================
-- Attach Trigger to MENU_ITEMS
-- ============================================================================
CREATE TRIGGER trg_menu_items_updated_at
BEFORE UPDATE ON menu_items
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();


-- ============================================================================
-- Attach Trigger to ORDERS
-- ============================================================================
CREATE TRIGGER trg_orders_updated_at
BEFORE UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();


-- ============================================================================
-- Attach Trigger to ORDER_ITEMS
-- ============================================================================
CREATE TRIGGER trg_order_items_updated_at
BEFORE UPDATE ON order_items
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();


-- ============================================================================
-- Attach Trigger to GALLERY_IMAGES
-- ============================================================================
CREATE TRIGGER trg_gallery_images_updated_at
BEFORE UPDATE ON gallery_images
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();


-- ============================================================================
-- Attach Trigger to TESTIMONIALS
-- ============================================================================
CREATE TRIGGER trg_testimonials_updated_at
BEFORE UPDATE ON testimonials
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();


-- ============================================================================
-- DATABASE COMPLETE
-- ============================================================================
--
-- The Café Fausse database now consists of:
--
-- Core Business Tables
-- --------------------
--
-- • customers
-- • reservations
-- • newsletter_subscribers
-- • menu_categories
-- • menu_items
-- • orders
-- • order_items
-- • gallery_images
-- • testimonials
--
-- Supporting Objects
-- ------------------
--
-- • Primary Keys
-- • Foreign Keys
-- • Check Constraints
-- • Unique Constraints
-- • Indexes
-- • Triggers
--
-- Together these provide:
--
-- ✓ Data integrity
-- ✓ Referential integrity
-- ✓ Performance
-- ✓ Maintainability
-- ✓ Automatic auditing
--
-- ============================================================================
-- END OF DATABASE SCHEMA
-- ============================================================================
