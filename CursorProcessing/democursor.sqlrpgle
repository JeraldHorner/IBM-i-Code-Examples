**FREE
ctl-opt dftactgrp(*no) actgrp(*caller) option(*srcstmt);

//*******************************************************************
// Program:   DEMOCURSOR
// Purpose:   Demonstrate embedded SQL cursors in RPG Free Format
//            to read and process data from the CUSTOMERS table.
//
// Author:    Jerald Horner
// Company:   Structured Systems
// Contact:   JeraldHorner@StructuredSys.com | 214-704-6178
//
// Description:
//   - Demonstrates cursor processing with embedded SQL
//   - Uses embedded SQL to:
//       * Declare a cursor for the CUSTOMERS table
//       * Open the cursor
//       * Fetch rows with indicator variables for NULL handling
//       * Process each customer record
//       * Close the cursor when done
//
// IBM i Requirements:
//   - Compile type: SQLRPGLE
//   - SQL precompiler must be enabled
//   - CUSTOMERS table must exist in JHORNER21 library
//   - Target release: V7R3 or higher
//
// Usage:
//   CALL JHORNER21/DEMOCURSOR
//
//*******************************************************************

// === Customer field declarations ===
dcl-s CustomerID         int(10);
dcl-s CustomerCode       char(10);
dcl-s FirstName          varchar(30);
dcl-s LastName           varchar(40);
dcl-s CompanyName        varchar(60);
dcl-s EmailAddress       varchar(80);
dcl-s PhoneNumber        varchar(20);
dcl-s AddressLine1       varchar(50);
dcl-s AddressLine2       varchar(50);
dcl-s City               varchar(30);
dcl-s State              char(2);
dcl-s ZipCode            varchar(10);
dcl-s Country            char(3);
dcl-s CreditLimit        packed(11: 2);
dcl-s CurrentBalance     packed(11: 2);
dcl-s CustomerType       char(1);
dcl-s ActiveFlag         char(1);
dcl-s CreatedDate        date;
dcl-s LastOrderDate      date;
dcl-s CreatedTimestamp   timestamp;

// === Working variables ===
dcl-s dspMsg             varchar(52);
dcl-s CustomerCount      int(10) inz(0);

// === Indicator variables for NULL handling ===
dcl-s ind_CustomerID         int(5);
dcl-s ind_CustomerCode       int(5);
dcl-s ind_FirstName          int(5);
dcl-s ind_LastName           int(5);
dcl-s ind_CompanyName        int(5);
dcl-s ind_EmailAddress       int(5);
dcl-s ind_PhoneNumber        int(5);
dcl-s ind_AddressLine1       int(5);
dcl-s ind_AddressLine2       int(5);
dcl-s ind_City               int(5);
dcl-s ind_State              int(5);
dcl-s ind_ZipCode            int(5);
dcl-s ind_Country            int(5);
dcl-s ind_CreditLimit        int(5);
dcl-s ind_CurrentBalance     int(5);
dcl-s ind_CustomerType       int(5);
dcl-s ind_ActiveFlag         int(5);
dcl-s ind_CreatedDate        int(5);
dcl-s ind_LastOrderDate      int(5);
dcl-s ind_CreatedTimestamp   int(5);

// === Declare cursor for CUSTOMERS table ===
Exec SQL
    DECLARE CustomerCursor CURSOR FOR
    SELECT CUSTOMER_ID, CUSTOMER_CODE, FIRST_NAME, LAST_NAME,
           COMPANY_NAME, EMAIL_ADDRESS, PHONE_NUMBER,
           ADDRESS_LINE1, ADDRESS_LINE2, CITY, STATE, ZIP_CODE,
           COUNTRY, CREDIT_LIMIT, CURRENT_BALANCE, CUSTOMER_TYPE,
           ACTIVE_FLAG, CREATED_DATE, LAST_ORDER_DATE,
           CREATED_TIMESTAMP
    FROM JHORNER21.CUSTOMERS
    ORDER BY LAST_NAME, FIRST_NAME;

// === Open the cursor ===
Exec SQL
    OPEN CustomerCursor;

// === Check for SQL errors ===
if SQLSTATE <> '00000';
    dspMsg = 'Error opening cursor: ' + SQLSTATE;
    dsply dspMsg;
    return;
endif;

// === Fetch first record ===
Exec SQL
    FETCH CustomerCursor INTO
        :CustomerID :ind_CustomerID,
        :CustomerCode :ind_CustomerCode,
        :FirstName :ind_FirstName,
        :LastName :ind_LastName,
        :CompanyName :ind_CompanyName,
        :EmailAddress :ind_EmailAddress,
        :PhoneNumber :ind_PhoneNumber,
        :AddressLine1 :ind_AddressLine1,
        :AddressLine2 :ind_AddressLine2,
        :City :ind_City,
        :State :ind_State,
        :ZipCode :ind_ZipCode,
        :Country :ind_Country,
        :CreditLimit :ind_CreditLimit,
        :CurrentBalance :ind_CurrentBalance,
        :CustomerType :ind_CustomerType,
        :ActiveFlag :ind_ActiveFlag,
        :CreatedDate :ind_CreatedDate,
        :LastOrderDate :ind_LastOrderDate,
        :CreatedTimestamp :ind_CreatedTimestamp;

// === Process all records ===
dow SQLSTATE = '00000';
    CustomerCount += 1;

    // Display customer information
    if ind_CompanyName >= 0 and CompanyName <> *blanks;
        dspMsg = %char(CustomerCount) + ': ' + %trim(CompanyName);
        dsply dspMsg;
        dspMsg = '   (' + %trim(FirstName) + ' ' + %trim(LastName) + ')';
        dsply dspMsg;
    else;
        dspMsg = %char(CustomerCount) + ': ' + %trim(FirstName);
        dsply dspMsg;
        dspMsg = '       ' + %trim(LastName);
        dsply dspMsg;
    endif;

    // Display contact info - check for NULLs
    if ind_PhoneNumber >= 0 and PhoneNumber <> *blanks;
        dspMsg = '   Phone: ' + %trim(PhoneNumber);
        dsply dspMsg;
    endif;

    if ind_EmailAddress >= 0 and EmailAddress <> *blanks;
        // Email might be long, so truncate if needed
        if %len(%trim(EmailAddress)) > 44;
            dspMsg = '   Email: ' + %subst(%trim(EmailAddress):1:44);
        else;
            dspMsg = '   Email: ' + %trim(EmailAddress);
        endif;
        dsply dspMsg;
    endif;

    // Display customer type and status
    select;
        when CustomerType = 'R';
            dspMsg = '   Type: Retail';
        when CustomerType = 'B';
            dspMsg = '   Type: Business';
        when CustomerType = 'W';
            dspMsg = '   Type: Wholesale';
        other;
            dspMsg = '   Type: Unknown';
    endsl;

    if ActiveFlag = 'Y';
        dspMsg += ' (Active)';
    else;
        dspMsg += ' (Inactive)';
    endif;
    dsply dspMsg;

    // Display credit information - handle NULLs
    if ind_CreditLimit >= 0 and ind_CurrentBalance >= 0;
        dspMsg = '   Credit: $' + %char(CreditLimit);
        dsply dspMsg;
        dspMsg = '   Balance: $' + %char(CurrentBalance);
        dsply dspMsg;
    elseif ind_CreditLimit >= 0;
        dspMsg = '   Credit: $' + %char(CreditLimit);
        dsply dspMsg;
        dspMsg = '   Balance: (NULL)';
        dsply dspMsg;
    elseif ind_CurrentBalance >= 0;
        dspMsg = '   Credit: (NULL)';
        dsply dspMsg;
        dspMsg = '   Balance: $' + %char(CurrentBalance);
        dsply dspMsg;
    else;
        dspMsg = '   Credit: (NULL) Balance: (NULL)';
        dsply dspMsg;
    endif;

    // Add separator line
    dspMsg = '   ----------------------------';
    dsply dspMsg;

    // Fetch next record
    Exec SQL
        FETCH CustomerCursor INTO
            :CustomerID :ind_CustomerID,
            :CustomerCode :ind_CustomerCode,
            :FirstName :ind_FirstName,
            :LastName :ind_LastName,
            :CompanyName :ind_CompanyName,
            :EmailAddress :ind_EmailAddress,
            :PhoneNumber :ind_PhoneNumber,
            :AddressLine1 :ind_AddressLine1,
            :AddressLine2 :ind_AddressLine2,
            :City :ind_City,
            :State :ind_State,
            :ZipCode :ind_ZipCode,
            :Country :ind_Country,
            :CreditLimit :ind_CreditLimit,
            :CurrentBalance :ind_CurrentBalance,
            :CustomerType :ind_CustomerType,
            :ActiveFlag :ind_ActiveFlag,
            :CreatedDate :ind_CreatedDate,
            :LastOrderDate :ind_LastOrderDate,
            :CreatedTimestamp :ind_CreatedTimestamp;
enddo;

// === Close the cursor ===
Exec SQL
    CLOSE CustomerCursor;

// === Display summary ===
dspMsg = 'Total customers processed: ' + %char(CustomerCount);
dsply dspMsg;

// === End program ===
*inlr = *on;
return;
