# IBM i RPG Free Format Sql Demo Programs

Training examples demonstrating modern RPG Free Format programming with embedded Sql on IBM i (AS/400, iSeries, Power i) platform.

## Author
**Jerald Horner**  
Email: JeraldHorner@StructuredSys.com  
Phone: 214-704-6178  

## Purpose
Educational demonstrations of RPG Free Format with embedded Sql for training purposes. These programs showcase best practices for IBM i development including proper error handling, multi-table joins, Common Table Expressions, and modern RPG techniques.

## Programs Included

### DEMOCAT - Basic Sql with Single Table
- **Description:** Displays CATEGORIES table data using embedded Sql cursor
- **Features:** Basic Sql SELECT, cursor processing, error handling
- **Tables Used:** CATEGORIES
- **Compile:** CRTSQLRPGI

### DEMOJOIN - Complex Multi-Table Joins  
- **Description:** Customer order details with 5-table joins
- **Features:** Complex joins, GROUP BY, calculated fields, hierarchical display
- **Tables Used:** CUSTOMERS → ORDERS → ORDERITEMS → PRODUCTS → CATEGORIES
- **Compile:** CRTSQLRPGI

### DEMOCTE - Common Table Expression Demo
- **Description:** Customer analysis using CTE for data aggregation
- **Features:** WITH clause, LEFT JOIN, GROUP BY aggregation, business logic
- **Tables Used:** CUSTOMERS → ORDERS (via CTE)
- **Compile:** CRTSQLRPGI

## Prerequisites

### System Requirements
- IBM i V7R5M0 or higher
- Sql preprocessor installed
- Library JHORNER21 exists

### Database Setup
The programs require these tables in library JHORNER21:
- CATEGORIES (product categories)
- CUSTOMERS (customer master)  
- PRODUCTS (product catalog)
- ORDERS (order headers)
- ORDERITEMS (order line items)

Create tables using the Sql scripts:
- `demofiles.txt` - Table creation DDL
- `demoinsert.txt` - Sample data inserts

## Installation & Compilation

### 1. Create Source Members
```
WRKMBRPDM JHORNER21/QRPGLESRC
  Add: DEMOCAT (Type: SQLRPGLE)
  Add: DEMOJOIN (Type: SQLRPGLE)
  Add: DEMOCTE (Type: SQLRPGLE)
```

### 2. Compile and Run
```
// Manual compilation  
CRTSQLRPGI OBJ(JHORNER21/DEMOCAT) SRCFILE(JHORNER21/QRPGLESRC) 
           SRCMBR(DEMOCAT) OBJTYPE(*PGM) COMMIT(*NONE) DBGVIEW(*SOURCE)

CRTSQLRPGI OBJ(JHORNER21/DEMOJOIN) SRCFILE(JHORNER21/QRPGLESRC)
           SRCMBR(DEMOJOIN) OBJTYPE(*PGM) COMMIT(*NONE) DBGVIEW(*SOURCE)

CRTSQLRPGI OBJ(JHORNER21/DEMOCTE) SRCFILE(JHORNER21/QRPGLESRC)
           SRCMBR(DEMOCTE) OBJTYPE(*PGM) COMMIT(*NONE) DBGVIEW(*SOURCE)
```

### 3. Running the Programs
```
CALL JHORNER21/DEMOCAT
CALL JHORNER21/DEMOJOIN  
CALL JHORNER21/DEMOCTE
```

## Key Features Demonstrated

### Modern RPG Techniques
- **FREE directive for fully free-format source
- Control specifications with modern options
- Qualified data structures
- Procedure-based programming
- Proper error handling with SqlSTATE

### Embedded Sql Best Practices
- Cursor declaration and processing
- Host variable usage with qualified names
- Multi-table joins with INNER JOIN syntax
- Common Table Expressions (CTEs) for complex analysis
- GROUP BY with aggregate functions
- Parameterized procedures for reusability

### IBM i Compliance
- Object names limited to 10 characters
- DSPLY output limited to 52 characters
- String operations using %min() to prevent RNX0100 errors
- Proper compilation with CRTSQLRPGI for Sql preprocessing

### Error Prevention
**Critical Rule Applied:** When using %subst() with fixed length parameters, always use %min() to prevent RNX0100 errors:
```rpg
// WRONG: %subst(%trim(field):1:20)
// RIGHT: %subst(%trim(field):1:%min(20:%len(%trim(field))))
```

## Sample Output

### DEMOCAT Output
```
DEMOCAT - Categories Display Demo
Training Program - Jerald Horner
Contact: JeraldHorner@StructuredSys.com

ID   Code      Category Name
---- --------- -------------------------
1 ELECT     Electronics
     Desc: Computers, phones, and electronic devices
2 CLOTH     Clothing & Apparel  
     Desc: Shirts, pants, shoes, and accessories
---
Total categories displayed: 7
```

### DEMOJOIN Output
```
DEMOJOIN - Customer Orders with Details
Multi-Table Join Demo - Jerald Horner
Contact: JeraldHorner@StructuredSys.com

Customer Orders Summary:
========================
CUST009 Homer Simpson ORD-2024-010
  Date:2024-04-28 Stat:O Items:2
  Total: $999.98
  1. BIKE001 Mountain Bike
     Cat:Sports & Outdoo Qty:1
     Price:$899.99 Total:$899.99
  2. TOY001 Educational Building Set
     Cat:Toys & Games Qty:1  
     Price:$89.99 Total:$89.99
---
Total orders displayed: 10
```

### DEMOCTE Output
```
DEMOCTE - Customer Summary with CTE
Single CTE Demo - Jerald Horner
Contact: JeraldHorner@StructuredSys.com

Customer Summary Report (CTE Demo):
=================================

CUST004 Betty Boop Type:W
  Orders:1 Total:$3694.55
  Last Order: 2024-03-18
---
CUST002 Bugs Bunny Type:B  
  Orders:1 Total:$2495.96
  Last Order: 2024-03-05
---
CUST010 Porky Pig Type:R
  Orders:0 Total:$0.00
  Last Order: Never
---
Total customers: 10

CTE Concepts Demonstrated:
- Common Table Expression (WITH clause)
- LEFT JOIN to include all customers
- GROUP BY aggregation
- COALESCE for NULL handling
- String concatenation in CTE
```

## Learning Objectives

1. **Basic Sql Integration:** Understand embedded Sql in RPG
2. **Cursor Management:** Learn proper cursor lifecycle management
3. **Multi-Table Joins:** Master complex relational queries
4. **Common Table Expressions:** Use CTEs for data aggregation and analysis
5. **Error Handling:** Implement robust SqlSTATE checking
6. **String Operations:** Safe string manipulation techniques
7. **Modern RPG:** Apply current RPG Free Format best practices

## Troubleshooting

### Common Issues
- **Sql0312 errors:** Check data structure field definitions match Sql column names
- **RNX0100 errors:** Ensure %subst() uses %min() for length parameters
- **Compilation failures:** Verify using CRTSQLRPGI not CRTBNDRPG for Sql programs

### Support
For questions or issues with these training materials, contact:
Jerald Horner - JeraldHorner@StructuredSys.com

## License
These programs are provided for educational and training purposes.