-- MySQL dump 10.13  Distrib 8.0.28, for Win64 (x86_64)
--
-- Host: localhost    Database: company
-- ------------------------------------------------------
-- Server version	8.0.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `employee_dummy`
--

DROP TABLE IF EXISTS `employee_dummy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_dummy` (
  `empid` int DEFAULT NULL,
  `first_name` varchar(25) DEFAULT NULL,
  `last_name` varchar(25) DEFAULT NULL,
  `salary` int DEFAULT NULL,
  `joining_date` datetime DEFAULT NULL,
  `department_name` varchar(25) DEFAULT NULL,
  KEY `emp_index1` (`first_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_dummy`
--

LOCK TABLES `employee_dummy` WRITE;
/*!40000 ALTER TABLE `employee_dummy` DISABLE KEYS */;
INSERT INTO `employee_dummy` VALUES (1,'Emiliano','Welch',50000,'2002-05-05 19:43:59','voluptate'),(2,'Noble','Beier',48500,'2018-11-20 07:44:57','consequatur'),(13,'Tiana','Graham',12500,'2021-12-20 23:21:06','rerum'),(4,'Travon','Mante',25000,'1985-08-05 00:25:41','voluptatem'),(5,'Jamison','Thiel',45000,'2011-05-06 15:22:08','eos'),(6,'Krystina','Wyman',85600,'1985-12-26 09:23:37','vel'),(7,'Ernestina','Fadel',78900,'1981-04-01 16:03:35','ea'),(8,'Lane','Adams',35200,'2006-04-01 17:04:59','nobis'),(9,'Justen','Adams',78900,'1995-04-10 07:39:07','explicabo'),(10,'Hunter','Ryan',54000,'2008-02-02 08:49:33','recusandae'),(14,'Emiliano','Welch',50000,'2002-05-05 19:43:59','voluptate'),(15,'Noble','Beier',48500,'2018-11-20 07:44:57','consequatur'),(16,'Tiana','Graham',12500,'2021-12-20 23:21:06','rerum'),(17,'Travon','Mante',25000,'1985-08-05 00:25:41','voluptatem'),(34,'Jamison','Thiel',45000,'2011-05-06 15:22:08','eos'),(33,'Krystina','Wyman',85600,'1985-12-26 09:23:37','vel'),(32,'Ernestina','Fadel',78900,'1981-04-01 16:03:35','ea'),(31,'Lane','Adams',35200,'2006-04-01 17:04:59','nobis'),(19,'Justen','Adams',78900,'1995-04-10 07:39:07','explicabo'),(20,'Hunter','Ryan',54000,'2008-02-02 08:49:33','recusandae'),(43,'Hunter','Ryan',54000,'2008-02-02 08:49:33','recusandae'),(50,'Jack','Ryan',54000,'2008-02-02 08:49:33','recusandae'),(52,'Agent','FourSeven',54000,'2008-02-02 08:49:33','recusandae');
/*!40000 ALTER TABLE `employee_dummy` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-02-06 14:11:14
