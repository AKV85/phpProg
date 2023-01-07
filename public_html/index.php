<?php

use AKport\Authenticator;
use AKport\Controllers\AdminController;
use AKport\Controllers\PradziaController;
use AKport\Controllers\PortfolioController;
use AKport\Controllers\KontaktaiController;
use AKport\Exceptions\MissingVariableException;
use AKport\Exceptions\UnauthenticatedException;
use AKport\Exceptions\PageNotFoundException;
use AKport\FS;
use AKport\Output;
use AKport\Router;
use Monolog\Logger;
use Monolog\Handler\StreamHandler;
use AKport\HtmlRender;

require __DIR__ . '/../vendor/autoload.php';
require __DIR__ . "/../vendor/larapack/dd/src/helper.php";

$log = new Logger('Portfolios');
$log->pushHandler(new StreamHandler('../logs/klaidos.log', Logger::WARNING));

$output = new Output();

try {
    session_start();

//    // Autentifikuojam vartotoja, tikrinam jo prisijungimo busena
//    $authenticator = new Authenticator();
//    $authenticator->authenticate($_POST['username'] ?? null, $_POST['password'] ?? null);

    $router = new Router();
    $router->addRoute('GET', '', [new PradziaController(), 'index']);
    $router->addRoute('GET', 'admin', [new AdminController(), 'index']);
    $router->addRoute('GET', 'kontaktai', [new KontaktaiController(), 'index']);
    $router->addRoute('GET', 'portfolio', [new PortfolioController(), 'index']);
    $router->run();
} catch (AKport\Exceptions\PageNotFoundException $e) {
    $output->store('Neradau puslapio');
    $log->warning($e->getMessage());
} catch (AKport\Exceptions\UnauthenticatedException $e) {
    $output->store('Neteisingi prisijungimo duomenys');
    $log->warning($e->getMessage());
} catch (AKport\Exceptions\MissingVariableException $e) {
    $output->store('Kilo klaida templeite.');
    $log->warning($e->getMessage());
} catch (Exception $e) {
    $output->store('Oi nutiko klaida! Bandyk vėliau dar karta.');
    $log->error($e->getMessage());
}

// Spausdinam viska kas buvo 'Storinta' Output klaseje
$output->print();