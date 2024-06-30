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

$stmt = $conn->prepare("SELECT id, username, avatar FROM users");
$stmt->execute();
$users = $stmt->fetchAll();
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Użytkownicy</title>
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

    <h1>Lista Użytkowników</h1>
    <div class="content">
        <?php foreach ($users as $user): ?>
            <div class="user">
            <p><?php if (!empty($user['avatar'])): ?>
                    <img class="avatar" src="uploads/<?= htmlspecialchars($user['avatar']) ?>" alt="Avatar" style="width:20px;height:20px;">
                <?php else: ?>
                    <img src="default-avatar.png" alt="No Avatar" style="width:20px;height:20px;">
                <?php endif; ?>
                <?= htmlspecialchars($user['username']) ?></p>
            </div>
        <?php endforeach; ?>
    </div>
</body>
</html>
