CREATE DATABASE QuanLySinhVien;
GO

USE QuanLySinhVien;
GO

CREATE TABLE Class (
    ClassID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    ClassName VARCHAR(60) NOT NULL,
    StartDate DATETIME NOT NULL,
    Status BIT
);
GO

CREATE TABLE Student (
    StudentID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    StudentName VARCHAR(30) NOT NULL,
    Address VARCHAR(50),
    Phone VARCHAR(20),
    Status BIT,
    ClassID INT NOT NULL,
    FOREIGN KEY (ClassID) REFERENCES Class(ClassID)
);
GO

CREATE TABLE Subject (
    SubID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    SubName VARCHAR(30) NOT NULL,
    Credit TINYINT NOT NULL DEFAULT 1,
    Status BIT DEFAULT 1,
    CHECK (Credit >= 1)
);
GO

CREATE TABLE Mark (
    MarkID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    SubID INT NOT NULL,
    StudentID INT NOT NULL,
    Mark FLOAT DEFAULT 0,
    ExamTimes TINYINT DEFAULT 1,
    UNIQUE (SubID, StudentID),
    FOREIGN KEY (SubID) REFERENCES Subject(SubID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    CHECK (Mark BETWEEN 0 AND 100)
);
GO