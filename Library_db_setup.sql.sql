-- ===========================
-- Library Management System
-- PostgreSQL Setup Script
-- ===========================

CREATE DATABASE library_management;


-- 1. Create 'members' table to store library members
CREATE TABLE members (
    member_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    membership_date DATE
);


-- 2. Create 'authors' table to store book authors
CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    nationality VARCHAR(50)
);


-- 3. Create 'books' table to store book records
CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(150),
    author_id INT REFERENCES authors(author_id),
    published_year INT,
    genre VARCHAR(50),
    total_copies INT,
    available_copies INT
);


-- 4. Create 'borrowings' table to track which member borrowed which book
CREATE TABLE borrowings (
    borrowing_id SERIAL PRIMARY KEY,
    member_id INT REFERENCES members(member_id),
    book_id INT REFERENCES books(book_id),
    borrow_date DATE,
    return_date DATE,
    is_returned BOOLEAN DEFAULT FALSE
);


-- 5. Create 'staff' table to manage library staff
CREATE TABLE staff (
    staff_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    position VARCHAR(50),
    hire_date DATE
);


-- 6. Create 'fines' table to track overdue or penalty charges
CREATE TABLE fines (
    fine_id SERIAL PRIMARY KEY,
    borrowing_id INT REFERENCES borrowings(borrowing_id),
    amount NUMERIC(6,2),
    paid BOOLEAN DEFAULT FALSE
);


-- ===========================
-- Sample Data Insertion
-- ===========================


-- Insert members
INSERT INTO members (name, email, membership_date) VALUES
('Alice Johnson', 'alice@example.com', '2022-01-15'),
('Bob Smith', 'bob@example.com', '2023-03-10'),
('Charlie Lee', 'charlie@example.com', '2021-07-22');


-- Insert authors
INSERT INTO authors (name, nationality) VALUES
('J.K. Rowling', 'British'),
('George Orwell', 'British'),
('Haruki Murakami', 'Japanese');


-- Insert books
INSERT INTO books (title, author_id, published_year, genre, total_copies, available_copies) VALUES
('1984', 2, 1949, 'Dystopian', 5, 3),
('Norwegian Wood', 3, 1987, 'Romance', 4, 4),
('Harry Potter and the Philosopher\'s Stone', 1, 1997, 'Fantasy', 6, 2);


-- Insert staff
INSERT INTO staff (name, position, hire_date) VALUES
('Susan Blake', 'Librarian', '2019-09-01'),
('David Miller', 'Assistant', '2021-04-18');


-- Insert borrowings
INSERT INTO borrowings (member_id, book_id, borrow_date, return_date, is_returned) VALUES
(1, 1, '2025-08-01', '2025-08-15', TRUE),
(2, 3, '2025-08-05', NULL, FALSE),
(3, 2, '2025-08-02', NULL, FALSE);


-- Insert fines
INSERT INTO fines (borrowing_id, amount, paid) VALUES
(1, 0.00, TRUE),
(2, 5.00, FALSE);
