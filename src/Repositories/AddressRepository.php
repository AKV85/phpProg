<?php

namespace AKport\Repositories;

class AddressRepository extends BaseRepository implements RepositoryInterface
{
    public function create(array $data): void
    {
        $this->db->query(
            "INSERT INTO `addresses` (`country_iso`, `city`, `street`, `postcode`)
                    VALUES (:country_iso, :city, :street, :postcode)",
            $data
        );
    }

    public function findById(int $id): array
    {
        return $this->db->query("SELECT * FROM `addresses`  WHERE id = :id", ['id' => $id])[0];
    }

//    public function findFullPerson(int $id): array
//    {
//        return $this->db->query('SELECT p.*, CONCAT_WS(\' - \', c.title, a.city, a.street, a.postcode) address
//                    FROM persons p
//                        LEFT JOIN addresses as on p.address_id = a.id
//                        LEFT JOIN countries c on a.country_iso = c.iso
//                    WHERE p.id = :id',
//            ['id' => $id])[0];
//    }

    public function update(array $data): void
    {
        $this->db->query(
            "UPDATE `addresses` 
                    SET `country_iso` = :country_iso, 
                        `city` = :city, 
                        `street` = :street, 
                        `postcode` = :postcode        
                    WHERE `id` = :id",
            $data
        );
    }

    public function delete(int $id): void
    {
        $this->db->query(
            "DELETE FROM `addresses` WHERE `id` = :id",
            ['id' => $id]
        );
    }

    public function findAll(): array
    {


        return $this->db->query("SELECT * FROM `addresses`");
    }
}