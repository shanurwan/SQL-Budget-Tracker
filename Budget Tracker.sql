-- Step-by-step Execution Order

-- 1. Create Base Tables

-- Transaction Table

CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    txn_date DATE NOT NULL,
    description VARCHAR(255) NOT NULL,
    debit DECIMAL(10,2),
    credit DECIMAL(10,2),
    balance DECIMAL(10,2),
    category VARCHAR(100) DEFAULT 'Uncategorized',
    account VARCHAR(100) DEFAULT 'Main',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(txn_date, description, debit, credit)
);

-- Category Table 
CREATE TABLE category_rules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    keyword VARCHAR(100) NOT NULL,
    category VARCHAR(100) NOT NULL
);

 -- Adjust According to your rule
INSERT INTO category_rules (keyword, category) VALUES
('SHOPEE', 'Online Shopping'),
('DuitQRP2PTransfer', 'E-Wallet / QR'),
('FundTransfer', 'E-Wallet / QR'),
('DuitNowQRP2P', 'E-Wallet / QR'),
('QRPOS', 'E-Wallet / QR'),
('TNG', 'Transportation'),
('SHOPEEMOBILEMALAYS', 'Online Shopping'),
('SHOPEEMALAYSIA', 'Online Shopping'),
('2C2PSYSTEMSDNBHD', 'Online Shopping'),
('DUITNOW', 'Transfers'),
('ACCNO', 'Transfers');

-- Budget Limit Table

CREATE TABLE monthly_budget (
    category VARCHAR(100) PRIMARY KEY,
    budget_limit DECIMAL(10, 2) NOT NULL
);

-- Example budgets:
INSERT INTO monthly_budget VALUES
('Online Shopping', 500),
('E-Wallet / QR', 300),
('Transportation', 400)

-- Budget Audit Table

CREATE TABLE budget_audit_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    audit_date DATE NOT NULL,         -- Date the audit was performed
    month_key VARCHAR(7) NOT NULL,    -- Format: 'YYYY-MM'
    category VARCHAR(100) NOT NULL,
    total_spent DECIMAL(10, 2) NOT NULL,
    budget_limit DECIMAL(10, 2) NOT NULL,
    difference DECIMAL(10, 2) NOT NULL,
    status ENUM('OK', 'OVER') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Create Logic (Trigger & Procedure)

-- Trigger that auto categorize transaction

DELIMITER $$

CREATE TRIGGER trg_auto_categorize
BEFORE INSERT ON transactions
FOR EACH ROW
BEGIN
    DECLARE cat VARCHAR(100);
    
    -- Attempt to find matching rule
    SELECT category INTO cat
    FROM category_rules
    WHERE LOWER(NEW.description) LIKE CONCAT('%', LOWER(keyword), '%')
    ORDER BY LENGTH(keyword) DESC
    LIMIT 1;

    -- Assign category if found
    IF cat IS NOT NULL THEN
        SET NEW.category = cat;
    ELSE
        SET NEW.category = 'Uncategorized';
    END IF;
END$$

DELIMITER ;

-- Stored procedure that performs budget check + inserts logs

DELIMITER $$

CREATE PROCEDURE sp_run_budget_audit()
BEGIN
    DECLARE today DATE;

    SET today = CURDATE();

    -- Avoid duplicate audit for today
    IF EXISTS (
        SELECT 1 FROM budget_audit_log
        WHERE audit_date = today
    ) THEN
        SELECT 'Audit already run for today.' AS message;
    ELSE
        -- Insert audit for all available months
        INSERT INTO budget_audit_log (
            audit_date,
            month_key,
            category,
            total_spent,
            budget_limit,
            difference,
            status
        )
        SELECT
            today AS audit_date,
            DATE_FORMAT(t.txn_date, '%Y-%m') AS month_key,
            t.category,
            SUM(IFNULL(t.debit, 0)) AS total_spent,
            MAX(b.budget_limit) AS budget_limit,
            SUM(IFNULL(t.debit, 0)) - MAX(b.budget_limit) AS difference,
            CASE
                WHEN SUM(IFNULL(t.debit, 0)) > MAX(b.budget_limit) THEN 'OVER'
                ELSE 'OK'
            END AS status
        FROM transactions t
        JOIN monthly_budget b ON LOWER(t.category) = LOWER(b.category)
        WHERE t.debit IS NOT NULL
        GROUP BY DATE_FORMAT(t.txn_date, '%Y-%m'), t.category;

        SELECT 'Audit completed for all available months.' AS message;
    END IF;
END$$

DELIMITER ;

--  4. Load Transaction Data
-- Load Data Infile
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Cleaned_Bank_Transaction.csv'
INTO TABLE transactions
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
ESCAPED BY '\\'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@txn_date, @description, @debit, @credit, @balance)
SET
    txn_date = STR_TO_DATE(@txn_date, '%e/%m/%Y'),
    description = @description,
    debit = NULLIF(REPLACE(@debit, ',', ''), ''),
    credit = NULLIF(REPLACE(@credit, ',', ''), ''),
    balance = NULLIF(REPLACE(@balance, ',', ''), '');

-- 5. Enable Automation

-- Enable the event scheduler globally (run once)
SET GLOBAL event_scheduler = ON;

-- Create scheduled event to run the audit daily
CREATE EVENT IF NOT EXISTS daily_budget_audit
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE + INTERVAL 1 HOUR
DO
  CALL sp_run_budget_audit();


-- 6. Run Audit Manually (First Time)

CALL sp_run_budget_audit();

--  7. View Results

-- View recent audits
SELECT * FROM budget_audit_log ORDER BY created_at DESC;

-- Check overspending this month
SELECT category, total_spent, budget_limit, difference
FROM budget_audit_log
WHERE month_key = DATE_FORMAT(CURDATE(), '%Y-%m')
  AND status = 'OVER';



