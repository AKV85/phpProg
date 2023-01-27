<?php

use AKport\Authenticator;
use AKport\Controllers\AdminController;
use AKport\Controllers\KontaktaiController;
use AKport\Controllers\PersonController;
use AKport\Controllers\AddressController;
use AKport\Controllers\PradziaController;
use AKport\ExceptionHandler;
use AKport\Output;
use AKport\Router;
use DI\ContainerBuilder;
use Monolog\Logger;
use Monolog\Handler\StreamHandler;

require __DIR__ . '/../vendor/autoload.php';
require __DIR__ . '/../vendor/larapack/dd/src/helper.php';

$log = new Logger('Portfolios');
$log->pushHandler(new StreamHandler('../logs/klaidos.log', Logger::INFO));

$output = new Output();

try {
    session_start();

    $containerBuilder = new ContainerBuilder();
    $container = $containerBuilder->build();

    $adminController = $container->get(AdminController::class);
    $kontaktaiController = $container->get(KontaktaiController::class);
    $personController = $container->get(PersonController::class);
    $addressController = $container->get(AddressController::class);

    $router = $container->get(Router::class);
    $router->addRoute('GET', '', [$container->get(PradziaController::class), 'index']);
    $router->addRoute('GET', 'admin', [$adminController, 'index']);
    $router->addRoute('POST', 'login', [$adminController, 'login']);
    $router->addRoute('GET', 'logout', [$adminController, 'logout']);
    $router->addRoute('GET', 'kontaktai', [$kontaktaiController, 'index']);
    $router->addRoute('GET', 'persons', [$personController, 'list']);
    $router->addRoute('GET', 'person/new', [$personController, 'new']);
    $router->addRoute('GET', 'person/delete', [$personController, 'delete']);
    $router->addRoute('GET', 'person/edit', [$personController, 'edit']);
    $router->addRoute('GET', 'person/show', [$personController, 'show']);
    $router->addRoute('POST', 'person', [$personController, 'store']);
    $router->addRoute('POST', 'person/update', [$personController, 'update']);
    $router->addRoute('GET', 'addresses', [$addressController, 'list']);
    $router->addRoute('GET', 'address/new', [$addressController, 'new']);
    $router->addRoute('GET', 'address/delete', [$addressController, 'delete']);
    $router->addRoute('GET', 'address/edit', [$addressController, 'edit']);
    $router->addRoute('GET', 'address/show', [$addressController, 'show']);
    $router->addRoute('POST', 'address', [$addressController, 'store']);
    $router->addRoute('POST', 'address/update', [$addressController, 'update']);
    $router->run();
}
catch (Exception $e) {
    $handler = new ExceptionHandler($output, $log);
    $handler->handle($e);
    $output->print();
}
