**FREE
//***********************************************************
//* Program Name: DEMOCAT
//* Description:  Demo program to read and display CATEGORIES
//*               table data using embedded SQL
//* Library:      JHORNER21
//* Author:       Jerald Horner
//* Contact:      JeraldHorner@StructuredSys.com
//* Phone:        214-704-6178
//* Purpose:      Training demonstration of RPG Free Format
//*               with embedded SQL
//* Date Created: 2025-08-21
//*
//* Compile Instructions:
//*   CRTSQLRPGI OBJ(JHORNER21/DEMOCAT)
//*              SRCFILE(JHORNER21/QRPGLESRC)
//*              SRCMBR(DEMOCAT) OBJTYPE(*PGM)
//*              COMMIT(*NONE) DBGVIEW(*SOURCE)
//*
//* Or use companion CL program DEMOCATCL
//***********************************************************

// Control specifications - modern RPG options
ctl-opt dftactgrp(*no) actgrp(*new) main(main)
        option(*srcstmt : *nodebugio);

// Program constants
dcl-c PROGRAM_NAME 'DEMOCAT';
dcl-c SQL_SUCCESS '00000';
dcl-c SQL_NOT_FOUND '02000';
dcl-c MAX_DISPLAY_WIDTH 52;

// Category record structure for SQL operations
dcl-ds categoryRec qualified;
  categoryId packed(5:0);
  categoryCode char(10);
  categoryName char(50);
  description char(100);
  activeFlag char(1);
  createdDate date;
end-ds;
dcl-s displayLine char(52);
dcl-s recordCount int(10) inz(0);
dcl-s errorMsg char(50);

//***********************************************************
//* Main Procedure
//***********************************************************
dcl-proc main;

  // Display program header
  displayHeader();

  // Process categories
  processCategories();

  // Display completion message
  dsply 'Program DEMOCAT completed successfully.';

end-proc;

//***********************************************************
//* Procedure: displayHeader
//* Purpose: Display program identification and column headers
//***********************************************************
dcl-proc displayHeader;

  dsply ' ';
  dsply 'DEMOCAT - Categories Display Demo';
  dsply 'Training Program - Jerald Horner';
  dsply 'Contact: JeraldHorner@StructuredSys.com';
  dsply ' ';
  dsply 'ID   Code      Category Name';
  dsply '---- --------- -------------------------';

end-proc;

//***********************************************************
//* Procedure: processCategories
//* Purpose: Read and display category records using SQL cursor
//***********************************************************
dcl-proc processCategories;

  // Declare cursor for active categories
  exec sql DECLARE catCursor CURSOR FOR
           SELECT CATEGORY_ID, CATEGORY_CODE, CATEGORY_NAME,
                  DESCRIPTION, ACTIVE_FLAG, CREATED_DATE
           FROM JHORNER21.CATEGORIES
           WHERE ACTIVE_FLAG = 'Y'
           ORDER BY CATEGORY_CODE;

  // Open cursor
  exec sql OPEN catCursor;

  // Check for cursor open errors
  if SQLSTATE <> SQL_SUCCESS;
    errorMsg = 'Error opening cursor: ' + SQLSTATE;
    dsply errorMsg;
    return;
  endif;

  // Fetch first record
  exec sql FETCH catCursor INTO :categoryRec.categoryId,
                                :categoryRec.categoryCode,
                                :categoryRec.categoryName,
                                :categoryRec.description,
                                :categoryRec.activeFlag,
                                :categoryRec.createdDate;

  // Process all records
  dow SQLSTATE = SQL_SUCCESS;
    recordCount += 1;

    // Format display line (max 52 characters)
    displayLine = %editc(categoryRec.categoryId:'Z') + ' ' +
                  %subst(categoryRec.categoryCode + '         ':1:9) +
                  ' ' + %subst(categoryRec.categoryName:1:25);

    dsply displayLine;

    // Display description on separate line if present
    if %trim(categoryRec.description) <> '';
              displayLine = '     Desc: ' +
              %subst(%trim(categoryRec.description):1:
                     %min(42:%len(%trim(categoryRec.description))));
      dsply displayLine;
    endif;

    // Fetch next record
    exec sql FETCH catCursor INTO :categoryRec.categoryId,
                                  :categoryRec.categoryCode,
                                  :categoryRec.categoryName,
                                  :categoryRec.description,
                                  :categoryRec.activeFlag,
                                  :categoryRec.createdDate;
  enddo;

  // Check for fetch errors (not just end of data)
  if SQLSTATE <> SQL_NOT_FOUND;
    errorMsg = 'Error reading data: ' + SQLSTATE;
    dsply errorMsg;
  else;
    dsply ' ';
    displayLine = 'Total categories displayed: ' +
                  %char(recordCount);
    dsply displayLine;
  endif;

  // Close cursor and handle any errors
  exec sql CLOSE catCursor;

  if SQLSTATE <> SQL_SUCCESS;
    errorMsg = 'Error closing cursor: ' + SQLSTATE;
    dsply errorMsg;
  endif;

end-proc;

//***********************************************************
//* End of Program DEMOCAT
//***********************************************************
