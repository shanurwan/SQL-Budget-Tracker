# 💸 MySQL-Powered Self-Auditing Budget Tracker

**Build your own Personal CFO.**  
A fully-automated personal finance audit engine powered entirely by MySQL.  

---

## 📌 Project Goals

✅ **Empower anyone to automate personal finance tracking** — without relying on third-party apps or paid tools.

🔍 **Give full visibility and control over your spending** through transparent, customizable SQL logic.

🔁 **Provide a fully reproducible system** that anyone can replicate, modify, or scale using just MySQL.

💼 **Demonstrate practical SQL automation techniques** — including triggers, procedures, and event scheduling 

🧠 **Help users gain financial clarity** by surfacing patterns, overspending habits, and monthly summaries in a structured, queryable format.

---

## 🛢️ Why MySQL?

### ✅ No-code, Transparent Logic
Unlike budgeting apps that hide how things work behind the scenes, this system runs entirely on visible, customizable SQL rules.
You can see, edit, and control how transactions are categorized, how budgets are set, and how overspending is flagged

### ✅ Native Automation
With features like Triggers, Stored Procedures, and Event Scheduler, MySQL enables:

- Real-time transaction tagging

- Scheduled daily audits

- Clean separation of data, logic, and logs

- No Python scripts, no external schedulers — just pure SQL automation.

### ✅ Beginner-Friendly & Reproducible
Anyone with basic SQL knowledge can:

- Set this up

- Modify logic to fit personal needs

- Run it on any MySQL-supported machine (including free hosting or Docker)

### ✅Security by Simplicity
Since no external code or APIs are involved, your sensitive financial data never leaves your local machine or trusted MySQL instance. This drastically reduces the risk of data leaks compared to cloud-based budgeting apps.

### ✅ Production-Ready Concepts
This project demonstrates skills used in professional data systems:

- ETL-style ingestion

- Rule-based classification

- Daily audit pipelines

It’s a great learning ground for aspiring Data Analysts, BI Developers, or SQL Engineers.

💡 Think of it as a lightweight, offline, customizable Personal Finance Engine, powered entirely by SQL.

---

## 🚀 Features

✅ Fully SQL-based budget tracker  
✅ Auto-categorizes transactions using keyword rules  
✅ Tracks monthly spending vs. budget  
✅ Logs overspending events for audit  
✅ Self-runs using MySQL Event Scheduler  
✅ No external scripts or dependencies — pure MySQL logic

---

## 📦 Project Structure

| Component              | Description                                                  |
|------------------------|--------------------------------------------------------------|
| `transactions`         | Stores bank transaction data (date, debit/credit, balance)   |
| `category_rules`       | Maps description keywords to budget categories               |
| `monthly_budget`       | Budget limits per category                                   |
| `budget_audit_log`     | Stores overspending logs (auto-generated daily)              |
| `sp_run_budget_audit`  | Stored procedure that performs budget check + inserts logs   |
| `trg_auto_categorize`  | Trigger that auto-tags transactions on insert                |
| `daily_budget_audit`   | Event that auto-runs audit procedure every 24 hours          |

---

## 🧠 How It Works

1. Import your bank data into `transactions` table.
2. Descriptions are categorized using `category_rules` (trigger or manual).
3. Budgets for each category are defined in `monthly_budget`.
4. Every day, `sp_run_budget_audit` checks actual spending vs. budget.
5. Over-budget results are inserted into `budget_audit_log`.
6. You get a clean, queryable audit history — no spreadsheets required.

---

## 🛠️ Setup Instructions

1. **Create all tables & triggers:**

```sql
-- Clone this repo, copy SQL files, or run schema manually
-- Run each section from schema.sql in your MySQL instance
```
2. **Enable event Scheduler**

```sql
SET GLOBAL event_scheduler = ON;
```

3. **Import your bank csv into**

```sql
-- Clean your CSV to match this format: date, description, debit, credit, balance
-- Then use MySQL Workbench or:

LOAD DATA INFILE '/path/to/your_file.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(txn_date, description, debit, credit, balance);
```

4. **Review Categorized Spending**

```sql
SELECT category, SUM(debit) AS total_spent
FROM transactions
WHERE debit IS NOT NULL
GROUP BY category
ORDER BY total_spent DESC;
```
---

## 🧾 Data Source

This project uses **actual personal bank transaction records** as the data foundation.

If you're starting with **PDF bank statements**, you can extract them to CSV format using this python script:

🔗 [PDF-to-CSV Converter (Python Script)](https://github.com/shanurwan/PDF-to-CSV)

Make sure to clean the csv file first before you load into MySQL, sample data cleaning :

🔗 [Sample Bank Transaction Data Cleaning](https://github.com/shanurwan/SQL-Budget-Tracker/blob/main/Clean%20Bank%20Transaction.ipynb)

---

### Example CSV Format (Expected)

| txn_date   | description             | debit   | credit  | balance  |
|------------|--------------------------|---------|---------|----------|
| 2024-12-03 | TESCO Store - PJ         | 43.21   |         | 1320.55  |
| 2024-12-04 | Salary - Company XYZ     |         | 3000.00 | 4320.55  |

> 💡 You can import this into the `transactions` table using `LOAD DATA INFILE` or MySQL Workbench.


## 🧾 Example Use Cases
- Track where your money actually goes

- Get alerts when you're over your food/delivery/online shopping budget

- Build a financial habit of reviewing monthly burn without touching Excel

- Beginner Friendly SQL automation practice

---


## 📚 Technologies Used
MySQL 8.0+

Native SQL: TRIGGER, PROCEDURE, EVENT, VIEW

Bank data in CSV format (any bank)


