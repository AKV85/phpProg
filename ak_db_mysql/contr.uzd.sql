#2uzduotis
USE akademija;
ALTER TABLE `users`
    ADD FOREIGN KEY (person_id)
        REFERENCES persons (id);
SELECT DISTINCT person_id
FROM `users`;
SELECT *
FROM persons
WHERE id NOT IN (SELECT DISTINCT person_id FROM `users`);
SELECT *
FROM `users`
WHERE person_id NOT IN (SELECT id From persons);
SELECT *
FROM persons
WHERE id = 5;
DELETE
FROM akademija.`users`
WHERE id IN (661);
SELECT id
FROM `users`
WHERE person_id NOT IN (SELECT id From persons);
INSERT INTO `users` (`person_id`, `name`)
VALUES (6, 'Uasia');
# pakeiciam state pavadinima i state_id
ALTER TABLE `users`
    RENAME COLUMN state TO state_id;
# bandom priskirt foreign raktus:
USE akademija;
ALTER TABLE `users`
    ADD FOREIGN KEY (`state_id`)
        REFERENCES `states` (`id`);
ALTER TABLE `addresses`
    ADD FOREIGN KEY (`country_iso`)
        REFERENCES `countries` (`iso`);
# HY000][1822] Failed to add the foreign key
# constraint. Missing index for constraint
# 'addresses_ibfk_1' in the referenced table 'countries'
alter table `addresses`
    add constraint addresses_countries_iso_fk
        foreign key (`country_iso`) references `countries` (`iso`);
CREATE INDEX index_name ON addresses (country_iso);
DROP INDEX addresses.index_name;
CREATE INDEX index_name ON countries (address_id)
ALTER TABLE countries
    ADD INDEX (iso);
ALTER TABLE addresses
    ADD CONSTRAINT addresses_ibfk_1
        FOREIGN KEY (country_iso) REFERENCES countries (iso);
SELECT DISTINCT country_iso
FROM `addresses`;
SELECT *
FROM countries
WHERE iso NOT IN (SELECT DISTINCT country_iso FROM `addresses`);
SELECT *
FROM `addresses`
WHERE country_iso NOT IN (SELECT iso From countries);
DELETE
FROM akademija.`addresses`
WHERE id IN (426, 433, 448, 454, 496, 559, 645, 667, 704, 716, 744, 769, 804, 819, 850, 859, 877);
ALTER TABLE `persons`
    ADD FOREIGN KEY (`address_id`)
        REFERENCES `addresses` (`id`);
SELECT DISTINCT address_id
FROM `persons`;
SELECT *
FROM addresses
WHERE id NOT IN (SELECT DISTINCT address_id FROM `persons`);
SELECT *
FROM `persons`
WHERE address_id NOT IN (SELECT id From addresses);
SELECT *
FROM addresses
WHERE id = 308;
DELETE
FROM akademija.`addresses`
WHERE id IN (426)
ALTER TABLE `groups`
    ADD FOREIGN KEY (`address_id`)
        REFERENCES `addresses` (`id`);
SELECT DISTINCT address_id
FROM `groups`;
SELECT *
FROM addresses
WHERE id NOT IN (SELECT DISTINCT address_id FROM `groups`);
SELECT *
FROM `groups`
WHERE address_id NOT IN (SELECT id From addresses);
SELECT *
FROM addresses
WHERE id = 308;
ALTER TABLE `groups`
    RENAME COLUMN state TO state_id;
ALTER TABLE `groups`
    ADD FOREIGN KEY (`state_id`)
        REFERENCES `states` (`id`);
ALTER TABLE `person2gruop`
    ADD FOREIGN KEY (person_id)
        REFERENCES persons (id);
SELECT DISTINCT person_id
FROM `person2gruop`;
SELECT *
FROM persons
WHERE id NOT IN (SELECT DISTINCT person_id FROM `person2gruop`);
SELECT *
FROM `person2gruop`
WHERE person_id NOT IN (SELECT id From persons);
SELECT *
FROM persons
WHERE id = 5;
DELETE
FROM akademija.`person2gruop`
WHERE id IN (439);
#3 uzduotis
CREATE TABLE `Classes`
(
    `id`        INT NOT NULL AUTO_INCREMENT,
    `title`     VARCHAR(255),
    `adress_id` VARCHAR(255),
    `state_id`  INT,
    PRIMARY KEY (`id`)
);
ALTER TABLE `Students`
    ADD FOREIGN KEY (`ClassID`)
        REFERENCES `Classes` (`id`);
# 4UZDUOTIS
CREATE TABLE `Orders`
(
    `id`       INT NOT NULL AUTO_INCREMENT,
    `Product`  VARCHAR(255),
    `Quantity` INT,
    `Price`    INT,
    PRIMARY KEY (`id`)
);
ALTER TABLE Orders
    ADD CONSTRAINT CHK_OrdersPrice CHECK (Price >= 10 AND Quantity > 0);
# 5 uzduotis
ALTER TABLE Employees
    ADD UNIQUE (email);
# 6.Sukurkite lentelę "Cities" su stulpeliais "ID", "Name" ir "Country",
# taip pat pridėkite "Primary Key" apribojimą "ID" stulpeliui ir "Not Null"
# apribojimą "Name" ir "Country" stulpeliams.
USE `akademija`;
ALTER TABLE `countries`
    MODIFY COLUMN `title` VARCHAR(50) NOT NULL;
ALTER TABLE `countries`
    MODIFY COLUMN `iso` VARCHAR(50) NOT NULL;
#7. Sukurkite lentelę "Products" su stulpeliais "ProductID", "Name",
# "Description" ir "Price", taip pat pridėkite "Default" apribojimą,
# kad "Description" stulpelis visada būtų "N/A" jeigu jis nenustatytas.
CREATE TABLE `Products`
(
    `id`          INT NOT NULL AUTO_INCREMENT,
    `Name`        VARCHAR(255),
    `Discription` VARCHAR(1000) DEFAULT 'N/A',
    `Price`       INT,
    PRIMARY KEY (`id`)
);
INSERT INTO `Products` (`Name`, `Price`)
values ('bred', 2);
# 8.Sukurkite lentelę "Transactions" su stulpeliais "ID", "AccountNumber",
# "TransactionType", "Amount", "TransactionDate" ir pridėkite "Trigger"
# apribojimą, kad pakeitus "TransactionType" stulpelį, automatiškai
# atnaujintų "TransactionDate" reikšmę į dabartinę datą.
CREATE TABLE `Transactions`
(
    `id`              INT NOT NULL AUTO_INCREMENT,
    `AccountNumber`   INT,
    `TransactionType` VARCHAR(250),
    `Amount`          DECIMAL(10, 2),
    `TransactionDate` DATETIME,
    PRIMARY KEY (`id`)
);
DELIMITER $$
CREATE TRIGGER tr_update_transaction_date
    AFTER UPDATE
    ON Transactions
    FOR EACH ROW
BEGIN
    SET NEW.TransactionDate = NOW();
END$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER tr_update_transaction_date
    BEFORE UPDATE
    ON Transactions
    FOR EACH ROW
BEGIN
    IF NEW.TransactionType <> OLD.TransactionType THEN
        SET NEW.TransactionDate = NOW();
    END IF;
END$$
DELIMITER ;
SET GLOBAL log_bin_trust_function_creators = 1;
# nesigavo  [42000][1227] Access denied; you need (at least one of)
# the SUPER or SYSTEM_VARIABLES_ADMIN privilege(s) for this operation

UPDATE Transactions
SET TransactionDate = NOW(),
    TransactionType = CASE
                          WHEN TransactionType = 'A' THEN 'B'
                          WHEN TransactionType = 'B' THEN 'A'
                          ELSE TransactionType
        END;
ALTER TABLE `Transactions`
    MODIFY `AccountNumber` VARCHAR(10000);

INSERT INTO `Transactions` (`TransactionType`, `Amount`)
VALUES ('cash', 100),
       ('bank', 100);
UPDATE `Transactions` SET `TransactionType` = 'bank' WHERE `id`=1;
# 9uzduotis .Sukurkite lentelę "Inventory" su stulpeliais "ItemID", "ItemName",
# "Quantity", "ReorderLevel" ir pridėkite "CHECK" apribojimą, kad "Quantity"
# reikšmė visada būtų didesnė nei "ReorderLevel" reikšmė.
CREATE TABLE Inventory (
                           ItemID INT PRIMARY KEY,
                           ItemName VARCHAR(255),
                           Quantity INT,
                           ReorderLevel INT,
                           CHECK (Quantity > ReorderLevel)
);
ALTER TABLE `Inventory`
MODIFY ItemID INT NOT NULL AUTO_INCREMENT;

# 10. Sukurkite lentelę "Customers" su stulpeliais "CustomerID", "Name", "Phone", "Email"
# ir pridėkite "Fulltext Index" apribojimą stulpeliui "Name" arba "Email" , kad būtų
# lengviau atlikti paieškas.
ALTER TABLE Costumers
    ADD FULLTEXT (`first_name`, `email`);

# 8 tesiam

DELIMITER $$
CREATE TRIGGER tr_update_transaction_date
    BEFORE UPDATE ON `Transactions`
    FOR EACH ROW
BEGIN
    IF NEW.TransactionType <> OLD.TransactionType THEN
        SET NEW.TransactionDate = NOW();
    END IF;
END$$
DELIMITER ;
# gavosi su pagr.localhostu,kur root teises



