CREATE DATABASE IF NOT EXISTS MedicalSystem;

USE MedicalSystem;

CREATE TABLE IF NOT EXISTS Roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(255) NOT NULL UNIQUE
);



CREATE TABLE IF NOT EXISTS Positions (
    position_id INT AUTO_INCREMENT PRIMARY KEY,
    position_name VARCHAR(255) NOT NULL,
    description TEXT NULL
);

CREATE TABLE IF NOT EXISTS Employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    position_id INT NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    middle_name VARCHAR(255) NULL,
    date_of_birth DATE NULL,
    gender ENUM('Male', 'Female') NULL,
    phone_number VARCHAR(20) NULL,
    email VARCHAR(255) NULL,
    hire_date DATE NOT NULL,
    fire_date DATE NULL,
    FOREIGN KEY (position_id) REFERENCES Positions (position_id)
);

CREATE TABLE IF NOT EXISTS Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NULL, -- Связь с сотрудником (если это сотрудник больницы)
    role_id INT NOT NULL,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Хранить хешированный пароль
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    middle_name VARCHAR(255) NULL,
    email VARCHAR(255) NULL,
    FOREIGN KEY (role_id) REFERENCES Roles (role_id),
    FOREIGN KEY (employee_id) REFERENCES Employees (employee_id) -- Может быть NULL, если это внешний пользователь
);

CREATE TABLE IF NOT EXISTS DoctorSpecialties (
    specialty_id INT AUTO_INCREMENT PRIMARY KEY,
    specialty_name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS Doctors (
    doctor_id INT PRIMARY KEY REFERENCES Employees (employee_id), -- Врачи - это сотрудники
    specialty_id INT NOT NULL,
    user_id INT NULL, -- Связь с таблицей Users
    FOREIGN KEY (specialty_id) REFERENCES DoctorSpecialties (specialty_id),
    FOREIGN KEY (user_id) REFERENCES Users (user_id)
);

CREATE TABLE IF NOT EXISTS Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    middle_name VARCHAR(255) NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female') NOT NULL,
    address VARCHAR(255) NULL,
    phone_number VARCHAR(20) NULL,
    email VARCHAR(255) NULL,
    medical_history TEXT NULL
);

CREATE TABLE IF NOT EXISTS DoctorSchedules (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    work_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (doctor_id) REFERENCES Doctors (doctor_id)
);

CREATE TABLE IF NOT EXISTS Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    schedule_id INT NULL, -- Ссылка на расписание, если прием запланирован
    appointment_date DATETIME NOT NULL,
    complaints TEXT NULL,
    diagnosis TEXT NULL,
    treatment TEXT NULL,
    FOREIGN KEY (patient_id) REFERENCES Patients (patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors (doctor_id),
    FOREIGN KEY (schedule_id) REFERENCES DoctorSchedules (schedule_id)
);

CREATE TABLE IF NOT EXISTS SickLeaves (
    sick_leave_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_id INT NULL,  -- Ссылка на прием, на котором был выдан больничный
    issue_date DATE NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    diagnosis TEXT NULL,
    notes TEXT NULL,
    closed_date DATE NULL, -- Дата закрытия больничного
    FOREIGN KEY (patient_id) REFERENCES Patients (patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors (doctor_id),
    FOREIGN KEY (appointment_id) REFERENCES Appointments (appointment_id)
);

CREATE TABLE IF NOT EXISTS Medications (
    medication_id INT AUTO_INCREMENT PRIMARY KEY,
    medication_name VARCHAR(255) NOT NULL,
    description TEXT NULL
);

CREATE TABLE IF NOT EXISTS Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    medication_id INT NOT NULL,
    dosage VARCHAR(255) NULL,
    instructions TEXT NULL,
    FOREIGN KEY (appointment_id) REFERENCES Appointments (appointment_id),
    FOREIGN KEY (medication_id) REFERENCES Medications (medication_id)
);


CREATE INDEX idx_patients_last_name ON Patients (last_name);
CREATE INDEX idx_appointments_patient_id ON Appointments (patient_id);
CREATE INDEX idx_sick_leaves_patient_id ON SickLeaves (patient_id);
CREATE INDEX idx_doctors_specialty_id ON Doctors (specialty_id);
CREATE INDEX idx_employees_last_name ON Employees (last_name);
CREATE INDEX idx_users_username ON Users (username); 

