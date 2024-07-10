-- Authors table
CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY, -- Unique identifier for each author
    full_name VARCHAR(255) NOT NULL -- Full name of the author
);
COMMENT ON TABLE authors IS 'Table storing author information';
COMMENT ON COLUMN authors.author_id IS 'Unique identifier for each author';
COMMENT ON COLUMN authors.full_name IS 'Full name of the author';

-- Books table
CREATE TABLE books (
    book_id SERIAL PRIMARY KEY, -- Unique identifier for each book
    isbn VARCHAR(20) NOT NULL UNIQUE, -- ISBN code of the book
    title VARCHAR(255) NOT NULL, -- Title of the book
    description TEXT, -- Description of the book
    genre VARCHAR(100), -- Genre of the book
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Timestamp of when the book was added
);
COMMENT ON TABLE books IS 'Table storing book information';
COMMENT ON COLUMN books.book_id IS 'Unique identifier for each book';
COMMENT ON COLUMN books.isbn IS 'ISBN code of the book';
COMMENT ON COLUMN books.title IS 'Title of the book';
COMMENT ON COLUMN books.description IS 'Description of the book';
COMMENT ON COLUMN books.genre IS 'Genre of the book';
COMMENT ON COLUMN books.created_at IS 'Timestamp of when the book was added';

-- Book-Authors table (join table for many-to-many relationship between books and authors)
CREATE TABLE book_authors (
    book_id INT NOT NULL, -- Reference to the book
    author_id INT NOT NULL, -- Reference to the author
    PRIMARY KEY (book_id, author_id), -- Composite primary key
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE, -- Foreign key to books table
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE -- Foreign key to authors table
);
COMMENT ON TABLE book_authors IS 'Table storing the many-to-many relationship between books and authors';
COMMENT ON COLUMN book_authors.book_id IS 'Reference to the book';
COMMENT ON COLUMN book_authors.author_id IS 'Reference to the author';

-- Book translations table (for storing titles, genres, and descriptions in multiple languages)
CREATE TABLE book_translations (
    translation_id SERIAL PRIMARY KEY, -- Unique identifier for each translation
    book_id INT NOT NULL, -- Reference to the original book
    language_code VARCHAR(10) NOT NULL, -- Language code of the translation
    title VARCHAR(255) NOT NULL, -- Translated title of the book
    description TEXT, -- Translated description of the book
    genre VARCHAR(100), -- Translated genre of the book
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE, -- Foreign key to books table
    UNIQUE (book_id, language_code) -- Ensure unique translation per language
);
COMMENT ON TABLE book_translations IS 'Table storing translations of book information';
COMMENT ON COLUMN book_translations.translation_id IS 'Unique identifier for each translation';
COMMENT ON COLUMN book_translations.book_id IS 'Reference to the original book';
COMMENT ON COLUMN book_translations.language_code IS 'Language code of the translation';
COMMENT ON COLUMN book_translations.title IS 'Translated title of the book';
COMMENT ON COLUMN book_translations.description IS 'Translated description of the book';
COMMENT ON COLUMN book_translations.genre IS 'Translated genre of the book';

-- Customers table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY, -- Unique identifier for each customer
    username VARCHAR(100) UNIQUE NOT NULL, -- Unique username of the customer
    password VARCHAR(255) NOT NULL, -- Hashed password of the customer
    email VARCHAR(255) UNIQUE NOT NULL, -- Unique email of the customer
    full_name VARCHAR(255), -- Full name of the customer
    address TEXT, -- Address of the customer
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Timestamp of when the customer was added
);
COMMENT ON TABLE customers IS 'Table storing customer information';
COMMENT ON COLUMN customers.customer_id IS 'Unique identifier for each customer';
COMMENT ON COLUMN customers.username IS 'Unique username of the customer';
COMMENT ON COLUMN customers.password IS 'Hashed password of the customer';
COMMENT ON COLUMN customers.email IS 'Unique email of the customer';
COMMENT ON COLUMN customers.full_name IS 'Full name of the customer';
COMMENT ON COLUMN customers.address IS 'Address of the customer';
COMMENT ON COLUMN customers.created_at IS 'Timestamp of when the customer was added';

-- Reviews table
CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY, -- Unique identifier for each review
    book_id INT NOT NULL, -- Reference to the reviewed book
    customer_id INT NOT NULL, -- Reference to the customer who wrote the review
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5), -- Rating given by the customer
    review_text TEXT, -- Review text
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Timestamp of when the review was added
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE, -- Foreign key to books table
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE -- Foreign key to customers table
);
COMMENT ON TABLE reviews IS 'Table storing reviews of books by customers';
COMMENT ON COLUMN reviews.review_id IS 'Unique identifier for each review';
COMMENT ON COLUMN reviews.book_id IS 'Reference to the reviewed book';
COMMENT ON COLUMN reviews.customer_id IS 'Reference to the customer who wrote the review';
COMMENT ON COLUMN reviews.rating IS 'Rating given by the customer';
COMMENT ON COLUMN reviews.review_text IS 'Review text';
COMMENT ON COLUMN reviews.review_date IS 'Timestamp of when the review was added';

-- Prices table (for managing book prices over time)
CREATE TABLE prices (
    price_id SERIAL PRIMARY KEY, -- Unique identifier for each price record
    book_id INT NOT NULL, -- Reference to the book
    price NUMERIC(10, 2) NOT NULL, -- Price of the book
    start_date TIMESTAMP NOT NULL, -- Start date of the price validity
    end_date TIMESTAMP, -- End date of the price validity
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE, -- Foreign key to books table
    CHECK (start_date < end_date OR end_date IS NULL) -- Ensure start date is before end date or end date is null
);
COMMENT ON TABLE prices IS 'Table managing book prices over time';
COMMENT ON COLUMN prices.price_id IS 'Unique identifier for each price record';
COMMENT ON COLUMN prices.book_id IS 'Reference to the book';
COMMENT ON COLUMN prices.price IS 'Price of the book';
COMMENT ON COLUMN prices.start_date IS 'Start date of the price validity';
COMMENT ON COLUMN prices.end_date IS 'End date of the price validity';

-- Orders table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY, -- Unique identifier for each order
    customer_id INT NOT NULL, -- Reference to the customer who placed the order
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Timestamp of when the order was placed
    total_amount NUMERIC(10, 2), -- Total amount of the order
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE -- Foreign key to customers table
);
COMMENT ON TABLE orders IS 'Table storing customer orders';
COMMENT ON COLUMN orders.order_id IS 'Unique identifier for each order';
COMMENT ON COLUMN orders.customer_id IS 'Reference to the customer who placed the order';
COMMENT ON COLUMN orders.order_date IS 'Timestamp of when the order was placed';
COMMENT ON COLUMN orders.total_amount IS 'Total amount of the order';

-- Order items table (to store individual items within each order)
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY, -- Unique identifier for each order item
    order_id INT NOT NULL, -- Reference to the order
    book_id INT NOT NULL, -- Reference to the book
    quantity INT NOT NULL DEFAULT 1, -- Quantity of the book ordered
    price NUMERIC(10, 2), -- Price of the book at the time of order
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE, -- Foreign key to orders table
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE -- Foreign key to books table
);
COMMENT ON TABLE order_items IS 'Table storing items within orders';
COMMENT ON COLUMN order_items.order_item_id IS 'Unique identifier for each order item';
COMMENT ON COLUMN order_items.order_id IS 'Reference to the order';
COMMENT ON COLUMN order_items.book_id IS 'Reference to the book';
COMMENT ON COLUMN order_items.quantity IS 'Quantity of the book ordered';
COMMENT ON COLUMN order_items.price IS 'Price of the book at the time of order';

-- Invoices table
CREATE TABLE invoices (
    invoice_id SERIAL PRIMARY KEY, -- Unique identifier for each invoice
    order_id INT NOT NULL, -- Reference to the order
    invoice_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Timestamp of when the invoice was created
    total_amount NUMERIC(10, 2), -- Total amount of the invoice
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE -- Foreign key to orders table
);
COMMENT ON TABLE invoices IS 'Table storing invoices';
COMMENT ON COLUMN invoices.invoice_id IS 'Unique identifier for each invoice';
COMMENT ON COLUMN invoices.order_id IS 'Reference to the order';
COMMENT ON COLUMN invoices.invoice_date IS 'Timestamp of when the invoice was created';
COMMENT ON COLUMN invoices.total_amount IS 'Total amount of the invoice';

-- Indexes creation
-- Books table indexes
CREATE INDEX idx_books_isbn ON books (isbn);
CREATE INDEX idx_books_genre ON books (genre);
CREATE INDEX idx_books_title ON books (title);

-- Book translations table indexes
CREATE INDEX idx_book_translations_title ON book_translations (title);
CREATE INDEX idx_book_translations_genre ON book_translations (genre);

-- Customers table indexes
CREATE INDEX idx_customers_email ON customers (email);
CREATE INDEX idx_customers_username ON customers (username);

-- Reviews table indexes
CREATE INDEX idx_reviews_book_id ON reviews (book_id);
CREATE INDEX idx_reviews_customer_id ON reviews (customer_id);

-- Orders table indexes
CREATE INDEX idx_orders_customer_id ON orders (customer_id);
CREATE INDEX idx_orders_order_date ON orders (order_date);

-- Order items table indexes
CREATE INDEX idx_order_items_order_id ON order_items (order_id);
CREATE INDEX idx_order_items_book_id ON order_items (book_id);
