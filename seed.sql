
USE garage_mini;

INSERT INTO teams (team_id, name) VALUES
(1, 'Engine & Transmission Team'),
(2, 'Electrical & Electronics Team'),
(3, 'Body & Paint Team'),
(4, 'Brakes & Suspension Team'),
(5, 'Air-Conditioning Team');

-- technicians (6)
INSERT INTO technicians (technician_id, full_name, email, skill, team_id) VALUES
(1, 'Nguyen Van An',   'an.nguyen@garage.example',   'Engine diagnostics',   1),
(2, 'Tran Minh Tuan',  'tuan.tran@garage.example',   'Gearbox repair',       1),
(3, 'Le Thi Hoa',      'hoa.le@garage.example',      'Auto electrical',      2),
(4, 'Pham Quoc Bao',   'bao.pham@garage.example',    'Panel beating',        3),
(5, 'Vo Thanh Long',   'long.vo@garage.example',     'Brake systems',        4),
(6, 'Dang Huu Phuc',   'phuc.dang@garage.example',   'A/C systems',          5);
-- customers (10)
INSERT INTO customers (customer_id, full_name, phone, address) VALUES
(1,  'Nguyen Thi Lan',  '0901000001', '12 Le Loi, District 1, Ho Chi Minh City'),
(2,  'Tran Van Hung',   '0901000002', '45 Nguyen Hue, District 1, Ho Chi Minh City'),
(3,  'Le Quang Vinh',   '0901000003', '78 Tran Phu, Hai Chau, Da Nang'),
(4,  'Pham Thi Mai',    '0901000004', '23 Hoang Dieu, Ba Dinh, Hanoi'),
(5,  'Hoang Van Nam',   '0901000005', '9 Pasteur, District 3, Ho Chi Minh City'),
(6,  'Do Thi Thu',      '0901000006', '56 Ly Thuong Kiet, Hoan Kiem, Hanoi'),
(7,  'Bui Anh Duc',     '0901000007', '31 Nguyen Trai, Thanh Xuan, Hanoi'),
(8,  'Vu Thi Hanh',     '0901000008', '88 Hung Vuong, Hai Chau, Da Nang'),
(9,  'Dang Minh Khoa',  '0901000009', '14 Vo Van Tan, District 3, Ho Chi Minh City'),
(10, 'Tran Van Hung',   '0901000010', '67 Cach Mang Thang 8, Ninh Kieu, Can Tho');
-- repair_orders (20)
INSERT INTO repair_orders (order_id, customer_id, technician_id, received_at, status, license_plate) VALUES
(1,  5, 6, '2024-11-12 09:00:00', 'Completed', '51A-111.11'),
(2,  1, 1, '2025-01-08 08:30:00', 'Completed', '30A-123.45'),
(3,  2, 3, '2025-01-15 10:00:00', 'Completed', '51F-222.22'),
(4,  3, 5, '2025-01-22 14:00:00', 'Pending',   '43A-333.33'),
(5,  4, 1, '2025-01-28 09:15:00', 'Cancelled', '29C-444.44'),
(6,  1, 2, '2025-02-10 11:00:00', 'Completed', '30A-123.45'),
(7,  6, 3, '2025-02-18 13:30:00', 'Completed', '30E-555.55'),
(8,  3, 2, '2025-03-31 23:30:00', 'Completed', '43A-333.33'),
(9,  1, 4, '2025-03-12 15:00:00', 'Completed', '51H-666.66'),
(10, 3, 4, '2025-03-20 08:45:00', 'Completed', '43B-777.77'),
(11, 2, 3, '2025-03-27 10:20:00', 'Cancelled', '51F-222.22'),
(12, 1, 1, '2025-05-14 09:30:00', 'Completed', '30A-123.45'),
(13, 2, 3, '2025-06-10 14:10:00', 'Completed', '51F-222.22'),
(14, 2, 2, '2025-09-05 10:00:00', 'Completed', '51F-222.22'),
(15, 7, 5, '2025-07-20 16:00:00', 'Pending',   '29A-888.88'),
(16, 7, 5, '2025-08-02 09:00:00', 'Cancelled', '29A-888.88'),
(17, 3, 4, '2025-11-03 11:15:00', 'Completed', '43A-333.33'),
(18, 9, 4, '2026-01-10 08:00:00', 'Completed', '51K-999.99'),
(19, 10, 3, '2025-12-28 15:40:00', 'Completed', '65A-101.01'),
(20, 4,  1, '2025-10-08 10:30:00', 'Completed', '29C-444.44');
-- repair_reports (15) : exactly one per Completed order, none for others
INSERT INTO repair_reports (report_id, order_id, fault_description, work_summary, cost) VALUES
(1,  1,  'Air conditioner not cooling',   'Replaced compressor, recharged gas',     3200000.00),
(2,  2,  'Engine misfire',                'Replaced spark plugs and ignition coils', 4500000.00),
(3,  3,  'Alternator not charging',       'Replaced alternator',                     2800000.00),
(4,  6,  'Gearbox slipping',              'Rebuilt gearbox clutch pack',             6000000.00),
(5,  7,  'Dashboard warning lights',      'Repaired wiring harness',                 1800000.00),
(6,  8,  'Gearbox oil leak',              'Replaced output shaft oil seal',          950000.00),
(7,  9,  'Collision damage on front bumper', 'Panel beating and repainting',        12500000.00),
(8,  10, 'Scratched door',                'Sanded and repainted door panel',         2100000.00),
(9,  12, 'Engine noise at idle',          'Replaced timing belt',                    3300000.00),
(10, 13, 'Battery drains overnight',      'Fixed parasitic drain, new battery',      1200000.00),
(11, 14, 'Transmission jerks',            'Replaced transmission mount and fluid',   5750000.00),
(12, 17, 'Rust on rear fender',           'Rust treatment and repainting',           4000000.00),
(13, 18, 'Crumpled hood',                 'Replaced hood and repainted',             2600000.00),
(14, 19, 'Faulty central locking',        'Replaced door lock actuator',             1500000.00),
(15, 20, 'Engine stalls at low speed',      'Replaced fuel pump',                     2400000.00);
-- payments (16)
INSERT INTO payments (payment_id, order_id, amount, payment_date, method) VALUES
(1,  1,  3200000.00, '2024-11-15', 'Cash'),
(2,  2,  2000000.00, '2025-01-10', 'Cash'),
(3,  2,  1500000.00, '2025-02-05', 'BankTransfer'),
(4,  2,  1000000.00, '2025-03-02', 'Card'),
(5,  3,  2800000.00, '2025-01-18', 'Card'),
(6,  6,  3000000.00, '2025-02-20', 'BankTransfer'),
(7,  7,  1000000.00, '2025-02-22', 'Cash'),
(8,  8,   950000.00, '2025-04-02', 'Cash'),
(9,  9,  5000000.00, '2025-03-20', 'BankTransfer'),
(10, 9,  4000000.00, '2025-04-15', 'BankTransfer'),
(11, 10, 2100000.00, '2025-03-25', 'Card'),
(12, 13, 1200000.00, '2025-06-12', 'Cash'),
(13, 14, 5750000.00, '2025-09-10', 'BankTransfer'),
(14, 17, 4000000.00, '2025-11-05', 'Card'),
(15, 18, 2600000.00, '2026-01-15', 'Cash'),
(16, 19, 1500000.00, '2026-01-05', 'BankTransfer');
-- Check 1: foreign keys (orphan rows)
SELECT 'technicians.team_id -> teams' AS check_name, COUNT(*) AS violations
FROM technicians t LEFT JOIN teams tm ON tm.team_id = t.team_id
WHERE tm.team_id IS NULL
UNION ALL
SELECT 'repair_orders.customer_id -> customers', COUNT(*)
FROM repair_orders o LEFT JOIN customers c ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL
UNION ALL
SELECT 'repair_orders.technician_id -> technicians', COUNT(*)
FROM repair_orders o LEFT JOIN technicians t ON t.technician_id = o.technician_id
WHERE t.technician_id IS NULL
UNION ALL
SELECT 'repair_reports.order_id -> repair_orders', COUNT(*)
FROM repair_reports r LEFT JOIN repair_orders o ON o.order_id = r.order_id
WHERE o.order_id IS NULL
UNION ALL
SELECT 'payments.order_id -> repair_orders', COUNT(*)
FROM payments p LEFT JOIN repair_orders o ON o.order_id = p.order_id
WHERE o.order_id IS NULL;
-- Check 2: status vs. repair report
SELECT 'Completed order without report' AS check_name, COUNT(*) AS violations
FROM repair_orders o LEFT JOIN repair_reports r ON r.order_id = o.order_id
WHERE o.status = 'Completed' AND r.report_id IS NULL
UNION ALL
SELECT 'Non-Completed order with a report', COUNT(*)
FROM repair_orders o JOIN repair_reports r ON r.order_id = o.order_id
WHERE o.status <> 'Completed'
UNION ALL
SELECT 'Order with more than one report', COUNT(*)
FROM (SELECT order_id FROM repair_reports GROUP BY order_id HAVING COUNT(*) > 1) x;
-- Check 3: payments only for orders that have a confirmed cost
SELECT 'Payment on order without confirmed cost' AS check_name, COUNT(*) AS violations
FROM payments p LEFT JOIN repair_reports r ON r.order_id = p.order_id
WHERE r.report_id IS NULL;
-- Check 4: total collected per order must not exceed the confirmed cost
SELECT 'Order paid more than its cost' AS check_name, COUNT(*) AS violations
FROM (
    SELECT r.order_id
    FROM repair_reports r
    JOIN payments p ON p.order_id = r.order_id
    GROUP BY r.order_id, r.cost
    HAVING SUM(p.amount) > r.cost
) x;
-- Check 5 (informational): per-order cost / collected / outstanding
SELECT r.order_id, r.cost,
       COALESCE(SUM(p.amount), 0)          AS total_paid,
       r.cost - COALESCE(SUM(p.amount), 0) AS outstanding,
       COUNT(p.payment_id)                 AS payment_count
FROM repair_reports r
LEFT JOIN payments p ON p.order_id = r.order_id
GROUP BY r.order_id, r.cost
ORDER BY r.order_id;
-- Check 6 (informational): minimum record counts required by the brief
SELECT 'teams' AS table_name, COUNT(*) AS row_count, 5  AS required FROM teams
UNION ALL SELECT 'technicians',    COUNT(*), 6  FROM technicians
UNION ALL SELECT 'customers',      COUNT(*), 10 FROM customers
UNION ALL SELECT 'repair_orders',  COUNT(*), 12 FROM repair_orders
UNION ALL SELECT 'repair_reports', COUNT(*), 10 FROM repair_reports
UNION ALL SELECT 'payments',       COUNT(*), 10 FROM payments;
