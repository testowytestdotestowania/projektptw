-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 27 Cze 2024, 22:17
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
-- Struktura tabeli dla tabeli `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
(17, 14, 2, 'xd', '2024-06-27 20:17:29');

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

--
-- Zrzut danych tabeli `reactions`
--

INSERT INTO `reactions` (`id`, `user_id`, `topic_id`, `comment_id`, `type`, `created_at`) VALUES
(34, 1, 14, NULL, 'like', '2024-06-27 20:10:36'),
(35, 2, 14, NULL, 'like', '2024-06-27 20:17:16'),
(36, 2, NULL, 17, 'like', '2024-06-27 20:17:30');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `tags`
--

CREATE TABLE `tags` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `tags`
--

INSERT INTO `tags` (`id`, `name`) VALUES
(1, 'AUDI'),
(2, 'BMW'),
(3, 'MERCEDES'),
(4, 'SKODA'),
(5, 'VOLKSWAGEN');

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
(14, 1, 'a', 'a', '2024-06-27 20:09:16', 0, NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `topic_tags`
--

CREATE TABLE `topic_tags` (
  `id` int(11) NOT NULL,
  `topic_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `topic_tags`
--

INSERT INTO `topic_tags` (`id`, `topic_id`, `tag_id`) VALUES
(4, 14, 1);

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
-- Indeksy dla tabeli `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

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
-- Indeksy dla tabeli `tags`
--
ALTER TABLE `tags`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `topics`
--
ALTER TABLE `topics`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indeksy dla tabeli `topic_tags`
--
ALTER TABLE `topic_tags`
  ADD PRIMARY KEY (`id`),
  ADD KEY `topic_id` (`topic_id`),
  ADD KEY `tag_id` (`tag_id`);

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
-- AUTO_INCREMENT dla tabeli `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT dla tabeli `reactions`
--
ALTER TABLE `reactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT dla tabeli `tags`
--
ALTER TABLE `tags`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT dla tabeli `topics`
--
ALTER TABLE `topics`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT dla tabeli `topic_tags`
--
ALTER TABLE `topic_tags`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

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

--
-- Ograniczenia dla tabeli `topic_tags`
--
ALTER TABLE `topic_tags`
  ADD CONSTRAINT `topic_tags_ibfk_1` FOREIGN KEY (`topic_id`) REFERENCES `topics` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `topic_tags_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
