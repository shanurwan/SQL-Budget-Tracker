-- Stored procedure that performs budget check + inserts logs

DELIMITER $$

CREATE PROCEDURE sp_run_budget_audit()
BEGIN
    DECLARE today DATE;
    DECLARE last_audited_txn_date DATE;

    SET today = CURDATE();

    -- Get the last txn_date already audited (NULL if never audited)
    SELECT MAX(STR_TO_DATE(CONCAT(month_key, '-01'), '%Y-%m-%d'))
    INTO last_audited_txn_date
    FROM budget_audit_log;

    -- If today's audit already exists, exit
    IF EXISTS (
        SELECT 1 FROM budget_audit_log
        WHERE audit_date = today
    ) THEN
        SELECT 'Audit already run for today.' AS message;

    -- If no new data beyond last audited txn_date, skip
    ELSEIF NOT EXISTS (
        SELECT 1 FROM transactions
        WHERE txn_date > IFNULL(last_audited_txn_date, '1900-01-01')
          AND debit IS NOT NULL
    ) THEN
        SELECT 'No new transactions to audit.' AS message;

    ELSE
        -- Insert audit for new data only
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
          AND t.txn_date > IFNULL(last_audited_txn_date, '1900-01-01')
        GROUP BY DATE_FORMAT(t.txn_date, '%Y-%m'), t.category;

        SELECT 'Audit completed for new transactions.' AS message;
    END IF;
END$$

DELIMITER ;
