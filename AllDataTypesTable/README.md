# All Data Types Table Example

Demonstration of the most common IBM i SQL data types with working CREATE TABLE and INSERT statements.

**Author:** Jerald Horner  
**Email:** JeraldHorner@StructuredSys.Com  
**Phone:** 214-704-6178

---

## Veteran Instructions (TL;DR)

**Quick Setup:**
1. **Create table:** Run `allfields.txt` in STRSQL or via `RUNSQLSTM`
2. **Insert data:** Run `allfieldsi.txt` 
3. **Update libraries:** Change `JHORNER21` to `MYLIBRARY` in both files
4. **Verify:** `SELECT * FROM MYLIBRARY.ALL_FIELD_TYPES`

**What it demonstrates:** Table with most common IBM i SQL data types (CHAR, VARCHAR, INTEGER, DECIMAL, DATE, TIMESTAMP, BINARY, XML, BOOLEAN, etc.) plus working sample data inserts using proper IBM i syntax.

**Files:** `allfields.txt` (CREATE TABLE), `allfieldsi.txt` (2 INSERT statements with sample data)

---

## Detailed Information

### Files Included

| File | Description |
|------|-------------|
| `allfields.txt` | CREATE TABLE statement with common IBM i SQL data types |
| `allfieldsi.txt` | INSERT statements with sample data demonstrating proper syntax |

### What This Example Demonstrates

The `ALL_FIELD_TYPES` table includes these common IBM i SQL data types:

#### **Character Types**
```sql
CHAR_FIELD        CHAR(10)         -- Fixed-length, padded with spaces
VARCHAR_FIELD     VARCHAR(50)      -- Variable-length character data
CLOB_FIELD        CLOB(1K)         -- Character Large Object for long text
```

#### **Numeric Types**
```sql
SMALLINT_FIELD    SMALLINT         -- 2-byte integer (-32,768 to 32,767)
INTEGER_FIELD     INTEGER          -- 4-byte integer (-2.1B to 2.1B)
BIGINT_FIELD      BIGINT           -- 8-byte integer (very large numbers)
DECIMAL_FIELD     DECIMAL(9, 2)    -- Packed decimal (precise currency)
NUMERIC_FIELD     NUMERIC(5, 0)    -- Same as DECIMAL
FLOAT_FIELD       FLOAT(8)         -- Approximate floating point
REAL_FIELD        REAL             -- Single-precision float
DOUBLE_FIELD      DOUBLE           -- Double-precision float
```

#### **Date and Time Types**
```sql
DATE_FIELD        DATE             -- Date only (YYYY-MM-DD)
TIME_FIELD        TIME             -- Time only (HH:MM:SS)
TIMESTAMP_FIELD   TIMESTAMP        -- Date + time + microseconds
```

#### **Binary and Special Types**
```sql
BINARY_FIELD      BINARY(8)        -- Fixed-length binary data
VARBINARY_FIELD   VARBINARY(100)   -- Variable-length binary data
BLOB_FIELD        BLOB(1K)         -- Binary Large Object
BOOLEAN_FIELD     BOOLEAN          -- TRUE/FALSE values (IBM i 7.1+)
ROWID_FIELD       ROWID            -- Unique system-generated identifier
XML_FIELD         XML              -- Native XML storage
ID_FIELD          INTEGER...IDENTITY -- Auto-incrementing primary key
```

### Setup Instructions

#### **Step 1: Create Your Library**
```sql
CREATE LIBRARY MYLIBRARY;
```

#### **Step 2: Create the Table**
1. **Edit `allfields.txt`** - Change `JHORNER21` to `MYLIBRARY`
2. **Run the script:**
   - **STRSQL:** Copy/paste the content
   - **RUNSQLSTM:** `RUNSQLSTM SRCFILE(MYLIBRARY/QSQLSRC) SRCMBR(ALLFIELDS)`

#### **Step 3: Insert Sample Data**
1. **Edit `allfieldsi.txt`** - Change `JHORNER21` to `MYLIBRARY`  
2. **Run the script:**
   - **STRSQL:** Copy/paste the content
   - **RUNSQLSTM:** `RUNSQLSTM SRCFILE(MYLIBRARY/QSQLSRC) SRCMBR(ALLFIELDSI)`

#### **Step 4: Verify Results**
```sql
-- Check record count (should be 2)
SELECT COUNT(*) FROM MYLIBRARY.ALL_FIELD_TYPES;

-- View all data
SELECT * FROM MYLIBRARY.ALL_FIELD_TYPES;

-- View key columns
SELECT ID_FIELD, CHAR_FIELD, VARCHAR_FIELD, INTEGER_FIELD, DATE_FIELD 
FROM MYLIBRARY.ALL_FIELD_TYPES 
ORDER BY ID_FIELD;
```

### Sample Data Explained

The INSERT script creates **2 sample records**:

#### **Record 1:** 'SAMPLE2' Customer
- **Character:** 'SAMPLE2   ', 'Jane Smith Customer Record'
- **Numeric:** Various integers, decimals, floating-point values
- **Date/Time:** 2025-01-07 with timestamp
- **Binary:** Hex-encoded values using CAST functions
- **XML:** `<customer><name>John</name><id>1001</id></customer>`

#### **Record 2:** 'SAMPLE1' Customer
- **Character:** 'SAMPLE1   ', 'John Smith Customer Record'  
- **Date/Time:** Historical date (2024-08-07)
- **Same structure** with different values for comparison

### Key IBM i SQL Syntax Demonstrated

#### **CAST Functions for Binary Data**
```sql
CAST(x'3132333435363738' AS BINARY(8))          -- Hex '12345678' to BINARY
CAST(x'414243444546' AS VARBINARY(6))           -- Hex 'ABCDEF' to VARBINARY  
CAST(x'53616D706C652062696E6172792064617461' AS BLOB) -- 'Sample binary data' to BLOB
```

#### **XML Parsing**
```sql
XMLPARSE(DOCUMENT '<customer><name>John</name><id>1001</id></customer>')
```

#### **CLOB Casting**
```sql
CAST('This is a sample CLOB field with longer text' AS CLOB)
```

#### **Identity and System Values**
```sql
DEFAULT                    -- System generates ROWID
ID_FIELD INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
```

### Testing and Exploration

#### **Query Different Data Types**
```sql
-- Character field analysis
SELECT ID_FIELD, CHAR_FIELD, VARCHAR_FIELD, LENGTH(VARCHAR_FIELD) as VARCHAR_LENGTH
FROM MYLIBRARY.ALL_FIELD_TYPES;

-- Numeric data examination  
SELECT ID_FIELD, SMALLINT_FIELD, INTEGER_FIELD, DECIMAL_FIELD, FLOAT_FIELD
FROM MYLIBRARY.ALL_FIELD_TYPES;

-- Date/time values
SELECT ID_FIELD, DATE_FIELD, TIME_FIELD, TIMESTAMP_FIELD
FROM MYLIBRARY.ALL_FIELD_TYPES;

-- Special types
SELECT ID_FIELD, BOOLEAN_FIELD, XML_FIELD
FROM MYLIBRARY.ALL_FIELD_TYPES;
```

#### **Add Your Own Test Data**
```sql
-- Insert additional test record
INSERT INTO MYLIBRARY.ALL_FIELD_TYPES (
    CHAR_FIELD, VARCHAR_FIELD, INTEGER_FIELD, DATE_FIELD, BOOLEAN_FIELD
) VALUES (
    'TEST      ', 'My test record', 99999, CURRENT_DATE, 1
);

-- Update existing data
UPDATE MYLIBRARY.ALL_FIELD_TYPES 
SET VARCHAR_FIELD = 'Updated customer record'
WHERE ID_FIELD = 1;
```

### Troubleshooting

#### **Common Issues**

**Boolean Field Errors (Older IBM i versions):**
```sql
-- Change BOOLEAN to SMALLINT for compatibility
BOOLEAN_FIELD     SMALLINT DEFAULT 0    -- Use 1/0 for TRUE/FALSE
```

**XML Parsing Errors:**
```sql
-- If XMLPARSE fails, use simple strings
'<customer><name>John</name><id>1001</id></customer>'  -- As VARCHAR
```

**Library Authority Issues:**
- Ensure `*OBJMGT` authority to create objects
- Use `GRTOBJAUT` if needed for team access

**Binary CAST Problems:**
- Verify hex strings have even number of characters
- Use uppercase A-F in hex values

### Use Cases

This table structure is perfect for:

- **Learning IBM i SQL data types** and their behavior
- **Testing applications** with various data type scenarios  
- **Training materials** for IBM i development
- **Database design validation** before production implementation
- **Data type conversion testing** using CAST and other functions

### Verification Queries

```sql
-- Check table structure in system catalog
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION
FROM QSYS2.SYSCOLUMNS 
WHERE TABLE_NAME = 'ALL_FIELD_TYPES' AND TABLE_SCHEMA = 'MYLIBRARY'
ORDER BY ORDINAL_POSITION;

-- Verify constraints
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE 
FROM QSYS2.SYSCONSTRAINTS 
WHERE TABLE_NAME = 'ALL_FIELD_TYPES' AND TABLE_SCHEMA = 'MYLIBRARY';
```

### Cleanup

To remove the example:
```sql
DROP TABLE MYLIBRARY.ALL_FIELD_TYPES;
```

---

This example provides a solid foundation for understanding IBM i SQL data types. Use it as a reference for database design and as a testing ground for application development.
