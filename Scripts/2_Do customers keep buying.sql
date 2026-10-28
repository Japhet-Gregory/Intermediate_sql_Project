WITH cohort AS (
    SELECT
        customerkey,
        EXTRACT(YEAR FROM first_order_date)::int AS cohort_year
    FROM vw_customer_summary
),
activity AS (
    SELECT
        s.customerkey,
        EXTRACT(YEAR FROM s.orderdate)::int AS order_year
    FROM sales s
    GROUP BY s.customerkey, EXTRACT(YEAR FROM s.orderdate)
),
cohort_activity AS (
    SELECT
        c.cohort_year,
        a.order_year - c.cohort_year   AS years_since_first,
        COUNT(DISTINCT c.customerkey)  AS active_customers
    FROM cohort c
    JOIN activity a ON c.customerkey = a.customerkey
    GROUP BY c.cohort_year, a.order_year - c.cohort_year
),
retention AS (
    SELECT
        cohort_year,
        years_since_first,
        cohort_year + years_since_first AS calendar_year,
        100.0 * active_customers
          / FIRST_VALUE(active_customers) OVER (
                PARTITION BY cohort_year ORDER BY years_since_first) AS retention_pct
    FROM cohort_activity
)
SELECT
    COALESCE(cohort_year::text, 'Average') AS cohort,
    ROUND(AVG(retention_pct) FILTER (WHERE calendar_year = 2016)::numeric, 1) AS "2016",
    ROUND(AVG(retention_pct) FILTER (WHERE calendar_year = 2017)::numeric, 1) AS "2017",
    ROUND(AVG(retention_pct) FILTER (WHERE calendar_year = 2018)::numeric, 1) AS "2018",
    ROUND(AVG(retention_pct) FILTER (WHERE calendar_year = 2019)::numeric, 1) AS "2019",
    ROUND(AVG(retention_pct) FILTER (WHERE calendar_year = 2020)::numeric, 1) AS "2020",
    ROUND(AVG(retention_pct) FILTER (WHERE calendar_year = 2021)::numeric, 1) AS "2021",
    ROUND(AVG(retention_pct) FILTER (WHERE calendar_year = 2022)::numeric, 1) AS "2022",
    ROUND(AVG(retention_pct) FILTER (WHERE calendar_year = 2023)::numeric, 1) AS "2023"
FROM retention
WHERE years_since_first > 0
  AND calendar_year <= 2023
GROUP BY ROLLUP (cohort_year)
ORDER BY cohort_year NULLS LAST;