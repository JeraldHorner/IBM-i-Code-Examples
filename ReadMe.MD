# IBM i RPG Free Format SQL Demo Programs

Training examples demonstrating modern RPG Free Format programming with embedded SQL on IBM i (AS/400, iSeries, Power i) platform.

## Author
**Jerald Horner**  
Email: JeraldHorner@StructuredSys.com  
Phone: 214-704-6178  

## Purpose
Educational demonstrations of RPG Free Format with embedded SQL for training purposes. These programs showcase best practices for IBM i development including proper error handling, multi-table joins, and modern RPG techniques.

## Programs Included

### DEMOCAT - Basic SQL with Single Table
- **Description:** Displays CATEGORIES table data using embedded SQL cursor
- **Features:** Basic SQL SELECT, cursor processing, error handling
- **Tables Used:** CATEGORIES
- **Compile:** CRTSQLRPGI

### DEMOJOIN - Complex Multi-Table Joins  
- **Description:** Customer order details with 5-table joins
- **Features:** Complex joins, GROUP BY, calculated fields, hierarchical display
- **Tables Used:** CUSTOMERS → ORDERS → ORDERITEMS → PRODUCTS → CATEGORIES
- **Compile:** CRTSQLRPGI

### Companion CL Programs
- **DEMOCATCL:** Compiles and runs DEMOCAT
- **DEMOJOINCL:** Compiles and runs DEMOJOIN

## Prerequisites

### System Requirements
- IBM i V7R5M0 or higher
- SQL preprocessor installed
- Library JHORNER21 exists

### Database Setup
The programs require these tables in library JHORNER21:
- CATEGORIES (product categories)
- CUSTOMERS (customer master)  
- PRODUCTS (product catalog)
- ORDERS (order headers)
- ORDERITEMS (order line items)

Create tables using the SQL scripts:
- `demofiles.txt` - Table creation DDL
- `demoinsert.txt` - Sample data inserts

## Installation & Compilation

### 1. Create Source Members
```
WRKMBRPDM JHORNER21/QRPGLESRC
  Add: DEMOCAT (Type: SQLRPGLE)
  Add: DEMOJOIN (Type: SQLRPGLE)

WRKMBRPDM JHORNER21/QCLSRC  
  Add: DEMOCATCL (Type: CLLE)
  Add: DEMOJOINCL (Type: CLLE)
```

### 2. Compile CL Programs
```
CRTCLPGM PGM(JHORNER21/DEMOCATCL) SRCFILE(JHORNER21/QCLSRC)
CRTCLPGM PGM(JHORNER21/DEMOJOINCL) SRCFILE(JHORNER21/QCLSRC)
```

### 3. Compile and Run
```
// Automatic compilation and execution
CALL JHORNER21/DEMOCATCL
CALL JHORNER21/DEMOJOINCL

// Manual compilation  
CRTSQLRPGI OBJ(JHORNER21/DEMOCAT) SRCFILE(JHORNER21/QRPGLESRC) 
           SRCMBR(DEMOCAT) OBJTYPE(*PGM) COMMIT(*NONE) DBGVIEW(*SOURCE)

CRTSQLRPGI OBJ(JHORNER21/DEMOJOIN) SRCFILE(JHORNER21/QRPGLESRC)
           SRCMBR(DEMOJOIN) OBJTYPE(*PGM) COMMIT(*NONE) DBGVIEW(*SOURCE)
```

## Key Features Demonstrated

### Modern RPG Techniques
- **FREE directive for fully free-format source
- Control specifications with modern options
- Qualified data structures
- Procedure-based programming
- Proper error handling with SQLSTATE

### Embedded SQL Best Practices
- Cursor declaration and processing
- Host variable usage with qualified names
- Multi-table joins with INNER JOIN syntax
- GROUP BY with aggregate functions
- Parameterized procedures for reusability

### IBM i Compliance
- Object names limited to 10 characters
- DSPLY output limited to 52 characters
- String operations using %min() to prevent RNX0100 errors
- Proper compilation with CRTSQLRPGI for SQL preprocessing

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

## Learning Objectives

1. **Basic SQL Integration:** Understand embedded SQL in RPG
2. **Cursor Management:** Learn proper cursor lifecycle management
3. **Multi-Table Joins:** Master complex relational queries
4. **Error Handling:** Implement robust SQLSTATE checking
5. **String Operations:** Safe string manipulation techniques
6. **Modern RPG:** Apply current RPG Free Format best practices

## Troubleshooting

### Common Issues
- **SQL0312 errors:** Check data structure field definitions match SQL column names
- **RNX0100 errors:** Ensure %subst() uses %min() for length parameters
- **Compilation failures:** Verify using CRTSQLRPGI not CRTBNDRPG for SQL programs

### Support
For questions or issues with these training materials, contact:
Jerald Horner - JeraldHorner@StructuredSys.com

## License
These programs are provided for educational and training purposes.