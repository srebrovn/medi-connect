-- Create table
CREATE TABLE dbo.Appointment
(
    id            INT PRIMARY KEY IDENTITY (1000,1),
    start_time    DATETIME NOT NULL,
    end_time      DATETIME,
    title         NVARCHAR (255) NOT NULL,
    description   NVARCHAR (1000),
    status        NVARCHAR (255) DEFAULT 'Pending',
    doctor_id     INT NOT NULL,
    patient_id    INT NOT NULL,
    created_by    BIT DEFAULT 0, -- 0 - Patient, 1 - Doctor
    sys_timestamp DATETIME,
    sys_created   DATETIME
);

-- Create INSERT trigger
CREATE TRIGGER trAppointmentInsert
    ON dbo.Appointment
    INSTEAD OF INSERT
    AS
BEGIN

    INSERT INTO dbo.Appointment (start_time, end_time, title, status, description, doctor_id, patient_id, created_by, sys_timestamp, sys_created)
    SELECT start_time, end_time, title, status, description, doctor_id, patient_id, created_by, GETDATE(), GETDATE()
    FROM inserted;
END;

-- Create UPDATE trigger
CREATE TRIGGER trAppointmentUpdate
    ON dbo.Appointment
    AFTER UPDATE
    AS
BEGIN
    -- Set the sys_timestamp field to the current date and time for the updated records
    UPDATE dbo.Appointment
    SET sys_timestamp = GETDATE()
    FROM dbo.Appointment e
             INNER JOIN inserted i ON e.ID = i.ID;
END;

ALTER TABLE dbo.Appointment
ADD CONSTRAINT CK_Appointment_Status
CHECK (status IN ('Pending', 'Confirmed', 'Declined', 'Canceled'));



