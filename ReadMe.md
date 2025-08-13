# IBM i Order Management System

A small order management database system designed for IBM i (AS/400) environments, featuring modern SQL tables, sample data, and journaling setup for training and development purposes.

## 📋 Overview

This project provides a comprehensive order management system with 5 related tables, designed specifically for IBM i compliance with:
- **All object names ≤ 10 characters** (IBM i requirement)
- **Realistic business scenarios** for JOIN practice
- **Sample data using cartoon characters** (obviously fake PII)
- **Complete journaling setup** for data integrity
- **Optimized for RPG Free and SQL training**

## 🗂️ Project Structure

```
├── demofiles.txt      # DDL script - Creates all tables and indexes
├── demoinsert.txt     # Sample data inserts (corrected for QSQLSRC width)
├── demojrn.clp        # CLP program for journaling setup
└── README.md          # This file
```

## 🏗️ Database Schema

### Tables (5 total)
- **CATEGORIES** (10 chars) - Product category lookup
- **CUSTOMERS** (9 chars) - Customer master information  
- **PRODUCTS** (8 chars) - Product catalog with inventory
- **ORDERS** (6 chars) - Order header information
- **ORDERITEMS** (10 chars) - Order line item details

### Key Features
- ✅ **Auto-increment primary keys** using IDENTITY columns
- ✅ **Foreign key relationships** with proper constraints
- ✅ **Performance indexes** on commonly queried fields
- ✅ **Realistic business data** (prices, inventory, dates)
- ✅ **Multiple order statuses** (Open, Shipped, Delivered, Cancelled)
- ✅ **Customer types** (Retail, Business, Wholesale)

## 🚀 Quick Start

### Prerequisites
- IBM i system with SQL support
- Authority to create libraries, tables, and journals
- QSQLSRC source member for SQL scripts
- QCLSRC source member for CLP programs

### Installation Steps

#### 1. Create the Database Tables
```sql
-- Copy demofiles.txt content to QSQLSRC member
-- Run via STRSQL or RUNSQLSTM
RUNSQLSTM SRCFILE(YOURLIB/QSQLSRC) SRCMBR(DEMOFILES)
```

#### 2. Load Sample Data
```sql
-- Copy demoinsert.txt content to QSQLSRC member  
-- Formatted for IBM i source member width constraints
RUNSQLSTM SRCFILE(YOURLIB/QSQLSRC) SRCMBR(DEMOINSERT)
```

#### 3. Setup Journaling (Optional)
```cl
// Copy demojrn.clp content to QCLSRC member
CRTCLPGM PGM(YOURLIB/SETUPJRN) SRCFILE(YOURLIB/QCLSRC) SRCMBR(SETUPJRN)
CALL YOURLIB/SETUPJRN
```

## 📊 Sample Data Overview

### Customers (10 records)
- **Obviously fake data** using cartoon characters
- All live on "Cartoon Lane" in "CartoonVille, TX"
- Mix of retail, business, and wholesale customers
- Various credit limits and current balances
- One inactive customer for testing scenarios

### Products (16 records)
- Electronics, Clothing, Books, Home & Garden, Sports, Toys, Automotive
- Realistic pricing with cost, list, and selling prices
- Inventory levels and reorder points
- Mix of taxable and non-taxable items

### Orders (10 records)
- Various order statuses and payment methods
- Date ranges from March to April 2024
- Different shipping addresses and PO numbers
- Mix of delivered, shipped, and open orders

### Order Items (19 line items)
- Multiple line items per order
- Various quantities and discount scenarios
- Some backordered items for testing
- Realistic business scenarios

## 🔄 Journaling Features

The included CLP program (`demojrn.clp`) sets up:
- **Journal receiver** for data capture
- **Journal** for all 5 tables
- **Before and after images** (*BOTH)
- **Automatic receiver management** (*SYSTEM)
- **Error handling** for existing objects

### Journal Benefits
- ✅ Data integrity and recovery
- ✅ Audit trail of all changes  
- ✅ Replication support (HA/DR)
- ✅ Commitment control support
- ✅ Performance monitoring

## 📈 Training Scenarios

Perfect for practicing:

### SQL JOINs
```sql
-- Simple: Customers with Orders
SELECT c.FIRST_NAME, c.LAST_NAME, o.ORDER_NUMBER, o.TOTAL_AMT
FROM CUSTOMERS c 
JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID;

-- Complex: Full Order Detail  
SELECT c.FIRST_NAME, o.ORDER_NUMBER, p.PRODUCT_NAME, oi.QTY_ORDERED
FROM CUSTOMERS c
JOIN ORDERS o ON c.CUSTOMER_ID = o.CUSTOMER_ID  
JOIN ORDERITEMS oi ON o.ORDER_ID = oi.ORDER_ID
JOIN PRODUCTS p ON oi.PRODUCT_ID = p.PRODUCT_ID;
```

### CTEs (Common Table Expressions)
```sql
-- Customer Lifetime Value
WITH CustomerTotals AS (
  SELECT CUSTOMER_ID, SUM(TOTAL_AMT) as LIFETIME_VALUE
  FROM ORDERS 
  GROUP BY CUSTOMER_ID
)
SELECT c.FIRST_NAME, c.LAST_NAME, ct.LIFETIME_VALUE
FROM CUSTOMERS c
JOIN CustomerTotals ct ON c.CUSTOMER_ID = ct.CUSTOMER_ID
ORDER BY ct.LIFETIME_VALUE DESC;
```

### UPDATE Scenarios
```sql
-- Update inventory when orders ship
UPDATE PRODUCTS 
SET QTY_ON_HAND = QTY_ON_HAND - 1
WHERE PRODUCT_ID = 1;

-- Calculate order totals from line items  
UPDATE ORDERS o
SET SUBTOTAL_AMT = (
  SELECT SUM(QTY_ORDERED * UNIT_PRICE - DISCOUNT_AMT)
  FROM ORDERITEMS oi 
  WHERE oi.ORDER_ID = o.ORDER_ID
);
```

## ⚙️ Customization

### Change Library Name
Update all instances of `JHORNER21` in the scripts:
1. In DDL script: Change schema references
2. In insert script: Change table qualifiers  
3. In CLP program: Change &LIBRARY variable

### Modify Sample Data
- All data uses cartoon characters (obviously fake)
- Safe for training and development environments
- Meets privacy compliance requirements
- Easy to modify for different scenarios

## 📝 File Specifications

### demofiles.txt
- **Purpose**: DDL script for table creation
- **Tables**: 5 tables with relationships
- **Indexes**: Performance indexes on key fields
- **Constraints**: Foreign keys and unique constraints

### demoinsert.txt  
- **Purpose**: Sample data population
- **Format**: Optimized for IBM i QSQLSRC width constraints
- **Data**: 53 total records across all tables
- **Features**: Realistic business scenarios with fake PII

### demojrn.clp
- **Purpose**: Journaling setup automation
- **Type**: CLP (Control Language Program)
- **Features**: Error handling, status messages, automatic setup
- **Objects**: Creates journal receiver and journal

## 🔧 Troubleshooting

### Common Issues

**SQL0204 - Object not found**
- Ensure library exists and is in library list
- Check object names (10 character limit)
- Verify proper authorities

**CPF7010 - Object already exists**  
- Normal for journal setup if objects exist
- CLP program handles these gracefully

**Line truncation in QSQLSRC**
- Use the provided demoinsert.txt (formatted for source width)
- Lines kept under 80 characters for compatibility

## 👨‍💻 Author

**Jerald Horner**
- Email: JeraldHorner@StructuredSys.Com
- Phone: 214-704-6178
- Purpose: RPG Free and SQL training

## 📄 License

This project is provided for educational and training purposes. Feel free to use and modify for your training needs.

## 🤝 Contributing

Contributions welcome! Please:
1. Maintain IBM i naming compliance (≤10 characters)
2. Keep sample data obviously fake (cartoon characters)
3. Test on actual IBM i systems
4. Document any changes

## 📚 Additional Resources

### IBM i Documentation
- [SQL Reference](https://www.ibm.com/docs/en/i/7.5?topic=reference-sql)
- [RPG Reference](https://www.ibm.com/docs/en/i/7.5?topic=reference-rpg)
- [Journaling Guide](https://www.ibm.com/docs/en/i/7.5?topic=management-journaling)

### Commands Reference
```
STRSQL          - Start SQL session
RUNSQLSTM       - Run SQL statements from source
WRKJRN          - Work with journal  
WRKJRNPF        - Work with journaled files
DSPJRN          - Display journal information
```

---

⭐ **Star this repo** if it helps with your IBM i training!
