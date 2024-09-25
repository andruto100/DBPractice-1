CREATE DATABASE MovieDB;
USE MovieDB;

CREATE TABLE Actors (
    ActorID INT AUTO_INCREMENT PRIMARY KEY,
    ActorName VARCHAR(100)
);

CREATE TABLE Movies (
    MovieID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(200),
    ReleaseYear INT,
    Genre VARCHAR(50),
    ProductionID INT
);

CREATE TABLE ProductionCompanies (
    ProductionID INT AUTO_INCREMENT PRIMARY KEY,
    CompanyName VARCHAR(100)
);

CREATE TABLE MovieCast (
    CastID INT AUTO_INCREMENT PRIMARY KEY,
    MovieID INT,
    ActorID INT,
    RoleName VARCHAR(100),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID),
    FOREIGN KEY (ActorID) REFERENCES Actors(ActorID)
);

CREATE TABLE BoxOffice (
    MovieID INT PRIMARY KEY,
    TotalGross DECIMAL(12, 2),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID)
);

CREATE TABLE Awards (
    AwardID INT AUTO_INCREMENT PRIMARY KEY,
    MovieID INT,
    AwardName VARCHAR(100),
    YearWon INT,
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID)
);

INSERT INTO Actors (ActorName) VALUES
('Leonardo DiCaprio'), 
('Johnny Depp'), 
('Scarlett Johansson'), 
('Emma Watson'), 
('Tom Hanks');

INSERT INTO ProductionCompanies (CompanyName) VALUES
('Warner Bros'), 
('Universal Pictures'), 
('Paramount Pictures'), 
('20th Century Studios'), 
('Netflix Studios');

INSERT INTO Movies (Title, ReleaseYear, Genre, ProductionID) VALUES
('Inception', 2010, 'Sci-Fi', 1),
('Pirates of the Caribbean', 2003, 'Adventure', 2),
('Avengers: Endgame', 2019, 'Action', 3),
('Beauty and the Beast', 2017, 'Fantasy', 4),
('Forrest Gump', 1994, 'Drama', 5);

INSERT INTO MovieCast (MovieID, ActorID, RoleName) VALUES
(1, 1, 'Cobb'),
(2, 2, 'Jack Sparrow'),
(3, 3, 'Black Widow'),
(4, 4, 'Belle'),
(5, 5, 'Forrest Gump');

INSERT INTO BoxOffice (MovieID, TotalGross) VALUES
(1, 829.89),
(2, 654.32),
(3, 2797.80),
(4, 1263.54),
(5, 678.90);

INSERT INTO Awards (MovieID, AwardName, YearWon) VALUES
(1, 'Oscar', 2011),
(2, 'BAFTA', 2004),
(3, 'Oscar', 2020),
(4, 'Golden Globe', 2018),
(5, 'Oscar', 1995);





WITH MovieStats AS (
    SELECT 
        mc.MovieID,
        bo.TotalGross,
        GROUP_CONCAT(DISTINCT aw.AwardName ORDER BY aw.YearWon) AS AwardNames,
        m.Genre AS Genre
    FROM MovieCast mc
    JOIN BoxOffice bo ON mc.MovieID = bo.MovieID
    LEFT JOIN Awards aw ON mc.MovieID = aw.MovieID
    JOIN Movies m ON mc.MovieID = m.MovieID
    GROUP BY mc.MovieID, bo.TotalGross, m.Genre
)

SELECT 
    m.Title AS MovieTitle,
    ms.TotalGross,
    ms.AwardNames,
    p.CompanyName AS ProductionCompany,
    a.ActorName AS `Main Star`,
    ms.Genre
FROM Movies m
JOIN MovieStats ms ON m.MovieID = ms.MovieID
JOIN ProductionCompanies p ON m.ProductionID = p.ProductionID
JOIN MovieCast mc ON m.MovieID = mc.MovieID
JOIN Actors a ON mc.ActorID = a.ActorID
WHERE m.ReleaseYear > 2000
GROUP BY m.MovieID, ms.TotalGross, ms.AwardNames, p.CompanyName, a.ActorName, ms.Genre

UNION ALL

SELECT 
    'Total Sales' AS MovieTitle,
    SUM(bo.TotalGross) AS TotalGross,
    NULL AS AwardNames,
    NULL AS ProductionCompany,
    NULL AS `Main Star`,
    NULL AS Genre
FROM BoxOffice bo

ORDER BY 
    CASE WHEN MovieTitle = 'Total Sales' THEN 1 ELSE 0 END, 
    TotalGross DESC;  




