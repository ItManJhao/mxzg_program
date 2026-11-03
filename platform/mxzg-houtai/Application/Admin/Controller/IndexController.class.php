<?php
namespace Admin\Controller;
use Think\Controller;
class IndexController extends PublicController{
    public function index(){
        if($_SERVER['SERVER_ADDR' ] == '172.16.0.8'){      //182.254.197.214
            $this->assign(['title_name' => C("TITLE_NAME_AN_TEST")]);
        }elseif($_SERVER['SERVER_ADDR' ] == '172.16.0.4'){  //134.175.85.111
            $this->assign(['title_name' => C("TITLE_NAME_AN_TRUE")]);
        }elseif($_SERVER['SERVER_ADDR' ] == '172.16.0.3'){   //106.52.38.134
            $this->assign(['title_name' => C("TITLE_NAME_IOS")]);
        }else{
            $this->assign(['title_name' => C("TITLE_NAME_DEFAULT")]);
        }
        $this->display();
    }
}