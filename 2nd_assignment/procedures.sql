DROP PROCEDURE title_search;
DROP PROCEDURE writer_search;
DROP PROCEDURE borrow;
DROP PROCEDURE end_of_borrowing;
DROP PROCEDURE add_book;
DROP PROCEDURE add_member;
DROP PROCEDURE update_date;
--------------------------------------------------------------------------------
ALTER SESSION SET NLS_DATE_FORMAT='DD-MM-YYYY';
--------------------------------------------------------------------------------
/*PROHGOUMENWS NA EXOUN GINEI COMPILE OLES OI SUNARTHSEIS APO TO ARXEIO functions.sql*/
--------------------------------------------------------------------------------
/*Μια διαδικασία για αναζήτηση βιβλίου με βάση τον τίτλο που θα επιστρέφει τα 
στοιχεία του βιβλίου (των βιβλίων) σε μήνυμα*/
CREATE OR REPLACE PROCEDURE title_search(book_title IN books.title%TYPE) AS 
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
/

DECLARE
    title books.title%TYPE;
BEGIN
    title := 'H TEXNH THS AMUNAS';
    title_search(title);
END;
/
--------------------------------------------------------------------------------
/*Μια διαδικασία για αναζήτηση βιβλίου με βάση τον συγγραφέα που θα επιστρέφει τα
στοιχεία του βιβλίου (των βιβλίων) σε μήνυμα*/
CREATE OR REPLACE PROCEDURE writer_search(book_writer IN books.writer%TYPE) AS 
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
/

DECLARE
    writer books.writer%TYPE;
BEGIN
    writer := 'STEPHEN HAWKING';
    writer_search(writer);
END;
/
--------------------------------------------------------------------------------
/*Μια διαδικασία για να δανείσετε ένα βιβλίο σε ένα μέλος*/
CREATE OR REPLACE PROCEDURE borrow(book_title IN borrowings.title%TYPE, 
                                   book_isbn IN borrowings.isbn%TYPE, 
                                   book_borrower_id IN borrowings.borrower_id%TYPE, 
                                   book_day IN borrowings.day%TYPE) 
AS 
BEGIN
    INSERT INTO borrowings VALUES (book_title, book_isbn, book_borrower_id, book_day);
    DBMS_OUTPUT.PUT_LINE('TO BIBLIO PROSTETHKE EPITUXWS STON PINAKA ME TA DANEISMENA BIBLIA');
END borrow;
/

DECLARE
    book_title borrowings.title%TYPE;
    book_isbn borrowings.isbn%TYPE;
    book_borrower_id borrowings.borrower_id%TYPE;
    book_day borrowings.day%TYPE;
BEGIN
    book_title := 'FATE FROUTA';
    book_isbn := 11234;
    book_borrower_id := 34567;
    book_day := '22-01-2023';
    borrow(book_title, book_isbn, book_borrower_id, book_day);
END;
/

SELECT * FROM borrowings;
--------------------------------------------------------------------------------
/*Μια διαδικασία για να επιστραφεί ένα βιβλίο που είναι σε δανεισμό*/
CREATE OR REPLACE PROCEDURE end_of_borrowing(book_isbn IN borrowings.isbn%TYPE) AS    
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
/

DECLARE
    book_isbn borrowings.isbn%TYPE;
BEGIN
    book_isbn := 11234;
    end_of_borrowing(book_isbn);
END;
/

SELECT * FROM borrowings;
--------------------------------------------------------------------------------
/*Μια διαδικασία για την προσθήκη ενός νέου βιβλίου στη συλλογή της βιβλιοθήκης*/
CREATE OR REPLACE PROCEDURE add_book(book_title books.title%TYPE, 
                                     book_writer books.writer%TYPE, 
                                     book_isbn books.isbn%TYPE, 
                                     book_category books.category%TYPE) 
AS 
BEGIN
    INSERT INTO books VALUES (book_title, book_writer, book_isbn, book_category);
    DBMS_OUTPUT.PUT_LINE('TO BIBLIO PROSTETHKE EPITUXWS STON PINAKA ME TA DIATHESIMA BIBLIA');
END add_book;
/

DECLARE
    book_title books.title%TYPE;
    book_writer books.writer%TYPE;    
    book_isbn books.isbn%TYPE;
    book_category books.category%TYPE;
BEGIN
    book_title := 'MIA NUXTA STO MOUSEIO';
    book_writer := 'ALEKOS PARAMUTHAS';
    book_isbn := 22345;
    book_category := 'PAIDIKA';
    add_book(book_title, book_writer, book_isbn, book_category);
END;
/

SELECT * FROM books;
--------------------------------------------------------------------------------
/*Μια διαδικασία για την προσθήκη νέου μέλους στη βιβλιοθήκη*/
CREATE OR REPLACE PROCEDURE add_member(member_id members.id%TYPE, 
                                       member_fname members.fname%TYPE, 
                                       member_lname members.lname%TYPE, 
                                       member_address members.address%TYPE) 
AS 
BEGIN
    INSERT INTO members VALUES (member_id, member_fname, member_lname, member_address);
    DBMS_OUTPUT.PUT_LINE('TO NEO MELOS PROSTETHKE EPITUXWS STON PINAKA');
END add_member;
/

DECLARE
    member_id members.id%TYPE;
    member_fname members.fname%TYPE; 
    member_lname members.lname%TYPE;
    member_address members.address%TYPE;    
BEGIN
    member_id := 22345;
    member_fname := 'VASILHS'; 
    member_lname := 'TOROSIDHS';
    member_address := 'XENOFONTOS 11';    
    add_member(member_id, member_fname, member_lname, member_address);
END;
/

SELECT * FROM members;
--------------------------------------------------------------------------------
/*Διαδικασία ενημέρωσης της ημερομηνίας λήξης ενός δανεισμού βιβλίου που είναι εν
ενεργεία*/
CREATE OR REPLACE PROCEDURE update_date(book_isbn borrowings.isbn%TYPE,
                                        book_day borrowings.day%TYPE) 
AS 
BEGIN
    UPDATE borrowings
    SET day = book_day
    WHERE isbn = book_isbn;
    DBMS_OUTPUT.PUT_LINE('H HMEROMHNIA TOU DANEISMOU ENHMERWTHKE EPITUXWS');
END update_date;
/

DECLARE
    book_isbn borrowings.isbn%TYPE;
    book_day borrowings.day%TYPE;
BEGIN
    book_isbn := 12345;
    booK_day := '18-01-2023';
    update_date(book_isbn, book_day);
END;
/

SELECT * FROM borrowings;
--------------------------------------------------------------------------------
