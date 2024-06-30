<?php
include 'db.php';

if (isBanned($conn)) {
    echo "Twoje konto jest zablokowane.";
    exit();
}

$results = [];

if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['query'])) {
    $query = $_GET['query'];


    $stmt = $conn->prepare("SELECT DISTINCT topics.id, topics.title, users.username 
                            FROM topics 
                            JOIN users ON topics.user_id = users.id 
                            WHERE topics.title LIKE ?");
    $stmt->execute(['%' . $query . '%']);
    $results = $stmt->fetchAll();


    $stmt_tag = $conn->prepare("SELECT DISTINCT topics.id, topics.title, users.username 
                                FROM topics 
                                JOIN users ON topics.user_id = users.id 
                                JOIN topic_tags ON topics.id = topic_tags.topic_id 
                                JOIN tags ON topic_tags.tag_id = tags.id 
                                WHERE tags.name LIKE ?");
    $stmt_tag->execute(['%' . $query . '%']);
    $results_tag = $stmt_tag->fetchAll();


    $results = array_merge($results, $results_tag);

    $results = array_unique($results, SORT_REGULAR);
}


?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Wyszukiwanie</title>
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

    <h1>Wyszukiwanie</h1>
    <form method="GET">
        <input type="text" name="query" placeholder="Szukaj tematu lub tagu...">
        <button type="submit">Szukaj</button>
    </form>

    <h2>Wyniki wyszukiwania:</h2>
    <ul>
        <?php foreach ($results as $result): ?>
            <li>
                <a href="topic.php?id=<?= $result['id'] ?>"><?= htmlspecialchars($result['title']) ?></a> by <?= htmlspecialchars($result['username']) ?>
            </li>
        <?php endforeach; ?>
    </ul>
</body>
</html>
