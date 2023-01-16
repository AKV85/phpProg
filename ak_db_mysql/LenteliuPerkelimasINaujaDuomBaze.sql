CREATE SCHEMA IF NOT EXISTS `eshop` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
GRANT ALL ON `eshop`.* TO 'akv85'@'%';

FLUSH privileges;

CREATE TABLE `test_persons`
AS SELECT * FROM `akademija`.persons;
#Perkeliam lenteles i kita duomenu baze
CREATE TABLE `eshop`.products
AS SELECT * FROM `akademija`.Products;

DROP TABLE `akademija`.Products;

CREATE TABLE `eshop`.transactions
AS SELECT * FROM `akademija`.Transactions;

DROP TABLE `akademija`.Transactions;

CREATE TABLE `eshop`.students
AS SELECT * FROM `akademija`.Students;

DROP TABLE `akademija`.Students;

CREATE TABLE `eshop`.orders
AS SELECT * FROM `akademija`.Orders;

DROP TABLE `akademija`.Orders;

CREATE TABLE `eshop`.inventory
AS SELECT * FROM `akademija`.Inventory;

DROP TABLE `akademija`.Inventory;

CREATE TABLE `eshop`.employees
AS SELECT * FROM `akademija`.Employees;

DROP TABLE `akademija`.Employees;

CREATE TABLE `eshop`.costumers
AS SELECT * FROM `akademija`.Costumers;

DROP TABLE `akademija`.Costumers;

CREATE TABLE `eshop`.classes
AS SELECT * FROM `akademija`.Classes;

DROP TABLE `akademija`.Classes;

