
CREATE TABLE BorrowedBooks (
   BorrowID INT PRIMARY KEY,
   MemberID INT,
   BookID INT,
   BorrowDate Date,
   ReturnDate DATE,
   FOREIGN KEY (BookID) REFERENCES Books (BookID)
   );

