WITH category_pivot AS (
    SELECT
        p.categoryname AS category,
        SUM(CASE WHEN seg.value_segment = 'High' THEN s.netprice * s.quantity ELSE 0 END) AS high_revenue,
        SUM(CASE WHEN seg.value_segment = 'Mid'  THEN s.netprice * s.quantity ELSE 0 END) AS mid_revenue,
        SUM(CASE WHEN seg.value_segment = 'Low'  THEN s.netprice * s.quantity ELSE 0 END) AS low_revenue
    FROM sales s
    JOIN product p ON s.productkey = p.productkey
    JOIN vw_customer_segments seg ON s.customerkey = seg.customerkey
    GROUP BY p.categoryname
)
SELECT
    category,
    ROUND((high_revenue / SUM(high_revenue) OVER ())::numeric * 100, 1) AS high_share_pct,
    ROUND((mid_revenue  / SUM(mid_revenue)  OVER ())::numeric * 100, 1) AS mid_share_pct,
    ROUND((low_revenue  / SUM(low_revenue)  OVER ())::numeric * 100, 1) AS low_share_pct,
    ROUND(((high_revenue / SUM(high_revenue) OVER ())
         - (low_revenue  / SUM(low_revenue)  OVER ()))::numeric * 100, 1) AS high_minus_low_pts
FROM category_pivot
ORDER BY high_minus_low_pts DESC;WITH category_pivot AS (
    SELECT
        p.categoryname AS category,
        SUM(CASE WHEN seg.value_segment = 'High' THEN s.netprice * s.quantity ELSE 0 END) AS high_revenue,
        SUM(CASE WHEN seg.value_segment = 'Mid'  THEN s.netprice * s.quantity ELSE 0 END) AS mid_revenue,
        SUM(CASE WHEN seg.value_segment = 'Low'  THEN s.netprice * s.quantity ELSE 0 END) AS low_revenue
    FROM sales s
    JOIN product p ON s.productkey = p.productkey
    JOIN vw_customer_segments seg ON s.customerkey = seg.customerkey
    GROUP BY p.categoryname
)
SELECT
    category,
    ROUND((high_revenue / SUM(high_revenue) OVER ())::numeric * 100, 1) AS high_share_pct,
    ROUND((mid_revenue  / SUM(mid_revenue)  OVER ())::numeric * 100, 1) AS mid_share_pct,
    ROUND((low_revenue  / SUM(low_revenue)  OVER ())::numeric * 100, 1) AS low_share_pct,
    ROUND(((high_revenue / SUM(high_revenue) OVER ())
         - (low_revenue  / SUM(low_revenue)  OVER ()))::numeric * 100, 1) AS high_minus_low_pts
FROM category_pivot
ORDER BY high_minus_low_pts DESC;