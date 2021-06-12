<?php
namespace ReunionouAPI\Models;

use Illuminate\Database\Eloquent\Model;

class User extends Model
{
    
    protected $table = 'users';
    protected $primaryKey = 'id';
    public $timestamps = false;
    protected $hidden = ['password', 'token'];

}