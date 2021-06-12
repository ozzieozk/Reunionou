<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Shared extends Model
{
    
    protected $table = 'shared_events';
    protected $primaryKey = 'id';
    public $timestamps = false;
}