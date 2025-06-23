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
