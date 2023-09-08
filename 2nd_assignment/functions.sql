DROP FUNCTION book_availability;
DROP FUNCTION days_of_borrowing;
DROP FUNCTION fine;
DROP FUNCTION books_of_category;
--------------------------------------------------------------------------------
ALTER SESSION SET NLS_DATE_FORMAT='DD-MM-YYYY';
--------------------------------------------------------------------------------
/*Μια συνάρτηση για αναζήτηση βιβλίου με βάση το ISBN που θα επιστρέφει αν το 
βιβλίο είναι διαθέσιμο ή δανεισμένο*/
CREATE OR REPLACE FUNCTION book_availability(book_id IN NUMBER) RETURN NUMBER IS 
    daneismeno NUMBER := 1;
    fun_isbn NUMBER;
    CURSOR c1 IS
        SELECT isbn FROM borrowings;       
    CURSOR c2 IS
        SELECT isbn FROM books;    
BEGIN
    OPEN c1;
    LOOP
        FETCH c1 INTO fun_isbn;   --PSAXNW TA DANEISMENA BIBLIA MONO 
        EXIT WHEN c1%NOTFOUND;
        IF book_id = fun_isbn THEN  
            daneismeno := 1;
            RETURN daneismeno;
        ELSE
            daneismeno := 0;
        END IF;
    END LOOP;       
    CLOSE c1;
    OPEN c2;
    LOOP
        FETCH c2 INTO fun_isbn;   --PSAXNW OLO TON PINAKA TWN BIBLIWN
        EXIT WHEN c2%NOTFOUND;
        IF fun_isbn = book_id THEN
            daneismeno := 0;  
            RETURN daneismeno;
        ELSE
            daneismeno := 2;
        END IF;
    END LOOP;       
    CLOSE c2;
    RETURN daneismeno; 
END;
/

DECLARE
    res1 NUMBER;
    book_id NUMBER;
BEGIN
    book_id := 67890;
    res1 := book_availability(book_id);
    IF res1 = 1 THEN 
        DBMS_OUTPUT.PUT_LINE('TO BIBLIO EINAI DANEISMENO');
    ELSIF res1 = 0 THEN 
        DBMS_OUTPUT.PUT_LINE('TO BIBLIO EINAI DIATHESIMO');
    ELSE
        DBMS_OUTPUT.PUT_LINE('TO BIBLIO DEN YPARXEI GENIKA STH BIBLIOTHKH');
    END IF;
END;
/
--------------------------------------------------------------------------------
/*Μια συνάρτηση για αναζήτηση βιβλίου με βάση το ISBN που θα επιστρέφει πόσες 
μέρες είναι ήδη το βιβλίο σε δανεισμό*/
CREATE OR REPLACE FUNCTION days_of_borrowing(book_id IN NUMBER) RETURN NUMBER IS 
    fun_tuple borrowings%ROWTYPE;
    days NUMBER := 0;
    CURSOR c1 IS
        SELECT * FROM borrowings;       
BEGIN
    OPEN c1;
    LOOP
        FETCH c1 INTO fun_tuple;
        EXIT WHEN c1%NOTFOUND;
        IF book_id = fun_tuple.isbn THEN
            SELECT sysdate - fun_tuple.day INTO days FROM dual;
            RETURN days;
        END IF;
    END LOOP;
    CLOSE c1;
END;
/

DECLARE
    res1 NUMBER;
    res2 NUMBER;
    book_id NUMBER;
BEGIN
    book_id := 67890;
    res1 := book_availability(book_id);
    IF res1 = 1 THEN 
        res2 := days_of_borrowing(book_id);
        DBMS_OUTPUT.PUT_LINE('TO BIBLIO EINAI DANEISMENO '||TRUNC(res2)||' MERES'); 
    ELSIF res1 = 0 THEN 
        DBMS_OUTPUT.PUT_LINE('TO BIBLIO EINAI DIATHESIMO');
    ELSE
        DBMS_OUTPUT.PUT_LINE('TO BIBLIO DEN YPARXEI GENIKA STH BIBLIOTHKH');
    END IF;
END;
/
--------------------------------------------------------------------------------
/*Μια συνάρτηση για τον υπολογισμό του προστίμου για καθυστερημένη επιστροφή
βιβλίου*/
CREATE OR REPLACE FUNCTION fine(book_id IN NUMBER, 
                                res2 IN NUMBER) 
RETURN NUMBER IS
    fun_tuple borrowings%ROWTYPE;
    prostimo NUMBER := 0;
    CURSOR c1 IS
        SELECT * FROM borrowings;       
BEGIN
    OPEN c1;
    LOOP
        FETCH c1 INTO fun_tuple;
        EXIT WHEN c1%NOTFOUND;
        IF book_id = fun_tuple.isbn THEN
            IF res2 > 7 THEN
                prostimo := TRUNC(res2 - 7) * 2;
                RETURN prostimo;
            END IF;    
        END IF;
    END LOOP;
    CLOSE c1;
END;
/

DECLARE
    res1 NUMBER;
    res2 NUMBER;
    res3 NUMBER;
    book_id NUMBER;
BEGIN
    book_id := 67890;
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
END;
/
--------------------------------------------------------------------------------
/*Μια συνάρτηση που να επιστρέφει τα βιβλία (ISBN) μιας κατηγορίας*/
CREATE OR REPLACE FUNCTION books_of_category(book_category IN books.category%TYPE) RETURN NUMBER IS 
    fun_tuple books%ROWTYPE;
    CURSOR c1 IS
        SELECT * FROM books;             
BEGIN
    OPEN c1;
    LOOP
        FETCH c1 INTO fun_tuple;  
        EXIT WHEN c1%NOTFOUND;
        IF REGEXP_LIKE(fun_tuple.category, book_category) THEN  
            DBMS_OUTPUT.PUT_LINE('->'||fun_tuple.isbn);
        END IF;
    END LOOP;       
    CLOSE c1;
    RETURN 0;
END;
/

DECLARE
    res4 NUMBER;
    category books.category%TYPE;
BEGIN
    category := 'MAGEIRIKH';
    res4 := books_of_category(category);
END;
/
--------------------------------------------------------------------------------