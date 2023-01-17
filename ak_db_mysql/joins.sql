# 1.Kiek 'useriu' kurių 'state' yra 'Inactive'  būsenoje.
SELECT count(*)
FROM `users`
         JOIN states ON users.state_id = states.id
WHERE states.title = 'Inactive';
SELECT DISTINCT state_id
FROM `users`;
#0
# 2.  Kiek 'gruops' kuriu 'state' yra 'Active' būsenoje.
SELECT count(*)
FROM `users`
         JOIN states ON users.state_id = states.id
WHERE states.title = 'Active';#352
SELECT count(*)
FROM `users`
         JOIN states ON users.state_id = states.id
WHERE states.title = 'Suspended';
#645
# 3.paSELECTinti iš 'persons' lentelės įrašus kurie turi
# 'address_id' , ekrane rodyti tik 'persons.first_name' ,
# 'persons.last_name', address.city' ir 'countries.title'
#     pilną šalies pavadinimą kur jis gyvena
SELECT `persons`.first_name, `persons`.last_name, `addresses`.city, `countries`.title
FROM `persons`
         LEFT JOIN `addresses` ON `persons`.address_id = `addresses`.id
         LEFT JOIN `countries` ON `addresses`.country_iso = `countries`.iso
;
# pakoregojam musu lentele countries,kad nesidubliotu iso
DELETE countries
FROM `countries`
         INNER JOIN (SELECT MAX(id) AS lastID, iso
                     from `countries`
                     where iso in (select iso
                                   from `countries`
                                   group by iso
                                   having count(*) > 1)
                     group by iso) duplic on duplic.iso = `countries`.iso
where `countries`.id < duplic.lastID;
select count(distinct country_iso)
from `addresses`;
# 4.  Suskaičiuoti kiek yra studentų tik aktyviose "Active" grupėse.
#     Pavaizduoti Grupės pavadinimą ir studentų skaičių tose grupese.
SELECT COUNT(*)
FROM `groups`
WHERE state_id = 4;
SELECT count(DISTINCT title)
FROM `groups`;
DELETE `groups`
FROM `groups`
         INNER JOIN (SELECT MAX(id) AS lastID, title
                     from `groups`
                     where title in (select title
                                     from `groups`
                                     group by title
                                     having count(*) > 1)
                     group by title) duplic on duplic.title = `groups`.title
where `groups`.id < duplic.lastID;
SELECT COUNT(*)
FROM `users`
WHERE state_id = 4;
SELECT `groups`.title, count(`persons`.id) as Studentu_skaicius
FROM `person2gruop`
         left JOIN `persons` ON `person2gruop`.person_id = `persons`.id
         left JOIN `groups` ON `person2gruop`.groups_id = `groups`.id
where `groups`.state_id = 4
group by `groups`.title
;
# grupes actyv(pasalinom dubliotas ir pokoregavom sarasa)

#5. Atvaizduoti tik dieninių (Kai grupės pavadinimas baigiasi 'D'
# raide) studijų studentų:a.sąrašą b.bendrą skaičių
SELECT COUNT(*)
FROM `groups`
WHERE `groups`.title LIKE '%D';#7
SELECT `groups`.title, count(`persons`.id) as Studentu_skaicius
FROM `person2gruop`
         left JOIN `persons` ON `person2gruop`.person_id = `persons`.id
         left JOIN `groups` ON `person2gruop`.groups_id = `groups`.id
WHERE `groups`.title LIKE '%D'
group by `groups`.title;
#parodo kiek studentu yra kiekvinoj Dieniuniu studiju
# grupej
SELECT concat(`persons`.first_name, ' ', `persons`.last_name) AS full_name, `groups`.title
FROM `person2gruop`
         left JOIN `persons` ON `person2gruop`.person_id = `persons`.id
         left JOIN `groups` ON `person2gruop`.groups_id = `groups`.id
WHERE `groups`.title LIKE '%D';
# atvaizduoja visus studentus ,kurie mokosi diena ir
# kokioj grupej.
# 6. Pavaizduoti pasirinktos grupės studentus ir pilną adresą viename stulpelyje.
# (Užklausos salygoje ieskoti pagal grupės pavadinimą ne ID)
SELECT concat(`groups`.title, ' ', `addresses`.country_iso, ' ', `addresses`.city, ' ', `addresses`.street, ' ',
              `addresses`.postcode) AS full_name
FROM `addresses`
         right JOIN `groups` ON `groups`.address_id = addresses.id
order by `groups`.title;
#atvaizduoja gerai,bet jeigu kur nors yra null
# reiksme ,tai grazina pila <null>

SELECT concat(IFNULL(`groups`.title, ''), ' ', IFNULL(`addresses`.country_iso, ''), ' ', IFNULL(`addresses`.city, ''),
              ' ', IFNULL(`addresses`.street, ''), ' ', IFNULL(`addresses`.postcode, '')) AS full_name
FROM `addresses`
         right JOIN `groups` ON `groups`.address_id = addresses.id
order by `groups`.title;
#dabar gerai
SELECT concat(IFNULL(`groups`.title, ''), ' ', IFNULL(`addresses`.country_iso, ''), ' ', IFNULL(`addresses`.city, ''),
              ' ', IFNULL(`addresses`.street, ''), ' ', IFNULL(`addresses`.postcode, '')) AS full_name
FROM `groups`
         JOIN addresses ON `groups`.address_id = addresses.id
WHERE `groups`.title = 'CS_JS_V';#dabar rodo konkrecios grupes adresa

# 7.Surasti visus asmenis (‘persons’) kurie neturi vardo (first_name’) arba pavardės (‘last_name’) ir
# turi neaktyvų (‘Inactive’) vartotoją (‘users’) (Jei tokių duomenų nėra prieš atliekant užduotį reikia pakoreguoti persons lentos  duomenis ir pašalinti keleta vardu ir pavardziu)
SELECT * FROM `persons` WHERE first_name='' or last_name='';#4 personai
SELECT * from states where title='Active';#id=3 ir id=4
SELECT * FROM `users` WHERE state_id between 3 and 4; #335 useriai
SELECT `persons`.first_name,`persons`.last_name,`users`.name,`users`.id
FROM `users`
         left JOIN `persons` ON `users`.person_id = `persons`.id
         left JOIN `states` ON `states`.id = `users`.state_id
WHERE `states`.title='Active' and persons.first_name='' or persons.last_name=''; #surado 2 vartotojus

# 8.Suskaičiuoti kiek grupių naudojasi tais pačiais adresais. Atvaizduoti kiekio stulpelį
# ir pilna adresą kaip vieną stulpelį. (viso 2 stulpeliai)
SELECT `groups`.*, `addresses`.*, concat(IFNULL(`groups`.title, ''), ' ', IFNULL(`addresses`.country_iso, ''), ' ', IFNULL(`addresses`.city, ''),
                                         ' ', IFNULL(`addresses`.street, ''), ' ', IFNULL(`addresses`.postcode, '')) AS full_name
FROM `groups`
         LEFT JOIN `addresses` ON `groups`.address_id = addresses.id
GROUP BY `groups`.address_id, `groups`.title
HAVING COUNT(groups.address_id) > 1;
SELECT * FROM `groups` WHERE address_id IN (SELECT address_id FROM `groups` GROUP BY address_id HAVING COUNT(*) > 1);#parodo kokios grupes pasikartoja
SELECT COUNT(DISTINCT address_id) FROM `groups` WHERE address_id IN (SELECT address_id FROM `groups` GROUP BY address_id HAVING COUNT(*) > 1);#paskaiciuoja kiek yra unikaliu pasikartojanciu adresu
SELECT address_id, COUNT(*) as 'Grupiu skaicius' FROM `groups` GROUP BY address_id HAVING COUNT(*) > 1;# rodo adreso id ir kiek grupiu jame ,jei grupiu>1
SELECT COUNT(*) as 'Grupiu skaicius', concat(addresses.country_iso,' ',addresses.city,' ',addresses.street) as full_address
from `groups`
         LEFT JOIN `addresses` ON `groups`.address_id = addresses.id
GROUP BY address_id
HAVING COUNT(*) > 1;# rodo kieki ir adresa

# 9.bonus.Atvaizduoti dieninių ir vakarinių studijų studentų bendrus skaičius.a.Skaičiuoti visus studentus
# b.Skaičiuoti tik aktyvių grupių studentus
SELECT DISTINCT title
FROM `groups` WHERE `groups`.title LIKE '%D' OR `groups`.title LIKE '%V';#Suradom kiek yra unikaliu grupiu Dieniniu ir Vakariniu
SELECT DISTINCT persons.id
FROM `persons`;
SELECT `groups`.title, COUNT(distinct persons.id) as Studentu_grupeje
FROM `person2gruop`
         left JOIN `persons` ON person2gruop.person_id = `persons`.id
         left JOIN `groups` ON person2gruop.groups_id = `groups`.id
WHERE `groups`.title LIKE '%D' OR `groups`.title LIKE '%V'
GROUP BY `groups`.title;# suradom kiek studentu kiekvienoj Dieninei ir Vakarinei grupese
SELECT `groups`.title, COUNT(distinct persons.id) as Studentu_grupeje
FROM `person2gruop`
         left JOIN `persons` ON person2gruop.person_id = `persons`.id
         left JOIN `groups` ON person2gruop.groups_id = `groups`.id
         left JOIN `users` ON users.person_id = `persons`.id
         left JOIN `states` ON states.id = `users`.state_id
WHERE `states`.title='Active' and `groups`.title LIKE '%D' OR `groups`.title LIKE '%V'
GROUP BY `groups`.title;#Suradom kiek unikaliu aktyviu studentu mokasi Dieniniose ir Vakarinese grupese
SELECT `groups`.title, COUNT(distinct persons.id) as Studentu_grupeje
FROM `person2gruop`
         left JOIN `persons` ON person2gruop.person_id = `persons`.id
         left JOIN `groups` ON person2gruop.groups_id = `groups`.id
         left JOIN `users` ON users.person_id = `persons`.id
         left JOIN `states` ON states.id = `users`.state_id
WHERE `groups`.state_id=4 AND `groups`.title LIKE '%D' OR `groups`.state_id=4 AND `groups`.title LIKE '%V'
GROUP BY `groups`.title;# rodo visus studentus tik aktyviosiose grupese

SELECT id, first_name,last_name,
       CASE
           WHEN id IN (SELECT person_id FROM `person2gruop` WHERE groups_id IN (SELECT id FROM `groups` WHERE title LIKE '%D')) THEN 'day'
           WHEN id IN (SELECT person_id FROM `person2gruop` WHERE groups_id IN (SELECT id FROM `groups` WHERE title LIKE '%V')) THEN 'evening'
           END AS study_time
FROM persons
WHERE id IN (SELECT person_id FROM `person2gruop` WHERE groups_id IN (SELECT id FROM `groups` WHERE title LIKE '%D' OR title LIKE '%V'));#sita uzklausa
#  parodys visus studentus kurie mokosi Dieniniose ir Vakariniuose studijose, o kitu nerodis, jeigu jie neatitinka salygos

SELECT
    `groups`.title,
    COUNT(DISTINCT
          CASE
              WHEN `groups`.title LIKE '%D' THEN `persons`.id
              WHEN `groups`.title LIKE '%V' THEN `persons`.id
              END
        ) as Studentu_grupeje
FROM `person2gruop`
         JOIN `persons` ON `person2gruop`.person_id = `persons`.id
         JOIN `groups` ON `person2gruop`.groups_id = `groups`.id
GROUP BY `groups`.title; #rodo kiek studentu mokosi kiekvienoje d ir v grupese

SELECT
    `groups`.title,
    COUNT(DISTINCT
          CASE
              WHEN `groups`.state_id=4 AND `groups`.title LIKE '%D' THEN `persons`.id
              WHEN `groups`.state_id=4 AND `groups`.title LIKE '%V' THEN `persons`.id
              END
        ) as Studentu_grupeje
FROM `person2gruop`
         JOIN `persons` ON `person2gruop`.person_id = `persons`.id
         JOIN `groups` ON `person2gruop`.groups_id = `groups`.id
         JOIN `users` ON `users`.person_id = `persons`.id
         JOIN `states` ON `states`.id = `users`.state_id
GROUP BY `groups`.title;#suradom kiek studentu mokosi kiekvienoj aktyvioj grupej, kitas grazina kaip 0

SELECT
    CASE
        WHEN `groups`.state_id=4 AND `groups`.title LIKE '%D' THEN 'D'
        WHEN `groups`.state_id=4 AND `groups`.title LIKE '%V' THEN 'V'
        END AS study_time,
    COUNT(DISTINCT `persons`.id) as Studentu_grupeje
FROM `person2gruop`
         JOIN `persons` ON `person2gruop`.person_id = `persons`.id
         JOIN `groups` ON `person2gruop`.groups_id = `groups`.id
         JOIN `users` ON `users`.person_id = `persons`.id
         JOIN `states` ON `states`.id = `users`.state_id
WHERE `groups`.state_id=4 AND (`groups`.title LIKE '%D' OR `groups`.title LIKE '%V')
GROUP BY study_time; #parodo kiek isviso studentu mokosi Aktiviose D ir V grupese

#10.Bonus2.Kiek studentų Aktyviose grupese turi jiems priskirtas 2 ir daugiau grupių
SELECT `persons`.id as student_id, count(distinct `groups`.id) as assigned_groups
FROM `person2gruop`
         left JOIN `persons` ON `person2gruop`.person_id = `persons`.id
         left JOIN `groups` ON `person2gruop`.groups_id = `groups`.id
where `groups`.state_id = 4
group by `persons`.id
HAVING count(distinct `groups`.id) >= 2; # radom studentus kurie turi 2 ir daugiau aktyviu grupiu

#COALESCE
SELECT COALESCE(NULL, persons.last_name, persons.first_name, 'W3Schools.com') as this from `akademija`.persons;# grazina tik sekanti po NULL reiksmes

