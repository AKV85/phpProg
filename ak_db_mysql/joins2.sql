#Joins.Bonus.Ziniu gilinimui
#Sukurkite užklausą, kuri susieja lenteles "employees" ir "departments"
# pagal "department_id" ir atvaizduoja visus "Employees" vardus, pavardes
# ir susijusias "departments" pavadinimus.
# sukurkime lentele `departments`:
CREATE TABLE `departments`
(
    `id`              INT NOT NULL AUTO_INCREMENT,
    `department_name` varchar(255),
    `location`        VARCHAR(255),
    PRIMARY KEY (`id`)
);

ALTER TABLE departments RENAME COLUMN `location` TO `Cities_id`;
ALTER TABLE departments
    MODIFY `Cities_id` INT;

# uzpildykime ja:
INSERT INTO departments (department_name, Cities_id)
VALUES ('Administracija', 1),
       ('Gamyba', 2)
;

INSERT INTO `Cities` (`Name`, `Country`)
VALUES ('LT', 'Lithuania'),
       ('LV', 'Latvia')
;
# duokime foreign rakta:
ALTER TABLE `Employees`
    ADD FOREIGN KEY (department_id)
        REFERENCES departments (id);

ALTER TABLE `departments`
    ADD FOREIGN KEY (Cities_id)
        REFERENCES Cities (id);
ALTER TABLE Cities rename column `ID` to `id`;

# susiekim su employees lentele:
SELECT `Employees`.first_name, `Employees`.last_name, `departments`.department_name, `departments`.`Cities_id`
FROM `Employees`
         JOIN `departments`
              ON `employees`.department_id = `departments`.id;

# Sukurkite užklausą, kuri susieja lenteles "customers" ir "orders"
# pagal "customer_id" ir atvaizduoja visus "Customers" vardus, pavardes
# ir susijusias "orders" sumas.
#uzpildykime orders lentele:
INSERT INTO `Orders` (`Product`, `Quantity`, `Price`)
VALUES ('Computer', 2, 1000);
INSERT INTO `Orders` (`Product`, `Quantity`, `Price`)
VALUES ('Monitor', 5, 500);
INSERT INTO `Orders` (`Product`, `Quantity`, `Price`)
VALUES ('Keyboard', 10, 50);
# padarykime nauja kolonele total_price ir kad ji skaiciuotu sandauga
# quantity ir price
ALTER TABLE `Orders`
    ADD total_price INT;
UPDATE `Orders`
SET `total_price` = Quantity * Price
WHERE `orders`.`total_price` IS NULL;
#  padarykime foregn key
ALTER TABLE `costumers`
    ADD FOREIGN KEY (order_id)
        REFERENCES orders (id);
#
SELECT `costumers`.first_name, `costumers`.last_name, `orders`.Price, `orders`.Quantity, orders.total_price
FROM `costumers`
         JOIN `orders`
              ON `costumers`.order_id = `orders`.id;
# Sukurkite užklausą, kuri susieja lenteles "products", inventory" ir "suppliers" pagal
# "productI_id, "item_id" ir "supplier_id" ir atvaizduoja visus "products" pavadinimus,
# susijusias "inventory" kiekius ir "suppliers" pavadinimus.

# sukurkime grupe suppliers
CREATE TABLE `suppliers`
(
    `id`            INT NOT NULL AUTO_INCREMENT,
    `supplier_name` VARCHAR(255),
    `item_id`       INT,
    PRIMARY KEY (`id`)
);
# suteikime raktus foreign
alter table `suppliers`
    add foreign key (item_id)
        references inventory (ItemID);

ALTER TABLE `inventory`
    ADD FOREIGN KEY (supplier_id)
        REFERENCES suppliers (id);

ALTER TABLE `inventory`
    ADD FOREIGN KEY (product_id)
        REFERENCES products (id);
# papildykim lenteles
INSERT INTO suppliers (supplier_name)
VALUES ('Viskas kompiuteriams'),
       ('Viskas kompiuteriams'),
       ('MonitorLtd'),
       ('Remonter')
;
INSERT INTO inventory (ItemName)
VALUES ('Schemos'),
       ('Plokstes'),
       ('Monitoriai'),
       ('Klavisai')
;

# surandom kokie itemai mus reikalingi musu produktui ir kas jas gamina
SELECT inventory.ItemName as Detale, products.Name as produktas, suppliers.supplier_name as DetalesPristato
FROM inventory
         JOIN products ON products.id = inventory.product_id
         JOIN suppliers ON inventory.supplier_id = suppliers.id;

# 4.Sukurkite užklausą, kuri susieja lenteles "students", "classes" ir
# "enrollments" pagal "student_id", "class_id" ir "enroll_date" ir
# atvaizduoja visus "Students" vardus, pavardes, susijusias "Classes"
# pavadinimus ir "enrollments" datas.
# sukurkime lentele enrollments
CREATE table `enrollments`
(
    `id`          INT NOT NULL AUTO_INCREMENT,
    `enroll_date` DATETIME DEFAULT NOW(),
    `student_id`  INT,
    `class_id`    INT,
    PRIMARY KEY (`id`)
);
# suteiksim raktu foreign
ALTER TABLE `enrollments`
    ADD FOREIGN KEY (student_id)
        REFERENCES `students` (id);
ALTER TABLE `enrollments`
    ADD FOREIGN KEY (class_id)
        REFERENCES `classes` (id);
ALTER TABLE `students`
    ADD FOREIGN KEY (ClassID)
        REFERENCES `classes` (id);
# PAPILDIKIME LENTELES
INSERT INTO `students` (Name)
VALUES ('Bobas Joniusas'),
       ('Zita Zule'),
       ('Kostas Laukskis');
INSERT INTO `classes` (title)
VALUES ('PHP'),
       ('SQL'),
       ('JS');
INSERT INTO `enrollments` (student_id)
VALUES (6),
       (5),
       (3);

SELECT students.Name, classes.title, enrollments.enroll_date
FROM `enrollments`
         JOIN students ON enrollments.student_id = students.id
         JOIN classes ON enrollments.class_id = classes.id;

# 5.Sukurkite užklausą, kuri susieja lenteles "employees",
# "departments" ir "salaries" pagal "employee_id",
# "department_id" ir "salary_start_date" ir atvaizduoja visus
# "employees" vardus, pavardes, susijusias "departments" pavadinimus
# ir "slaries" reikšmes.
# sukurkime lentel sararies

CREATE TABLE `salaries`
(
    `id`                    INT      NOT NULL AUTO_INCREMENT,
    `salary_start_datetime` DATETIME NOT NULL,
    `salary_value`          DECIMAL(10, 2),
    `work_days`             INT,
    `total_salary`          DECIMAL(10, 2),
    PRIMARY KEY (`id`)
);
# sukurti trigerį kuris skaičiuos darbo dienas tarp
# salary_start_datetime ir NOW() kiekvieną kartą kai eilutė yra
# sukuriama ar pakeista
DELIMITER $$
CREATE TRIGGER calculate_work_days_insert
    BEFORE INSERT ON salaries
    FOR EACH ROW
BEGIN
    SET NEW.work_days = DATEDIFF(NOW(), NEW.salary_start_datetime);
    SET NEW.total_salary = NEW.salary_value*NEW.work_days;
END$$

    CREATE TRIGGER calculate_work_days_update
        BEFORE UPDATE ON salaries
        FOR EACH ROW
    BEGIN
        SET NEW.work_days = DATEDIFF(NOW(), NEW.salary_start_datetime);
    SET NEW.total_salary = NEW.salary_value*NEW.work_days;
END$$
        DELIMITER ;
# papildom salaries lentele
INSERT INTO `salaries` (salary_start_datetime, salary_value)
VALUES ('2023/01/12', 100),
       ('2023/01/12', 200),
       ('2023/01/12', 300);

DELIMITER $$
        CREATE TRIGGER calculate_work_days_insert
            BEFORE INSERT ON salaries
            FOR EACH ROW
        BEGIN
            SET NEW.work_days = DATEDIFF(NOW(), NEW.salary_start_datetime) - WEEKDAY(NOW()) + WEEKDAY(NEW.salary_start_datetime);
    SET NEW.total_salary = NEW.salary_value*NEW.work_days;
END$$

            CREATE TRIGGER calculate_work_days_update
                BEFORE UPDATE ON salaries
                FOR EACH ROW
            BEGIN
                SET NEW.work_days = DATEDIFF(NOW(), NEW.salary_start_datetime) - WEEKDAY(NOW()) + WEEKDAY(NEW.salary_start_datetime);
    SET NEW.total_salary = NEW.salary_value*NEW.work_days;
END$$
                DELIMITER ;
                DROP TRIGGER calculate_work_days_insert;
                DROP TRIGGER calculate_work_days_update;
                DELIMITER $$
                CREATE TRIGGER calculate_work_days_insert
                    BEFORE INSERT ON salaries
                    FOR EACH ROW
                BEGIN
                    SET NEW.work_days = DATEDIFF(NOW(), NEW.salary_start_datetime) - (WEEKDAY(NOW()) = 0) - (WEEKDAY(NOW()) = 6) - (WEEKDAY(NEW.salary_start_datetime) = 0) - (WEEKDAY(NEW.salary_start_datetime) = 6);
    SET NEW.total_salary = NEW.salary_value*NEW.work_days;
END$$

                    CREATE TRIGGER calculate_work_days_update
                        BEFORE UPDATE ON salaries
                        FOR EACH ROW
                    BEGIN
                        SET NEW.work_days = DATEDIFF(NOW(), NEW.salary_start_datetime) - (WEEKDAY(NOW()) = 0) - (WEEKDAY(NOW()) = 6) - (WEEKDAY(NEW.salary_start_datetime) = 0) - (WEEKDAY(NEW.salary_start_datetime) = 6);
    SET NEW.total_salary = NEW.salary_value*NEW.work_days;
                    END;
                    DELIMITER ;

                    DELIMITER $$
                    CREATE TRIGGER calculate_work_days_insert
                        BEFORE INSERT ON salaries
                        FOR EACH ROW
                    BEGIN
                        SET NEW.work_days = DATEDIFF(CURDATE(), NEW.salary_start_datetime) - (WEEKDAY(CURDATE()) = 0) - (WEEKDAY(CURDATE()) = 6) - (WEEKDAY(NEW.salary_start_datetime) = 0) - (WEEKDAY(NEW.salary_start_datetime) = 6);
    SET NEW.total_salary = NEW.salary_value*NEW.work_days;
                    END;
                    CREATE TRIGGER calculate_work_days_update
                        BEFORE UPDATE ON salaries
                        FOR EACH ROW
                    BEGIN
                        SET NEW.work_days = DATEDIFF(CURDATE(), NEW.salary_start_datetime) - (WEEKDAY(CURDATE()) = 0) - (WEEKDAY(CURDATE()) = 6) - (WEEKDAY(NEW.salary_start_datetime) = 0) - (WEEKDAY(NEW.salary_start_datetime) = 6);
    SET NEW.total_salary = NEW.salary_value*NEW.work_days;
                    END;
                    DELIMITER ; #rodo neteisingai,norejau kad skaiciuotu be iseiginiu dienu


