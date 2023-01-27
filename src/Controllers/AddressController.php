<?php

namespace AKport\Controllers;

    use AKport\HtmlRender;
    use AKport\Managers\AddressManager;
    use AKport\Request;
    use AKport\Response;
    use AKport\Validator;

class AddressController extends BaseController
{
    public const TITLE = 'Adresai';

    public function __construct(protected AddressManager $manager, Response $response, HtmlRender $htmlRender)
    {
        parent::__construct($htmlRender, $response);
    }

    public function list(Request $request): Response
    {
        $persons = $this->manager->getAll();
//        $persons = $this->manager->getFiltered($request);
//        $total = $this->manager->getTotal();
        $total = count($persons);
        $rez = $this->generateAddressTable($persons);

        return $this->render(
            'address/list',
            ['content' => $rez, 'pagination' => $this->generatePagination($total, $request), 'title' => self::TITLE],
            ['title' => self::TITLE]
        );
    }

    public function new(): Response
    {
        return $this->render('address/new');
    }

    public function store(Request $request): Response
    {
        Validator::required($request->get('country_iso'));
        Validator::required($request->get('city'));
        Validator::required($request->get('street'));
        Validator::required($request->get('postcode'));


        $this->manager->store($request);

        return $this->redirect('/addresses', ['message' => "Record created successfully"]);
    }

    public function delete(Request $request): Response
    {
        $id = (int)$request->get('id');

        Validator::required($id);
        Validator::numeric($id);
        Validator::min($id, 1);

        $this->manager->delete($request);

        return $this->redirect('/addresses', ['message' => "Record deleted successfully"]);
    }

    public function edit(Request $request): Response
    {
        $adresas = $this->manager->getOne($request);

        return $this->render('address/edit', $adresas);
    }

    public function update(Request $request): Response
    {
        Validator::required($request->get('country_iso'));
        Validator::required($request->get('city'));
        Validator::required($request->get('street'));
        Validator::required($request->get('postcode'));

        $this->manager->update($request);

        return $this->redirect('/address/show?id=' . $request->get('id'), ['message' => "Record updated successfully"]);
    }

    public function show(Request $request): Response
    {
        $address = $this->manager->getOne($request);

        return $this->render('address/show', $address);
    }

    /**
     * @param array $asmenys
     * @return string
     */
    protected function generateAddressTable(array $adresai): string
    {
        $rez = '<table class="highlight striped">
            <tr>
                <th>ID</th>
                <th>Salies ISO</th>
                <th>Miestas</th>
                <th>Gatve</th>
                <th>Pasto kodas</th>
                <th>Veiksmai</th>
            </tr>';
        foreach ($adresai as $adresas) {
            $rez .= $this->htmlRender->renderTemplate('address/address_row', $adresas);
        }
        $rez .= '</table>';
        return $rez;
    }
}