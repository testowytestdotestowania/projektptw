<?php
include 'db.php';

if (isBanned($conn)) {
    echo "Twoje konto jest zablokowane.";
    exit();
}

if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

$stmt = $conn->prepare("SELECT * FROM users WHERE id = ?");
$stmt->execute([$_SESSION['user_id']]);
$user = $stmt->fetch();
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Regulamin</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <img src="logo.png" class="logo" alt="logo">
    <nav>
        <a href="index.php">Strona Główna</a>
        <a href="search.php">Wyszukiwanie</a>
        <a href="users.php">Użytkownicy</a>
        <a href="rules.php">Regulamin</a>
        <?php if (isset($_SESSION['username'])): ?>
            <?php if (isAdmin()): ?>
                <a href="admin_panel.php">Panel Administratora</a>
            <?php endif; ?>
            <a href="profile.php">Profil</a>
            <a href="logout.php">Wyloguj</a>
        <?php else: ?>
            <a href="register.php">Rejestracja</a>
            <a href="login.php">Logowanie</a>
        <?php endif; ?>
    </nav>

    <h1>Regulamin</h1>
    <p class="rules">
        1. Użytkownicy są zobowiązani do przestrzegania zasad kultury osobistej.<br>
        2. Zabrania się umieszczania treści niezgodnych z prawem.<br>
        3. Administracja forum ma prawo do usuwania postów i banowania użytkowników naruszających regulamin.<br>
        4. Użytkownicy są zobowiązani do poszanowania prywatności innych użytkowników.<br>
        5. Reklamowanie innych stron bez zgody administracji jest zabronione.<br>
    </p>
</body>
</html>
