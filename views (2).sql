-- =====================================================================
-- views.sql  |  3 views (all-time, not limited to 2025)
-- Requires: schema.sql and seed.sql executed first
-- =====================================================================
USE garage_mini;

-- ---------------------------------------------------------------------
-- v_detail : one row per repair order.
-- LEFT JOIN on repair_reports keeps orders with no report (cost = NULL).
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_detail AS
SELECT o.order_id,
       o.received_at,
       o.status,
       c.customer_id,
       c.full_name     AS customer_name,
       t.technician_id,
       t.full_name     AS technician_name,
       tm.team_id,
       tm.name         AS team_name,
       r.cost          AS repair_cost
FROM repair_orders o
JOIN customers   c  ON c.customer_id   = o.customer_id
JOIN technicians t  ON t.technician_id = o.technician_id
JOIN teams       tm ON tm.team_id      = t.team_id
LEFT JOIN repair_reports r ON r.order_id = o.order_id;

-- ---------------------------------------------------------------------
-- v_group_summary : one row per team (teams without orders are kept).
-- Counts use CASE so every order is counted once; payments are not joined,
-- so cost cannot be duplicated. Missing totals are shown as 0.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_group_summary AS
SELECT tm.team_id,
       tm.name AS team_name,
       COUNT(o.order_id)                                        AS total_orders,
       COALESCE(SUM(CASE WHEN o.status = 'Completed' THEN 1 ELSE 0 END), 0) AS completed_orders,
       COALESCE(SUM(CASE WHEN o.status = 'Cancelled' THEN 1 ELSE 0 END), 0) AS cancelled_orders,
       COALESCE(SUM(r.cost), 0)                                 AS total_repair_cost
FROM teams tm
LEFT JOIN technicians t     ON t.team_id       = tm.team_id
LEFT JOIN repair_orders o   ON o.technician_id = t.technician_id
LEFT JOIN repair_reports r  ON r.order_id      = o.order_id
GROUP BY tm.team_id, tm.name;

-- ---------------------------------------------------------------------
-- v_debt : one row per customer.
-- Cost and payments are aggregated SEPARATELY in derived tables, then joined
-- on customer_id.  Joining reports and payments directly would repeat the
-- cost once per payment and inflate the total (fan-out / double counting).
-- debt = confirmed cost - money actually collected.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_debt AS
SELECT c.customer_id,
       c.full_name AS customer_name,
       COALESCE(cost.total_cost, 0)                              AS total_confirmed_cost,
       COALESCE(paid.total_paid, 0)                              AS total_paid,
       COALESCE(cost.total_cost, 0) - COALESCE(paid.total_paid, 0) AS outstanding_debt
FROM customers c
LEFT JOIN (
    SELECT o.customer_id, SUM(r.cost) AS total_cost
    FROM repair_orders o
    JOIN repair_reports r ON r.order_id = o.order_id
    GROUP BY o.customer_id
) cost ON cost.customer_id = c.customer_id
LEFT JOIN (
    SELECT o.customer_id, SUM(p.amount) AS total_paid
    FROM repair_orders o
    JOIN payments p ON p.order_id = o.order_id
    GROUP BY o.customer_id
) paid ON paid.customer_id = c.customer_id;

-- ---------------------------------------------------------------------
-- Quick demonstration of the views
-- ---------------------------------------------------------------------
SELECT * FROM v_detail ORDER BY order_id;
SELECT * FROM v_group_summary ORDER BY team_id;
SELECT * FROM v_debt ORDER BY customer_id;
