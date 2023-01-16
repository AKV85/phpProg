#1.Uzduotis. Parašykite užklausą, kuri ištrauktų visus įrašus iš lentelės "Employees" ir atvaizduotų jų vardus ir pavardes.
# Sukuriam lentele Employees
CREATE TABLE `Employees`
(
    `id`         INT NOT NULL AUTO_INCREMENT,
    `first_name` VARCHAR(255),
    `last_name`  VARCHAR(255),
    `phone`      VARCHAR(255),
    `email`      VARCHAR(255),
    `profession` VARCHAR(255),
    `salary`     INT,
    PRIMARY KEY (`id`)
);
# Sumetam duomenis i musu nauja lentele Emplyees
INSERT INTO `Employees` (first_name, last_name, phone, email, profession, salary)
VALUES ('Vasilij', 'Bubikov', +37064582123, 'buba@gmail.com', 'Teacher', 2000),
       ('John', 'Smith', +37135551111, 'johnsmith@email.com', 'Engineer', 3000),
       ('Jane', 'Doe', +37035552222, 'janedoe@email.com', 'Doctor', 6000),
       ('Bob', 'Johnson', +37235553333, 'bobjohnson@email.com', 'Nurse', 2500),
       ('Emily', 'Brown', +37035554444, 'emilybrown@email.com', 'Teacher', 4000),
       ('Michael', 'Garcia', +37035557777, 'michaelgarcia@email.com', 'Lawyer', 6000),
       ('Samantha', 'Taylor', +37035556666, 'samanthataylor@email.com', 'Accountant', 3500),
       ('Joshua', 'Anderson', +37035559999, 'joshuaanderson@email.com', 'IT professional', 5500),
       ('Ashley', 'Thomas', +37035551111, 'ashleythomas@email.com', 'Marketing', 4500),
       ('David', 'Moore', +37035552222, 'davidmoore@email.com', 'Human Resources', 4000),
       ('Daniel', 'Jackson', +37035553333, 'danieljackson@email.com', 'Sales', 3500);
# Dabar  Parašykime užklausą, kuri ištrauktų visus įrašus iš lentelės "Employees" ir atvaizduotų jų vardus ir pavardes.
SELECT first_name, last_name
FROM `Employees`;

# 2.Uzduotis .Parašykite užklausą, kuri atnaujintų darbuotojo algas lentelėje "Employees", kurio ID yra "123", į 10% didesnę nei dabartinė alga.
# Paimkime 1-mo darbuotojo alga ir padidinkime ja 10%
UPDATE `Employees`
SET salary = salary * 1.1
WHERE id = 1;

# 3.Uzduotis. Parašykite užklausą, kuri ištrintų visus įrašus iš lentelės "Orders", kurie yra senesni nei 1 metai.
# Sukurkime lentele Orders:
CREATE TABLE `Orders`
(
    `id`           INT NOT NULL AUTO_INCREMENT,
    `order_name`   VARCHAR(255),
    `order_date`   DATETIME,
    `costumer_id`  INT,
    `employees_id` INT,
    PRIMARY KEY (`id`)
);
# Sumetam duomenis i musu nauja lentele Emplyees:
INSERT INTO `Orders` (order_name, order_date, costumer_id, employees_id)
VALUES ('Apmokymai', '2021-01-01', 1, 3),
       ('Konsultacija', '2021-04-01', 2, 1),
       ('Apmokymai', '2021-06-01', 3, 2),
       ('Fizinis darbas', '2021-11-01', 4, 3),
       ('Konsultacija', '2022-01-25', 5, 4),
       ('Apmokymai', '2022-02-01', 6, 5),
       ('Fizinis darbas', '2022-04-01', 7, 6),
       ('Konsultacija', '2022-08-01', 8, 7),
       ('Apmokymai', '2022-09-01', 9, 8),
       ('Fizinis darbas', '2022-10-01', 10, 9),
       ('Konsultacija', '2022-11-01', 2, 10);

# Parašykime užklausą, kuri ištrintų visus įrašus iš lentelės "Orders", kurie yra senesni nei 1 metai.
DELETE
FROM `Orders`
WHERE order_date < DATE_SUB(NOW(), INTERVAL 1 YEAR);

# 4. Uzduotis. Parašykite užklausą, kuri į lentelę "Customers" įterptų naują įrašą su vardu "John", pavarde "Doe" ir el. pašto adresu "john.doe@email.com".
## Sukurkime lentele Costumers:
CREATE TABLE `Costumers`
(
    `id`         INT NOT NULL AUTO_INCREMENT,
    `first_name` VARCHAR(255),
    `last_name`  VARCHAR(255),
    `phone`      VARCHAR(255),
    `email`      VARCHAR(255),
    `order_id`   INT,
    PRIMARY KEY (`id`)
);
# Sumetam duomenis i musu nauja lentele Emplyees:
INSERT INTO `Costumers` (first_name, last_name, phone, email, order_id)
VALUES ('Laurynas', 'Maziukas', +3706412523, 'didelis@gmail.com', 1),
       ('John', 'Smith', +13235551111, 'johnsmith@email.com', 2),
       ('Jane', 'Doe', +13235552222, 'janedoe@email.com', 3),
       ('Bob', 'Johnson', +13235553333, 'bobjohnson@email.com', 4),
       ('Emily', 'Brown', +13235554444, 'emilybrown@email.com', 5),
       ('Michael', 'Garcia', +13235557777, 'michaelgarcia@email.com', 6),
       ('Samantha', 'Taylor', +13235556666, 'samanthataylor@email.com', 7),
       ('Joshua', 'Anderson', +13235559999, 'joshuaanderson@email.com', 8),
       ('Ashley', 'Thomas', +13235551111, 'ashleythomas@email.com', 9),
       ('David', 'Moore', +13235552222, 'davidmoore@email.com', 10),
       ('Daniel', 'Jackson', +13235553333, 'danieljackson@email.com', 11);

# Parašykime užklausą, kuri į lentelę "Customers" įterptų naują įrašą su vardu "John", pavarde "Doe" ir el. pašto adresu "john.doe@email.com".
INSERT INTO `Costumers` (first_name, last_name, email)
VALUES ('John', 'Doe', 'john.doe@email.com');