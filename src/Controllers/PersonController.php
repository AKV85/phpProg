<?php

namespace AKport\Controllers;

use AKport\Database;
use AKport\HtmlRender;
use AKport\Managers\PersonsManager;
use AKport\Request;
use AKport\Response;
use AKport\Validator;
use AKport\Configs;

class PersonController extends BaseController
{
    public const TITLE = 'Asmenys';

    public function __construct(protected PersonsManager $manager, Response $response, HtmlRender $htmlRender)
    {
        parent::__construct($htmlRender, $response);
    }

    public function list(Request $request): Response
    {
        $amount = $request->get('amount') ?? 10;
        $search = $request->get('searchInput') ?? '';
        $asmenys = $this->manager->getAll($search, $amount);

        $rez = $this->generatePersonsTable($asmenys);

        return $this->render('person/list', $rez);
    }

    public function new(): Response
    {
        return $this->render('person/new');
    }

    public function store(Request $request): Response
    {
        Validator::required($request->get('first_name'));
        Validator::required($request->get('last_name'));
        Validator::required((int)$request->get('code'));
        Validator::numeric((int)$request->get('code'));
        Validator::asmensKodas((int)$request->get('code'));

        $this->manager->insertPerson($request->all());

        return $this->redirect('/persons', ['message' => "Record created successfully"]);
    }

    public function delete(Request $request): Response
    {
        $kuris = (int)$request->get('id');

        Validator::required($kuris);
        Validator::numeric($kuris);
        Validator::min($kuris, 1);

        $this->manager->deleteOne($kuris);

        return $this->redirect('/persons', ['message' => "Record deleted successfully"]);
    }


    public function edit(Request $request): Response
    {
        $person = $this->manager->getOne((int)$request->get('id'));

        return $this->render('person/edit', $person);
    }

    public function update(Request $request): Response
    {
        Validator::required($request->get('first_name'));
        Validator::required($request->get('last_name'));
        Validator::required($request->get('code'));
        Validator::numeric($request->get('code'));
        Validator::asmensKodas($request->get('code'));

        $this->manager->update($request->all());

        return $this->redirect('/person/show?id='.$request->get('id'), ['message' => "Record updated successfully"]);
    }

    public function show(Request $request): Response
    {
        $person = $this->manager->getOneById((int)$request->get('id'));

        return $this->render('person/show', $person);
    }

    /**
     * @param array $asmenys
     * @return string
     */
    protected function generatePersonsTable(array $asmenys): string
    {
        $rez = '<table class="highlight striped">
            <tr>
                <th>ID</th>
                <th>Vardas</th>
                <th>Pavarde</th>
                <th>Emailas</th>
                <th>Asmens kodas</th>
                <th><a href="/persons?orderby=phone">TEl</a></th>
                <th>Addr.ID</th>
                <th>Veiksmai</th>
            </tr>';
        foreach ($asmenys as $asmuo) {
            $rez .= $this->htmlRender->renderTemplate('person/person_row', $asmuo);
        }
        $rez .= '</table>';
        return $rez;
    }
}