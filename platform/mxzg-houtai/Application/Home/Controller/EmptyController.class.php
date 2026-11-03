<?php
namespace Home\Controller;
use Think\Controller;
/**
 * 空模块，主要用于显示404页面，请不要删除
 */
class EmptyController extends PublicController{
	//没有任何方法，直接执行HomeController的_empty方法
	//请不要删除该控制器
    public function index(){
        header("HTTP/1.0 404 Not Found");//404状态码  
        $this->display("index/page404"); //显示自定义的404页面模版  
    }
}
