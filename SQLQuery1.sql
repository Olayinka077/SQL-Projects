

CREATE TABLE Books (
    BookID INT PRIMARY KEY,     --- Unique ID for each book
	Title VARCHAR (100),        --- Book title
	Author VARCHAR (100),       --- Author's name
	Genre VARCHAR (50),         --- Book genre (e.g., Fiction, Mystery)
	PublishedYear INT,          --- Year the book was published
	Price DECIMAL (10,2),       --- Price of the book
	);

INSERT INTO Books (BookID, Title, Author, Genre, PublishedYear, Price)
VALUES
(1, 'Atomic Habits', 'James Clear', 'Self-Help', 2018, 15.99),
(2, 'The Alchemist', 'Paulo Coelho', 'Fiction', 1988, 9.99),
(3, 'Sapiens', 'Yuval Norah Harari', 'History', 2011, 19.99),
(4, 'Harry Potter', 'J.K. Rowling', 'Fantasy', 1997, 29.99);

Select *
From Books

ALTER TABLE Books
ADD Stock INT DEFAULT 10;

UPDATE Books 
SET Stock = 0
WHERE Title = 'Sapiens';

ALTER Table Books

DROP Stock;

Truncate Table Books;

INSERT INTO Books (BookID, Title, Author, Genre, PublishedYear, Price)
VALUES
(1, 'Atomic Habits', 'James Clear', 'Self-Help', 2018, 15.99),
(2, 'The Alchemist', 'Paulo Coelho', 'Fiction', 1988, 9.99),
(3, 'Sapiens', 'Yuval Norah Harari', 'History', 2011, 19.99),
(4, 'Harry Potter', 'J.K. Rowling', 'Fantasy', 1997, 29.99);

DELETE FROM Books
WHERE Title = 'Harry Potter';

INSERT INTO Books (BookID, Title, Author, Genre, PublishedYear, Price)
VALUES
(4, 'Harry Potter', 'J.K. Rowling', 'Fantasy', 1997, 29.99);

CREATE VIEW FictionBooks AS
SELECT Title, Author, Price
FROM Books
WHERE Genre = 'Fiction';







