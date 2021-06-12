<?php
namespace ReunionouAPI\Models;

use Illuminate\Database\Eloquent\Model;

class Shared extends Model
{
    
    protected $table = 'shared_events';
    protected $primaryKey = 'id';
    public $timestamps = false;

    public function event(){
        return $this->belongsTo('ReunionouAPI\Models\Event', 'event_id');
    }

    public function user(){
        return $this->belongsTo('ReunionouAPI\Models\User', 'user_id');
    }

    public function comments(){
        return $this->hasMany('ReunionouAPI\Models\Comment', 'event_id');
    }

}