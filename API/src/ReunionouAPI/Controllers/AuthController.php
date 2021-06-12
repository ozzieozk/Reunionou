<?php
namespace ReunionouAPI\Controllers;

class AuthController {

    public static function verifyPassword($password, $db_password) {
        return password_verify($password, $db_password);
    }

    public static function hashPassword($password) {
        return password_hash($password, PASSWORD_DEFAULT);
    }

}