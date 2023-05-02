/*---------------------------------------------------------- 
MASV: 46.01.104.097
HO TEN: Lê Bảo Lộc
LAB: 04
NGAY: 14/04/2023
----------------------------------------------------------*/ 
/*--CAU LENH TAO DB*/
CREATE DATABASE [QLSV]
 /*CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QLSV', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\QLSV.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'QLSV_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\QLSV_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO*/

USE [QLSV]
GO

/*---------------------------------------------------------- 
MASV: 46.01.104.097
HO TEN: Lê Bảo Lộc
LAB: 04
NGAY: 14/04/2023
----------------------------------------------------------*/ 
/*--CAC CAU LENH TAO TABLE*/
CREATE TABLE SINHVIEN (
	MASV VARCHAR(20) PRIMARY KEY,
	HOTEN NVARCHAR(100) NOT NULL,
	NGAYSINH DATETIME,
	DIACHI NVARCHAR(200),
	MALOP VARCHAR(20),
	TENDN NVARCHAR(100) NOT NULL,
	MATKHAU VARBINARY(MAX) NOT NULL
)
GO


CREATE TABLE NHANVIEN (
	MANV VARCHAR(20) PRIMARY KEY,
	HOTEN NVARCHAR(100) NOT NULL,
	EMAIL VARCHAR(20),
	LUONG VARBINARY(MAX),
	TENDN NVARCHAR(100) NOT NULL,
	MATKHAU VARBINARY(MAX) NOT NULL
)
GO


CREATE TABLE LOP (
	MALOP VARCHAR(20) PRIMARY KEY,
	TENLOP NVARCHAR(100) NOT NULL,
	MANV VARCHAR(20)
)
GO

/*---------------------------------------------------------- 
MASV: 46.01.104.097
HO TEN: Lê Bảo Lộc
LAB: 04
NGAY: 14/04/2023
----------------------------------------------------------*/ 
/*CAU LENH TAO STORED PROCEDURE*/

--i/ Stored dùng để thêm mới dữ liệu (Insert) vào table SINHVIEN
/*ALTER TABLE SINHVIEN
ALTER COLUMN MATKHAU VARCHAR(32)
GO*/
Create proc SP_INS_SINHVIEN
	@MASV VARCHAR(20),
	@HOTEN NVARCHAR(100),
	@NGAYSINH DATETIME,
	@DIACHI NVARCHAR(200),
	@MALOP VARCHAR(20),
	@TENDN NVARCHAR(100),
	@MATKHAU VARCHAR(MAX)
As
	Begin
		Declare @MKBINARY VARBINARY(MAX);
		Set @MKBINARY = CONVERT(varbinary(max), HASHBYTES('MD5',@MATKHAU), 2);

		Insert Into SINHVIEN Values(@MASV, @HOTEN, @NGAYSINH, @DIACHI, @MALOP, @TENDN, @MKBINARY)
	End
GO

EXEC SP_INS_SINHVIEN 'SV01','NGUYEN VAN A','1/1/1990','280 AN DUONG VUONG','CNTT-K35','NVA','123456'
GO

DROP PROCEDURE SP_INS_SINHVIEN

SELECT * FROM dbo.SINHVIEN


--ii/ Stored dùng để thêm mới dữ liệu (Insert) vào table NHANVIEN

CREATE SYMMETRIC KEY SymmetricKey
WITH ALGORITHM = AES_256
ENCRYPTION BY PASSWORD = '46.01.104.097';
GO

Create proc SP_INS_NHANVIEN
	@MANV VARCHAR(20),
	@HOTEN NVARCHAR(100),
	@EMAIL VARCHAR(20),
	@LUONG VARCHAR(MAX),
	@TENDN NVARCHAR(100),
	@MATKHAU VARCHAR(MAX)
As
	Begin
		Declare @MKBINARY VARBINARY(MAX);
		Set @MKBINARY = CONVERT(varbinary(max), HASHBYTES('SHA1',@MATKHAU), 2);
		SET NOCOUNT ON;
	 
		OPEN SYMMETRIC KEY SymmetricKey
		DECRYPTION BY PASSWORD = '46.01.104.097' 

		INSERT INTO NHANVIEN(MANV, HOTEN, EMAIL, LUONG, TENDN, MATKHAU) 
		VALUES(@MANV, @HOTEN, @EMAIL, ENCRYPTBYKEY(KEY_GUID('SymmetricKey'), CONVERT(VARBINARY(MAX), @LUONG)) , @TENDN, @MKBINARY)

		CLOSE SYMMETRIC KEY SymmetricKey
	End
Go

EXEC SP_INS_NHANVIEN 'NV01', 'NGUYEN VAN A', 'NVA@', '3000000', 'NVA', 'abcd12'
GO

EXEC SP_INS_NHANVIEN 'NV02', 'NGUYEN VAN B', 'NVB@', '23000000', 'NVB', 'abcd12'
GO
			 
DROP PROCEDURE SP_INS_NHANVIEN

SELECT * FROM dbo.NHANVIEN


--iii/ Stored dùng để truy vấn dữ liệu nhân viên (NHANVIEN)
CREATE PROCEDURE SP_SEL_NHANVIEN
AS
BEGIN
	SELECT MANV, HOTEN, EMAIL, LUONG FROM NHANVIEN
END

EXEC SP_SEL_NHANVIEN

Drop Proc SP_SEL_NHANVIEN
GO

--e)Viết màn hình load danh sách nhân viên (sử dụng C#) như mô tả, Gọi stored procedure SP_SEL_ ENCRYPT _NHANVIEN, giải mã dữ liệu lương và hiển thị lên màn hình

CREATE PROCEDURE SP_SEL_ENCRYPT_NHANVIEN
AS
BEGIN
	OPEN SYMMETRIC KEY SymmetricKey
	DECRYPTION BY PASSWORD = '46.01.104.097'
	

	SELECT MANV, HOTEN, EMAIL, CONVERT(VARCHAR(MAX), DECRYPTBYKEY(LUONG)) AS LUONG FROM NHANVIEN

	CLOSE SYMMETRIC KEY SymmetricKey
END

EXEC SP_SEL_ENCRYPT_NHANVIEN
GO 

DROP PROC dbo.SP_SEL_ENCRYPT_NHANVIEN
GO 

DELETE FROM dbo.NHANVIEN WHERE MANV = 'NV02'

-- network protocol: LPC
set quoted_identifier on
set arithabort off
set numeric_roundabort off
set ansi_warnings on
set ansi_padding on
set ansi_nulls on
set concat_null_yields_null on
set cursor_close_on_commit off
set implicit_transactions off
set language us_english
set dateformat mdy
set datefirst 7
set transaction isolation level read committed

EXEC SP_INS_NHANVIEN 'NV02', N'NGUYEN VAN B', 'NVB@', '4000000', 'NVB', '123456'