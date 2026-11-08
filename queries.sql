USE garage_mini;
-- Q1
SELECT o.order_id,
       o.received_at,
       c.customer_id,
       c.full_name      AS customer_name,
       t.technician_id,
       t.full_name      AS technician_name
FROM repair_orders o
JOIN customers   c ON c.customer_id   = o.customer_id
JOIN technicians t ON t.technician_id = o.technician_id
WHERE o.status = 'Completed'
  AND o.received_at >= '2025-01-01'
  AND o.received_at <  '2025-02-01'
ORDER BY o.received_at, o.order_id;
-- Q2
SELECT tm.team_id,
       tm.name AS team_name,
       COUNT(o.order_id) AS total_orders_q1_2025
FROM teams tm
LEFT JOIN technicians t ON t.team_id = tm.team_id
LEFT JOIN repair_orders o
       ON o.technician_id = t.technician_id
      AND o.received_at >= '2025-01-01'
      AND o.received_at <  '2025-04-01'
GROUP BY tm.team_id, tm.name
ORDER BY tm.team_id;
-- Q3
SELECT DISTINCT c.customer_id,
       c.full_name AS customer_name
FROM customers c
JOIN repair_orders o       ON o.customer_id = c.customer_id
LEFT JOIN repair_reports r ON r.order_id    = o.order_id
WHERE o.status <> 'Cancelled'
  AND r.report_id IS NULL
ORDER BY c.customer_id;
-- Q4
SELECT tm.team_id,
       tm.name AS team_name,
       COUNT(o.order_id)      AS completed_orders,
       ROUND(AVG(r.cost), 2)  AS avg_cost_per_completed_order
FROM teams tm
JOIN technicians t     ON t.team_id       = tm.team_id
JOIN repair_orders o   ON o.technician_id = t.technician_id
                      AND o.status = 'Completed'
JOIN repair_reports r  ON r.order_id      = o.order_id
GROUP BY tm.team_id, tm.name
ORDER BY tm.team_id;
-- Q5
SELECT t.technician_id,
       t.full_name AS technician_name,
       COUNT(o.order_id) AS completed_orders_2025
FROM technicians t
JOIN repair_orders o ON o.technician_id = t.technician_id
WHERE o.status = 'Completed'
  AND o.received_at >= '2025-01-01'
  AND o.received_at <  '2026-01-01'
GROUP BY t.technician_id, t.full_name
ORDER BY completed_orders_2025 DESC, t.technician_id ASC
LIMIT 3;
-- Q6
SELECT c.customer_id,
       c.full_name AS customer_name,
       COALESCE(SUM(p.amount), 0) AS total_paid_2025
FROM customers c
LEFT JOIN repair_orders o ON o.customer_id = c.customer_id
LEFT JOIN payments p      ON p.order_id    = o.order_id
                         AND p.payment_date >= '2025-01-01'
                         AND p.payment_date <  '2026-01-01'
GROUP BY c.customer_id, c.full_name
ORDER BY c.customer_id;
-- Q7
SELECT c.customer_id,
       c.full_name AS customer_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM repair_orders o
    JOIN payments p ON p.order_id = o.order_id
    WHERE o.customer_id = c.customer_id
)
ORDER BY c.customer_id;
-- Q8
SELECT c.customer_id,
       c.full_name AS customer_name,
       COALESCE(SUM(r.cost), 0) AS total_confirmed_cost
FROM customers c
LEFT JOIN repair_orders o  ON o.customer_id = c.customer_id
LEFT JOIN repair_reports r ON r.order_id    = o.order_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_confirmed_cost DESC, c.customer_id ASC;
-- Q9
SELECT t.technician_id,
       t.full_name AS technician_name,
       COUNT(o.order_id)                              AS total_orders_2025,
       COALESCE(SUM(CASE WHEN o.status = 'Cancelled' THEN 1 ELSE 0 END), 0) AS cancelled_orders_2025,
       ROUND(SUM(CASE WHEN o.status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0
             / NULLIF(COUNT(o.order_id), 0), 2)       AS cancellation_rate_pct
FROM technicians t
LEFT JOIN repair_orders o
       ON o.technician_id = t.technician_id
      AND o.received_at >= '2025-01-01'
      AND o.received_at <  '2026-01-01'
GROUP BY t.technician_id, t.full_name
ORDER BY t.technician_id;
-- Q10
SELECT c.customer_id,
       c.full_name AS customer_name,
       COUNT(o.order_id) AS completed_orders_2025
FROM customers c
JOIN repair_orders o ON o.customer_id = c.customer_id
WHERE o.status = 'Completed'
  AND o.received_at >= '2025-01-01'
  AND o.received_at <  '2026-01-01'
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) > 3
ORDER BY completed_orders_2025 DESC, c.customer_id;
