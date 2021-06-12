<?php
namespace ReunionouAPI\Middlewares;

use Slim\Container;
use Slim\Http\Request;
use Slim\Http\Response;
use ReunionouAPI\Models\User;

class TokenMiddleware {

    public function __construct(Container $container){
        $this->container = $container;
    }

    public function __invoke(Request $request, Response $response, $next) {
        $token = $request->getParam('token');
        if(empty($token)) {
            $resp = $response->withHeader('Content-Type', 'application/json');
            $resp->getBody()->write(json_encode(['error' => 'missing token']));
            return $resp;
        } else {
            $exist = User::where('token', $token)->count();
            if(!$exist) {
                $resp = $response->withHeader('Content-Type', 'application/json');
                $resp->getBody()->write(json_encode(['error' => 'invalid token']));
                return $resp;
            } else {
                $user = User::select('id')->where('token', $token)->first();
                $_SESSION['id'] = $user->id;
            }
        }

        return $next($request, $response);
    }

}