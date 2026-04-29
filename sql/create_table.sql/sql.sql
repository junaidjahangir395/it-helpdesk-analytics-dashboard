CREATE DATABASE helpdesk_db;
USE helpdesk_db;
CREATE TABLE helpdesk_tickets (
    ticket_id VARCHAR(20),
    created_date DATETIME,
    resolved_date DATETIME,
    priority VARCHAR(20),
    category VARCHAR(50),
    assigned_to VARCHAR(50),
    status VARCHAR(20),
    sla_violated VARCHAR(5),
    satisfaction_rating INT,
    escalation_level INT
);
SELECT 
    *
FROM
    helpdesk_tickets;
