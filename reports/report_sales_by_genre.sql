WITH sales_per_month AS (
    SELECT
        c.customer_id,
        b.genre,
        DATE_TRUNC('month', o.order_date) AS month,
        SUM(oi.price * oi.quantity) AS total_sales
    FROM
        orders o
    JOIN
        order_items oi ON o.order_id = oi.order_id
    JOIN
        books b ON oi.book_id = b.book_id
    JOIN
        customers c ON o.customer_id = c.customer_id
    GROUP BY
        c.customer_id, b.genre, DATE_TRUNC('month', o.order_date)
),
previous_sales AS (
    SELECT
        c.customer_id,
        c.genre,
        c.month,
        c.total_sales,
        p.total_sales AS previous_month_sales
    FROM
        sales_per_month c
    LEFT JOIN
        sales_per_month p
    ON
        c.customer_id = p.customer_id
        AND c.genre = p.genre
        AND c.month = (p.month + INTERVAL '1 month')
)
SELECT
    customer_id,
    genre,
    to_char(month, 'YYYY-MM') AS month,
    total_sales,
    COALESCE(previous_month_sales, 0) AS previous_month_sales,
    (total_sales - COALESCE(previous_month_sales, 0)) AS sales_difference
FROM
    previous_sales
ORDER BY
    customer_id, genre, month;

