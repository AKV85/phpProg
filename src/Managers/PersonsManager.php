<?php

namespace AKport\Managers;

use AKport\Database;

class PersonsManager
{
    public function __construct(protected Database $db)
    {
    }

    public function getAll(string $search = '', int $amount = 20): array
    {
        $searchQuery = '';
        $params = [];
        if ($search) {
            $searchQuery = "WHERE p.id LIKE :search OR p.first_name LIKE :search OR p.last_name LIKE :search OR p.address_id LIKE :search OR p.email LIKE :search OR p.phone LIKE :search OR p.code LIKE :search";
            $params['search'] = '%' . $search . '%';
        }

        return $this->db->query("SELECT p.*, concat(c.title, ' - ', a.city, ' - ', a.street, ' - ', a.postcode) addresses
FROM persons p
    LEFT JOIN addresses a on p.address_id = a.id
    LEFT JOIN countries c on a.country_iso = c.iso " . $searchQuery . "
ORDER BY id DESC LIMIT " . $amount, $params);
    }

    public function getOne(int $id): array
    {
        return $this->db->query('SELECT p.*, concat(c.title, \' - \', a.city, \' - \', a.street, \' - \', a.postcode) address
                    FROM persons p
                        LEFT JOIN addresses a on p.address_id = a.id 
                        LEFT JOIN countries c on a.country_iso = c.iso
                    WHERE p.id = :id',
            ['id' => $id])[0];
    }

    public function update(array $data): void
    {
        $this->db->query(
            "UPDATE `persons` 
                SET `first_name` = :first_name, 
                    `last_name` = :last_name, 
                    `code` = :code, 
                    `email` = :email,          
                    `phone` = :phone, 
                    `address_id` = :address_id 
                WHERE `id` = :id",
            $data
        );
    }

    public function getOneById(int $id)
    {
        return $this->db->query("SELECT * FROM `persons` WHERE `id` = :id", ['id' => $id])[0];
    }

    public function deleteOne(int $id): void
    {
        $this->db->query("DELETE FROM `persons` WHERE `id` = :id", ['id' => $id]);
    }

    public function insertPerson(array $data): void
    {
        $this->db->query(
            "INSERT INTO `persons` (`first_name`, `last_name`, `code`)
                    VALUES (:first_name, :last_name, :code)",
            $data
        );
    }
}