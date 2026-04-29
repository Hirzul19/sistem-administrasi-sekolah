<?php
class Student {
    private $conn;
    private $table = 'students';

    public function __construct($db) {
        $this->conn = $db;
    }

    public function getAll() {
        $query = "SELECT s.*, c.class_name FROM " . $this->table . " s 
                  LEFT JOIN classes c ON s.class_id = c.id 
                  ORDER BY s.full_name ASC";
        $result = $this->conn->query($query);
        return $result->fetch_all(MYSQLI_ASSOC);
    }

    public function getById($id) {
        $query = "SELECT s.*, c.class_name FROM " . $this->table . " s 
                  LEFT JOIN classes c ON s.class_id = c.id 
                  WHERE s.id = ?";
        $stmt = $this->conn->prepare($query);
        $stmt->bind_param("i", $id);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }

    public function create($data) {
        $query = "INSERT INTO " . $this->table . " (nis, full_name, gender, date_of_birth, place_of_birth, 
                  religion, phone, address, parent_name, parent_phone, class_id, status) 
                  VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $this->conn->prepare($query);
        $stmt->bind_param("ssssssssssii", $data['nis'], $data['full_name'], $data['gender'], 
                         $data['date_of_birth'], $data['place_of_birth'], $data['religion'], 
                         $data['phone'], $data['address'], $data['parent_name'], 
                         $data['parent_phone'], $data['class_id'], $data['status']);
        return $stmt->execute();
    }

    public function update($id, $data) {
        $query = "UPDATE " . $this->table . " SET nis = ?, full_name = ?, gender = ?, date_of_birth = ?, 
                  place_of_birth = ?, religion = ?, phone = ?, address = ?, parent_name = ?, 
                  parent_phone = ?, class_id = ?, status = ? WHERE id = ?";
        $stmt = $this->conn->prepare($query);
        $stmt->bind_param("sssssssssssii", $data['nis'], $data['full_name'], $data['gender'], 
                         $data['date_of_birth'], $data['place_of_birth'], $data['religion'], 
                         $data['phone'], $data['address'], $data['parent_name'], 
                         $data['parent_phone'], $data['class_id'], $data['status'], $id);
        return $stmt->execute();
    }

    public function delete($id) {
        $query = "DELETE FROM " . $this->table . " WHERE id = ?";
        $stmt = $this->conn->prepare($query);
        $stmt->bind_param("i", $id);
        return $stmt->execute();
    }

    public function getByClass($class_id) {
        $query = "SELECT * FROM " . $this->table . " WHERE class_id = ? AND status = 'aktif'";
        $stmt = $this->conn->prepare($query);
        $stmt->bind_param("i", $class_id);
        $stmt->execute();
        return $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    }
}
?>