**FREE
ctl-opt dftactgrp(*no) actgrp(*caller) option(*srcstmt);

//********************************************************************
// Program:   SP_GETSAMP
// Purpose:   Demonstrate how to call a stored procedure in embedded
//            SQL from an RPG Free Format program and fetch the
//            returned result set.
//
// Author:    Jerald Horner
// Company:   Structured Systems
// Contact:   JeraldHorner@StructuredSys.com | 214-704-6178
//
// Description:
//   - This program calls a stored procedure that returns a result set.
//   - It uses embedded SQL to:
//       * Call the procedure
//       * Associate the result set locator
//       * Allocate a cursor for the result set
//       * Fetch rows into a data structure
//       * Close the cursor when done
//
// IBM i Requirements:
//   - Compile type: SQLRPGLE
//   - SQL precompiler must be enabled
//   - The procedure must be defined and return at least one result set
//   - Target release: V7R3 or higher
//
//********************************************************************

dcl-s CustomerID        packed(7: 0);
dcl-s FirstName         varchar(50);
dcl-s LastName          varchar(50);

dcl-s MySetLocator      SQLType(Result_Set_Locator);
dcl-s DspMsg            varchar(50);

exec sql
    Call SP_GetSampleData;

Exec SQL
    ASSOCIATE RESULT SET LOCATORS (:MySetLocator)
        WITH PROCEDURE SP_GetSampleData;

Exec SQL
    ALLOCATE MyCursor CURSOR
    FOR RESULT SET :MySetLocator;

Exec SQL
    fetch MyCursor into
        : CustomerID ,
        : FirstName  ,
        : LastName;

Dow SQLSTATE ='00000';

    Dsply   ('CustomerID: ' + %Char(CustomerID));

    Exec SQL
        fetch MyCursor into
            : CustomerID ,
            : FirstName  ,
        :    LastName;

EndDo;

Exec SQL
    CLOSE MyCursor;

*inlr = *on;
return;
