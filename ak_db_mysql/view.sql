- Sukuriamas VIEW
CREATE VIEW studentai AS
SELECT p.*,
       concat(
               COALESCE(a.street, ''), ' ',
               COALESCE(a.city, ''), ' ',
               COALESCE(a.postcode, ''), ' ',
               COALESCE(c.title, '')
           ) AS Adresas
FROM `persons` AS p
         Join `addresses` AS a on p.address_id = a.id
         Join `countries` AS c on a.country_iso = c.iso
;
# ALTER ALGORITHM = MERGE ; #modifikuoti
# CREATE OR REPLACE; #SUKURK ARBA Modifikuok
-- Panaudojamas view'as duomenis atvaizduoti
select * from studentai;
select * from studentai where address_id=774;# bandoymai

use eshop;
# Views klases darbas
# 1. uzduotis. Sukurkite view lentelę, kuri susieja lenteles
# `employees` ir `departments` pagal `departments`.`id` ir atvaizduoja visus
# `employees` vardus, pavardes ir susijusias `departments` pavadinimus.
CREATE VIEW Darbuotojai AS
SELECT e.*, d.department_name, c.Country
FROM `Employees` AS e
         Join `departments` AS d ON e.department_id = d.id
         Join `Cities` AS c ON d.Cities_id = c.id
;#sukurem

ALTER ALGORITHM = MERGE VIEW Darbuotojai AS
SELECT e.first_name,e.last_name,e.phone,e.email,e.profession,e.salary, d.department_name, c.Country
FROM `Employees` AS e
         Join `departments` AS d ON e.department_id = d.id
         Join `Cities` AS c ON d.Cities_id = c.id
;#modifikavom

#2. Sukurkite view lentelę, kuri susieja lenteles `customers` ir `orders` pagal `customers`.`id`
# ir atvaizduoja visus `customers` vardus, pavardes ir susijusias `orders` sumas, tik tada kai
# suma yra didesnė nei 1000.

CREATE VIEW Klientu_uzsakymai AS
SELECT c.first_name, c.last_name,c.email,c.phone,o.Product, o.Price, o.Quantity,o.total_price
FROM costumers AS c
         JOIN `orders` AS o ON c.order_id = o.id
WHERE total_price>1000;

# 3.Sukurkite view lentelę, kuri susieja lenteles `products` ir
# `inventory` pagal `products`.`id` ir atvaizduoja visus `products`
# pavadinimus, susijusias `inventory` kiekius ir `reorder_level`
# reikšmes, tik tada kai `quantity` yra mažesnė nei `reorder_level`.
# reikia modifikuoti reorder leveli;

CREATE VIEW Produktu_trukumas AS
SELECT i.ItemName,i.Quantity,i.ReorderLevel,p.Name,p.Price
FROM `products` AS p
         JOIN `inventory` AS i ON i.product_id = p.id
WHERE i.ReorderLevel>i.Quantity

    # Sukurkite view lentelę, kuri susieja lenteles `students`, `classes`
# ir `enrollments` pagal `students`.`id`, `classes`.`id` ir `enrollments`
# .enroll_date` ir atvaizduoja visus `students` vardus, pavardes ir susijusius duomenis.
CREATE VIEW Studentai AS
SELECT s.Name,s.Age,c.title,e.enroll_date
FROM `enrollments` AS e
         Join `classes` AS c ON e.class_id = c.id
         Join `students` AS s ON e.student_id = s.id