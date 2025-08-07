-- ===========================
-- PostgreSQL Queries for Library DB
-- ===========================


-- 1. View all members
SELECT * FROM members;


-- 2. View all books
SELECT * FROM books;


-- 3. View all authors
SELECT * FROM authors;


-- 4. View all borrowings
SELECT * FROM borrowings;


-- 5. View all staff
SELECT * FROM staff;


-- 6. View all fines
SELECT * FROM fines;


-- 7. List members who joined after 2022
SELECT * FROM members WHERE membership_date > '2022-01-01';


-- 8. List books with fewer than 3 available copies
SELECT * FROM books WHERE available_copies < 3;


-- 9. Find all overdue borrowings (assuming today is '2025-08-07')
SELECT * FROM borrowings
WHERE return_date IS NULL AND borrow_date < CURRENT_DATE - INTERVAL '14 days';


-- 10. Get all books by 'J.K. Rowling'
SELECT b.title
FROM books b
JOIN authors a ON b.author_id = a.author_id
WHERE a.name = 'J.K. Rowling';


-- 11. Show all members who have borrowed books
SELECT DISTINCT m.member_id, m.name
FROM members m
JOIN borrowings b ON m.member_id = b.member_id;


-- 12. Show members who have never borrowed books
SELECT * FROM members
WHERE member_id NOT IN (
  SELECT member_id FROM borrowings
);


-- 13. Count total books in the library
SELECT SUM(total_copies) AS total_books FROM books;


-- 14. Count currently available books
SELECT SUM(available_copies) AS available_books FROM books;


-- 15. Find most borrowed book
SELECT book_id, COUNT(*) AS times_borrowed
FROM borrowings
GROUP BY book_id
ORDER BY times_borrowed DESC
LIMIT 1;


-- 16. List books not currently borrowed
SELECT * FROM books
WHERE book_id NOT IN (
  SELECT book_id FROM borrowings WHERE is_returned = FALSE
);


-- 17. List top 3 most active members (by borrow count)
SELECT member_id, COUNT(*) AS total_borrows
FROM borrowings
GROUP BY member_id
ORDER BY total_borrows DESC
LIMIT 3;


-- 18. Count number of books per genre
SELECT genre, COUNT(*) FROM books GROUP BY genre;


-- 19. List staff hired before 2020
SELECT * FROM staff WHERE hire_date < '2020-01-01';


-- 20. Show unpaid fines
SELECT * FROM fines WHERE paid = FALSE;


-- 21. Total unpaid fines amount
SELECT SUM(amount) FROM fines WHERE paid = FALSE;


-- 22. List members with unpaid fines
SELECT DISTINCT m.name
FROM members m
JOIN borrowings b ON m.member_id = b.member_id
JOIN fines f ON f.borrowing_id = b.borrowing_id
WHERE f.paid = FALSE;


-- 23. Update book availability after return
UPDATE books
SET available_copies = available_copies + 1
WHERE book_id = 3;


-- 24. Mark a borrowing as returned
UPDATE borrowings
SET is_returned = TRUE, return_date = CURRENT_DATE
WHERE borrowing_id = 2;


-- 25. Insert a new book
INSERT INTO books (title, author_id, published_year, genre, total_copies, available_copies)
VALUES ('Kafka on the Shore', 3, 2002, 'Fiction', 5, 5);


-- 26. Delete a staff record
DELETE FROM staff WHERE staff_id = 2;


-- 27. Find books published before year 2000
SELECT * FROM books WHERE published_year < 2000;


-- 28. Get books with no borrowings
SELECT * FROM books
WHERE book_id NOT IN (
  SELECT book_id FROM borrowings
);


-- 29. Total fines per member
SELECT m.name, SUM(f.amount) AS total_fines
FROM members m
JOIN borrowings b ON m.member_id = b.member_id
JOIN fines f ON f.borrowing_id = b.borrowing_id
GROUP BY m.name;


-- 30. Borrowings with fines over 4.00
SELECT * FROM fines WHERE amount > 4.00;


-- 31. Books that are completely checked out
SELECT * FROM books WHERE available_copies = 0;


-- 32. Percentage of books currently available
SELECT 
  ROUND(SUM(available_copies) * 100.0 / SUM(total_copies), 2) AS available_percentage
FROM books;


-- 33. List all borrowings and their fine amount (if any)
SELECT b.borrowing_id, b.book_id, f.amount
FROM borrowings b
LEFT JOIN fines f ON f.borrowing_id = b.borrowing_id;


-- 34. Authors with more than 1 book in the library
SELECT a.name, COUNT(*) AS book_count
FROM authors a
JOIN books b ON a.author_id = b.author_id
GROUP BY a.name
HAVING COUNT(*) > 1;


-- 35. Books borrowed in the last 7 days
SELECT * FROM borrowings
WHERE borrow_date >= CURRENT_DATE - INTERVAL '7 days';


-- 36. Count of books per author
SELECT a.name, COUNT(b.book_id) AS total_books
FROM authors a
LEFT JOIN books b ON a.author_id = b.author_id
GROUP BY a.name;


-- 37. Members who borrowed '1984'
SELECT m.name
FROM members m
JOIN borrowings b ON m.member_id = b.member_id
JOIN books bk ON b.book_id = bk.book_id
WHERE bk.title = '1984';


-- 38. Show borrowing history per member
SELECT m.name, bk.title, b.borrow_date, b.return_date
FROM borrowings b
JOIN members m ON b.member_id = m.member_id
JOIN books bk ON b.book_id = bk.book_id
ORDER BY m.name;


-- 39. Most recent borrowing per member (uses DISTINCT ON - PostgreSQL specific)
SELECT DISTINCT ON (member_id) member_id, book_id, borrow_date
FROM borrowings
ORDER BY member_id, borrow_date DESC;


-- 40. Books borrowed but not returned
SELECT bk.title, m.name
FROM borrowings b
JOIN books bk ON bk.book_id = b.book_id
JOIN members m ON m.member_id = b.member_id
WHERE is_returned = FALSE;


-- 41. Add a new column to books table (e.g., language)
ALTER TABLE books ADD COLUMN language VARCHAR(30);


-- 42. Update language values
UPDATE books SET language = 'English';


-- 43. Show members and number of overdue books
SELECT m.name, COUNT(*) AS overdue_books
FROM members m
JOIN borrowings b ON m.member_id = b.member_id
WHERE b.return_date IS NULL AND b.borrow_date < CURRENT_DATE - INTERVAL '14 days'
GROUP BY m.name;


-- 44. Get borrowings with duration (in days)
SELECT borrowing_id, 
       borrow_date, 
       return_date, 
       return_date - borrow_date AS duration
FROM borrowings
WHERE return_date IS NOT NULL;


-- 45. Calculate average fine amount
SELECT AVG(amount) FROM fines;


-- 46. Count books by genre and show only those with more than 1 book
SELECT genre, COUNT(*) FROM books GROUP BY genre HAVING COUNT(*) > 1;


-- 47. Borrowings without return date and not overdue yet
SELECT * FROM borrowings
WHERE return_date IS NULL AND borrow_date >= CURRENT_DATE - INTERVAL '14 days';


-- 48. Rename column 'language' to 'book_language'
ALTER TABLE books RENAME COLUMN language TO book_language;


-- 49. Drop a test column (if added)
ALTER TABLE books DROP COLUMN test_column;
