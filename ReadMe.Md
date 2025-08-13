# IBM i Code Samples

Practical, working examples for modern IBM i development. Real code that runs on IBM i systems with complete setup instructions.

**Author:** Jerald Horner  
**Email:** JeraldHorner@StructuredSys.Com  
**Phone:** 214-704-6178

---

## Quick Overview (TL;DR)

**Purpose:** Working IBM i code examples for SQL, RPG Free, and system integration  
**Target:** IBM i developers at all skill levels  
**Format:** Complete, runnable code with setup documentation  
**Platform:** IBM i V7R3+ (compatibility notes provided)

**How to use:** Pick a directory, follow its README, update library names, and run the code.

---

## Repository Contents

### **Current Examples**

| Directory | Description | Skill Level |
|-----------|-------------|-------------|
| **[AllDataTypesTable](./AllDataTypesTable/)** | CREATE TABLE and INSERT examples with common IBM i SQL data types | Beginner |
| **[Demo Tables For Training](./Demo%20Tables%20For%20Training/)** | Complete 5-table business system with relationships, sample data, and journaling | Intermediate |
| **[StoredProcReadInRPG](./StoredProcReadInRPG/)** | Creating SQL stored procedures and calling them from RPG Free programs | Intermediate |
| **CursorProcessing** |(.CursorProcessing/)** | SQL cursors, fetch loops, and positioned updates | Intermediate |

### **Planned Examples**

| Directory | Description | Status |
|-----------|-------------|---------|
| **EmbeddedSQLExamples** | Basic embedded SQL in RPG programs | Coming Soon |
| **JSONandXMLProcessing** | Modern data format handling in IBM i | Coming Soon |
| **DynamicSQLTechniques** | Runtime SQL generation and execution | Coming Soon |
| **ReportingExamples** | SQL-based reporting and analytics | Coming Soon |
| **PerformanceOptimization** | Indexing, query tuning, and performance tips | Coming Soon |
| **DataValidationTechniques** | SQL patterns for data quality and validation | Coming Soon |
| **ModernizationPatterns** | Updating legacy code with modern techniques | Coming Soon |
| **UtilityScripts** | Helpful CL and SQL utilities for development | Coming Soon |

## Getting Started

### **Prerequisites**
- **IBM i system** with SQL support (V7R3 or higher recommended)
- **Development tools:** VS Code with IBM i extensions or traditional IBM i tools
- **Authority** to create libraries and database objects
- **Basic knowledge** of SQL and RPG concepts

### **Quick Start Steps**
1. **Browse the directories** above and pick an example that interests you
2. **Read the README** in that directory for specific setup instructions  
3. **Create your library:** Most examples use `MYLIBRARY` or `JHORNER21` - create it or substitute your own
4. **Update library names** in the code files as needed
5. **Run the examples** using STRSQL, RUNSQLSTM, or your preferred tools
6. **Experiment and modify** - all code is designed to be educational

## Repository Structure

```
IBM-i-Code-Samples/
├── README.md                           # This file - main overview
├── AllDataTypesTable/                  # SQL data types demonstration
│   ├── README.md
│   ├── allfields.txt
│   └── allfieldsi.txt
├── Demo Tables For Training/           # Complete business system example
│   ├── ReadMe.md
│   ├── demofiles.txt                   # DDL script for tables
│   ├── demoinsert.txt                  # Sample data inserts
│   └── demojrn.clp                     # Journaling setup CLP
├── StoredProcReadInRPG/               # Stored procedures with RPG
│   └── README.md
├── EmbeddedSQLExamples/               # Coming soon
├── CursorProcessing/                  # Coming soon
├── JSONandXMLProcessing/              # Coming soon
├── DynamicSQLTechniques/              # Coming soon
├── ReportingExamples/                 # Coming soon
├── PerformanceOptimization/           # Coming soon
├── DataValidationTechniques/          # Coming soon
├── ModernizationPatterns/             # Coming soon
└── UtilityScripts/                    # Coming soon
```

## Featured Examples

### 📊 **AllDataTypesTable**
**What it does:** Demonstrates most common IBM i SQL data types in a single table with working sample data.

**Files:**
- `README.md` - Setup instructions and documentation
- `allfields.txt` - CREATE TABLE script with all data types
- `allfieldsi.txt` - INSERT statements with sample data

**Includes:**
- Complete CREATE TABLE with CHAR, VARCHAR, INTEGER, DECIMAL, DATE, TIMESTAMP, BINARY, XML, BOOLEAN
- INSERT statements with proper IBM i syntax
- CAST functions for binary data, XML parsing, and date handling

**Perfect for:** Learning IBM i data types, testing applications, training materials

### 🏢 **Demo Tables For Training**
**What it does:** Complete order management business system with 5 related tables, realistic sample data, and automated journaling setup.

**Files:**
- `ReadMe.md` - Complete setup and usage documentation
- `demofiles.txt` - DDL script creating all 5 tables with relationships
- `demoinsert.txt` - Sample data inserts (53 records, formatted for QSQLSRC width)
- `demojrn.clp` - CLP program for automated journaling setup

**Database Schema:**
- **CATEGORIES** - Product category lookup table
- **CUSTOMERS** - Customer master information  
- **PRODUCTS** - Product catalog with inventory
- **ORDERS** - Order header information
- **ORDERITEMS** - Order line item details

**Key Features:**
- ✅ **5 related tables** with proper foreign key relationships
- ✅ **53 sample records** using cartoon characters (obviously fake PII)
- ✅ **Automated journaling** setup with CLP program
- ✅ **IBM i optimized** - all names ≤10 characters, QSQLSRC width compatible
- ✅ **Business scenarios** - orders, inventory, customers, products

**Perfect for:** Learning table relationships, practicing complex JOINs, understanding business database design, journaling concepts

### 🔄 **StoredProcReadInRPG**  
**What it does:** Shows how to create SQL stored procedures and call them from RPG Free format programs.

**Files:**
- `README.md` - Setup instructions and examples

**Includes:**
- SQL stored procedure that returns sample customer data
- RPG Free program using embedded SQL to call the procedure
- Result set processing with cursors and fetch loops

**Perfect for:** Understanding stored procedure integration, learning embedded SQL patterns

## Development Environment

### **Recommended Tools**
- **VS Code** with IBM i Development Pack
- **IBM i Access Client Solutions (ACS)**
- **STRSQL** for interactive testing
- **RUNSQLSTM** for script execution

### **Code Standards**
- **Library naming:** Examples use `MYLIBRARY` or `JHORNER21` - update to your library
- **Source types:** SQL scripts, SQLRPGLE programs, CL procedures as appropriate
- **Comments:** All code includes explanatory comments and headers
- **IBM i syntax:** Uses proper IBM i SQL dialect and conventions

## IBM i Compatibility

### **Version Requirements**
- **V7R3 or higher:** Recommended for all examples
- **V7R2:** Most examples work with noted exceptions
- **Earlier versions:** Some modern features may not be available

### **Feature Notes**
- **BOOLEAN data type:** V7R1+ (alternatives provided for older versions)
- **JSON functions:** V7R2+ 
- **Advanced SQL features:** V7R3+ recommended
- **Journaling:** All versions support basic journaling features
- **Compatibility notes:** Included in individual example READMEs

## Learning Path Recommendations

### **For Beginners:**
1. Start with **AllDataTypesTable** to understand IBM i SQL basics
2. Move to **Demo Tables For Training** for table relationships and business logic
3. Try **EmbeddedSQLExamples** (when available) for RPG integration
4. Explore the journaling features in **Demo Tables For Training**

### **For Intermediate Developers:**
1. **Demo Tables For Training** for complex database design patterns
2. **StoredProcReadInRPG** for advanced procedure techniques
3. **CursorProcessing** (when available) for complex data handling
4. **DynamicSQLTechniques** for flexible applications
5. **PerformanceOptimization** for production readiness

### **For Advanced Developers:**
1. **JSONandXMLProcessing** for modern data integration
2. **ModernizationPatterns** for legacy system updates
3. **ReportingExamples** for business intelligence
4. **UtilityScripts** for development automation

### **Training-Focused Path:**
1. **AllDataTypesTable** → **Demo Tables For Training** → **StoredProcReadInRPG**
2. Use **Demo Tables For Training** for practicing:
   - Complex JOINs across multiple tables
   - CTEs for customer analysis and reporting
   - UPDATE scenarios for inventory management
   - Journaling and data recovery concepts

## Contributing and Usage

### **Educational Purpose**
These examples are designed for learning and reference. Feel free to:
- **Use in your projects** - modify and adapt as needed
- **Share with colleagues** - all code is freely usable
- **Suggest improvements** - feedback welcome
- **Request examples** - let me know what you'd like to see

### **Code Quality Standards**
All examples strive to be:
- **Complete and runnable** - no pseudo-code or placeholders
- **Well-documented** - clear comments and setup instructions
- **Practical** - based on real-world development needs
- **Modern** - using current IBM i best practices

### **Privacy Compliance**
- **Demo Tables For Training** uses cartoon characters for all PII data
- Safe for training, demos, and development environments
- Meets privacy requirements for sample data

## Resources and References

### **IBM Documentation**
- [IBM i SQL Reference](https://www.ibm.com/docs/en/i/7.4?topic=reference-sql)
- [RPG Language Reference](https://www.ibm.com/docs/en/i/7.4?topic=languages-rpg)
- [Embedded SQL Programming](https://www.ibm.com/docs/en/i/7.4?topic=programming-embedded-sql)
- [Journaling Guide](https://www.ibm.com/docs/en/i/7.4?topic=management-journaling)

### **Development Tools**
- [VS Code IBM i Extensions](https://marketplace.visualstudio.com/items?itemName=halcyontechltd.code-for-ibmi)
- [IBM i Access Client Solutions](https://www.ibm.com/support/pages/ibm-i-access-client-solutions)

### **Community**
- IBM i Open Source Community
- RPG & DB2 Summit
- Local IBM i User Groups

## Contact and Support

**Questions?** Feel free to reach out:
- **Email:** JeraldHorner@StructuredSys.Com
- **Phone:** 214-704-6178

**Found an issue?** Check the individual example's README for troubleshooting tips.

---

**Repository Status:** Active development - new examples added regularly  
**Last Updated:** January 2025  
**IBM i Compatibility:** V7R3+ (notes provided for earlier versions)
