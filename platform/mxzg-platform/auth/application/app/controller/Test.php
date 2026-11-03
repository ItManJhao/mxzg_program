<?php
namespace app\controller;

class Test extends \core\lss {
	function  __construct() {
        parent::__construct();
    }

    public function index(){
    	// phpinfo();
    	// exit;
    	echo date('Y-m-d H:i:s');
        echo '<br/>';
        echo time();
        exit;
    }

}