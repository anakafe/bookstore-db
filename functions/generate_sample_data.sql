-- Function to generate sample data
CREATE OR REPLACE FUNCTION generate_sample_data()
RETURNS void AS $$
BEGIN
    -- Insert sample authors
    INSERT INTO authors (full_name) VALUES
        ('J.K. Rowling'),
        ('George Orwell'),
        ('J.R.R. Tolkien'),
        ('Harper Lee'),
        ('Mark Twain'),
        ('F. Scott Fitzgerald'),
        ('Ernest Hemingway');

    -- Insert sample books
    INSERT INTO books (isbn, title, description, genre)
    VALUES
        ('9780747532743', 'Harry Potter and the Philosopher''s Stone', 'A young wizard''s journey begins.', 'Fantasy'),
        ('9780451524935', '1984', 'A dystopian novel set in a totalitarian society.', 'Science Fiction'),
        ('9780544003415', 'The Hobbit', 'A hobbit''s adventure to reclaim a lost kingdom.', 'Fantasy'),
        ('9780061120084', 'To Kill a Mockingbird', 'A story of racial injustice in the Deep South.', 'Fiction'),
        ('9780141439600', 'Adventures of Huckleberry Finn', 'A classic novel about the adventures of a young boy along the Mississippi River.', 'Adventure'),
        ('9780743273565', 'The Great Gatsby', 'A novel about the American dream and the disillusionment that comes with it.', 'Fiction'),
        ('9780684801223', 'The Old Man and the Sea', 'A story of an aging fisherman''s struggle with a giant marlin.', 'Fiction');

    -- Insert sample book-author relationships
    INSERT INTO book_authors (book_id, author_id)
    VALUES
        (1, 1),
        (2, 2),
        (3, 3),
        (4, 4),
        (5, 5),
        (6, 6),
        (7, 7);

    -- Insert sample book translations in Spanish
    INSERT INTO book_translations (book_id, language_code, title, description, genre)
    VALUES
        (1, 'es', 'Harry Potter y la piedra filosofal', 'El comienzo del viaje de un joven mago.', 'Fantasía'),
        (2, 'es', '1984', 'Una novela distópica ambientada en una sociedad totalitaria.', 'Ciencia Ficción'),
        (3, 'es', 'El Hobbit', 'La aventura de un hobbit para reclamar un reino perdido.', 'Fantasía'),
        (4, 'es', 'Matar a un ruiseñor', 'Una historia de injusticia racial en el profundo sur.', 'Ficción'),
        (5, 'es', 'Las aventuras de Huckleberry Finn', 'Una novela clásica sobre las aventuras de un joven a lo largo del río Misisipi.', 'Aventura'),
        (6, 'es', 'El gran Gatsby', 'Una novela sobre el sueño americano y la desilusión que viene con él.', 'Ficción'),
        (7, 'es', 'El viejo y el mar', 'La historia de la lucha de un pescador anciano con un pez gigante.', 'Ficción');

    -- Insert sample book translations in French
    INSERT INTO book_translations (book_id, language_code, title, description, genre)
    VALUES
        (1, 'fr', 'Harry Potter à l''école des sorciers', 'Le début du voyage d''un jeune sorcier.', 'Fantaisie'),
        (2, 'fr', '1984', 'Un roman dystopique situé dans une société totalitaire.', 'Science-fiction'),
        (3, 'fr', 'Le Hobbit', 'L''aventure d''un hobbit pour reconquérir un royaume perdu.', 'Fantaisie'),
        (4, 'fr', 'Ne tirez pas sur l''oiseau moqueur', 'Une histoire d''injustice raciale dans le sud profond.', 'Fiction'),
        (5, 'fr', 'Les Aventures de Huckleberry Finn', 'Un roman classique sur les aventures d''un jeune garçon le long du fleuve Mississippi.', 'Aventure'),
        (6, 'fr', 'Gatsby le Magnifique', 'Un roman sur le rêve américain et la désillusion qui en découle.', 'Fiction'),
        (7, 'fr', 'Le vieil homme et la mer', 'L''histoire de la lutte d''un vieux pêcheur avec un marlin géant.', 'Fiction');

    -- Insert sample customers
    INSERT INTO customers (username, password, email, full_name, address)
    VALUES
        ('john_doe', 'hashed_password', 'john.doe@example.com', 'John Doe', '123 Main St, Anytown, USA'),
        ('jane_smith', 'hashed_password', 'jane.smith@example.com', 'Jane Smith', '456 Elm St, Othertown, USA'),
        ('alice_wonder', 'hashed_password', 'alice.wonder@example.com', 'Alice Wonder', '789 Oak St, Somewhere, USA'),
        ('bob_builder', 'hashed_password', 'bob.builder@example.com', 'Bob Builder', '321 Pine St, Anytown, USA');

    -- Insert sample reviews
    INSERT INTO reviews (book_id, customer_id, rating, review_text)
    VALUES
        (1, 1, 5, 'An amazing start to a magical series!'),
        (2, 2, 4, 'A chilling view of a dystopian future.'),
        (3, 1, 5, 'A timeless adventure story.'),
        (4, 2, 5, 'A powerful and moving tale of justice.'),
        (5, 3, 4, 'A classic adventure novel.'),
        (6, 4, 3, 'An insightful look into the American dream.'),
        (7, 1, 5, 'A gripping story of perseverance.');

    -- Insert sample prices
    INSERT INTO prices (book_id, price, start_date)
    VALUES
        (1, 19.99, NOW()),
        (2, 14.99, NOW()),
        (3, 24.99, NOW()),
        (4, 18.99, NOW()),
        (5, 14.99, NOW()),
        (6, 15.99, NOW()),
        (7, 19.99, NOW());

    -- Insert sample orders
    INSERT INTO orders (customer_id, total_amount, order_date)
    VALUES
        (3, 29.98, '2024-01-15'),
        (4, 15.99, '2024-01-25'),
        (1, 24.99, '2024-02-10'),
        (2, 39.98, '2024-02-20'),
        (3, 19.99, '2024-03-05'),
        (4, 22.99, '2024-03-15');

    -- Insert sample order items
    INSERT INTO order_items (order_id, book_id, quantity, price)
    VALUES
        (1, 5, 1, 14.99),
        (1, 6, 1, 14.99),
        (2, 7, 1, 15.99),
        (3, 1, 1, 19.99),
        (4, 2, 1, 19.99),
        (4, 3, 1, 19.99),
        (5, 4, 1, 19.99),
        (6, 5, 1, 11.99),
        (6, 6, 1, 11.99),
        (6, 7, 1, 19.99);

    -- Insert sample invoices
    INSERT INTO invoices (order_id, total_amount)
    VALUES
        (1, 29.98),
        (2, 15.99),
        (3, 24.99),
        (4, 39.98),
        (5, 19.99),
        (6, 22.99);

END;
$$ LANGUAGE plpgsql;

-- Call the function to generate sample data
SELECT generate_sample_data();
