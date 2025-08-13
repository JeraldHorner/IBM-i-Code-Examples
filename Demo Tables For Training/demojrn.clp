/* ===================================================================== */
/* Program:   SETUPJRN                                                  */
/* Type:      CLP (Control Language Program)                            */
/* Library:   JHORNER21 >> CHANGE THE INSTANCAES OF THESE               */
/*                                                                       */
/* Purpose:   Create journal receiver, journal, and start journaling    */
/*            for Order Management System tables                         */
/*                                                                       */
/* Author:    Jerald Horner                                              */
/* Email:     JeraldHorner@StructuredSys.Com                            */
/* Phone:     214-704-6178                                               */
/* Date:      Created for RPG Free and SQL training purposes            */
/*                                                                       */
/* Description:                                                          */
/* This CLP will:                                                        */
/*   1. Create journal receiver JHORNER21                           */
/*   2. Create journal ORDMGMTJ                                         */
/*   3. Add all 5 order management tables to the journal                */
/*   4. Start journaling for data integrity and recovery                */
/*                                                                       */
/* Compilation Instructions:                                             */
/* 1. Save this source in member SETUPJRN in JHORNER21/QCLSRC           */
/* 2. Compile using: CRTCLPGM PGM(JHORNER21/SETUPJRN)                   */
/*                   SRCFILE(JHORNER21/QCLSRC) SRCMBR(SETUPJRN)         */
/* 3. Run using: CALL JHORNER21/SETUPJRN                                */
/*                                                                       */
/* Prerequisites:                                                        */
/* - Order Management tables must already exist                         */
/* - User must have *ALLOBJ or appropriate journaling authorities       */
/* - Library JHORNER21 must exist                                       */
/*                                                                       */
/* Notes:                                                                */
/* - Journal receiver will be created in JHORNER21 library              */
/* - Journal will be created in JHORNER21 library                       */
/* - Error handling included for existing objects                       */
/* - All tables will be journaled for *BOTH (before and after images)  */
/* ===================================================================== */

             PGM

             /* =================================================== */
             /* Variable Declarations                               */
             /* =================================================== */
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(100)
             DCL        VAR(&LIBRARY) TYPE(*CHAR) LEN(10) VALUE('JHORNER21')

             /* =================================================== */
             /* Global Error Monitoring                             */
             /* =================================================== */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))

             /* =================================================== */
             /* Display startup message                             */
             /* =================================================== */
             SNDPGMMSG  MSGID(CPF9897) MSGF(QCPFMSG) +
                        MSGDTA('Starting Order Management Journal Setup...')

             /* =================================================== */
             /* Step 1: Create Journal Receiver                     */
             /* =================================================== */
             SNDPGMMSG  MSGID(CPF9897) MSGF(QCPFMSG) +
                        MSGDTA('Creating journal receiver JHORNER21...')

             CRTJRNRCV  JRNRCV(&LIBRARY/JHORNER21) +
                        TEXT('Order Mgmt Journal Receiver 0001') +
                        THRESHOLD(500000) +
                        AUT(*EXCLUDE)

             /* Handle case where receiver already exists */
             MONMSG     MSGID(CPF7010) EXEC(DO)
                SNDPGMMSG  MSGID(CPF9897) MSGF(QCPFMSG) +
                           MSGDTA('Journal receiver JHORNER21 already exists')
             ENDDO

             /* =================================================== */
             /* Step 2: Create Journal                              */
             /* =================================================== */
             SNDPGMMSG  MSGID(CPF9897) MSGF(QCPFMSG) +
                        MSGDTA('Creating journal ORDMGMTJ...')

             CRTJRN     JRN(&LIBRARY/ORDMGMTJ) +
                        JRNRCV(&LIBRARY/JHORNER21) +
                        MNGRCV(*SYSTEM) +
                        DLTRCV(*NO) +
                        TEXT('Order Management System Journal') +
                        AUT(*EXCLUDE)

             /* Handle case where journal already exists */
             MONMSG     MSGID(CPF7003) EXEC(DO)
                SNDPGMMSG  MSGID(CPF9897) MSGF(QCPFMSG) +
                           MSGDTA('Journal ORDMGMTJ already exists')
             ENDDO

             /* =================================================== */
             /* Step 3: Start Journaling for CATEGORIES table      */
             /* =================================================== */
             SNDPGMMSG  MSGID(CPF9897) MSGF(QCPFMSG) +
                        MSGDTA('Starting journaling for CATEGORIES table...')

             STRJRNPF   FILE(&LIBRARY/CATEGORIES) +
                        JRN(&LIBRARY/ORDMGMTJ) +
                        IMAGES(*BOTH) +
                        OMTJRNE(*OPNCLO)

             /* Handle case where table already being journaled */
             MONMSG     MSGID(CPF7024) EXEC(DO)
                SNDPGMMSG  MSGID(CPF9897) MSGF(QCPFMSG) +
                           MSGDTA('CATEGORIES already being journaled')
             ENDDO

             /* =================================================== */
             /* Step 4: Start Journaling for CUSTOMERS table       */
             /* =================================================== */
             SNDPGMMSG  MSGID(CPF9897) MSGF(QCPFMSG) +
                        MSGDTA('Starting journaling for CUSTOMERS table...')

             STRJRNPF   FILE(&LIBRARY/CUSTOMERS) +
                        JRN(&LIBRARY/ORDMGMTJ) +
                        IMAGES(*BOTH) +
                        OMTJRNE(*OPNCLO)

             /* Handle case where table already being journaled */
             MONMSG     MSGID(CPF7024) EXEC(DO)
                SNDPGMMSG  MSGID(CPF9897) MSGF(QCPFMSG) +
                           MSGDTA('CUSTOMERS already being journaled')
             ENDDO

             /* =================================================== */
             /* Step 5: Start Journaling for PRODUCTS table        */
             /* =================================================== */
             SNDPGMMSG  MSGID(CPF9897) MSGF(QCPFMSG) +
                        MSGDTA('Starting journaling for PRODUCTS table...')

             STRJRNPF   FILE(&LIBRARY/PRODUCTS) +
                        JRN(&LIBRARY/ORDMGMTJ) +
                        IMAGES(*BOTH) +
                        OMTJRNE(*OPNCLO)

             /* Handle case where table already being journaled */
             MONMSG     MSGID(CPF7024) EXEC(DO)
                SNDPGMMSG  MSGID(CPF9897) MSGF(QCPFMSG) +
                           MSGDTA('PRODUCTS already being journaled')
             ENDDO

             /* =================================================== */
             /* Step 6: Start Journaling for ORDERS table          */
             /* =================================================== */
             SNDPGMMSG  MSGID(CPF9897) MSGF(QCPFMSG) +
                        MSGDTA('Starting journaling for ORDERS table...')

             STRJRNPF   FILE(&LIBRARY/ORDERS) +
                        JRN(&LIBRARY/ORDMGMTJ) +
                        IMAGES(*BOTH) +
                        OMTJRNE(*OPNCLO)

             /* Handle case where table already being journaled */
             MONMSG     MSGID(CPF7024) EXEC(DO)
                SNDPGMMSG  MSGID(CPF9897) MSGF(QCPFMSG) +
                           MSGDTA('ORDERS already being journaled')
             ENDDO

             /* =================================================== */
             /* Step 7: Start Journaling for ORDERITEMS table     */
             /* =================================================== */
             SNDPGMMSG  MSGID(CPF9897) MSGF(QCPFMSG) +
                        MSGDTA('Starting journaling for ORDERITEMS table...')

             STRJRNPF   FILE(&LIBRARY/ORDERITEMS) +
                        JRN(&LIBRARY/ORDMGMTJ) +
                        IMAGES(*BOTH) +
                        OMTJRNE(*OPNCLO)

             /* Handle case where table already being journaled */
             MONMSG     MSGID(CPF7024) EXEC(DO)
                SNDPGMMSG  MSGID(CPF9897) MSGF(QCPFMSG) +
                           MSGDTA('ORDERITEMS already being journaled')
             ENDDO

             /* =================================================== */
             /* Step 8: Display journal status                      */
             /* =================================================== */
             SNDPGMMSG  MSGID(CPF9897) MSGF(QCPFMSG) +
                        MSGDTA('Displaying journal status...')

             WRKJRN     JRN(&LIBRARY/ORDMGMTJ)

             /* =================================================== */
             /* Success completion message                          */
             /* =================================================== */
             SNDPGMMSG  MSGID(CPF9897) MSGF(QCPFMSG) +
                        MSGDTA('Journal setup completed successfully!')

             SNDPGMMSG  MSGID(CPF9897) MSGF(QCPFMSG) +
                        MSGDTA('All 5 Order Management tables are now journaled')

             GOTO       CMDLBL(END)

             /* =================================================== */
             /* Error Handling Section                              */
             /* =================================================== */
 ERROR:      RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID)

             SNDPGMMSG  MSGID(CPF9897) MSGF(QCPFMSG) +
                        MSGDTA('ERROR: Journal setup failed!')

             SNDPGMMSG  MSGID(CPF9897) MSGF(QCPFMSG) +
                        MSGDTA('Error Message ID: ' *CAT &MSGID)

             SNDPGMMSG  MSGID(CPF9897) MSGF(QCPFMSG) +
                        MSGDTA('Error Data: ' *CAT &MSGDTA)

             SNDPGMMSG  MSGID(CPF9897) MSGF(QCPFMSG) +
                        MSGDTA('Check authorities and table existence')

             /* =================================================== */
             /* Program End                                         */
             /* =================================================== */
 END:        ENDPGM

/* ===================================================================== */
/* USAGE NOTES:                                                          */
/*                                                                       */
/* After running this program, you can:                                 */
/*                                                                       */
/* 1. Display journal information:                                       */
/*    DSPJRN JRN(JHORNER21/ORDMGMTJ)                                    */
/*                                                                       */
/* 2. Display journaled objects:                                         */
/*    WRKJRNPF JRN(JHORNER21/ORDMGMTJ)                                  */
/*                                                                       */
/* 3. Work with journal entries:                                         */
/*    WRKJRNE JRN(JHORNER21/ORDMGMTJ)                                   */
/*                                                                       */
/* 4. Display journal receiver attributes:                               */
/*    DSPJRNRCVA JRNRCV(JHORNER21/JHORNER21)                       */
/*                                                                       */
/* BENEFITS OF JOURNALING:                                               */
/* - Data integrity and recovery capabilities                            */
/* - Audit trail of all changes                                         */
/* - Replication support (for HA/DR scenarios)                          */
/* - Commitment control support                                          */
/* - Performance monitoring and analysis                                 */
/*                                                                       */
/* JOURNAL ENTRY TYPES YOU'LL SEE:                                      */
/* - UB = Update Before Image                                            */
/* - UR = Update After Image                                             */
/* - DL = Delete                                                         */
/* - AD = Add (Insert)                                                   */
/* - OF = Open File                                                      */
/* - CF = Close File                                                     */
/*                                                                       */
/* MAINTENANCE NOTES:                                                    */
/* - Journal receivers will be automatically managed (*SYSTEM)          */
/* - Monitor receiver size and manage as needed                         */
/* - Consider setting up receiver save/restore procedures               */
/* - Review journal entries periodically for audit purposes             */
/* ===================================================================== */
