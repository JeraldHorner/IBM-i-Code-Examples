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
| **[StoredProcReadInRPG](./StoredProcReadInRPG/)** | Creating SQL stored procedures and calling them from RPG Free programs | Intermediate |

### **Planned Examples**

| Directory | Description | Status |
|-----------|-------------|---------|
| **EmbeddedSQLExamples** | Basic embedded SQL in RPG programs | Coming Soon |
| **JournalingSetup** | Database journaling configuration and usage | Coming Soon |
| **CursorProcessing** | SQL cursors, fetch loops, and positioned updates | Coming Soon |
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
3. **Create your library:** Most examples use `MYLIBRARY` - create it or substitute your own
4. **Update library names** in the code files as needed
5. **Run the examples** using STRSQL, RUNSQLSTM, or your preferred tools
6. **Experiment and modify** - all code is designed to be educational

## Repository Structure

```
IBM-i-Code-Samples/
├── README.md                     # This file - main overview
├── AllDataTypesTable/            # SQL data types demonstration
├── StoredProcReadInRPG/         # Stored procedures with RPG
├── EmbeddedSQLExamples/         # Coming soon
├── JournalingSetup/             # Coming soon
├── CursorProcessing/            # Coming soon
├── JSONandXMLProcessing/        # Coming soon
├── DynamicSQLTechniques/        # Coming soon
├── ReportingExamples/           # Coming soon
├── PerformanceOptimization/     # Coming soon
├── DataValidationTechniques/    # Coming soon
├── ModernizationPatterns/       # Coming soon
└── UtilityScripts/              # Coming soon
```

## Featured Examples

### 📊 **AllDataTypesTable**
**What it does:** Demonstrates most common IBM i SQL data types in a single table with working sample data.

**Includes:**
- Complete CREATE TABLE with CHAR, VARCHAR, INTEGER, DECIMAL, DATE, TIMESTAMP, BINARY, XML, BOOLEAN
- INSERT statements with proper IBM i syntax
- CAST functions for binary data, XML parsing, and date handling

**Perfect for:** Learning IBM i data types, testing applications, training materials

### 🔄 **StoredProcReadInRPG**  
**What it does:** Shows how to create SQL stored procedures and call them from RPG Free format programs.

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
- **Compatibility notes:** Included in individual example READMEs

## Learning Path Recommendations

### **For Beginners:**
1. Start with **AllDataTypesTable** to understand IBM i SQL basics
2. Move to **EmbeddedSQLExamples** (when available) for RPG integration
3. Try **StoredProcReadInRPG** for procedure concepts
4. Explore **JournalingSetup** for database management

### **For Intermediate Developers:**
1. **StoredProcReadInRPG** for advanced procedure techniques
2. **CursorProcessing** for complex data handling
3. **DynamicSQLTechniques** for flexible applications
4. **PerformanceOptimization** for production readiness

### **For Advanced Developers:**
1. **JSONandXMLProcessing** for modern data integration
2. **ModernizationPatterns** for legacy system updates
3. **ReportingExamples** for business intelligence
4. **UtilityScripts** for development automation

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

## Resources and References

### **IBM Documentation**
- [IBM i SQL Reference](https://www.ibm.com/docs/en/i/7.4?topic=reference-sql)
- [RPG Language Reference](https://www.ibm.com/docs/en/i/7.4?topic=languages-rpg)
- [Embedded SQL Programming](https://www.ibm.com/docs/en/i/7.4?topic=programming-embedded-sql)

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
**IBM i Compatibility:** V7R3+ (notes provided for earlier versions)# IBM-i-Code-Examples
IBM i Code Samples
