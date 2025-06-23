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
