<?php

namespace AKport\Controllers;
use AKport\FS;
class KontaktaiController
{
    public function index()
    {
        // Nuskaitomas HTML failas ir siunciam jo teksta i Output klase
        $failoSistema = new FS('../src/html/kontaktai.html');
        $failoTurinys = $failoSistema->getFailoTurinys();
        return $failoTurinys;
    }
}