SELECT COUNT(*) AS total_tickets
FROM helpdesk_tickets;
SELECT priority, COUNT(*) AS ticket_count
FROM helpdesk_tickets
GROUP BY priority;
SELECT category, COUNT(*) AS ticket_count
FROM helpdesk_tickets
GROUP BY category;
SELECT sla_violated, COUNT(*) AS count
FROM helpdesk_tickets
GROUP BY sla_violated;
SELECT 
AVG(TIMESTAMPDIFF(HOUR, created_date, resolved_date))
AS avg_resolution_hours
FROM helpdesk_tickets;
SELECT assigned_to, COUNT(*) AS tickets_handled
FROM helpdesk_tickets
GROUP BY assigned_to
ORDER BY tickets_handled DESC;

