<?php
namespace ReunionouAPI\Controllers;

use ReunionouAPI\Controllers\AuthController;
use ReunionouAPI\Models\Comment;
use ReunionouAPI\Models\Event;
use ReunionouAPI\Models\User;
use ReunionouAPI\Models\Location;
use ReunionouAPI\Models\Shared;

class PostController {

    public static $message = 
    [
        "empty"         =>  "Un ou plusieurs champs sont manquants !",
        "exist"         =>  "La ressource spécifiée n'existe pas !",
        "incorrect"     =>  "Email ou mot de passe incorrect !",
        "email_taken"   => "L'adresse email spécifiée n'est pas disponible !"
    ];

    private static function success(){
        return json_encode([
            'post'      => true
        ]);
    }

    private static function error(string $message){
        return json_encode([
            'post'      => false,
            'message'   => $message
        ]);
    }

    private static function generateToken(){
        return bin2hex(random_bytes(16));
    }

    public static function signin($email, $password) {
        $user = User::where('email', $email)->first();
        if(!is_null($user)) {
            if(AuthController::verifyPassword($password, $user->password)) {
                $response = [
                    'post'      =>  true,
                    'fullname'  =>  $user->fullname,
                    'email'     =>  $user->email,
                    'token'     =>  $user->token
                ];
                return json_encode($response);
            } else {
                return self::error(self::$message['incorrect']);
            }
        } else {
            return self::error(self::$message['incorrect']);
        }
    }

    public static function signup($fullname, $email, $password) {
        $user = User::where('email', $email)->first();
        if(is_null($user)) {
            $password = AuthController::hashPassword($password);
            $token = self::generateToken();
            User::insert(['fullname' => $fullname, 'email' => $email, 'password' => $password, 'token' => $token]);
            return self::success();
        } else {
            return self::error(self::$message['email_taken']);
        }
    }

    public static function postEvent($title, $description, $date, $location, $x, $y) {
        if(empty($title) || empty($description) || empty($date) || empty($location) || empty($x) || empty ($y)) {
            return self::error(self::$message['empty']);
        } else {
            Location::insert(['name' => $location, 'x' => $x, 'y' => $y]);
            $location_lastInsertedId = Location::latest('id')->first()->id;

            $token = self::generateToken();
            Event::insert(['title' => $title, 'description' => $description, 'date' => $date, 'location_id' => $location_lastInsertedId, 'user_id' => $_SESSION['id'], 'token' => $token]);

            return self::success();
        }
    }

    public static function editEvent($id, $title, $description, $date, $location, $x, $y) {
        if(empty($title) || empty($description) || empty($date) || empty($location) || empty($x) || empty ($y)) {
            return self::error(self::$message['empty']);
        } else {
            $exist = Event::where('id', $id)->count();
            if(!$exist) {
                return self::error(self::$message['exist']);
            } else {
                $location_id = Event::where('id', $id)->first()->location_id;
                Location::where('id', $location_id)->update(['name' => $location, 'x' => $x, 'y' => $y]);
    
                Event::where('id', $id)->update(['title' => $title, 'description' => $description, 'date' => $date]);
    
                return self::success();
            }
        }
    }

    public static function deleteEvent($id){
        $exist = Event::where(['id' => $id, 'user_id' => $_SESSION['id']])->count();
        if(!$exist) {
            return self::error(self::$message['exist']);
        } else {
            Comment::where('event_id', $id)->delete();
            Shared::where('event_id', $id)->delete();
            Event::where('id', $id)->delete();

            return self::success();
        }
    }

    public static function postComment($id, $content, $event_id){
        if(empty($content) || empty($event_id)) {
            return self::error(self::$message['empty']);
        } else {
            Comment::insert(['content' => $content, 'user_id' => $_SESSION['id'], 'event_id' => $event_id]);

            $response = [
                'post'      => true,
                'user_id'   => $_SESSION['id'],
                'event_id'  =>  $event_id
            ];

            return json_encode($response);
        }
    }

    public static function editProfile($fullname, $email, $password) {
        if(empty($fullname) || empty($email) || empty($password)) {
            return self::error(self::$message['empty']);
        } else {
            $exist = User::where('email', $email)->where('id', '!=', $_SESSION['id'])->count();
            if($exist) {
                return self::error(self::$message['email_taken']);
            } else {
                $password = AuthController::hashPassword($password);
                User::where('id', $_SESSION['id'])->update(['fullname' => $fullname, 'email' => $email, 'password' => $password]);

                return self::success();
            }
        }
    }

    public static function postShared($event_id, $user_id) {
        if(empty($event_id) || empty($user_id)) {
            return self::error(self::$message['empty']);
        } else {
            Shared::insert(['event_id' => $event_id, 'user_id' => $user_id]);

            return self::success();
        }
    }

}