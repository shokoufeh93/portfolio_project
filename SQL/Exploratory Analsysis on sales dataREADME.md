# SQL Sales Data Exploration and Business Analysis

## Overview

This project focuses on exploring and analyzing sales data stored in a SQL Data Warehouse environment. The analysis aims to uncover business insights related to customers, products, sales performance, revenue generation, and operational metrics.

Using SQL queries, the project investigates key dimensions of the business and provides answers to common business questions through data exploration and aggregation techniques.

---

## Database Structure

The analysis is performed on the following tables:

### Customer Dimension

`gold.dim_customers`

Contains customer information including:

* Customer ID
* Name
* Gender
* Country
* Birthdate

### Product Dimension

`gold.dim_products`

Contains product-related information including:

* Product Name
* Category
* Subcategory
* Cost

### Sales Fact Table

`gold.fact_sales`

Contains transactional sales data including:

* Order Number
* Product Key
* Customer Key
* Quantity
* Price
* Sales Amount
* Order Date
* Shipping Date
* Due Date

---

## Project Objectives

The project was designed to answer several business questions:

* Who are our customers and where do they come from?
* Which products generate the highest revenue?
* What product categories perform best?
* Which customers contribute the most revenue?
* How many orders, products, and customers exist in the business?
* What is the overall sales performance?
* How are sales distributed across countries?

---

## Key Analysis Performed

### Database Exploration

* Explored database tables and columns using INFORMATION_SCHEMA.
* Examined the structure of dimension and fact tables.
* Identified available business entities and attributes.

### Customer Analysis

* Customer distribution by country.
* Customer distribution by gender.
* Youngest and oldest customer identification.
* Number of active customers placing orders.

### Product Analysis

* Product categories and subcategories exploration.
* Product count by category.
* Average product cost by category.

### Sales Analysis

* Total Sales Revenue.
* Total Quantity Sold.
* Average Selling Price.
* Total Number of Orders.
* Revenue by Product Category.
* Revenue by Customer.
* Sales Distribution by Country.

### Performance Analysis

* Top 5 Best-Selling Products.
* Bottom 5 Worst-Performing Products.
* Top 10 Revenue-Generating Customers.
* Customers with the Fewest Orders.

### Time Analysis

* First and Last Order Dates.
* Sales Date Range.
* Number of Years Covered in the Dataset.

---

## Business KPIs

The following KPIs were calculated:

| KPI                   | Description                    |
| --------------------- | ------------------------------ |
| Total Sales           | Total revenue generated        |
| Total Quantity Sold   | Number of products sold        |
| Average Selling Price | Average sales price            |
| Total Orders          | Number of orders placed        |
| Total Products        | Number of products available   |
| Total Customers       | Number of registered customers |
| Active Customers      | Customers who placed orders    |

---

## SQL Concepts Used

This project demonstrates practical use of:

* SELECT Statements
* Aggregate Functions (SUM, AVG, COUNT)
* GROUP BY
* ORDER BY
* DISTINCT
* JOIN Operations
* LEFT JOIN
* UNION ALL
* Window Functions
* ROW_NUMBER()
* Date Functions
* DATEDIFF()
* INFORMATION_SCHEMA

---

## Business Insights Generated

The analysis provides insights into:

* Revenue drivers
* Customer behavior
* Product performance
* Market distribution
* Sales trends
* Customer segmentation

These insights can support business decision-making related to product strategy, customer targeting, and sales optimization.

---

## Tools Used

* SQL Server
* T-SQL
* Data Warehouse
* SQL Server Management Studio (SSMS)

