<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "motoryzacyjne_forum";

$conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

session_start();

function isAdmin() {
    return isset($_SESSION['role']) && $_SESSION['role'] === 'admin';
}

function isBanned($conn) {
    if (isset($_SESSION['user_id'])) {
        $stmt = $conn->prepare("SELECT banned FROM users WHERE id = ?");
        $stmt->execute([$_SESSION['user_id']]);
        return $stmt->fetchColumn();
    }
    return false;
}
?>
