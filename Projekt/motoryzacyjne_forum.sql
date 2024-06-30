-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 26 Cze 2024, 00:08
-- Wersja serwera: 10.4.22-MariaDB
-- Wersja PHP: 8.1.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `motoryzacyjne_forum`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `topic_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `comments`
--

INSERT INTO `comments` (`id`, `topic_id`, `user_id`, `content`, `created_at`) VALUES
(8, 8, 1, 'a', '2024-06-25 22:01:11'),
(9, 8, 1, 'xd', '2024-06-25 22:06:13'),
(10, 8, 1, 'xd', '2024-06-25 22:06:15'),
(11, 8, 2, 'a', '2024-06-25 22:06:24');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `reactions`
--

CREATE TABLE `reactions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `topic_id` int(11) DEFAULT NULL,
  `comment_id` int(11) DEFAULT NULL,
  `type` enum('like','dislike') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `topics`
--

CREATE TABLE `topics` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `pinned` tinyint(1) DEFAULT 0,
  `image_path` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `topics`
--

INSERT INTO `topics` (`id`, `user_id`, `title`, `content`, `created_at`, `pinned`, `image_path`) VALUES
(8, 1, 'adasd', 'sadsadsadsa', '2024-06-25 21:51:12', 0, 'uploads/logo.webp');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `role` enum('user','admin') DEFAULT 'user',
  `banned` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `avatar` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `email`, `role`, `banned`, `created_at`, `avatar`) VALUES
(1, 'admin', '$2y$10$hD3bPcBFBHinVfVAKoFFy.u4Gbhk7bEU6IS19vA0aVZY595./Opeu', 'admin@wp.pl', 'admin', 0, '2024-06-25 18:06:40', 'logo.png'),
(2, 'adm', '$2y$10$tb60QQA31gYLTZJn6RC5KeKPeSBx4eaA/5JK.WmdF8CIM8mFIJ1ZC', 'adm@wp.pl', 'user', 0, '2024-06-25 19:51:58', 'channels4_banner (4).jpg');

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `topic_id` (`topic_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indeksy dla tabeli `reactions`
--
ALTER TABLE `reactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `topic_id` (`topic_id`),
  ADD KEY `comment_id` (`comment_id`);

--
-- Indeksy dla tabeli `topics`
--
ALTER TABLE `topics`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indeksy dla tabeli `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT dla zrzuconych tabel
--

--
-- AUTO_INCREMENT dla tabeli `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT dla tabeli `reactions`
--
ALTER TABLE `reactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `topics`
--
ALTER TABLE `topics`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT dla tabeli `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`topic_id`) REFERENCES `topics` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `reactions`
--
ALTER TABLE `reactions`
  ADD CONSTRAINT `reactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reactions_ibfk_2` FOREIGN KEY (`topic_id`) REFERENCES `topics` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reactions_ibfk_3` FOREIGN KEY (`comment_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `topics`
--
ALTER TABLE `topics`
  ADD CONSTRAINT `topics_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
