<?php
class StudentAttendance {
    private $conn;
    private $table = 'student_attendance';

    public function __construct($db) {
        $this->conn = $db;
    }

    public function create($data) {
        $query = "INSERT INTO " . $this->table . " (student_id, attendance_date, status, notes) 
                  VALUES (?, ?, ?, ?) 
                  ON DUPLICATE KEY UPDATE status = ?, notes = ?";
        $stmt = $this->conn->prepare($query);
        $stmt->bind_param("isssss", $data['student_id'], $data['attendance_date'], 
                         $data['status'], $data['notes'], $data['status'], $data['notes']);
        return $stmt->execute();
    }

    public function getByStudent($student_id, $month = null, $year = null) {
        $query = "SELECT * FROM " . $this->table . " WHERE student_id = ?";
        
        if ($month && $year) {
            $query .= " AND MONTH(attendance_date) = ? AND YEAR(attendance_date) = ?";
        }
        
        $query .= " ORDER BY attendance_date DESC";
        
        $stmt = $this->conn->prepare($query);
        
        if ($month && $year) {
            $stmt->bind_param("iii", $student_id, $month, $year);
        } else {
            $stmt->bind_param("i", $student_id);
        }
        
        $stmt->execute();
        return $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    public function getByClass($class_id, $date) {
        $query = "SELECT sa.*, s.full_name FROM " . $this->table . " sa 
                  JOIN students s ON sa.student_id = s.id 
                  WHERE s.class_id = ? AND sa.attendance_date = ?
                  ORDER BY s.full_name ASC";
        $stmt = $this->conn->prepare($query);
        $stmt->bind_param("is", $class_id, $date);
        $stmt->execute();
        return $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    public function getStatistics($student_id, $month, $year) {
        $query = "SELECT 
                    COUNT(*) as total,
                    SUM(CASE WHEN status = 'hadir' THEN 1 ELSE 0 END) as hadir,
                    SUM(CASE WHEN status = 'alfa' THEN 1 ELSE 0 END) as alfa,
                    SUM(CASE WHEN status = 'sakit' THEN 1 ELSE 0 END) as sakit,
                    SUM(CASE WHEN status = 'izin' THEN 1 ELSE 0 END) as izin
                  FROM " . $this->table . " 
                  WHERE student_id = ? AND MONTH(attendance_date) = ? AND YEAR(attendance_date) = ?";
        $stmt = $this->conn->prepare($query);
        $stmt->bind_param("iii", $student_id, $month, $year);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }
}
?>