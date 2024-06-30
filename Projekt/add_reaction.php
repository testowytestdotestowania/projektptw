<?php
include 'db.php';

if (!isset($_SESSION['user_id'])) {
    http_response_code(401);
    exit(json_encode(['error' => 'Użytkownik nie jest zalogowany.']));
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    $isTopic = $data['is_topic'];
    $id = $data['id'];
    $type = $data['type'];
    $user_id = $_SESSION['user_id'];

    if ($isTopic) {
        $stmt = $conn->prepare("SELECT * FROM reactions WHERE topic_id = ? AND user_id = ?");
        $stmt->execute([$id, $user_id]);
    } else {
        $stmt = $conn->prepare("SELECT * FROM reactions WHERE comment_id = ? AND user_id = ?");
        $stmt->execute([$id, $user_id]);
    }

    if ($stmt->rowCount() > 0) {
        if ($isTopic) {
            $stmt = $conn->prepare("DELETE FROM reactions WHERE topic_id = ? AND user_id = ?");
            $stmt->execute([$id, $user_id]);
        } else {
            $stmt = $conn->prepare("DELETE FROM reactions WHERE comment_id = ? AND user_id = ?");
            $stmt->execute([$id, $user_id]);
        }
    }


    if ($isTopic) {
        $stmt = $conn->prepare("INSERT INTO reactions (user_id, topic_id, type) VALUES (?, ?, ?)");
        $stmt->execute([$user_id, $id, $type]);
    } else {
        $stmt = $conn->prepare("INSERT INTO reactions (user_id, comment_id, type) VALUES (?, ?, ?)");
        $stmt->execute([$user_id, $id, $type]);
    }


    if ($isTopic) {
        $stmt = $conn->prepare("SELECT 
                                (SELECT COUNT(*) FROM reactions WHERE topic_id = ? AND type = 'like') AS likes,
                                (SELECT COUNT(*) FROM reactions WHERE topic_id = ? AND type = 'dislike') AS dislikes
                                ");
        $stmt->execute([$id, $id]);
    } else {
        $stmt = $conn->prepare("SELECT 
                                (SELECT COUNT(*) FROM reactions WHERE comment_id = ? AND type = 'like') AS likes,
                                (SELECT COUNT(*) FROM reactions WHERE comment_id = ? AND type = 'dislike') AS dislikes
                                ");
        $stmt->execute([$id, $id]);
    }

    $result = $stmt->fetch(PDO::FETCH_ASSOC);

    echo json_encode([
        'likes' => $result['likes'],
        'dislikes' => $result['dislikes'],
        'message' => 'Reakcja została dodana'
    ]);
}
?>
