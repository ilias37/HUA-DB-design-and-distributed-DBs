DROP PACKAGE books_package;
DROP PACKAGE members_package;
DROP PACKAGE borrowings_package;
--------------------------------------------------------------------------------
ALTER SESSION SET NLS_DATE_FORMAT='DD-MM-YYYY';
--------------------------------------------------------------------------------
/*PROHGOUMENWS NA EXOUN GINEI COMPILE OLES OI SUNARTHSEIS APO TO ARXEIO functions.sql*/
--------------------------------------------------------------------------------
/*Ένα πακέτο για τη διαχείριση της συλλογής βιβλίων της βιβλιοθήκης*/
CREATE OR REPLACE PACKAGE books_package AS
    PROCEDURE proc_book_availability(book_id IN NUMBER); 
    PROCEDURE proc_books_of_category(book_category IN books.category%TYPE); 
    PROCEDURE title_search(book_title IN books.title%TYPE);
    PROCEDURE writer_search(book_writer IN books.writer%TYPE); 
    PROCEDURE add_book(book_title books.title%TYPE, book_writer books.writer%TYPE, book_isbn books.isbn%TYPE, book_category books.category%TYPE); 
    PROCEDURE delete_book(book_isbn books.isbn%TYPE); 

END books_package;
/

CREATE OR REPLACE PACKAGE BODY books_package AS

    PROCEDURE proc_book_availability(book_id IN NUMBER) AS
        res1 NUMBER;
    BEGIN
        res1 := book_availability(book_id);
        IF res1 = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('TO BIBLIO EINAI DANEISMENO');
        ELSIF res1 = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('TO BIBLIO EINAI DIATHESIMO');
        ELSE
            DBMS_OUTPUT.PUT_LINE('TO BIBLIO DEN YPARXEI GENIKA STH BIBLIOTHKH');
        END IF;
    END proc_book_availability;

    PROCEDURE proc_books_of_category(book_category IN books.category%TYPE) AS
        res4 NUMBER;
    BEGIN
        res4 := books_of_category(book_category);
    END proc_books_of_category;

    PROCEDURE title_search(book_title IN books.title%TYPE) AS 
        proc_tuple books%ROWTYPE;
        CURSOR c1 IS
            SELECT * FROM books;    
    BEGIN
        OPEN c1;
        LOOP
            FETCH c1 INTO proc_tuple;   --PSAXNW OLO TON PINAKA TWN BIBLIWN
            EXIT WHEN c1%NOTFOUND;
            IF REGEXP_LIKE(PROC_tuple.title, book_title) THEN  
                DBMS_OUTPUT.PUT_LINE('-> TITLOS: '||proc_tuple.title||', SUGGRAFEAS: '||proc_tuple.writer||', ISBN: '||proc_tuple.isbn||', KATHGORIA: '||proc_tuple.category);
            END IF;
        END LOOP;       
        CLOSE c1;
    END title_search;

    PROCEDURE writer_search(book_writer IN books.writer%TYPE) AS 
        proc_tuple books%ROWTYPE;
        CURSOR c1 IS
            SELECT * FROM books;    
    BEGIN
        OPEN c1;
        LOOP
            FETCH c1 INTO proc_tuple;   --PSAXNW OLO TON PINAKA TWN BIBLIWN
            EXIT WHEN c1%NOTFOUND;
            IF REGEXP_LIKE(PROC_tuple.writer, book_writer) THEN  
                DBMS_OUTPUT.PUT_LINE('-> TITLOS: '||proc_tuple.title||', SUGGRAFEAS: '||proc_tuple.writer||', ISBN: '||proc_tuple.isbn||', KATHGORIA: '||proc_tuple.category);
            END IF;
        END LOOP;       
        CLOSE c1;
    END writer_search;

    PROCEDURE add_book(book_title books.title%TYPE, 
                       book_writer books.writer%TYPE, 
                       book_isbn books.isbn%TYPE, 
                       book_category books.category%TYPE) 
    AS 
    BEGIN
        INSERT INTO books VALUES (book_title, book_writer, book_isbn, book_category);
        DBMS_OUTPUT.PUT_LINE('TO BIBLIO PROSTETHKE EPITUXWS STON PINAKA ME TA DIATHESIMA BIBLIA');
    END add_book;

    PROCEDURE delete_book(book_isbn books.isbn%TYPE) AS 
    BEGIN
        DELETE FROM books WHERE isbn = book_isbn;
        DBMS_OUTPUT.PUT_LINE('TO BIBLIO DIAGRAFHKE EPITUXWS APO TON PINAKA ME TA BIBLIA');
    END delete_book;
   
END books_package;
/

CALL books_package.proc_book_availability(67890);
CALL books_package.proc_books_of_category('MAGEIRIKH');
CALL books_package.title_search('H TEXNH THS AMUNAS');
CALL books_package.writer_search('STEPHEN HAWKING');
CALL books_package.add_book('MIA NUXTA STO MOUSEIO', 'ALEKOS PARAMUTHAS', 22345, 'PAIDIKA');
CALL books_package.delete_book(22345);

SELECT * FROM books;
--------------------------------------------------------------------------------
/*Ένα πακέτο για τη διαχείριση των μελών της βιβλιοθήκης*/
CREATE OR REPLACE PACKAGE members_package AS
    PROCEDURE add_member(member_id members.id%TYPE, member_fname members.fname%TYPE, member_lname members.lname%TYPE, member_address members.address%TYPE); 
    PROCEDURE delete_member(member_id members.id%TYPE);
END members_package;
/

CREATE OR REPLACE PACKAGE BODY members_package AS

    PROCEDURE add_member(member_id members.id%TYPE, 
                         member_fname members.fname%TYPE, 
                         member_lname members.lname%TYPE, 
                         member_address members.address%TYPE) 
    AS  
    BEGIN
        INSERT INTO members VALUES (member_id, member_fname, member_lname, member_address);
        DBMS_OUTPUT.PUT_LINE('TO NEO MELOS PROSTETHKE EPITUXWS STON PINAKA');
    END add_member;

    PROCEDURE delete_member(member_id members.id%TYPE) AS 
    BEGIN
        DELETE FROM members WHERE id = member_id;
        DBMS_OUTPUT.PUT_LINE('TO MELOS DIAGRAFHKE EPITUXWS APO TON PINAKA ME TA MELH');
    END delete_member;

END members_package;
/

CALL members_package.add_member(22345, 'VASILHS', 'TOROSIDHS', 'XENOFONTOS 11');
CALL members_package.delete_member(22345);

SELECT * FROM members;
--------------------------------------------------------------------------------
/*Ένα πακέτο για τη διαχείριση των δανεισμών βιβλίων*/
CREATE OR REPLACE PACKAGE borrowings_package AS
    PROCEDURE proc_days_of_borrowing(book_id NUMBER);
    PROCEDURE proc_fine(book_id NUMBER);
    PROCEDURE borrow(book_title borrowings.title%TYPE, book_isbn borrowings.isbn%TYPE, book_borrower_id borrowings.borrower_id%TYPE, book_day borrowings.day%TYPE);
    PROCEDURE end_of_borrowing(book_isbn borrowings.isbn%TYPE);
    PROCEDURE update_date(book_isbn borrowings.isbn%TYPE, book_day borrowings.day%TYPE);
END borrowings_package;
/

CREATE OR REPLACE PACKAGE BODY borrowings_package AS

    PROCEDURE proc_days_of_borrowing(book_id IN NUMBER) AS
        res1 NUMBER;
        res2 NUMBER;
    BEGIN
        res1 := book_availability(book_id);
        IF res1 = 1 THEN 
            res2 := days_of_borrowing(book_id);
            DBMS_OUTPUT.PUT_LINE('TO BIBLIO EINAI DANEISMENO '||TRUNC(res2)||' MERES'); 
        ELSIF res1 = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('TO BIBLIO EINAI DIATHESIMO');
        ELSE
            DBMS_OUTPUT.PUT_LINE('TO BIBLIO DEN YPARXEI GENIKA STH BIBLIOTHKH');
        END IF;
    END proc_days_of_borrowing;

    PROCEDURE proc_fine(book_id IN NUMBER) AS
        res1 NUMBER;
        res2 NUMBER;
        res3 NUMBER;
    BEGIN
        res1 := book_availability(book_id);
        IF res1 = 1 THEN                     --AN TO BIBLIO EINAI DANEISMENO
            res2 := days_of_borrowing(book_id);
            IF res2 > 7 THEN                 --AN TO BIBLIO EINAI EKPROTHESMO
                res3 := fine(book_id, res2);
                DBMS_OUTPUT.PUT_LINE('TO PROSTIMO POU ANTISTOIXEI GIA '||TRUNC(res2)||' MERES EINAI '||TRUNC(res3)||'$');
            ELSE                --AN TO BIBLIO EINAI EMPROTHESMO
                DBMS_OUTPUT.PUT_LINE('TO BIBLIO EINAI DANEISMENO '||TRUNC(res2)||' MERES'); 
            END IF;    
        ELSIF res1 = 0 THEN                  --AN TO BIBLIO DEN EINAI DANEISMENO
            DBMS_OUTPUT.PUT_LINE('TO BIBLIO EINAI DIATHESIMO');
        ELSE 
            DBMS_OUTPUT.PUT_LINE('TO BIBLIO DEN YPARXEI GENIKA STH BIBLIOTHKH');
        END IF;    
    END proc_fine;

    PROCEDURE borrow(book_title IN borrowings.title%TYPE, 
                     book_isbn IN borrowings.isbn%TYPE, 
                     book_borrower_id IN borrowings.borrower_id%TYPE, 
                     book_day IN borrowings.day%TYPE) 
    AS 
    BEGIN
        INSERT INTO borrowings VALUES (book_title, book_isbn, book_borrower_id, book_day);
        DBMS_OUTPUT.PUT_LINE('TO BIBLIO PROSTETHKE EPITUXWS STON PINAKA ME TA DANEISMENA BIBLIA');
    END borrow;

    PROCEDURE end_of_borrowing(book_isbn IN borrowings.isbn%TYPE) AS    
        res2 NUMBER;
        res3 NUMBER;
    BEGIN
        res2 := days_of_borrowing(book_isbn);
        IF res2 > 7 THEN                 --AN TO BIBLIO EINAI EKPROTHESMO
                res3 := fine(book_isbn, res2);
                DBMS_OUTPUT.PUT_LINE('TO PROSTIMO POU ANTISTOIXEI GIA '||TRUNC(res2)||' MERES EINAI '||TRUNC(res3)||'$');
            ELSE                --AN TO BIBLIO EINAI EMPROTHESMO
                DBMS_OUTPUT.PUT_LINE('TO BIBLIO EINAI DANEISMENO '||TRUNC(res2)||' MERES'); 
            END IF;
        DELETE FROM borrowings WHERE isbn = book_isbn;
        DBMS_OUTPUT.PUT_LINE('TO BIBLIO DIAGRAFHKE EPITUXWS APO TON PINAKA ME TA DANEISMENA BIBLIA');
    END end_of_borrowing;

    PROCEDURE update_date(book_isbn borrowings.isbn%TYPE,
                          book_day borrowings.day%TYPE) 
    AS 
    BEGIN
        UPDATE borrowings
        SET day = book_day
        WHERE isbn = book_isbn;
        DBMS_OUTPUT.PUT_LINE('H HMEROMHNIA TOU DANEISMOU ENHMERWTHKE EPITUXWS');
    END update_date;

END borrowings_package;
/

CALL borrowings_package.proc_days_of_borrowing(67890);
CALL borrowings_package.proc_fine(67890);
CALL borrowings_package.borrow('FATE FROUTA', 11234, 34567, '22-01-2023');
CALL borrowings_package.end_of_borrowing(11234);
CALL borrowings_package.update_date(12345, '18-01-2023');

SELECT * FROM borrowings; 
--------------------------------------------------------------------------------