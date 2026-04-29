# IT Helpdesk Analytics Dashboard

An end-to-end data analytics project that transforms raw IT helpdesk ticket data into actionable insights using Python, SQL, and Power BI. The pipeline covers data ingestion, cleaning, KPI analysis, and an interactive dashboard for tracking support team performance.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Project Structure](#project-structure)
- [Dataset](#dataset)
- [Pipeline Stages](#pipeline-stages)
  - [1. Data Cleaning (Python)](#1-data-cleaning-python)
  - [2. Database Setup (SQL)](#2-database-setup-sql)
  - [3. KPI Analysis (SQL)](#3-kpi-analysis-sql)
  - [4. Dashboard (Power BI)](#4-dashboard-power-bi)
- [Key Metrics & KPIs](#key-metrics--kpis)
- [SLA Policy](#sla-policy)
- [Getting Started](#getting-started)
- [Requirements](#requirements)
- [Dashboard Preview](#dashboard-preview)

---

## Project Overview

IT support teams generate large volumes of ticket data that often go underutilised. This project builds a full analytics pipeline to answer critical operational questions:

- How many tickets are being raised, and by what priority?
- Which categories (Network, Hardware, Software, etc.) consume the most support time?
- Are SLA targets being met?
- Which agents handle the most tickets, and how quickly do they resolve them?
- How does ticket volume trend over time?

The result is an interactive Power BI dashboard backed by clean, analysis-ready data.

---

## Project Structure

```
it-helpdesk-analytics-dashboard-main/
│
├── data/
│   ├── raw data.csv.csv                  # Original raw ticket export (1,000 records)
│   └── cleaned_helpdesk_data.csv.csv     # Cleaned dataset with derived SLA columns
│
├── python/
│   └── data_cleaning.ipynb               # Jupyter notebook: cleaning + KPI calculation
│
├── sql/
│   ├── create_table.sql/
│   │   └── sql.sql                       # Database & table creation DDL
│   ├── data_cleaning.sql/
│   │   └── sql.sql                       # SQL-side data cleaning & deduplication
│   ├── kpi_analysis.sql/
│   │   ├── kpi.sql                       # Core KPI queries
│   │   └── kpi_analysis.sql              # Extended KPI analysis queries
│   └── query/
│       └── query.sql                     # Ad-hoc exploratory queries
│
├── powerbi/
│   └── helpdesk.pbix                     # Power BI dashboard file
│
├── image/
│   ├── Screenshot 2026-01-11 231639.png  # Dashboard screenshot — overview
│   ├── Screenshot 2026-01-11 232353.png  # Dashboard screenshot — agent performance
│   └── Screenshot 2026-01-11 232701.png  # Dashboard screenshot — category/trend view
│
└── README.md
```

---

## Dataset

The project uses a helpdesk ticket dataset with **1,000 records** across **14 raw fields**, expanded to 16 fields after cleaning.

| Field | Description |
|---|---|
| `ticket_id` | Unique ticket identifier (e.g. T0001) |
| `created_date` | Timestamp when the ticket was opened |
| `resolved_date` | Timestamp when the ticket was closed (nullable for open tickets) |
| `priority` | Ticket urgency — `High`, `Medium`, or `Low` |
| `category` | Issue type — Email, Network, VPN, Software, Hardware, Server, Printing, Database, or Access |
| `assigned_to` | Name of the support agent assigned |
| `status` | Current state — `Open` or `Resolved` |
| `sla_violated` | Whether the SLA deadline was breached (`Yes` / `No`) |
| `satisfaction_rating` | End-user satisfaction score (numeric) |
| `escalation_level` | Number of escalation steps taken |
| `ticket_source` | Submission channel — Portal, Email, Phone, or Chat |
| `root_cause` | Identified root cause of the issue |
| `resolution_notes` | Free-text description of the resolution |
| `resolution_time_hours` | Hours from ticket creation to resolution |
| `sla_hours` *(derived)* | SLA target hours based on priority |
| `sla_status` *(derived)* | `Met` or `Violated` based on resolution time vs. SLA target |

---

## Pipeline Stages

### 1. Data Cleaning (Python)

**File:** `python/data_cleaning.ipynb`

The notebook performs the following transformations on the raw CSV:

**Type Conversion**
- Parses `created_date` and `resolved_date` as proper datetime objects (with `errors='coerce'` for malformed entries).

**Resolution Time Calculation**
- Computes `resolution_time_hours` as the difference between `resolved_date` and `created_date` in hours.
- Fills null values (open tickets with no resolution) with `0`.

**SLA Enrichment**
- Maps each priority level to its SLA target (see [SLA Policy](#sla-policy)).
- Derives `sla_status` as `Violated` if `resolution_time_hours > sla_hours`, otherwise `Met`.

**KPI Summary Export**
- Groups data by priority and computes total tickets, average resolution time, and SLA violation count per priority tier.
- Exports the KPI summary as `kpi_summary.csv`.

**Output:** `data/cleaned_helpdesk_data.csv.csv`

---

### 2. Database Setup (SQL)

**File:** `sql/create_table.sql/sql.sql`

Creates the MySQL database and table to host the ticket data for SQL-based analysis.

```sql
CREATE DATABASE helpdesk_db;
USE helpdesk_db;

CREATE TABLE helpdesk_tickets (
    ticket_id          VARCHAR(20),
    created_date       DATETIME,
    resolved_date      DATETIME,
    priority           VARCHAR(20),
    category           VARCHAR(50),
    assigned_to        VARCHAR(50),
    status             VARCHAR(20),
    sla_violated       VARCHAR(5),
    satisfaction_rating INT,
    escalation_level   INT
);
```

**File:** `sql/data_cleaning.sql/sql.sql`

Handles SQL-side data quality fixes after import:

- Sets `resolved_date = created_date` for rows where `resolved_date` is NULL (prevents broken resolution time calculations).
- Standardises `sla_violated` values to consistent casing (`Yes` / `No`).
- Checks for duplicate `ticket_id` entries.

---

### 3. KPI Analysis (SQL)

**Files:** `sql/kpi_analysis.sql/` and `sql/query/query.sql`

A comprehensive set of queries covering all major reporting dimensions:

| Query | Purpose |
|---|---|
| Total ticket count | Overall volume |
| Tickets by priority | Distribution across High / Medium / Low |
| Tickets by category | Which issue types are most common |
| Tickets by status | Open vs. resolved split |
| SLA violation rate | Percentage of tickets that breached SLA |
| Average resolution time | Mean hours from open to close |
| Resolution time by category | Which categories take longest to resolve |
| Agent performance | Tickets handled and avg. resolution time per agent |
| Monthly ticket volume | Trend over time by `YYYY-MM` |
| Top 5 categories | Highest-volume issue types |

---

### 4. Dashboard (Power BI)

**File:** `powerbi/helpdesk.pbix`

The Power BI dashboard visualises the cleaned dataset and SQL-derived KPIs in an interactive format. It is built to support filtering by date range, priority, category, and agent.

Key visuals include:

- **KPI cards** — Total tickets, SLA compliance rate, average resolution time
- **Ticket volume by priority** — Bar or donut chart
- **Category breakdown** — Which issue types drive the most volume and resolution delay
- **SLA compliance** — Met vs. Violated distribution
- **Agent leaderboard** — Tickets handled and average resolution time per agent
- **Monthly trend line** — Ticket volume over time

---

## Key Metrics & KPIs

| KPI | Description |
|---|---|
| **Total Tickets** | Count of all tickets in the dataset |
| **SLA Compliance Rate** | % of resolved tickets where `sla_status = 'Met'` |
| **Average Resolution Time** | Mean `resolution_time_hours` across resolved tickets |
| **SLA Violation Rate** | % of tickets where the SLA deadline was breached |
| **Tickets per Agent** | Workload distribution across the support team |
| **Average Resolution Time by Category** | Identifies which issue types are slowest to resolve |
| **Ticket Volume Trend** | Month-over-month ticket count |

---

## SLA Policy

The following SLA targets are used to derive `sla_hours` and classify `sla_status`:

| Priority | SLA Target |
|---|---|
| Critical | 4 hours |
| High | 8 hours |
| Medium | 24 hours |
| Low | 48 hours |

A ticket is marked **Violated** if `resolution_time_hours > sla_hours`.

---

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/<your-username>/it-helpdesk-analytics-dashboard.git
cd it-helpdesk-analytics-dashboard
```

### 2. Run the Python cleaning notebook

Open `python/data_cleaning.ipynb` in Jupyter and run all cells. The notebook reads `data/raw data.csv.csv` and outputs `cleaned_helpdesk_data.csv` to the same directory.

```bash
pip install pandas numpy jupyter
jupyter notebook python/data_cleaning.ipynb
```

### 3. Set up the SQL database

Connect to a MySQL instance and run the scripts in order:

```bash
# 1. Create the database and table
mysql -u <user> -p < sql/create_table.sql/sql.sql

# 2. Import the cleaned CSV into helpdesk_tickets
# (Use MySQL Workbench's Table Data Import Wizard or LOAD DATA INFILE)

# 3. Run data cleaning fixes
mysql -u <user> -p helpdesk_db < sql/data_cleaning.sql/sql.sql

# 4. Run KPI analysis queries
mysql -u <user> -p helpdesk_db < sql/kpi_analysis.sql/kpi_analysis.sql
```

### 4. Open the Power BI dashboard

Open `powerbi/helpdesk.pbix` in [Power BI Desktop](https://powerbi.microsoft.com/desktop). Update the data source connection to point to your local cleaned CSV or MySQL database, then refresh.

---

## Requirements

| Tool | Version |
|---|---|
| Python | 3.8+ |
| pandas | Any recent version |
| numpy | Any recent version |
| Jupyter Notebook | Any recent version |
| MySQL | 8.0+ |
| Power BI Desktop | Latest (free) |

---

## Dashboard Preview

| Overview | Agent Performance | Category & Trends |
|---|---|---|
| ![Overview](image/Screenshot%202026-01-11%20231639.png) | ![Agents](image/Screenshot%202026-01-11%20232353.png) | ![Categories](image/Screenshot%202026-01-11%20232701.png) |
