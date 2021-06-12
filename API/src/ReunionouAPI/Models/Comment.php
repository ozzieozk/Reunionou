<?php
namespace ReunionouAPI\Models;

use Illuminate\Database\Eloquent\Model;

class Comment extends Model
{
    
    protected $table = 'comments';
    protected $primaryKey = 'id';
    public $timestamps = false;

    public function user(){
        return $this->belongsTo('ReunionouAPI\Models\User', 'user_id');
    }

}