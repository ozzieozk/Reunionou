<?php
namespace ReunionouAPI\Controllers;

use ReunionouAPI\Models\Event;
use ReunionouAPI\Models\Comment;
use ReunionouAPI\Models\Shared;
use ReunionouAPI\Models\User;

class GetController {

    public static function getEvents() {
        $events = Event::where('user_id', $_SESSION['id'])->with('location', 'author')->get();
        $events->makeHidden(['location_id', 'user_id']);

        $shareds = Shared::where('user_id', $_SESSION['id'])->with('event.location', 'event.author')->get();
        $shareds->makeHidden(['location_id', 'user_id', 'id', 'event_id']);

        for ($i = 0; $i < sizeof($shareds); $i++) {
            $shareds[$i] = $shareds[$i]['event'];
        }
        
        return json_encode(['owned' => $events, 'shared' => $shareds]);
    }

    public static function getEvent($id) {
        $owned = Event::where(['id' => $id, 'user_id' => $_SESSION['id']])->count();
        $shared = Shared::where(['event_id' => $id, 'user_id' => $_SESSION['id']])->count();

        if($owned || $shared) {
            $event = Event::where('id', $id)->with('location', 'author')->get();
            $event->makeHidden(['location_id', 'user_id']);
            return json_encode($event);
        } else {
            return json_encode(['error' => 'permissions denied']);
        }
    }

    public static function getPublicEvent($token) {
        $event = Event::where('token', $token)->with('location', 'author')->first();
        return json_encode($event);
    }

    public static function getComments() {
        $comments = Comment::where('user_id', $_SESSION['id'])->with('user')->get();
        $comments->makeHidden(['user_id']);

        $shared = Shared::where('user_id', $_SESSION['id'])->with('comments', 'user')->get();
        $shared->makeHidden(['id', 'event_id', 'user_id']);

        return json_encode(['owned' => $comments, 'shared' => $shared]);
    }

    public static function getComment($id) {
        $owned = Event::where(['id' => $id, 'user_id' => $_SESSION['id']])->count();
        $shared = Shared::where(['event_id' => $id, 'user_id' => $_SESSION['id']])->count();

        if($owned || $shared) {
            $comment = Comment::where('event_id', $id)->orderBy('id', 'DESC')->with('user')->get();
            $comment->makeHidden(['user_id']);
            return json_encode($comment);
        } else {
            return json_encode(['error' => 'permissions denied']);
        }        
    }

    public static function getPublicComments($token) {
        $event_id = Event::where('token', $token)->first()->id;
        $comments = Comment::where('event_id', $event_id)->orderBy('id', 'DESC')->with('user')->get();
        $comments->makeHidden(['user_id']);
        return json_encode($comments);
    }

    public static function getShared() {
        $shared = Shared::select()->with('event', 'user')->get();
        $shared->makeHidden(['event_id', 'user_id']);
        return json_encode($shared);
    }

    public static function getSharedEvent($id) {
        $shared = Shared::where('event_id', $id)->with('user')->get();
        $shared->makeHidden(['user_id']);
        return json_encode($shared);
    }

    public static function getUsers() {
        $users = User::select()->get();
        $users->makeHidden(['password', 'token']);
        return json_encode($users);
    }

}