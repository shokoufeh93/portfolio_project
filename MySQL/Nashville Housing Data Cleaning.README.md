# Nashville Housing Data Cleaning 

## Overview

This project focuses on cleaning and transforming a real-world housing dataset using MySQL. The dataset contains property sales information from Nashville, and the goal is to convert raw, inconsistent data into a structured and analysis-ready format.

The project demonstrates practical data cleaning techniques commonly used in data engineering and analytics workflows.

---

## Dataset

The dataset includes housing transaction data with fields such as:

* Parcel ID
* Property Address
* Owner Address
* Sale Date
* Sale Price
* Legal Reference
* Sold As Vacant
* Tax District

---

## Project Objectives

The main goals of this project are:

* Standardize inconsistent date formats.
* Handle missing property address values.
* Split combined address fields into structured columns.
* Standardize categorical values (Y/N → Yes/No).
* Remove duplicate records.
* Drop unnecessary columns.

---

## Data Cleaning Steps

### 1. Standardizing Date Format

* Converted `SaleDate` from text format to proper DATE format using `STR_TO_DATE()`.
* Ensures correct handling for time-based analysis.

---

### 2. Handling Missing Property Address

* Identified missing values in `PropertyAddress`.
* Used `ParcelID` to join and populate missing address values from existing records.
* Applied `COALESCE()` and self-joins for data imputation.

---

### 3. Splitting Address Columns

#### Property Address

Split into:

* Address
* City

Using string functions such as:

* `SUBSTRING()`
* `LOCATE()`

---

#### Owner Address

Split into:

* Owner Address
* Owner City
* Owner State

Using:

* `SUBSTRING_INDEX()`

This improves data structure and analytical usability.

---

### 4. Standardizing Categorical Values

* Converted:

  * `Y` → Yes
  * `N` → No

Applied using `CASE WHEN` statement on `SoldAsVacant` column.

---

### 5. Removing Duplicate Records

* Used `ROW_NUMBER()` window function.

* Partitioned data by key fields:

  * ParcelID
  * PropertyAddress
  * SaleDate
  * SalePrice
  * LegalReference

* Removed rows with duplicate ranking (>1).

---

### 6. Removing Unused Columns

Dropped redundant columns after transformation:

* PropertyAddress
* OwnerAddress
* TaxDistrict

This reduces redundancy and improves dataset clarity.

---

## SQL Concepts Used

This project demonstrates strong usage of:

* Data Cleaning Techniques
* String Functions (`SUBSTRING`, `LOCATE`, `SUBSTRING_INDEX`)
* CASE Statements
* COALESCE()
* JOIN Operations (Self Join)
* Window Functions (`ROW_NUMBER()`)
* CTE (Common Table Expressions)
* Data Type Conversion
* ALTER TABLE operations
* DELETE operations

---

## Business Value

Clean housing data enables:

* Accurate real estate price analysis
* Reliable reporting dashboards
* Better geographic insights
* Improved data-driven decision making
* Higher quality analytics outputs

---

## Key Skills Demonstrated

* Data Cleaning & Transformation
* SQL Scripting (MySQL)
* Data Structuring
* Handling Missing Data
* Feature Engineering (splitting columns)
* Deduplication Strategies
* Real-world ETL workflow design

---

## Tools Used

* MySQL
* SQL
* Data Cleaning Techniques

---

## Outcome

The dataset is transformed from a raw, inconsistent structure into a clean, analysis-ready dataset suitable for:

* Exploratory Data Analysis (EDA)
* Power BI Dashboards
* Real Estate Analytics
* Business Intelligence Reporting

