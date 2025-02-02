       01  TAX-RECORD.
           03 META.
             05 TAXID PIC S9(9) USAGE IS COMP-3.
             05 STATS PIC X.
             05 LAST-UPDATED.
               10 UPDATE-DATE PIC 9(6).
               10 UPDATE-TIME PIC 9(9).
           03 BALANCE PIC S9(11)V99 USAGE IS COMP-3.
           03 NOTES PIC X(100)
             OCCURS 10 TIMES.
