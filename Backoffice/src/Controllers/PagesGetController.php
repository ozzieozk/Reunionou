<?php
namespace App\Controllers;

use App\Controllers\Auth\AuthController;
use App\Models\User;
use App\Models\Event;
use Slim\Http\Request;
use Slim\Http\Response;

class PagesGetController extends Controller {

    public function home(Request $request, Response $response) {
        $this->render($response, 'Pages/Home.twig');
    }

    public function login(Request $request, Response $response) {
        $this->render($response, 'Pages/Login.twig');
    }

    public function logout(Request $request, Response $response) {
        AuthController::logout();
        return $this->redirect($response, 'login');
    }

    public function profile(Request $request, Response $response) {
        $this->render($response, 'Pages/Profile.twig');
    }

    public function createUser(Request $request, Response $response) {
        $this->render($response, 'Pages/CreateUser.twig');
    }

    public function users(Request $request, Response $response) {
        $users = User::select()->get();
        $this->render($response, 'Pages/Users.twig', ['users' => $users]);
    }

    public function events(Request $request, Response $response) {
        $events = Event::select()->get();
        $this->render($response, 'Pages/Events.twig', ['events' => $events]);
    }

}