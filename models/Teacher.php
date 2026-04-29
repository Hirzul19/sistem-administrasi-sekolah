<?php
class Teacher {
    private $conn;
    private $table = 'teachers';

    public function __construct($db) {
        $this->conn = $db;
    }

    public function getAll() {
        $query = "SELECT * FROM " . $this->table . " ORDER BY full_name ASC";
        $result = $this->conn->query($query);
        return $result->fetch_all(MYSQLI_ASSOC);
    }

    public function getById($id) {
        $query = "SELECT * FROM " . $this->table . " WHERE id = ?";
        $stmt = $this->conn->prepare($query);
        $stmt->bind_param("i", $id);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }

    public function create($data) {
        $query = "INSERT INTO " . $this->table . " (nip, full_name, gender, date_of_birth, email, 
                  phone, address, education, subject, status) 
                  VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $this->conn->prepare($query);
        $stmt->bind_param("ssssssssss", $data['nip'], $data['full_name'], $data['gender'], 
                         $data['date_of_birth'], $data['email'], $data['phone'], 
                         $data['address'], $data['education'], $data['subject'], $data['status']);
        return $stmt->execute();
    }

    public function update($id, $data) {
        $query = "UPDATE " . $this->table . " SET nip = ?, full_name = ?, gender = ?, date_of_birth = ?, 
                  email = ?, phone = ?, address = ?, education = ?, subject = ?, status = ? WHERE id = ?";
        $stmt = $this->conn->prepare($query);
        $stmt->bind_param("ssssssssssi", $data['nip'], $data['full_name'], $data['gender'], 
                         $data['date_of_birth'], $data['email'], $data['phone'], 
                         $data['address'], $data['education'], $data['subject'], $data['status'], $id);
        return $stmt->execute();
    }

    public function delete($id) {
        $query = "DELETE FROM " . $this->table . " WHERE id = ?";
        $stmt = $this->conn->prepare($query);
        $stmt->bind_param("i", $id);
        return $stmt->execute();
    }
}
?>