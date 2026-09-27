CREATE DATABASE QuanLyBanHang;
GO

USE QuanLyBanHang;
GO

-- Bảng Customer
CREATE TABLE Customer (
    cID INT IDENTITY(1,1) PRIMARY KEY,
    cName VARCHAR(50) NOT NULL,
    cAge INT
);
GO

-- Bảng Product
CREATE TABLE Product (
    pID INT IDENTITY(1,1) PRIMARY KEY,
    pName VARCHAR(50) NOT NULL,
    pPrice DECIMAL(12,2) NOT NULL
);
GO

-- Bảng Orders
CREATE TABLE Orders (
    oID INT IDENTITY(1,1) PRIMARY KEY,
    cID INT NOT NULL,
    oDate DATE NOT NULL,

    CONSTRAINT FK_Orders_Customer
        FOREIGN KEY (cID) REFERENCES Customer(cID)
);
GO

-- Bảng OrderDetail
CREATE TABLE OrderDetail (
    oID INT NOT NULL,
    pID INT NOT NULL,
    odQTY INT NOT NULL,

    CONSTRAINT PK_OrderDetail
        PRIMARY KEY (oID, pID),

    CONSTRAINT FK_OrderDetail_Orders
        FOREIGN KEY (oID) REFERENCES Orders(oID),

    CONSTRAINT FK_OrderDetail_Product
        FOREIGN KEY (pID) REFERENCES Product(pID)
);
GO



USE QuanLyBanHang;
GO

SELECT * FROM Customer;
SELECT * FROM Product;
SELECT * FROM Orders;
SELECT * FROM OrderDetail;