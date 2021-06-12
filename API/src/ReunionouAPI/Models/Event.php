<?php
namespace ReunionouAPI\Models;

use Illuminate\Database\Eloquent\Model;

class Event extends Model
{
    
    protected $table = 'events';
    protected $primaryKey = 'id';
    public $timestamps = false;

    protected $fillable = ['title', 'description', 'date', 'location_id', 'user_id', 'token'];

    public function location(){
        return $this->belongsTo('ReunionouAPI\Models\Location', 'location_id');
    }

    public function author(){
        return $this->belongsTo('ReunionouAPI\Models\User', 'user_id');
    }

}