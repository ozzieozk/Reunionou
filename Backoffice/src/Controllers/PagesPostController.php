<?php
namespace App\Controllers;

use Slim\Http\Request;
use Slim\Http\Response;
use App\Controllers\Auth\AuthController;
use App\Models\Admin;
use App\Models\Comment;
use App\Models\User;
use App\Models\Shared;
use App\Models\Event;
use App\Models\Location;

class PagesPostController extends Controller {

    public function login(Request $request, Response $response) {
        $email = htmlspecialchars(trim($request->getParam('email_address')));
        $password = htmlspecialchars(trim($request->getParam('password')));
        
        if(empty($email) || empty($password)) {
            $this->flash('Un ou plusieurs champs sont vide(s) !', 'error');
        } else {
            if(!AuthController::login($email, $password)) {
                $this->flash('Adresse email ou mot de passe incorrect !', 'error');
            } else {
                return $this->redirect($response, 'home');
            }
        }
        return $this->redirect($response, 'login');
    }

    public function profile(Request $request, Response $response) {
        $currentPassword = htmlspecialchars(trim($request->getParam('currentPassword')));
        $newPassword = htmlspecialchars(trim($request->getParam('newPassword')));

        if(empty($currentPassword) || empty($newPassword)) {
            $this->flash("Un ou plusieurs champs sont vides !", 'error');
        } else {
            $db_password = Admin::select('password')->where('id', $_SESSION['id'])->first();

            if(AuthController::verifyPassword($currentPassword, $db_password->password)) {
                $hashedPassword = AuthController::hashPassword($newPassword);
                Admin::where('id', $_SESSION['id'])->update(['password' => $hashedPassword]);
                $this->flash("Le mot de passe a bien été sauvegardé !");
            } else {
                $this->flash("Mot de passe actuel incorrect !", 'error');
            }
        }
        return $this->redirect($response, 'profile');
    }

    public function createUser(Request $request, Response $response) {
        $fullname_user = htmlspecialchars(trim($request->getParam('fullname_user')));
        $mail_user = htmlspecialchars(trim($request->getParam('mail_user')));
        $password_user = htmlspecialchars(trim($request->getParam('mdp_user')));
        $token_user = bin2hex(random_bytes(16));

        if(!filter_var($mail_user, FILTER_VALIDATE_EMAIL)) {
            $this->flash('Cette adresse email est invalide !', 'error');
        } else {
            if(empty($fullname_user || $mail_user || $password_user)) {
                $this->flash('Veuillez renseigner tous les champs !', 'error');
            } else {
                $exist = User::where('email', '=', $mail_user)->count();
                if($exist) {
                    $this->flash('Cette adresse e-mail est déjà utilisée !', 'error');
                } else {
                    $password_hash = AuthController::hashPassword($password_user);
                    User::insert(['fullname' => $fullname_user, 'email' => $mail_user, 'password' => $password_hash, 'token' => $token_user]);
                    $this->flash("L'utilisateur a été créé avec succès !");
                }
            }
        }        
        return $this->redirect($response, 'createUser');
    }

    public function userDelete(Request $request, Response $response) {
        $id = $request->getParam('id');
        $exist = User::where('id', '=', $id)->count();
        
        if(!$exist) {
            return "L'utilisateur que vous essayez de supprimer n'existe pas !";
        } else {
            User::where('id', $id)->delete();
            $events = Event::where('user_id', $id)->get();
            Event::where('user_id', $id)->delete();
            Shared::where('user_id', $id)->delete();
            foreach($events as $event) {
                Comment::where('event_id', $event->id)->delete();
                Shared::where('event_id', $event->id)->delete();
                Location::where('id', $event->location_id)->delete();
            }
            return "success";
        }
    }

    public function userUpdate(Request $request, Response $response) {
        $id = $request->getParam('id');
        $fullname = htmlspecialchars(trim($request->getParam('newFullname')));
        $email = htmlspecialchars(trim($request->getParam('newEmail')));
        $verifToken = htmlspecialchars(trim($request->getParam('newToken')));
        $newToken = bin2hex(random_bytes(16));
    
        $exist = User::where('id', '=', $id)->count();
    


        if(!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $this->flash('Cette adresse email est invalide !', 'error');
        } else {
            if(!$exist) {
                return "L'utilisateur que vous essayez de modifier n'existe pas !";
            } else {
                if($verifToken == 1)  {
                    User::where('id', '=', $id)->update(['fullname' => $fullname, 'email' => $email, 'token' => $newToken]);
                } else {
                    User::where('id', '=', $id)->update(['fullname' => $fullname, 'email' => $email]);
                }
                return "success";
                
            }
        } 

    }

    //Suppression d'un event
    public function eventDelete(Request $request, Response $response)
    {
      //Récupère l'id de l'event
        $id = $request->getParam('id');
        $exist = Event::where('id', '=', $id)->count();

        //Vérifie si l'event existe
        if(!$exist)
        {
            return "L'evenement que vous essayez de supprimer n'existe pas !";
        }
        else
        {
            //Récupère les attributs de l'évènement que l'on souhaite supprimer
            $event = Event::where('id', '=', $id)->get();

            //Supprime l'évènement
            Event::where('id', $id)->delete();

            //Supprime les commentaires de l'évènement
            Comment::where('event_id', $id)->delete();

            //Supprime les partages
            Shared::where('event_id', $id)->delete();

            //Obligé de faire une boucle sinon cela ne marche pas ¯\_(ツ)_/¯
            foreach($event as $e)
            {
                //Supprime la localisation
                Location::where('id', $e->location_id)->delete();
            }

            return "success";
        }
    }

}