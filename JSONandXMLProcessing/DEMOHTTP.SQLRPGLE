**FREE
//***********************************************************
//* Program Name: DEMOHTTP
//* Description:  Demo program showing HTTP API calls using
//*               embedded Sql HTTP_GET function
//* Library:      JHORNER21
//* Author:       Jerald Horner
//* Contact:      JeraldHorner@StructuredSys.com
//* Phone:        214-704-6178
//* Purpose:      Training demonstration of HTTP functions
//*               in IBM i embedded Sql
//* Date Created: 2025-08-21
//*
//* API Used: JSONPlaceholder (free test API)
//* URL: https://jsonplaceholder.typicode.com/users/1
//*
//* Compile Instructions:
//*   CRTSQLRPGI OBJ(JHORNER21/DEMOHTTP)
//*              SRCFILE(JHORNER21/QRPGLESRC)
//*              SRCMBR(DEMOHTTP) OBJTYPE(*PGM)
//*              COMMIT(*NONE) DBGVIEW(*SOURCE)
//***********************************************************

ctl-opt dftactgrp(*no) actgrp(*new) main(main)
        option(*srcstmt : *nodebugio);

// Program constants
dcl-c PROGRAM_NAME 'DEMOHTTP';
dcl-c SQL_SUCCESS '00000';
dcl-c SQL_NOT_FOUND '02000';
dcl-c MAX_DISPLAY_WIDTH 52;

// HTTP response structure - enhanced for multiple fields
dcl-ds httpResponse qualified;
  responseBody varchar(32000);
  userName varchar(50);
  userEmail varchar(100);
  userPhone varchar(30);
  userWebsite varchar(50);
  streetAddress varchar(100);
  userCity varchar(50);
  userZipcode varchar(20);
  companyName varchar(100);
  companyCatchPhrase varchar(200);
end-ds;

// Working variables
dcl-s displayLine char(52);
dcl-s errorMsg char(50);

//***********************************************************
//* Main Procedure
//***********************************************************
dcl-proc main;

  displayHeader();
  callHttpApi();

  dsply ' ';
  dsply 'Program DEMOHTTP completed successfully.';

end-proc;

//***********************************************************
//* Procedure: displayHeader
//***********************************************************
dcl-proc displayHeader;

  dsply ' ';
  dsply 'DEMOHTTP - HTTP API Call Demo';
  dsply 'HTTP Functions - Jerald Horner';
  dsply 'Contact: JeraldHorner@StructuredSys.com';
  dsply ' ';

end-proc;

//***********************************************************
//* Procedure: callHttpApi
//* Purpose: Call JSONPlaceholder API and display results
//***********************************************************
dcl-proc callHttpApi;

  dcl-s httpUrl varchar(200);
  dcl-s httpStatus varchar(500);
  dcl-s statusCode int(10) inz(0);

  httpUrl = 'https://jsonplaceholder.typicode.com/users/1';

  dsply 'Making HTTP API call...';
  dsply 'URL: JSONPlaceholder Users API';
  dsply ' ';

  // Get HTTP response with status information
  exec sql SET :httpResponse.responseBody = QSYS2.HTTP_GET(:httpUrl);

  if SQLSTATE <> SQL_SUCCESS;
    errorMsg = 'HTTP call failed - SqlSTATE: ' + SQLSTATE;
    dsply errorMsg;
    dsply 'Check network connectivity and URL access';
    return;
  endif;

  // Check if we got a response
  if %len(%trim(httpResponse.responseBody)) = 0;
    dsply 'ERROR: Empty response received';
    dsply 'Possible network or API issue';
    return;
  endif;

  // Try to determine if response looks like valid JSON
  if %subst(%trim(httpResponse.responseBody):1:1) <> '{';
    dsply 'WARNING: Response may not be valid JSON';
    displayLine = 'Response: ' +
                  %subst(%trim(httpResponse.responseBody):1:
                         %min(40:%len(%trim(httpResponse.responseBody))));
    dsply displayLine;
    return;
  endif;

  dsply 'HTTP API Call - SUCCESS';
  dsply '========================';

  // Parse JSON fields with error handling
  parseJsonFields();

  // Display formatted results
  displayUserInfo();

end-proc;

//***********************************************************
//* Procedure: parseJsonFields
//* Purpose: Extract JSON fields with individual error handling
//***********************************************************
dcl-proc parseJsonFields;

  // Parse user name
  exec sql SET :httpResponse.userName = JSON_VALUE(:httpResponse.responseBody, '$.name');
  if SQLSTATE <> SQL_SUCCESS;
    httpResponse.userName = 'Name not available';
  endif;

  // Parse email
  exec sql SET :httpResponse.userEmail = JSON_VALUE(:httpResponse.responseBody, '$.email');
  if SQLSTATE <> SQL_SUCCESS;
    httpResponse.userEmail = 'Email not available';
  endif;

  // Parse phone
  exec sql SET :httpResponse.userPhone = JSON_VALUE(:httpResponse.responseBody, '$.phone');
  if SQLSTATE <> SQL_SUCCESS;
    httpResponse.userPhone = 'Phone not available';
  endif;

  // Parse website
  exec sql SET :httpResponse.userWebsite = JSON_VALUE(:httpResponse.responseBody, '$.website');
  if SQLSTATE <> SQL_SUCCESS;
    httpResponse.userWebsite = 'Website not available';
  endif;

  // Parse address fields - shorter lines for IBM i width
  exec sql SET :httpResponse.streetAddress =
               JSON_VALUE(:httpResponse.responseBody, '$.address.street');
  if SQLSTATE <> SQL_SUCCESS;
    httpResponse.streetAddress = 'Address not available';
  endif;

  exec sql SET :httpResponse.userCity =
               JSON_VALUE(:httpResponse.responseBody, '$.address.city');
  if SQLSTATE <> SQL_SUCCESS;
    httpResponse.userCity = 'City not available';
  endif;

  exec sql SET :httpResponse.userZipcode =
               JSON_VALUE(:httpResponse.responseBody, '$.address.zipcode');
  if SQLSTATE <> SQL_SUCCESS;
    httpResponse.userZipcode = 'ZIP not available';
  endif;

  // Parse company information
  exec sql SET :httpResponse.companyName =
               JSON_VALUE(:httpResponse.responseBody, '$.company.name');
  if SQLSTATE <> SQL_SUCCESS;
    httpResponse.companyName = 'Company not available';
  endif;

  exec sql SET :httpResponse.companyCatchPhrase =
               JSON_VALUE(:httpResponse.responseBody, '$.company.catchPhrase');
  if SQLSTATE <> SQL_SUCCESS;
    httpResponse.companyCatchPhrase = 'Catchphrase not available';
  endif;

end-proc;

//***********************************************************
//* Procedure: displayUserInfo
//* Purpose: Display parsed user information in formatted layout
//***********************************************************
dcl-proc displayUserInfo;

  dsply ' ';
  dsply 'USER INFORMATION:';
  dsply '=================';

  // Display name
  displayLine = 'Name: ' +
                %subst(%trim(httpResponse.userName):1:
                       %min(45:%len(%trim(httpResponse.userName))));
  dsply displayLine;

  // Display email
  displayLine = 'Email: ' +
                %subst(%trim(httpResponse.userEmail):1:
                       %min(44:%len(%trim(httpResponse.userEmail))));
  dsply displayLine;

  // Display phone
  displayLine = 'Phone: ' +
                %subst(%trim(httpResponse.userPhone):1:
                       %min(44:%len(%trim(httpResponse.userPhone))));
  dsply displayLine;

  // Display website
  displayLine = 'Web: ' +
                %subst(%trim(httpResponse.userWebsite):1:
                       %min(46:%len(%trim(httpResponse.userWebsite))));
  dsply displayLine;

  dsply ' ';
  dsply 'ADDRESS:';
  dsply '--------';

  // Display street address
  displayLine = 'Street: ' +
                %subst(%trim(httpResponse.streetAddress):1:
                       %min(43:%len(%trim(httpResponse.streetAddress))));
  dsply displayLine;

  // Display city and ZIP
  displayLine = 'City: ' +
                %subst(%trim(httpResponse.userCity):1:
                       %min(25:%len(%trim(httpResponse.userCity)))) +
                ' ZIP: ' +
                %subst(%trim(httpResponse.userZipcode):1:
                       %min(12:%len(%trim(httpResponse.userZipcode))));
  dsply displayLine;

  dsply ' ';
  dsply 'COMPANY:';
  dsply '--------';

  // Display company name
  displayLine = 'Name: ' +
                %subst(%trim(httpResponse.companyName):1:
                       %min(45:%len(%trim(httpResponse.companyName))));
  dsply displayLine;

  // Display company catchphrase (may need multiple lines)
  if %len(%trim(httpResponse.companyCatchPhrase)) > 45;
    displayLine = 'Motto: ' +
                  %subst(%trim(httpResponse.companyCatchPhrase):1:45);
    dsply displayLine;
    if %len(%trim(httpResponse.companyCatchPhrase)) > 45;
      displayLine = '  ' +
                    %subst(%trim(httpResponse.companyCatchPhrase):46:
                           %min(50:%len(%trim(httpResponse.companyCatchPhrase)) - 45));
      dsply displayLine;
    endif;
  else;
    displayLine = 'Motto: ' +
                  %subst(%trim(httpResponse.companyCatchPhrase):1:
                         %min(45:%len(%trim(httpResponse.companyCatchPhrase))));
    dsply displayLine;
  endif;

  dsply ' ';
  dsply 'JSON PARSING COMPLETED';
  dsply 'Features Demonstrated:';
  dsply '- HTTP_GET() function call';
  dsply '- Multiple JSON_VALUE() extractions';
  dsply '- Nested JSON object parsing';
  dsply '- Error handling for missing fields';
  dsply '- Formatted display output';

end-proc;

//***********************************************************
//* End of Program DEMOHTTP
//***********************************************************
