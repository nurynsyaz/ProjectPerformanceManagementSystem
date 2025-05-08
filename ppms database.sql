-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 08, 2025 at 05:38 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ppms`
--

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notificationID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `message` text NOT NULL,
  `isRead` tinyint(1) DEFAULT 0,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notificationID`, `userID`, `message`, `isRead`, `createdAt`) VALUES
(1, 37, 'You have been assigned to a new project (ID: 34).', 1, '2025-05-06 09:09:00'),
(2, 37, 'You have been assigned to a new project (ID: 34).', 1, '2025-05-06 17:52:38'),
(3, 37, 'You have been removed from project (ID: 34).', 0, '2025-05-08 04:52:22'),
(4, 38, 'You have been assigned to a new project (ID: 34).', 1, '2025-05-08 08:09:59'),
(5, 39, 'You have been assigned to a new project (ID: 34).', 0, '2025-05-08 08:10:03'),
(6, 37, 'You have been assigned to a new project (ID: 34).', 0, '2025-05-08 08:10:07'),
(7, 39, 'You have been assigned to a new task (ID: 47) under Project ID: 34.', 0, '2025-05-08 08:13:27'),
(8, 37, 'You have been assigned to a new task (ID: 47) under Project ID: 34.', 0, '2025-05-08 08:13:33'),
(9, 39, 'You have been assigned to a new project (ID: 35).', 0, '2025-05-08 09:22:29'),
(10, 38, 'You have been assigned to a new project (ID: 35).', 1, '2025-05-08 09:22:33'),
(11, 37, 'You have been assigned to a new project (ID: 35).', 0, '2025-05-08 09:22:37'),
(12, 37, 'A new progress was uploaded for Task ID: 47 in Project ID: 34.', 0, '2025-05-08 10:28:36'),
(13, 38, 'A new progress was uploaded for Task ID: 47 in Project ID: 34.', 0, '2025-05-08 10:28:36'),
(14, 37, 'A new progress was uploaded for Task ID: 47 in Project ID: 34.', 0, '2025-05-08 10:44:12'),
(15, 38, 'A new progress was uploaded for Task ID: 47 in Project ID: 34.', 0, '2025-05-08 10:44:12'),
(16, 37, 'A task progress was updated for Task ID: 47.', 0, '2025-05-08 10:53:27'),
(17, 38, 'A task progress was updated for Task ID: 47.', 0, '2025-05-08 10:53:27'),
(18, 37, 'Head Manager added a new comment. [Task ID: 47]', 0, '2025-05-08 15:03:23'),
(19, 38, 'Head Manager added a new comment. [Task ID: 47]', 0, '2025-05-08 15:03:23'),
(20, 39, 'Head Manager added a new comment. [Task ID: 47]', 0, '2025-05-08 15:03:23'),
(21, 37, 'Head Manager deleted a comment. [Task ID: 47]', 0, '2025-05-08 15:03:30'),
(22, 38, 'Head Manager deleted a comment. [Task ID: 47]', 0, '2025-05-08 15:03:30'),
(23, 39, 'Head Manager deleted a comment. [Task ID: 47]', 0, '2025-05-08 15:03:30');

-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

CREATE TABLE `projects` (
  `projectID` int(11) NOT NULL,
  `projectName` varchar(100) NOT NULL,
  `projectDetails` text NOT NULL,
  `projectStartDate` date DEFAULT NULL,
  `projectEndDate` date DEFAULT NULL,
  `userID` int(11) NOT NULL,
  `roleID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `projects`
--

INSERT INTO `projects` (`projectID`, `projectName`, `projectDetails`, `projectStartDate`, `projectEndDate`, `userID`, `roleID`) VALUES
(34, 'Test Project', 'Just a test', '2025-05-06', '2025-05-09', 36, 1),
(35, 'another project test', 'another one', '2025-05-09', '2025-05-13', 36, 1);

-- --------------------------------------------------------

--
-- Table structure for table `project_assignment`
--

CREATE TABLE `project_assignment` (
  `assignmentID` int(11) NOT NULL,
  `projectID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `assignedBy` int(11) DEFAULT NULL,
  `assignedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `project_assignment`
--

INSERT INTO `project_assignment` (`assignmentID`, `projectID`, `userID`, `assignedBy`, `assignedAt`) VALUES
(64, 34, 38, 36, '2025-05-08 08:09:59'),
(65, 34, 39, 36, '2025-05-08 08:10:03'),
(66, 34, 37, 36, '2025-05-08 08:10:07'),
(67, 35, 39, 36, '2025-05-08 09:22:29'),
(68, 35, 38, 36, '2025-05-08 09:22:33'),
(69, 35, 37, 36, '2025-05-08 09:22:37');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `roleID` int(11) NOT NULL,
  `roleName` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`roleID`, `roleName`) VALUES
(4, 'Client'),
(1, 'Head Manager'),
(2, 'Project Manager'),
(3, 'Team Member');

-- --------------------------------------------------------

--
-- Table structure for table `status`
--

CREATE TABLE `status` (
  `statusID` int(11) NOT NULL,
  `statusDescription` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `status`
--

INSERT INTO `status` (`statusID`, `statusDescription`) VALUES
(1, 'In Progress'),
(2, 'On-Time'),
(3, 'Delayed'),
(4, 'Not Started');

-- --------------------------------------------------------

--
-- Table structure for table `tasks`
--

CREATE TABLE `tasks` (
  `taskID` int(11) NOT NULL,
  `taskName` varchar(100) NOT NULL,
  `taskDetails` text NOT NULL,
  `taskStartDate` date NOT NULL,
  `taskEndDate` date NOT NULL,
  `statusID` int(11) NOT NULL,
  `projectID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tasks`
--

INSERT INTO `tasks` (`taskID`, `taskName`, `taskDetails`, `taskStartDate`, `taskEndDate`, `statusID`, `projectID`) VALUES
(47, 'just a test task', 'test task', '2025-05-08', '2025-05-08', 2, 34);

-- --------------------------------------------------------

--
-- Table structure for table `task_assignment`
--

CREATE TABLE `task_assignment` (
  `taskAssignmentID` int(11) NOT NULL,
  `taskID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `assignedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `task_assignment`
--

INSERT INTO `task_assignment` (`taskAssignmentID`, `taskID`, `userID`, `assignedAt`) VALUES
(36, 47, 39, '2025-05-08 08:13:27'),
(37, 47, 37, '2025-05-08 08:13:33');

-- --------------------------------------------------------

--
-- Table structure for table `task_comments`
--

CREATE TABLE `task_comments` (
  `commentID` int(11) NOT NULL,
  `taskID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `commentText` text NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `task_progress`
--

CREATE TABLE `task_progress` (
  `progressID` int(11) NOT NULL,
  `taskID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `fileName` varchar(255) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `uploadedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `projectID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `task_progress`
--

INSERT INTO `task_progress` (`progressID`, `taskID`, `userID`, `fileName`, `notes`, `uploadedAt`, `projectID`) VALUES
(13, 47, 39, '47_1746700116484_ETHICS AND PROFESSIONAL PRACTICES NOTES CHAPTER 1 UNTIL 4.pdf', 'just a test progress pdf', '2025-05-08 10:28:36', 34),
(14, 47, 39, '47_1746701052600_ETHICS AND PROFESSIONAL PRACTICES NOTES CHAPTER 1 UNTIL 4.pdf', 'just test pdf', '2025-05-08 10:53:26', 34);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `userID` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phoneNumber` varchar(15) NOT NULL,
  `salt` varchar(255) NOT NULL,
  `roleID` int(11) DEFAULT NULL,
  `security_question` varchar(255) NOT NULL,
  `security_answer` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`userID`, `username`, `email`, `password`, `phoneNumber`, `salt`, `roleID`, `security_question`, `security_answer`) VALUES
(36, 'NurynSyaz', 'nurin0508@gmail.com', 'bU6Y25cttZ2n1sbnfZGZtdcBRYWGQvezbd3on/XA+nY=', '0184650723', 'l8hwxU1jI8zwgLD3eMUvBw==', 1, 'What is your mother\'s maiden name?', 'Junainah'),
(37, 'Hannah25', 'hannah25@gmail.com', 'nwF1pHdRZm7mMb8hNZsX6KdKYQIGb3xlow4N4Fu9Q+M=', '0103172549', 's1Dpo9tr13Z076sMY7l3GQ==', 4, 'What was your first pet\'s name?', 'Fifi'),
(38, 'Shakir77', 'shakir07@gmail.com', '2bIZYzNrcAyLgiKQ5EHa0jgujtFuJqtQHyR1GauJc9M=', '0183505205', '9dsI8FJV0KaQ9WCq3Xp0Mw==', 2, 'What is your mother\'s maiden name?', 'Junainah'),
(39, 'FaizalAzmir77', 'faar2777@gmail.com', 'KRT+ppbfuJwN7NECI91lnQRHD5ulz2qksBiivD8FASY=', '0133483027', 'vPTfL0VuMPDDKmlvmQnSqQ==', 3, 'What is your mother\'s maiden name?', 'Rohayati');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notificationID`),
  ADD KEY `userID` (`userID`);

--
-- Indexes for table `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`projectID`),
  ADD UNIQUE KEY `projectName` (`projectName`),
  ADD KEY `userID` (`userID`),
  ADD KEY `roleID` (`roleID`);

--
-- Indexes for table `project_assignment`
--
ALTER TABLE `project_assignment`
  ADD PRIMARY KEY (`assignmentID`),
  ADD UNIQUE KEY `projectID` (`projectID`,`userID`),
  ADD KEY `userID` (`userID`),
  ADD KEY `assignedBy` (`assignedBy`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`roleID`),
  ADD UNIQUE KEY `roleName` (`roleName`);

--
-- Indexes for table `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`statusID`);

--
-- Indexes for table `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`taskID`),
  ADD KEY `fk_status` (`statusID`),
  ADD KEY `fk_project` (`projectID`);

--
-- Indexes for table `task_assignment`
--
ALTER TABLE `task_assignment`
  ADD PRIMARY KEY (`taskAssignmentID`),
  ADD KEY `taskID` (`taskID`),
  ADD KEY `userID` (`userID`);

--
-- Indexes for table `task_comments`
--
ALTER TABLE `task_comments`
  ADD PRIMARY KEY (`commentID`),
  ADD KEY `taskID` (`taskID`),
  ADD KEY `userID` (`userID`);

--
-- Indexes for table `task_progress`
--
ALTER TABLE `task_progress`
  ADD PRIMARY KEY (`progressID`),
  ADD KEY `fk_taskprogress_task` (`taskID`),
  ADD KEY `fk_taskprogress_user` (`userID`),
  ADD KEY `projectID` (`projectID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`userID`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `fk_role` (`roleID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notificationID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `projects`
--
ALTER TABLE `projects`
  MODIFY `projectID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `project_assignment`
--
ALTER TABLE `project_assignment`
  MODIFY `assignmentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `roleID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `status`
--
ALTER TABLE `status`
  MODIFY `statusID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tasks`
--
ALTER TABLE `tasks`
  MODIFY `taskID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `task_assignment`
--
ALTER TABLE `task_assignment`
  MODIFY `taskAssignmentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `task_comments`
--
ALTER TABLE `task_comments`
  MODIFY `commentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `task_progress`
--
ALTER TABLE `task_progress`
  MODIFY `progressID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `userID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`) ON DELETE CASCADE;

--
-- Constraints for table `projects`
--
ALTER TABLE `projects`
  ADD CONSTRAINT `projects_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `projects_ibfk_2` FOREIGN KEY (`roleID`) REFERENCES `roles` (`roleID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `project_assignment`
--
ALTER TABLE `project_assignment`
  ADD CONSTRAINT `project_assignment_ibfk_1` FOREIGN KEY (`projectID`) REFERENCES `projects` (`projectID`) ON DELETE CASCADE,
  ADD CONSTRAINT `project_assignment_ibfk_2` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`) ON DELETE CASCADE,
  ADD CONSTRAINT `project_assignment_ibfk_3` FOREIGN KEY (`assignedBy`) REFERENCES `users` (`userID`) ON DELETE SET NULL;

--
-- Constraints for table `tasks`
--
ALTER TABLE `tasks`
  ADD CONSTRAINT `fk_project` FOREIGN KEY (`projectID`) REFERENCES `projects` (`projectID`),
  ADD CONSTRAINT `fk_status` FOREIGN KEY (`statusID`) REFERENCES `status` (`statusID`);

--
-- Constraints for table `task_assignment`
--
ALTER TABLE `task_assignment`
  ADD CONSTRAINT `task_assignment_ibfk_1` FOREIGN KEY (`taskID`) REFERENCES `tasks` (`taskID`) ON DELETE CASCADE,
  ADD CONSTRAINT `task_assignment_ibfk_2` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`) ON DELETE CASCADE;

--
-- Constraints for table `task_comments`
--
ALTER TABLE `task_comments`
  ADD CONSTRAINT `task_comments_ibfk_1` FOREIGN KEY (`taskID`) REFERENCES `tasks` (`taskID`) ON DELETE CASCADE,
  ADD CONSTRAINT `task_comments_ibfk_2` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`) ON DELETE CASCADE;

--
-- Constraints for table `task_progress`
--
ALTER TABLE `task_progress`
  ADD CONSTRAINT `fk_taskprogress_task` FOREIGN KEY (`taskID`) REFERENCES `tasks` (`taskID`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_taskprogress_user` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`) ON DELETE CASCADE,
  ADD CONSTRAINT `task_progress_ibfk_1` FOREIGN KEY (`projectID`) REFERENCES `projects` (`projectID`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_role` FOREIGN KEY (`roleID`) REFERENCES `roles` (`roleID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
