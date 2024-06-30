<?php
include 'db.php';

if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_FILES['avatar'])) {
    $target_dir = "uploads/";
    $target_file = $target_dir . basename($_FILES["avatar"]["name"]);
    $uploadOk = 1;
    $imageFileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));


    $check = getimagesize($_FILES["avatar"]["tmp_name"]);
    if ($check !== false) {
        $uploadOk = 1;
    } else {
        echo "Plik nie jest obrazem.";
        $uploadOk = 0;
    }


    if ($_FILES["avatar"]["size"] > 2000000) {
        echo "Plik jest za duży.";
        $uploadOk = 0;
    }


    if ($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg" && $imageFileType != "gif") {
        echo "Przepraszam, tylko pliki JPG, JPEG, PNG i GIF są dozwolone.";
        $uploadOk = 0;
    }


    if ($uploadOk == 0) {
        echo "Przepraszam, nie udało się przesłać pliku.";

    } else {
        if (move_uploaded_file($_FILES["avatar"]["tmp_name"], $target_file)) {

            $stmt = $conn->prepare("UPDATE users SET avatar = ? WHERE id = ?");
            $stmt->execute([basename($_FILES["avatar"]["name"]), $_SESSION['user_id']]);
            header("Location: profile.php");
        } else {
            echo "Przepraszam, wystąpił błąd podczas przesyłania pliku.";
        }
    }
}
?>
