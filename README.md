# 💸 MySQL-Powered Self-Auditing Budget Tracker

**Build your own Personal CFO.**  
A fully-automated personal finance audit engine powered entirely by MySQL.  
No Python. No spreadsheets. Just native SQL: triggers, procedures, and scheduled audits.

---

## 📌 Project Goals

✅ **Empower anyone to automate personal finance tracking** — without relying on third-party apps or paid tools.

🔍 **Give full visibility and control over your spending** through transparent, customizable SQL logic.

🔁 **Provide a fully reproducible system** that anyone can replicate, modify, or scale using just MySQL.

💼 **Demonstrate practical SQL automation techniques** — including triggers, procedures, and event scheduling — valuable for both beginners and professionals.

🧠 **Help users gain financial clarity** by surfacing patterns, overspending habits, and monthly summaries in a structured, queryable format.

---

## 🚀 Features

✅ Fully SQL-based budget tracker  
✅ Auto-categorizes transactions using keyword rules  
✅ Tracks monthly spending vs. budget  
✅ Logs overspending events for audit  
✅ Self-runs daily using MySQL Event Scheduler  
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

---

## 🧾 Example Use Cases
- Track where your money actually goes

- Get alerts when you're over your food/delivery/online shopping budget

- Build a financial habit of reviewing monthly burn without touching Excel

- Beginner Friendly SQL automation practice

---

### Example CSV Format (Expected)

| txn_date   | description             | debit   | credit  | balance  |
|------------|--------------------------|---------|---------|----------|
| 2024-12-03 | TESCO Store - PJ         | 43.21   |         | 1320.55  |
| 2024-12-04 | Salary - Company XYZ     |         | 3000.00 | 4320.55  |

> 💡 You can import this into the `transactions` table using `LOAD DATA INFILE` or MySQL Workbench.


## 📚 Technologies Used
MySQL 8.0+

Native SQL: TRIGGER, PROCEDURE, EVENT, VIEW

Bank data in CSV format (any bank)


