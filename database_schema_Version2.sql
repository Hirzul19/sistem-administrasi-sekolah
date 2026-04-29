-- =====================================================
-- DATABASE: sekolah_admin
-- SISTEM ADMINISTRASI SEKOLAH
-- =====================================================

-- Buat Database
CREATE DATABASE IF NOT EXISTS sekolah_admin;
USE sekolah_admin;

-- =====================================================
-- TABLE: users (Login Admin, Guru, Staff)
-- =====================================================
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('admin', 'guru', 'staff') DEFAULT 'staff',
    phone VARCHAR(15),
    address TEXT,
    status ENUM('aktif', 'tidak_aktif') DEFAULT 'aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: classes (Kelas)
-- =====================================================
CREATE TABLE IF NOT EXISTS classes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    class_name VARCHAR(50) NOT NULL UNIQUE,
    grade INT NOT NULL,
    teacher_id INT,
    capacity INT DEFAULT 40,
    academic_year VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE SET NULL,
    INDEX idx_class_name (class_name),
    INDEX idx_grade (grade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: teachers (Guru)
-- =====================================================
CREATE TABLE IF NOT EXISTS teachers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nip VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    gender ENUM('L', 'P') NOT NULL,
    date_of_birth DATE NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(15),
    address TEXT,
    education VARCHAR(100),
    subject VARCHAR(100),
    status ENUM('aktif', 'cuti', 'pensiun') DEFAULT 'aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_nip (nip),
    INDEX idx_full_name (full_name),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: students (Siswa)
-- =====================================================
CREATE TABLE IF NOT EXISTS students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nis VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    gender ENUM('L', 'P') NOT NULL,
    date_of_birth DATE NOT NULL,
    place_of_birth VARCHAR(100),
    religion VARCHAR(50),
    phone VARCHAR(15),
    address TEXT,
    parent_name VARCHAR(100),
    parent_phone VARCHAR(15),
    class_id INT NOT NULL,
    status ENUM('aktif', 'lulus', 'keluar') DEFAULT 'aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE,
    INDEX idx_nis (nis),
    INDEX idx_full_name (full_name),
    INDEX idx_class_id (class_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: student_attendance (Absensi Siswa)
-- =====================================================
CREATE TABLE IF NOT EXISTS student_attendance (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status ENUM('hadir', 'alfa', 'sakit', 'izin') DEFAULT 'hadir',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    UNIQUE KEY unique_attendance (student_id, attendance_date),
    INDEX idx_student_id (student_id),
    INDEX idx_attendance_date (attendance_date),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: teacher_attendance (Absensi Guru)
-- =====================================================
CREATE TABLE IF NOT EXISTS teacher_attendance (
    id INT PRIMARY KEY AUTO_INCREMENT,
    teacher_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status ENUM('hadir', 'alfa', 'sakit', 'izin') DEFAULT 'hadir',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE CASCADE,
    UNIQUE KEY unique_attendance (teacher_id, attendance_date),
    INDEX idx_teacher_id (teacher_id),
    INDEX idx_attendance_date (attendance_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: student_outstanding (Tunggakan Siswa)
-- =====================================================
CREATE TABLE IF NOT EXISTS student_outstanding (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    month VARCHAR(20) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_status ENUM('belum_dibayar', 'sebagian', 'lunas') DEFAULT 'belum_dibayar',
    payment_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    INDEX idx_student_id (student_id),
    INDEX idx_payment_status (payment_status),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: academic_year (Tahun Ajaran)
-- =====================================================
CREATE TABLE IF NOT EXISTS academic_year (
    id INT PRIMARY KEY AUTO_INCREMENT,
    year VARCHAR(10) NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_active TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_year (year),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- INSERT DEFAULT DATA
-- =====================================================

-- Insert Default Admin User
-- Username: admin
-- Password: admin123 (hashed with SHA2)
INSERT INTO users (username, password, email, full_name, role, status) 
VALUES ('admin', '240be518fabd2724ddb6f04eeb1da5967448d7e1c33ddef7e82b151ca4bfe47d', 'admin@sekolah.local', 'Administrator Sekolah', 'admin', 'aktif');

-- Insert Default Academic Year
INSERT INTO academic_year (year, start_date, end_date, is_active) 
VALUES ('2025-2026', '2025-07-01', '2026-06-30', 1);

-- Insert Sample Classes
INSERT INTO classes (class_name, grade, capacity, academic_year) VALUES 
('X-A', 10, 35, '2025-2026'),
('X-B', 10, 36, '2025-2026'),
('XI-A', 11, 34, '2025-2026'),
('XI-B', 11, 35, '2025-2026'),
('XII-A', 12, 32, '2025-2026'),
('XII-B', 12, 33, '2025-2026');

-- =====================================================
-- PRIVILEGES & PERMISSIONS
-- =====================================================
-- Uncomment dan edit sesuai kebutuhan server Anda
-- CREATE USER 'sekolah_user'@'localhost' IDENTIFIED BY 'password_sekolah';
-- GRANT ALL PRIVILEGES ON sekolah_admin.* TO 'sekolah_user'@'localhost';
-- FLUSH PRIVILEGES;