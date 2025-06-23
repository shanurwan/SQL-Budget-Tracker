-- Enable the event scheduler globally (run once)
SET GLOBAL event_scheduler = ON;

-- Create scheduled event to run the audit daily
CREATE EVENT IF NOT EXISTS daily_budget_audit
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE + INTERVAL 1 HOUR
DO
  CALL sp_run_budget_audit();
