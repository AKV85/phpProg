<?php

namespace AKport\Repositories;

use AKport\Database;

class BaseRepository
{
    public function __construct(protected Database $db)
    {
    }
}