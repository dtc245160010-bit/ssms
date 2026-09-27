/* =====================================================
   HEALTHSYNC DATABASE
   SQL SERVER / SSMS
   ===================================================== */

-- 1. TẠO DATABASE
CREATE DATABASE healthsync_db;
GO

USE healthsync_db;
GO


/* =====================================================
   2. TẠO BẢNG PATIENTS
   ===================================================== */

CREATE TABLE Patients (
    patient_id INT IDENTITY(1,1) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL
);
GO


/* =====================================================
   3. TẠO BẢNG DOCTORS
   ===================================================== */

CREATE TABLE Doctors (
    doctor_id INT IDENTITY(1,1) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(50)
);
GO


/* =====================================================
   4. TẠO BẢNG APPOINTMENTS - CẤU TRÚC CŨ
   ===================================================== */

CREATE TABLE Appointments (
    appointment_id INT IDENTITY(1,1) PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATETIME NOT NULL,
    is_active BIT DEFAULT 1,

    FOREIGN KEY (patient_id)
        REFERENCES Patients(patient_id),

    FOREIGN KEY (doctor_id)
        REFERENCES Doctors(doctor_id)
);
GO


/* =====================================================
   5. SỬA APPOINTMENTS
   XÓA DEFAULT CONSTRAINT CỦA is_active
   ===================================================== */

ALTER TABLE Appointments
DROP CONSTRAINT DF__Appointme__is_ac__3B75D760;
GO


/* =====================================================
   6. XÓA is_active
   ===================================================== */

ALTER TABLE Appointments
DROP COLUMN is_active;
GO


/* =====================================================
   7. THÊM STATUS
   SQL SERVER KHÔNG CÓ ENUM
   => DÙNG VARCHAR + CHECK
   ===================================================== */

ALTER TABLE Appointments
ADD status VARCHAR(20) NOT NULL
    CONSTRAINT DF_Appointments_Status DEFAULT 'PENDING';
GO


ALTER TABLE Appointments
ADD CONSTRAINT CK_Appointments_Status
CHECK (
    status IN (
        'PENDING',
        'CONFIRMED',
        'CHECKED_IN',
        'COMPLETED',
        'CANCELLED'
    )
);
GO


/* =====================================================
   8. THÊM TIỀN CỌC, PHÍ PHẠT, LÝ DO HỦY
   ===================================================== */

ALTER TABLE Appointments
ADD deposit_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    penalty_fee DECIMAL(12,2) NOT NULL DEFAULT 0,
    cancel_reason VARCHAR(255);
GO


/* =====================================================
   9. TẠO BẢNG PRESCRIPTIONS
   ===================================================== */

CREATE TABLE Prescriptions (
    prescription_id INT IDENTITY(1,1) PRIMARY KEY,
    appointment_id INT NOT NULL,
    medication_details VARCHAR(MAX),
    issued_date DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Prescriptions_Appointments
        FOREIGN KEY (appointment_id)
        REFERENCES Appointments(appointment_id)
);
GO


/* =====================================================
   10. THÊM BỆNH NHÂN
   ===================================================== */

INSERT INTO Patients (full_name, phone)
VALUES
('Nguyen Van A', '0900000001'),
('Tran Thi B', '0900000002');
GO


/* =====================================================
   11. THÊM BÁC SĨ
   ===================================================== */

INSERT INTO Doctors (full_name, specialty)
VALUES
('Nguyen Van Bac Si', 'Noi khoa'),
('Tran Thi Bac Si', 'Ngoai khoa');
GO


/* =====================================================
   KỊCH BẢN 1
   PENDING -> CHECKED_IN -> COMPLETED
   CỌC 500.000
   ===================================================== */

INSERT INTO Appointments
(
    patient_id,
    doctor_id,
    appointment_date,
    status,
    deposit_amount
)
VALUES
(
    1,
    1,
    '2026-09-28 08:00:00',
    'PENDING',
    500000
);
GO


-- Bệnh nhân đến khám
UPDATE Appointments
SET status = 'CHECKED_IN'
WHERE appointment_id = 1;
GO


-- Khám xong
UPDATE Appointments
SET status = 'COMPLETED'
WHERE appointment_id = 1;
GO


-- Bác sĩ kê đơn
INSERT INTO Prescriptions
(
    appointment_id,
    medication_details
)
VALUES
(
    1,
    'Paracetamol 500mg, uong 2 lan/ngay'
);
GO


/* =====================================================
   KỊCH BẢN 2
   CONFIRMED -> CANCELLED
   CỌC 300.000
   PHẠT 150.000
   ===================================================== */

INSERT INTO Appointments
(
    patient_id,
    doctor_id,
    appointment_date,
    status,
    deposit_amount
)
VALUES
(
    2,
    2,
    '2026-09-29 09:00:00',
    'CONFIRMED',
    300000
);
GO


-- Hủy lịch + lý do + phí phạt
UPDATE Appointments
SET
    status = 'CANCELLED',
    cancel_reason = N'Bận việc đột xuất',
    penalty_fee = 150000
WHERE appointment_id = 2;
GO


/* =====================================================
   12. KIỂM TRA APPOINTMENTS
   ===================================================== */

SELECT
    appointment_id,
    patient_id,
    doctor_id,
    appointment_date,
    status,
    deposit_amount,
    penalty_fee,
    cancel_reason
FROM Appointments;
GO


/* =====================================================
   13. KIỂM TRA PRESCRIPTIONS
   ===================================================== */

SELECT *
FROM Prescriptions;
GO


/* =====================================================
   14. JOIN KIỂM TRA BỆNH NHÂN ĐÃ KHÁM + ĐƠN THUỐC
   ===================================================== */

SELECT
    a.appointment_id,
    p.full_name AS Patient,
    a.status,
    a.deposit_amount,
    pr.medication_details,
    pr.issued_date
FROM Appointments a
JOIN Patients p
    ON a.patient_id = p.patient_id
JOIN Prescriptions pr
    ON a.appointment_id = pr.appointment_id
WHERE a.status = 'COMPLETED';
GO


/* =====================================================
   15. KIỂM TRA LỊCH ĐÃ HỦY VÀ TIỀN PHẠT
   ===================================================== */

SELECT
    a.appointment_id,
    p.full_name AS Patient,
    a.status,
    a.deposit_amount,
    a.penalty_fee,
    a.cancel_reason
FROM Appointments a
JOIN Patients p
    ON a.patient_id = p.patient_id
WHERE a.status = 'CANCELLED';
GO