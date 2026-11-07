-- =====================================================================
-- schema.sql  |  Exam 02 - Auto Repair Garage Management  |  MySQL 8.0+
-- Run order: schema.sql -> seed.sql -> queries.sql -> views.sql
-- =====================================================================

DROP DATABASE IF EXISTS garage_mini;
CREATE DATABASE garage_mini
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE garage_mini;

-- ---------------------------------------------------------------------
-- 1. teams : one team has many technicians
-- ---------------------------------------------------------------------
CREATE TABLE teams (
    team_id INT          NOT NULL AUTO_INCREMENT,
    name    VARCHAR(100) NOT NULL,
    CONSTRAINT pk_teams PRIMARY KEY (team_id),
    CONSTRAINT uq_teams_name UNIQUE (name)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 2. technicians : each technician belongs to exactly one team
-- ---------------------------------------------------------------------
CREATE TABLE technicians (
    technician_id INT          NOT NULL AUTO_INCREMENT,
    full_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(120) NOT NULL,
    skill         VARCHAR(100) NULL,
    team_id       INT          NOT NULL,
    CONSTRAINT pk_technicians PRIMARY KEY (technician_id),
    CONSTRAINT uq_technicians_email UNIQUE (email),
    CONSTRAINT fk_technicians_team FOREIGN KEY (team_id)
        REFERENCES teams (team_id)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 3. customers
-- ---------------------------------------------------------------------
CREATE TABLE customers (
    customer_id INT          NOT NULL AUTO_INCREMENT,
    full_name   VARCHAR(100) NOT NULL,
    phone       VARCHAR(20)  NULL,
    address     VARCHAR(255) NULL,
    CONSTRAINT pk_customers PRIMARY KEY (customer_id)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 4. repair_orders : one customer, one main technician per order
--    status: Pending / Completed / Cancelled
--    license_plate is stored directly on the order and must not be blank
-- ---------------------------------------------------------------------
CREATE TABLE repair_orders (
    order_id      INT          NOT NULL AUTO_INCREMENT,
    customer_id   INT          NOT NULL,
    technician_id INT          NOT NULL,
    received_at   DATETIME     NOT NULL,
    status        ENUM('Pending', 'Completed', 'Cancelled') NOT NULL DEFAULT 'Pending',
    license_plate VARCHAR(20)  NOT NULL,
    CONSTRAINT pk_repair_orders PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id),
    CONSTRAINT fk_orders_technician FOREIGN KEY (technician_id)
        REFERENCES technicians (technician_id),
    CONSTRAINT chk_orders_plate_not_blank CHECK (license_plate REGEXP '[^[:space:]]')
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 5. repair_reports : at most one report per order (UNIQUE order_id)
--    cost = confirmed repair cost, must be >= 0
-- ---------------------------------------------------------------------
CREATE TABLE repair_reports (
    report_id         INT           NOT NULL AUTO_INCREMENT,
    order_id          INT           NOT NULL,
    fault_description VARCHAR(500)  NOT NULL,
    work_summary      VARCHAR(500)  NULL,
    cost              DECIMAL(12,2) NOT NULL,
    CONSTRAINT pk_repair_reports PRIMARY KEY (report_id),
    CONSTRAINT uq_reports_order UNIQUE (order_id),
    CONSTRAINT fk_reports_order FOREIGN KEY (order_id)
        REFERENCES repair_orders (order_id),
    CONSTRAINT chk_reports_cost CHECK (cost >= 0)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 6. payments : each row is one real cash-in event (partial payments allowed)
--    amount > 0, method in (Cash, BankTransfer, Card)
-- ---------------------------------------------------------------------
CREATE TABLE payments (
    payment_id   INT           NOT NULL AUTO_INCREMENT,
    order_id     INT           NOT NULL,
    amount       DECIMAL(12,2) NOT NULL,
    payment_date DATE          NOT NULL,
    method       ENUM('Cash', 'BankTransfer', 'Card') NOT NULL,
    CONSTRAINT pk_payments PRIMARY KEY (payment_id),
    CONSTRAINT fk_payments_order FOREIGN KEY (order_id)
        REFERENCES repair_orders (order_id),
    CONSTRAINT chk_payments_amount CHECK (amount > 0)
) ENGINE = InnoDB;

-- Helpful indexes for date-range reports (FK columns are already indexed by InnoDB)
CREATE INDEX idx_orders_received_at ON repair_orders (received_at);
CREATE INDEX idx_payments_date      ON payments (payment_date);

-- Business rules that need data from several tables (Completed <=> exactly one
-- report; payments only after a confirmed cost; SUM(payments) <= cost) cannot be
-- expressed with CHECK. They are verified by the queries at the end of seed.sql.
