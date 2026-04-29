UPDATE helpdesk_tickets
SET resolved_date = created_date
WHERE resolved_date IS NULL;
UPDATE helpdesk_tickets
SET sla_violated = 'Yes'
WHERE LOWER(sla_violated) = 'yes';

UPDATE helpdesk_tickets
SET sla_violated = 'No'
WHERE LOWER(sla_violated) = 'no';
SELECT ticket_id, COUNT(*)
FROM helpdesk_tickets
GROUP BY ticket_id
HAVING COUNT(*) > 1;
