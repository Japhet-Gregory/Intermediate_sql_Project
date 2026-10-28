WITH ranked AS (
    SELECT total_spent,
           NTILE(5) OVER (ORDER BY total_spent DESC) AS quintile
    FROM vw_customer_segments
)
SELECT
    CASE quintile
        WHEN 1 THEN 'Top 20%'
        WHEN 2 THEN '20-40%'
        WHEN 3 THEN '40-60%'
        WHEN 4 THEN '60-80%'
        WHEN 5 THEN 'Bottom 20%'
    END                                                        AS customer_group,
    quintile,
    COUNT(*)                                                   AS customers,
    ROUND(SUM(total_spent)::numeric, 0)                        AS revenue,
    ROUND((100.0 * SUM(total_spent)
           / SUM(SUM(total_spent)) OVER ())::numeric, 1)       AS pct_revenue,
    ROUND((100.0 * SUM(SUM(total_spent)) OVER (ORDER BY quintile)
           / SUM(SUM(total_spent)) OVER ())::numeric, 1)       AS cumulative_pct,
    ROUND((SUM(total_spent) / COUNT(*))::numeric, 0)           AS revenue_per_customer,
    ROUND(((SUM(total_spent) / COUNT(*))
           / FIRST_VALUE(SUM(total_spent) / COUNT(*))
                 OVER (ORDER BY quintile DESC))::numeric, 1)   AS times_team5
FROM ranked
GROUP BY quintile
ORDER BY quintile;