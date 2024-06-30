<?php
include 'db.php';


if (!isset($_GET['id'])) {
    die('Brak ID tematu.');
}

$topic_id = $_GET['id'];

$stmt = $conn->prepare("SELECT topics.id, topics.title, topics.content, topics.image_path, users.username,
                        (SELECT COUNT(*) FROM reactions WHERE topic_id = topics.id AND type = 'like') AS likes,
                        (SELECT COUNT(*) FROM reactions WHERE topic_id = topics.id AND type = 'dislike') AS dislikes
                        FROM topics
                        JOIN users ON topics.user_id = users.id
                        WHERE topics.id = ?");
$stmt->execute([$topic_id]);
$topic = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$topic) {
    die('Temat nie istnieje.');
}


$stmt = $conn->prepare("SELECT comments.id, comments.content, comments.created_at, users.username, users.avatar,
                        (SELECT COUNT(*) FROM reactions WHERE comment_id = comments.id AND type = 'like') AS likes,
                        (SELECT COUNT(*) FROM reactions WHERE comment_id = comments.id AND type = 'dislike') AS dislikes
                        FROM comments
                        JOIN users ON comments.user_id = users.id
                        WHERE comments.topic_id = ?
                        ORDER BY comments.created_at DESC");
$stmt->execute([$topic_id]);
$comments = $stmt->fetchAll(PDO::FETCH_ASSOC);

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><?= htmlspecialchars($topic['title']) ?></title>
    <link rel="stylesheet" href="style.css">
    <script>
        function addReaction(isTopic, id, type) {
            fetch('add_reaction.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    is_topic: isTopic,
                    id: id,
                    type: type
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.message) {
                    alert(data.message);
                }

                if (data.likes !== undefined && data.dislikes !== undefined) {
                    if (isTopic) {
                        document.getElementById('topic-likes').textContent = data.likes;
                        document.getElementById('topic-dislikes').textContent = data.dislikes;
                    } else {
                        document.getElementById('comment-likes-' + id).textContent = data.likes;
                        document.getElementById('comment-dislikes-' + id).textContent = data.dislikes;
                    }
                }
            })
            .catch(error => console.error('Error:', error));
        }
    </script>
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
    <div class="content">
        <h1><?= htmlspecialchars($topic['title']) ?></h1>
        <p>Stworzone przez <?= htmlspecialchars($topic['username']) ?></p>
        <p>Treść: <?= nl2br(htmlspecialchars($topic['content'])) ?></p>
        <?php if ($topic['image_path']): ?>
            <img src="<?= htmlspecialchars($topic['image_path']) ?>" height="100px" width="auto" alt="<?= htmlspecialchars($topic['title']) ?>">
        <?php endif; ?>
        <div>
            <button onclick="addReaction(true, <?= $topic['id'] ?>, 'like')">👍</button>
            <span id="topic-likes"><?= $topic['likes'] ?></span>
            <button onclick="addReaction(true, <?= $topic['id'] ?>, 'dislike')">👎</button>
            <span id="topic-dislikes"><?= $topic['dislikes'] ?></span>

        </div>
    </div>

    <h2>Komentarze</h2>
    <ul>
        <?php foreach ($comments as $comment): ?>
            <li>
                <div class="comment-info">
                    <?php if (!empty($comment['avatar'])): ?>
                        <img class="avatar" src="uploads/<?= htmlspecialchars($comment['avatar']) ?>" alt="Avatar" style="width:20px;height:20px;">
                    <?php else: ?>
                        <img src="default-avatar.png" alt="No Avatar" style="width:20px;height:20px;">
                    <?php endif; ?> 
                    <span><?= htmlspecialchars($comment['username']) ?></span>: <?= htmlspecialchars($comment['content']) ?>
                </div>
                <div>
                    <button onclick="addReaction(false, <?= $comment['id'] ?>, 'like')">👍</button>
                    <span id="comment-likes-<?= $comment['id'] ?>"><?= $comment['likes'] ?></span>
                    <button onclick="addReaction(false, <?= $comment['id'] ?>, 'dislike')">👎</button>
                    <span id="comment-dislikes-<?= $comment['id'] ?>"><?= $comment['dislikes'] ?></span>

                </div>
            </li>
        <?php endforeach; ?>
    </ul>

    <?php if (isset($_SESSION['username'])): ?>
        <h2>Dodaj komentarz</h2>
        <form method="POST" action="add_comment.php">
            <input type="hidden" name="topic_id" value="<?= $topic['id'] ?>">
            <label>Zawartość: <br><textarea name="content" required></textarea></label><br>
            <button type="submit">Add Comment</button>
        </form>
    <?php endif; ?>
</body>
<script>
    function addReaction(isTopic, id, type) {
        fetch('add_reaction.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                is_topic: isTopic,
                id: id,
                type: type
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.message) {
                alert(data.message);
            }
            if (data.likes !== undefined && data.dislikes !== undefined) {
                if (isTopic) {
                    document.getElementById('topic-likes').textContent = data.likes;
                    document.getElementById('topic-dislikes').textContent = data.dislikes;
                } else {
                    document.getElementById('comment-likes-' + id).textContent = data.likes;
                    document.getElementById('comment-dislikes-' + id).textContent = data.dislikes;
                }
            }
        })
        .catch(error => console.error('Error:', error));
    }
</script>

</html>
