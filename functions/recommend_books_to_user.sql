CREATE OR REPLACE FUNCTION recommend_books_to_user(target_customer_id INT)
RETURNS TABLE (
    book_id INT,
    title VARCHAR,
    genre VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    -- Identify the books purchased and rated by the target customer
    WITH target_customer_purchases AS (
        SELECT DISTINCT oi.book_id, r.rating AS user_rating
        FROM orders o
        JOIN order_items oi ON o.order_id = oi.order_id
        LEFT JOIN reviews r ON oi.book_id = r.book_id AND r.customer_id = o.customer_id
        WHERE o.customer_id = target_customer_id
    ),

    -- Find genres of books purchased by the target customer
    target_customer_genres AS (
        SELECT DISTINCT b.genre
        FROM books b
        JOIN target_customer_purchases tcp ON b.book_id = tcp.book_id
    ),

    -- Find other books in the same genres, excluding already purchased books
    genre_based_recommendations AS (
        SELECT b.book_id, b.genre
        FROM books b
        JOIN target_customer_genres tcg ON b.genre = tcg.genre
        WHERE b.book_id NOT IN (SELECT tcp.book_id FROM target_customer_purchases tcp)
    ),

    -- Consider only highly-rated books
    highly_rated_books AS (
        SELECT r.book_id, AVG(r.rating) AS avg_rating
        FROM reviews r
        GROUP BY r.book_id
        HAVING AVG(r.rating) >= 4
    ),

    -- Combine the data to recommend books
    recommended_books AS (
        SELECT gr.book_id, gr.genre, hrb.avg_rating
        FROM genre_based_recommendations gr
        JOIN highly_rated_books hrb ON gr.book_id = hrb.book_id
    )

    -- Final selection of recommended books
    SELECT
        rb.book_id,
        b.title,
        b.genre
    FROM recommended_books rb
    JOIN books b ON rb.book_id = b.book_id;
END;
$$ LANGUAGE plpgsql;

-- Call the function to test it
SELECT * FROM recommend_books_to_user(1);
