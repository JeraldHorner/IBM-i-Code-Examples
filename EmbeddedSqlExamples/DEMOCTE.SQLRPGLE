**FREE
//***********************************************************
//* Program Name: DEMOCTE
//* Description:  Demo program showing single CTE example
//*               Customer summary with order aggregation
//* Library:      JHORNER21
//* Author:       Jerald Horner
//* Contact:      JeraldHorner@StructuredSys.com
//* Phone:        214-704-6178
//* Purpose:      Training demonstration of basic CTE usage
//*               with GROUP BY and LEFT JOIN
//* Date Created: 2025-08-21
//*
//* CTE Structure: Single customer_summary CTE
//*
//* Compile Instructions:
//*   CRTSQLRPGI OBJ(JHORNER21/DEMOCTE)
//*              SRCFILE(JHORNER21/QRPGLESRC)
//*              SRCMBR(DEMOCTE) OBJTYPE(*PGM)
//*              COMMIT(*NONE) DBGVIEW(*SOURCE)
//***********************************************************

ctl-opt dftactgrp(*no) actgrp(*new) main(main)
        option(*srcstmt : *nodebugio);

// Program constants
dcl-c PROGRAM_NAME 'DEMOCTE';
dcl-c SQL_SUCCESS '00000';
dcl-c SQL_NOT_FOUND '02000';
dcl-c MAX_DISPLAY_WIDTH 52;

// Customer summary record structure
dcl-ds customerSummary qualified;
  customerCode char(10);
  customerName char(40);
  customerType char(1);
  orderCount int(10);
  totalSpent packed(11:2);
  lastOrderDate date;
end-ds;

// Working variables
dcl-s displayLine char(52);
dcl-s recordCount int(10) inz(0);
dcl-s errorMsg char(50);

//***********************************************************
//* Main Procedure
//***********************************************************
dcl-proc main;

  displayHeader();
  processCustomerSummary();

  dsply ' ';
  dsply 'Program DEMOCTE completed successfully.';

end-proc;

//***********************************************************
//* Procedure: displayHeader
//***********************************************************
dcl-proc displayHeader;

  dsply ' ';
  dsply 'DEMOCTE - Customer Summary with CTE';
  dsply 'Single CTE Demo - Jerald Horner';
  dsply 'Contact: JeraldHorner@StructuredSys.com';
  dsply ' ';

end-proc;

//***********************************************************
//* Procedure: processCustomerSummary
//* Purpose: Execute single CTE query for customer analysis
//***********************************************************
dcl-proc processCustomerSummary;

  // Declare cursor with single CTE
  exec sql DECLARE cteCursor CURSOR FOR
           WITH customer_summary AS (
             SELECT c.customer_code,
                    c.first_name || ' ' || c.last_name AS customer_name,
                    c.customer_type,
                    COALESCE(COUNT(o.order_id), 0) AS order_count,
                    COALESCE(SUM(o.total_amt), 0) AS total_spent,
                    MAX(o.order_date) AS last_order_date
             FROM jhorner21.customers c
             LEFT JOIN jhorner21.orders o ON c.customer_id = o.customer_id
             WHERE c.active_flag = 'Y'
             GROUP BY c.customer_code, c.first_name, c.last_name, c.customer_type
           )
           SELECT customer_code,
                  customer_name,
                  customer_type,
                  order_count,
                  total_spent,
                  last_order_date
           FROM customer_summary
           ORDER BY total_spent DESC;

  exec sql OPEN cteCursor;

  if SQLSTATE <> SQL_SUCCESS;
    errorMsg = 'Error opening CTE cursor: ' + SQLSTATE;
    dsply errorMsg;
    return;
  endif;

  dsply 'Customer Summary Report (CTE Demo):';
  dsply '=================================';
  dsply ' ';

  // Fetch first customer record
  exec sql FETCH cteCursor INTO :customerSummary.customerCode,
                                :customerSummary.customerName,
                                :customerSummary.customerType,
                                :customerSummary.orderCount,
                                :customerSummary.totalSpent,
                                :customerSummary.lastOrderDate;

  dow SQLSTATE = SQL_SUCCESS;
    recordCount += 1;

    // Display customer code and name
    displayLine = %trim(customerSummary.customerCode) + ' ' +
                  %subst(%trim(customerSummary.customerName):1:
                         %min(25:%len(%trim(customerSummary.customerName)))) +
                  ' Type:' + customerSummary.customerType;
    dsply displayLine;

    // Display order summary
    displayLine = '  Orders:' + %char(customerSummary.orderCount) +
                  ' Total:$' + %char(customerSummary.totalSpent);
    dsply displayLine;

    // Display last order date if available
    if customerSummary.lastOrderDate <> *loval;
      displayLine = '  Last Order: ' + %char(customerSummary.lastOrderDate);
    else;
      displayLine = '  Last Order: Never';
    endif;
    dsply displayLine;

    dsply '---';

    // Fetch next customer
    exec sql FETCH cteCursor INTO :customerSummary.customerCode,
                                  :customerSummary.customerName,
                                  :customerSummary.customerType,
                                  :customerSummary.orderCount,
                                  :customerSummary.totalSpent,
                                  :customerSummary.lastOrderDate;
  enddo;

  // Check for fetch errors (not just end of data)
  if SQLSTATE <> SQL_NOT_FOUND;
    errorMsg = 'Error reading CTE data: ' + SQLSTATE;
    dsply errorMsg;
  else;
    dsply ' ';
    displayLine = 'Total customers: ' + %char(recordCount);
    dsply displayLine;

    dsply ' ';
    dsply 'CTE Concepts Demonstrated:';
    dsply '- Common Table Expression (WITH clause)';
    dsply '- LEFT JOIN to include all customers';
    dsply '- GROUP BY aggregation';
    dsply '- COALESCE for NULL handling';
    dsply '- String concatenation in CTE';
  endif;

  exec sql CLOSE cteCursor;

  if SQLSTATE <> SQL_SUCCESS;
    errorMsg = 'Error closing CTE cursor: ' + SQLSTATE;
    dsply errorMsg;
  endif;

end-proc;

//***********************************************************
//* End of Program DEMOCTE
//***********************************************************
