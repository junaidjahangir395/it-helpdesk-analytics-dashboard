
USE helpdesk_analytics;
SHOW TABLES;
SELECT COUNT(*) FROM tickets;
SELECT *
FROM tickets
LIMIT 10;
SELECT COUNT(*) AS total_tickets
FROM tickets;
SELECT status, COUNT(*) AS ticket_count
FROM tickets
GROUP BY status
ORDER BY ticket_count DESC;
SELECT priority, COUNT(*) AS ticket_count
FROM tickets
GROUP BY priority
ORDER BY ticket_count DESC;
SELECT
    ROUND(
        SUM(CASE WHEN sla_violated = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS sla_violation_percentage
FROM tickets;
SELECT
    ROUND(AVG(TIMESTAMPDIFF(HOUR, created_date, resolved_date)), 2)
    AS avg_resolution_time_hours
FROM tickets
WHERE resolved_date IS NOT NULL;
SELECT
    category,
    COUNT(*) AS total_tickets,
    ROUND(
        AVG(TIMESTAMPDIFF(HOUR, created_date, resolved_date)), 2
    ) AS avg_resolution_time
FROM tickets
GROUP BY category
ORDER BY avg_resolution_time DESC;
SELECT
    assigned_to AS agent,
    COUNT(*) AS tickets_handled,
    ROUND(
        AVG(TIMESTAMPDIFF(HOUR, created_date, resolved_date)), 2
    ) AS avg_resolution_time
FROM tickets
GROUP BY assigned_to
ORDER BY tickets_handled DESC;
SELECT
    DATE_FORMAT(created_date, '%Y-%m') AS month,
    COUNT(*) AS total_tickets
FROM tickets
GROUP BY month
ORDER BY month;
SELECT
    category,
    COUNT(*) AS ticket_count
FROM tickets
GROUP BY category
ORDER BY ticket_count DESC
LIMIT 5;






