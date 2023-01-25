<?php

namespace AKport\Controllers;

use AKport\Response;

class KontaktaiController extends BaseController
{
    public function index(): Response
    {
        return $this->render('kontaktai');
    }
}