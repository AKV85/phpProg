<?php

namespace AKport;

use AKport\Exceptions\PageNotFoundException;

class Router
{
    private array $routes = [];

    public function addRoute(string $method, string $url, array $controllerData): void//Funkcijos pavadinimas
        // yra "addRoute", ji priima tris parametrus: "string" tipo "method", "string" tipo "url" ir "array"
        // tipo "controllerData", ir ji negrąžina jokio rezultato (`void`).
    {
        $this->routes[$method][$url] = $controllerData;// Ši eilutė prideda naują maršrutą į $routes masyvą.
    }

    public function run():void//
    {
        $method = $_SERVER['REQUEST_METHOD'];// $method yra kintamasis, kuris saugo HTTP užklausos tipą
        // (pvz., "GET", "POST" ir t.t.).
        $url = $_SERVER['REQUEST_URI'];// $url yra kintamasis, kuris saugo užklausimo URL.
        $url = explode('?', $url)[0];// Ši eilutė išskiria URL nuo galimų URL parametrų.
        $url = rtrim($url, '/'); // /admin/ => /admin    Ši eilutė ištrina visus "/" simbolius
        $url = ltrim($url, '/'); // admin/ -> admin

        if (isset($this->routes[$method][$url])) {// Jei toks maršrutas yra nustatytas,
            $controllerData = $this->routes[$method][$url];// išsaugome kontrolerio duomenis į $controllerData kintamąjį,
            $controller = $controllerData[0];// išsaugome kontrolerio pavadinimą į $controller kintamąjį,
            $action = $controllerData[1];// išsaugome veiksmo pavadinimą į $action kintamąjį,
            $response = $controller->$action();// ir paleidžiame nurodytą veiksmą su $response kintamuoju.
        } else {
            throw new PageNotFoundException('404');// išmetame "PageNotFoundException" klaidą su tekstu "404".
        }

        echo $response;// Išvedame atsakymą į naršyklę.
    }
}