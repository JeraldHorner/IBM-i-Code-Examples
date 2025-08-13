# DEMOCURSOR - SQL Cursor Processing with NULL Handling

A comprehensive RPG Free training program that demonstrates embedded SQL cursor processing and proper NULL data handling techniques.

**Author:** Jerald Horner  
**Email:** JeraldHorner@StructuredSys.Com  
**Phone:** 214-704-6178

---

## 📋 Program Overview

**DEMOCURSOR** is an educational RPG Free program designed to teach two critical IBM i development concepts:
1. **SQL Cursor Processing** - How to read and process data from database tables using embedded SQL cursors
2. **NULL Data Handling** - How to properly handle NULL values using indicator variables to prevent SQLSTATE 22002 errors

## 🎯 Training Objectives

After studying and running this program, developers will understand:

### **SQL Cursor Fundamentals**
- ✅ How to declare a cursor with `DECLARE CURSOR FOR`
- ✅ How to open, fetch from, and close cursors properly
- ✅ How to process multiple rows using `DOW` loops
- ✅ How to check `SQLSTATE` for successful operations
- ✅ Proper cursor lifecycle management

### **NULL Handling Techniques** 
- ✅ What SQLSTATE 22002 means and how to prevent it
- ✅ How to declare and use indicator variables
- ✅ How to test for NULL values using indicator variables
- ✅ How to display meaningful messages when data is NULL
- ✅ Best practices for defensive programming with database nulls

## 🏗️ Program Structure

### **Data Declarations**
```rpg
// Main customer data fields
dcl-s CustomerID         int(10);
dcl-s FirstName          varchar(30);
dcl-s CompanyName        varchar(60);
// ... etc

// Indicator variables for NULL detection
dcl-s ind_CompanyName    int(5);
dcl-s ind_EmailAddress   int(5);
// ... one indicator for each nullable field
```

### **Cursor Processing Pattern**
```rpg
// 1. Declare cursor
DECLARE CustomerCursor CURSOR FOR SELECT...

// 2. Open cursor
OPEN CustomerCursor;

// 3. Fetch first record
FETCH CustomerCursor INTO :variables :indicators

// 4. Process loop
dow SQLSTATE = '00000';
    // Process current record
    // Fetch next record
enddo;

// 5. Close cursor
CLOSE CustomerCursor;
```

### **NULL Handling Pattern**
```rpg
// Check indicator before using data
if ind_CompanyName >= 0 and CompanyName <> *blanks;
    // Safe to use CompanyName - it's not NULL
    dspMsg = 'Company: ' + %trim(CompanyName);
else;
    // Handle NULL case appropriately
    dspMsg = 'Company: (Not specified)';
endif;
```

## 📊 Expected Output

When you run `CALL JHORNER21/DEMOCURSOR`, you'll see output similar to this:

```
1: Acme Corporation
   (Bugs Bunny)
   Phone: 972-555-0102
   Email: bugsbunny@MySundayMorningCartoons.com
   Type: Business (Active)
   Credit: $15000.00
   Balance: $2250.75
   ----------------------------

2: Mickey
       Mouse
   Phone: 214-555-0101
   Email: mickeymouse@MySundayMorningCartoons.com
   Type: Retail (Active)
   Credit: $5000.00
   Balance: $0.00
   ----------------------------

3: Donald
       Duck
   Phone: 469-555-0103
   Email: donaldduck@MySundayMorningCartoons.com
   Type: Retail (Active)
   Credit: $7500.00
   Balance: $0.00
   ----------------------------

... (continues for all customers)

Total customers processed: 10
```

## 🔍 Key Learning Points in Output

### **Customer Display Variations**
- **Business customers:** Show company name with personal name in parentheses
- **Individual customers:** Show first and last name on separate lines
- **Contact information:** Only displays if not NULL
- **Email truncation:** Long emails are truncated to fit display width

### **NULL Handling Examples**
- **Missing company names:** Program handles gracefully without errors
- **Missing contact info:** Skips display rather than showing blanks
- **Credit information:** Shows "(NULL)" when database contains NULL values

### **Data Type Demonstrations**
- **Numeric formatting:** Currency amounts displayed with $ symbol
- **Character data:** Proper trimming and concatenation
- **Status indicators:** Readable text for coded values (R=Retail, B=Business, etc.)

## 🚀 Setup Instructions

### **Prerequisites**
- IBM i system with SQL support (V7R3+ recommended)
- CUSTOMERS table from "Demo Tables For Training" must exist
- Authority to create programs in JHORNER21 library

### **Installation Steps**

#### 1. Create Source Member
```
WRKMBRPDM FILE(JHORNER21/QRPGLESRC)
```
- Add member: **DEMOCURSOR**
- Copy the program source into this member

#### 2. Compile Program
```
CRTSQLRPGI PGM(JHORNER21/DEMOCURSOR) SRCFILE(JHORNER21/QRPGLESRC)
```

#### 3. Run Program
```
CALL JHORNER21/DEMOCURSOR
```

## 🔧 Technical Requirements

### **Compilation Settings**
- **Source Type:** SQLRPGLE (SQL RPG Free format)
- **SQL Precompiler:** Must be enabled (automatic with CRTSQLRPGI)
- **Target Release:** V7R3 or higher recommended

### **Dependencies**
- **JHORNER21.CUSTOMERS table** must exist and contain sample data
- **Library JHORNER21** must be in library list or fully qualified

### **Authority Requirements**
- **Read access** to CUSTOMERS table
- **Execute authority** for the program

## 📚 Educational Concepts Demonstrated

### **1. Embedded SQL Best Practices**
- Proper cursor declaration and management
- Error checking with SQLSTATE
- Clean separation of SQL and RPG logic
- Efficient single-pass data processing

### **2. NULL Handling Strategies**
- **Prevention:** Using indicator variables prevents runtime errors
- **Detection:** Testing indicator values before using data
- **User Experience:** Displaying meaningful messages for missing data
- **Defensive Programming:** Assume any field might be NULL

### **3. RPG Free Format Techniques**
- Modern variable declarations with proper typing
- Clean program structure and organization
- Efficient string handling and concatenation
- Display formatting within source width constraints

### **4. Real-World Application Patterns**
- Reading customer data for reports
- Processing variable-length result sets
- Handling mixed data scenarios (business vs. individual customers)
- Formatting data for user-friendly display

## 🐛 Common Issues and Solutions

### **SQLSTATE 22002 Error**
**Problem:** "Data exception - Null value, no indicator parameter"  
**Solution:** This program demonstrates the proper fix using indicator variables

### **Compilation Errors**
**Problem:** Source line too long  
**Solution:** Program is formatted for 80-character width compatibility

### **No Output Displayed**
**Problem:** CUSTOMERS table is empty or doesn't exist  
**Solution:** Run the sample data insert scripts from "Demo Tables For Training"

### **Permission Errors**
**Problem:** Cannot read CUSTOMERS table  
**Solution:** Ensure library is in library list and user has read authority

## 🎓 Next Steps

After mastering this program, consider these advanced topics:

### **Enhanced Cursor Techniques**
- **Scrollable cursors** for bidirectional navigation
- **Positioned updates** using `WHERE CURRENT OF`
- **Multiple cursor management** in single programs
- **Dynamic SQL** with variable WHERE clauses

### **Advanced NULL Handling**
- **COALESCE** functions for default values
- **CASE statements** for complex NULL logic
- **Stored procedures** with NULL parameter handling
- **JSON parsing** with optional fields

### **Performance Optimization**
- **Index usage** for cursor performance
- **Fetch optimization** for large result sets
- **Memory management** for long-running processes
- **Commitment control** with cursor operations

## 📞 Support and Questions

**Questions about this program?**
- **Email:** JeraldHorner@StructuredSys.Com
- **Phone:** 214-704-6178

**Found an issue?**
- Check that sample data is loaded properly
- Verify compilation settings match requirements
- Ensure proper authorities are granted

---

**Program Status:** Production ready for training use  
**Last Updated:** January 2025  
**Compatibility:** IBM i V7R3+