<?php
require_once '../src/vendor/autoload.php';

use App\Controllers\PagesGetController;
use App\Controllers\PagesPostController;
use App\Middlewares\AuthMiddleware;
use App\Middlewares\GuestMiddleware;

session_start();

$app = new \Slim\App([
    'settings' => [
        'displayErrorDetails' => true
    ]
]);

require '../src/container.php';
require '../src/database.php';

$container = $app->getContainer();

// Middlewares
$app->add(new \App\Middlewares\FlashMiddleware($container->view->getEnvironment()));

// Routes : utilisateur non connecté
$app->group('', function() {
    // Route : Page de connexion (GET)
    $this->get('/login', PagesGetController::class . ':login')->setName('login');

    // Route : Page de connexion (POST)
    $this->post('/login', PagesPostController::class . ':login');
})->add(new GuestMiddleware($container));

// Routes : utilisateur connecté
$app->group('', function() {
    // Route : Page d'accueil (GET)
    $this->get('/', PagesGetController::class . ':home')->setName('home');

    // Route : Page de profil (GET)
    $this->get('/profile', PagesGetController::class . ':profile')->setName('profile');

    // Route : Page de profil (POST)
    $this->post('/profile', PagesPostController::class . ':profile');

    // Route : Page de déconnexion (GET)
    $this->get('/logout', PagesGetController::class . ':logout')->setName('logout');

    // Route : Page de création d'un utilisateur (GET)
    $this->get('/create/user', PagesGetController::class . ':createUser')->setName('createUser');

    // Route : Page de création d'un utilisateur (POST)
    $this->post('/create/user', PagesPostController::class . ':createUser');

    // Route : Page de gestion des utilisateurs (GET)
    $this->get('/users', PagesGetController::class . ':users')->setName('users');

    // Route : Suppression d'un utilisateur (POST)
    $this->post('/user/delete', PagesPostController::class . ':userDelete')->setName('userDelete');

    // Route : Modification d'un utilisateur (POST)
    $this->post('/user/update', PagesPostController::class . ':userUpdate')->setName('userUpdate');

    // Route : Page de gestion des events (GET)
    $this->get('/events', PagesGetController::class . ':events')->setName('events');

    // Route : Suppression d'un event (POST)
    $this->post('/event/delete', PagesPostController::class . ':eventDelete')->setName('eventDelete');


})->add(new AuthMiddleware($container));

$app->run();