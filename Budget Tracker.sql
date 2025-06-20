-- Create Table Transaction

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
