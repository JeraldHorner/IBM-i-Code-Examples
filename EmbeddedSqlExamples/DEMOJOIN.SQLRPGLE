**FREE
//***********************************************************
//* Program Name: DEMOJOIN
//* Description:  Demo program showing multi-table joins
//*               Customer Orders with Product Details
//* Library:      JHORNER21
//* Author:       Jerald Horner
//* Contact:      JeraldHorner@StructuredSys.com
//* Phone:        214-704-6178
//* Purpose:      Training demonstration of complex SQL joins
//*               across multiple related tables
//* Date Created: 2025-08-21
//*
//* Tables Joined:
//*   CUSTOMERS -> ORDERS -> ORDERITEMS -> PRODUCTS -> CATEGORIES
//*
//* Compile Instructions:
//*   CRTSQLRPGI OBJ(JHORNER21/DEMOJOIN)
//*              SRCFILE(JHORNER21/QRPGLESRC)
//*              SRCMBR(DEMOJOIN) OBJTYPE(*PGM)
//*              COMMIT(*NONE) DBGVIEW(*SOURCE)
//***********************************************************

ctl-opt dftactgrp(*no) actgrp(*new) main(main)
        option(*srcstmt : *nodebugio);

// Program constants
dcl-c PROGRAM_NAME 'DEMOJOIN';
dcl-c SQL_SUCCESS '00000';
dcl-c SQL_NOT_FOUND '02000';
dcl-c MAX_DISPLAY_WIDTH 52;

// Order summary record structure
dcl-ds orderSummary qualified;
  customerCode char(10);
  customerName char(40);
  orderNumber char(20);
  orderDate date;
  orderStatus char(1);
  totalAmount packed(11:2);
  itemCount int(10);
end-ds;

// Order detail record structure
dcl-ds orderDetail qualified;
  orderNumber char(20);
  lineNumber int(5);
  productCode char(20);
  productName char(40);
  categoryName char(30);
  qtyOrdered packed(9:2);
  unitPrice packed(9:2);
  lineTotal packed(11:2);
end-ds;

// Working variables
dcl-s displayLine char(52);
dcl-s recordCount int(10) inz(0);
dcl-s errorMsg char(50);
dcl-s currentOrder char(20) inz('');

//***********************************************************
//* Main Procedure
//***********************************************************
dcl-proc main;

  displayHeader();
  processOrderSummary();

  dsply ' ';
  dsply 'Program DEMOJOIN completed successfully.';

end-proc;

//***********************************************************
//* Procedure: displayHeader
//***********************************************************
dcl-proc displayHeader;

  dsply ' ';
  dsply 'DEMOJOIN - Customer Orders with Details';
  dsply 'Multi-Table Join Demo - Jerald Horner';
  dsply 'Contact: JeraldHorner@StructuredSys.com';
  dsply ' ';

end-proc;

//***********************************************************
//* Procedure: processOrderSummary
//* Purpose: Display customer orders with summary info
//***********************************************************
dcl-proc processOrderSummary;

  // Declare cursor for order summary (3-table join)
  exec sql DECLARE orderCursor CURSOR FOR
           SELECT c.customer_code,
                  TRIM(c.first_name) || ' ' || TRIM(c.last_name) as customer_name,
                  o.order_number,
                  o.order_date,
                  o.order_status,
                  o.total_amt,
                  COUNT(oi.orderitem_id) as item_count
           FROM jhorner21.customers c
           INNER JOIN jhorner21.orders o
              ON c.customer_id = o.customer_id
           INNER JOIN jhorner21.orderitems oi
              ON o.order_id = oi.order_id
           WHERE c.active_flag = 'Y'
           GROUP BY c.customer_code, c.first_name, c.last_name,
                    o.order_number, o.order_date, o.order_status, o.total_amt
           ORDER BY o.order_date DESC, c.customer_code;

  exec sql OPEN orderCursor;

  if SQLSTATE <> SQL_SUCCESS;
    errorMsg = 'Error opening order cursor: ' + SQLSTATE;
    dsply errorMsg;
    return;
  endif;

  dsply 'Customer Orders Summary:';
  dsply '========================';

  // Fetch first order record
  exec sql FETCH orderCursor INTO :orderSummary.customerCode,
                                  :orderSummary.customerName,
                                  :orderSummary.orderNumber,
                                  :orderSummary.orderDate,
                                  :orderSummary.orderStatus,
                                  :orderSummary.totalAmount,
                                  :orderSummary.itemCount;

  dow SQLSTATE = SQL_SUCCESS;
    recordCount += 1;

    // Display order summary (keep under 52 chars)
    // Using %min() to prevent RNX0100 errors
    displayLine = %trim(orderSummary.customerCode) + ' ' +
                  %subst(%trim(orderSummary.customerName):1:
                         %min(20:%len(%trim(orderSummary.customerName)))) + ' ' +
                  %trim(orderSummary.orderNumber);
    dsply displayLine;

    displayLine = '  Date:' + %char(orderSummary.orderDate) +
                  ' Stat:' + orderSummary.orderStatus +
                  ' Items:' + %char(orderSummary.itemCount);
    dsply displayLine;

    displayLine = '  Total: $' +
                  %char(orderSummary.totalAmount);
    dsply displayLine;

    // Show order details for this order
    processOrderDetails(%trim(orderSummary.orderNumber));

    dsply '---';

    // Fetch next order
    exec sql FETCH orderCursor INTO :orderSummary.customerCode,
                                    :orderSummary.customerName,
                                    :orderSummary.orderNumber,
                                    :orderSummary.orderDate,
                                    :orderSummary.orderStatus,
                                    :orderSummary.totalAmount,
                                    :orderSummary.itemCount;
  enddo;

  exec sql CLOSE orderCursor;

  dsply ' ';
  displayLine = 'Total orders displayed: ' + %char(recordCount);
  dsply displayLine;

end-proc;

//***********************************************************
//* Procedure: processOrderDetails
//* Purpose: Display line items for a specific order
//***********************************************************
dcl-proc processOrderDetails;
  dcl-pi *n;
    orderNum char(20) const;
  end-pi;

  dcl-s detailCount int(10) inz(0);

  // 5-table join for complete order details
  exec sql DECLARE detailCursor CURSOR FOR
           SELECT o.order_number,
                  oi.line_number,
                  p.product_code,
                  p.product_name,
                  c.category_name,
                  oi.qty_ordered,
                  oi.unit_price,
                  (oi.qty_ordered * oi.unit_price) as line_total
           FROM jhorner21.orders o
           INNER JOIN jhorner21.orderitems oi
              ON o.order_id = oi.order_id
           INNER JOIN jhorner21.products p
              ON oi.product_id = p.product_id
           INNER JOIN jhorner21.categories c
              ON p.category_id = c.category_id
           WHERE o.order_number = :orderNum
           ORDER BY oi.line_number;

  exec sql OPEN detailCursor;

  if SQLSTATE <> SQL_SUCCESS;
    return;
  endif;

  exec sql FETCH detailCursor INTO :orderDetail.orderNumber,
                                   :orderDetail.lineNumber,
                                   :orderDetail.productCode,
                                   :orderDetail.productName,
                                   :orderDetail.categoryName,
                                   :orderDetail.qtyOrdered,
                                   :orderDetail.unitPrice,
                                   :orderDetail.lineTotal;

  dow SQLSTATE = SQL_SUCCESS;
    detailCount += 1;

    // Display line item details - using %min() to prevent RNX0100
    displayLine = '  ' + %char(orderDetail.lineNumber) + '. ' +
                  %subst(%trim(orderDetail.productCode):1:
                         %min(12:%len(%trim(orderDetail.productCode)))) + ' ' +
                  %subst(%trim(orderDetail.productName):1:
                         %min(20:%len(%trim(orderDetail.productName))));
    dsply displayLine;

    displayLine = '     Cat:' +
                  %subst(%trim(orderDetail.categoryName):1:
                         %min(15:%len(%trim(orderDetail.categoryName)))) +
                  ' Qty:' + %char(orderDetail.qtyOrdered);
    dsply displayLine;

    displayLine = '     Price:$' + %char(orderDetail.unitPrice) +
                  ' Total:$' + %char(orderDetail.lineTotal);
    dsply displayLine;

    exec sql FETCH detailCursor INTO :orderDetail.orderNumber,
                                     :orderDetail.lineNumber,
                                     :orderDetail.productCode,
                                     :orderDetail.productName,
                                     :orderDetail.categoryName,
                                     :orderDetail.qtyOrdered,
                                     :orderDetail.unitPrice,
                                     :orderDetail.lineTotal;
  enddo;

  exec sql CLOSE detailCursor;

end-proc;

//***********************************************************
//* End of Program DEMOJOIN
//***********************************************************
