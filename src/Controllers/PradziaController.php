<?php

namespace AKport\Controllers;

use AKport\FS;

class PradziaController
{
    public function index()
    {
        // Nuskaitomas HTML failas ir siunciam jo teksta i Output klase
        $failoSistema = new FS('../src/html/pradzia.html');
        $failoTurinys = $failoSistema->getFailoTurinys();
        return $failoTurinys;
    }
}