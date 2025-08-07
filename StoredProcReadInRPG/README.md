# Stored Procedure Read in RPG Example

Complete example of creating SQL stored procedures and calling them from RPG Free format programs using embedded SQL.

**Author:** Jerald Horner  
**Email:** JeraldHorner@StructuredSys.Com  
**Phone:** 214-704-6178

---

## Veteran Instructions (TL;DR)

**Quick Setup:**
1. **Create stored procedure:** Run `sp_getsamp.txt` via `RUNSQLSTM` 
2. **Compile RPG program:** Compile `spexample1.sqlrpgle` using `CRTSQLRPGI`
3. **Update libraries:** Change `JHORNER21` to `MYLIBRARY` in both files
4. **Test:** `CALL MYLIBRARY/SPEXAMPLE1` and check job log for customer IDs

**What it demonstrates:** SQL stored procedure returning sample customer data + RPG Free program using embedded SQL to call the procedure, associate result sets, allocate cursors, and fetch data in a loop.

**Files:** `sp_getsamp.txt` (stored procedure), `spexample1.sqlrpgle` (RPG caller program)

---

## Detailed Information

### Files Included

| File | Description |
|------|-------------|
| `sp_getsamp.txt` | SQL source to create the stored procedure `SP_GetSampleData` |
| `spexample1.sqlrpgle` | RPG Free format program demonstrating stored procedure calls |

### What This Example Demonstrates

#### **SQL Stored Procedure Concepts**
- Creating procedures that return result sets
- Using `VALUES` clause to generate sample data
- Cursor management with `DECLARE...WITH RETURN`
- Granting execute permissions

#### **RPG Embedded SQL Concepts**  
- Calling stored procedures from RPG
- Working with result set locators
- Allocating cursors for result sets
- Fetch loops with `SQLSTATE` checking
- Proper cursor cleanup

### Architecture Overview

```
┌─────────────────┐    CALL     ┌────────────────────┐
│                 │ ----------> │                    │
│ RPG Program     │             │ SQL Stored         │
│ (spexample1)    │             │ Procedure          │
│                 │ <---------- │ (SP_GetSampleData) │
└─────────────────┘  Result Set └────────────────────┘
                                          │
                                          ▼
                                  ┌──────────────┐
                                  │ Sample Data  │
                                  │ CustomerID   │
                                  │ FirstName    │  
                                  │ LastName     │
                                  └──────────────┘
```

### Setup Instructions

#### **Step 1: Create Your Library**
```
CRTLIB LIB(MYLIBRARY) TEXT('Training Library')
```

#### **Step 2: Create the Stored Procedure**
1. **Edit `sp_getsamp.txt`** - Change `JHORNER21` to `MYLIBRARY`
2. **Create the procedure:**
   ```
   RUNSQLSTM SRCFILE(MYLIBRARY/QSQLSRC) SRCMBR(SP_GETSAMP)
   ```
   **Alternative:** Copy/paste content into STRSQL session

#### **Step 3: Compile the RPG Program**
1. **Edit `spexample1.sqlrpgle`** - Update procedure call to use `MYLIBRARY.SP_GetSampleData`
2. **Save to source member:** `MYLIBRARY/QRPGLESRC(SPEXAMPLE1)`
3. **Compile the program:**
   ```
   CRTSQLRPGI OBJ(MYLIBRARY/SPEXAMPLE1) SRCFILE(MYLIBRARY/QRPGLESRC) SRCMBR(SPEXAMPLE1)
   ```

#### **Step 4: Test the Integration**
```
CALL MYLIBRARY/SPEXAMPLE1
```

Check the job log (`DSPJOBLOG`) for output showing customer IDs.

### Code Walkthrough

#### **Stored Procedure (`sp_getsamp.txt`)**

**Key Components:**
```sql
CREATE PROCEDURE JHORNER21.SP_GetSampleData()
    LANGUAGE SQL
    READS SQL DATA
    RESULT SETS 1

BEGIN
    DECLARE C1 CURSOR WITH RETURN FOR
        SELECT CustomerID, CustomerFirstName, CustomerLastName
        FROM (VALUES
            (1001, 'John', 'Smith'),
            (1002, 'Jane', 'Johnson'),
            -- ... more sample data
        ) AS SampleData(CustomerID, CustomerFirstName, CustomerLastName);
    
    OPEN C1;
END;
```

**Features:**
- **`RESULT SETS 1`** - Declares it returns one result set
- **`WITH RETURN`** - Makes cursor returnable to caller
- **`VALUES` clause** - Generates sample data without tables
- **`GRANT EXECUTE`** - Allows other programs to call it

#### **RPG Program (`spexample1.sqlrpgle`)**

**Key SQL Statements:**
```rpg
// 1. Call the stored procedure
exec sql
    Call SP_GetSampleData;

// 2. Associate the result set with a locator
Exec SQL
    ASSOCIATE RESULT SET LOCATORS (:MySetLocator)
        WITH PROCEDURE SP_GetSampleData;

// 3. Allocate a cursor for the result set
Exec SQL
    ALLOCATE MyCursor CURSOR
    FOR RESULT SET :MySetLocator;

// 4. Fetch data in a loop
Exec SQL
    fetch MyCursor into :CustomerID, :FirstName, :LastName;

Dow SQLSTATE = '00000';
    // Process the data
    Dsply ('CustomerID: ' + %Char(CustomerID));
    
    // Fetch next row
    Exec SQL
        fetch MyCursor into :CustomerID, :FirstName, :LastName;
EndDo;

// 5. Clean up
Exec SQL
    CLOSE MyCursor;
```

### Expected Output

When you run `CALL MYLIBRARY/SPEXAMPLE1`, you should see output like:
```
CustomerID: 1001
CustomerID: 1002
CustomerID: 1003
CustomerID: 1004
CustomerID: 1005
CustomerID: 1006
CustomerID: 1007
CustomerID: 1008
CustomerID: 1009
CustomerID: 1010
```

### Key Learning Points

#### **Result Set Locators**
- **Purpose:** Bridge between stored procedure result sets and RPG program
- **Type:** `SQLType(Result_Set_Locator)`
- **Usage:** Associated with procedure, then used to allocate cursor

#### **Cursor Management**
- **ALLOCATE:** Creates cursor from result set locator
- **FETCH:** Retrieves rows one at a time
- **CLOSE:** Releases cursor resources

#### **SQLSTATE Checking**
- **'00000':** Successful operation
- **'02000':** No more data (end of result set)
- **Other values:** Various SQL errors

### Customization Examples

#### **Modify the Stored Procedure**
```sql
-- Add parameters
CREATE PROCEDURE MYLIBRARY.SP_GetSampleData(
    IN CustomerIDStart INT,
    IN MaxRows INT
)

-- Add WHERE clause
SELECT CustomerID, CustomerFirstName, CustomerLastName
FROM (VALUES...) AS SampleData(CustomerID, CustomerFirstName, CustomerLastName)
WHERE CustomerID >= CustomerIDStart
FETCH FIRST MaxRows ROWS ONLY;
```

#### **Enhanced RPG Processing**
```rpg
// Process all three fields
Dow SQLSTATE = '00000';
    Dsply ('Customer: ' + %Trim(FirstName) + ' ' + %Trim(LastName) + 
           ' (ID: ' + %Char(CustomerID) + ')');
    
    Exec SQL
        fetch MyCursor into :CustomerID, :FirstName, :LastName;
EndDo;
```

### Troubleshooting

#### **Common Issues**

**Stored Procedure Not Found:**
- Verify procedure was created successfully: `WRKOBJ MYLIBRARY/*ALL *SQLPKG`
- Check library name in RPG call matches creation library

**SQLSTATE Errors in RPG:**
```rpg
// Add error checking
Exec SQL
    Call MYLIBRARY.SP_GetSampleData;

If SQLSTATE <> '00000';
    Dsply ('SQL Error: ' + SQLSTATE);
    Return;
EndIf;
```

**Compilation Errors:**
- Ensure source type is `SQLRPGLE`
- Verify embedded SQL syntax (semicolons, etc.)
- Check for proper variable declarations

**Authority Issues:**
```sql
-- Grant execute permission if needed
GRANT EXECUTE ON PROCEDURE MYLIBRARY.SP_GetSampleData TO USER(username);
```

#### **Debug Tips**

**Test Procedure Independently:**
```sql
-- In STRSQL
CALL MYLIBRARY.SP_GetSampleData;
```

**Add Debug to RPG:**
```rpg
// Display SQLSTATE after each operation
Dsply ('After CALL: ' + SQLSTATE);
Dsply ('After ASSOCIATE: ' + SQLSTATE);
Dsply ('After ALLOCATE: ' + SQLSTATE);
```

### Advanced Techniques

#### **Multiple Result Sets**
```sql
-- Stored procedure with multiple result sets
RESULT SETS 2

DECLARE C1 CURSOR WITH RETURN FOR SELECT...;
DECLARE C2 CURSOR WITH RETURN FOR SELECT...;
OPEN C1;
OPEN C2;
```

#### **Error Handling in Procedures**
```sql
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
BEGIN
    -- Error handling logic
END;
```

#### **Dynamic Result Sets**
```sql
-- Build SQL dynamically based on parameters
SET SQLString = 'SELECT * FROM MYTABLE WHERE FIELD = ' + InputParm;
PREPARE Statement FROM SQLString;
DECLARE C1 CURSOR WITH RETURN FOR Statement;
```

### Use Cases

This pattern is perfect for:

- **Data retrieval** from complex queries
- **Business logic encapsulation** in stored procedures  
- **Performance optimization** - compile once, call many times
- **Code reusability** - multiple programs can call same procedure
- **Security** - grant execute without table access
- **Legacy integration** - modern SQL with traditional RPG

### Related Examples

After mastering this example, consider:
- **Parameters** - Pass values to stored procedures
- **Output parameters** - Return single values
- **Error handling** - Robust exception management
- **Transaction control** - Commit/rollback in procedures
- **Dynamic SQL** - Build queries at runtime

### Cleanup

To remove the example:
```sql
DROP PROCEDURE MYLIBRARY.SP_GetSampleData;
DLTPGM PGM(MYLIBRARY/SPEXAMPLE1);
```

---

This example provides the foundation for stored procedure development on IBM i. The combination of SQL procedures with RPG programs offers powerful capabilities for modern IBM i applications.
