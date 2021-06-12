<?php
namespace App\Controllers\Auth;

use App\Controllers\Controller;
use App\Models\Admin;

class AuthController extends Controller {

    public static function login($email, $password) {
        $status = false;
        $user = Admin::where('email', $email)->first();
        if(!is_null($user)) {
            if(self::verifyPassword($password, $user->password)) {
                $_SESSION['id'] = $user->id;
                $_SESSION['email'] = $user->email;
                $status = true;
            }
        }
        return $status;
    }

    public static function logout() {
        unset($_SESSION['id']);
        unset($_SESSION['email']);
    }

    public static function isLogged() {
        if(isset($_SESSION['id'])) {
            return true;
        } else {
            return false;
        }
    }

    public static function verifyPassword($password, $db_password) {
        return password_verify($password, $db_password);
    }

    public static function hashPassword($password) {
        return password_hash($password, PASSWORD_DEFAULT);
    }

}