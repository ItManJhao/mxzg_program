<?php
namespace core\lib;
use core\lib\conf;
class route{
    public $ctrl;#控制器
    public $action;#方法
    public function __construct()
    {
        //xx.com/index.php/index/index
        //xx.com/index/index
        /**
         * 1.隐藏index.php文件，引入.htaccess文件，与入口文件同级
         * 2.获取URL 参数部分，即get传值
         * 3.返回对应控制器和方法
         */
        $this->ctrl = conf::get('CTRL','route');
        $this->action = conf::get('ACTION','route');
        if(isset($_REQUEST['action'])){
            $web_action = $_REQUEST['action'];
            if (!empty($web_action)){
                $web_action_arr = explode('.', $web_action);
                if (isset($web_action_arr[0])){
                    $this->ctrl = $web_action_arr[0];
                }
                if (isset($web_action_arr[1])){
                    $this->action = $web_action_arr[1];
                }
            }
        }else{
            if (isset($_SERVER['REQUEST_URI'])&& $_SERVER['REQUEST_URI'] != '/'){
                $path = $_SERVER['REQUEST_URI'];
                $path_arr = explode('?',$path);
                $path = $path_arr[0];
                $pathArr = explode('/',trim($path,'/'));//数组
                if (isset($pathArr[0])){
                    $this->ctrl = $pathArr[0];
                    unset($pathArr[0]);
                }
                if (isset($pathArr[1])){
                    $this->action = $pathArr[1];
                    unset($pathArr[1]);
                }else{
                    $this->action = conf::get('ACTION','route');
                }
                //url 多余部分转换成GET eg:index/index/id/1 实现get传值
                $count = count($pathArr) + 2;
                $i = 2;
                while ($i < $count){
                    if (isset($pathArr[$i+1])){
                        $_GET[$pathArr[$i]] = $pathArr[$i+1];
                    }
                    $i = $i + 2;
                };
            }else{
                $this->ctrl = conf::get('CTRL','route');
                $this->action = conf::get('ACTION','route');
            }
        }
    }
}