<?php

namespace AKport\Controllers;

use AKport\Response;
use AKport\Request;

class PradziaController extends BaseController
{
    public function index(Request $request): Response
    {
        return $this->render('pradzia', $request->all());
    }
}