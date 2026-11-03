<?php
namespace Admin\Controller;
use Think\Controller;

/*
 * 后台操作日志
 */
class RequestLogController extends PublicController{

    /*搜索*/
    public function index(){
        //记录搜索条件
        $url_name = I('url_name', '');
        $admin_name = I('admin_name', '');

        $where = "1 ";
        if(!empty($url_name)){
            $where .= "and url_name like '%{$url_name}%' ";
        }
        if(!empty($admin_name)){
            $where .= "and admin_name like '%{$admin_name}%' ";
        }

        $count = M('request_log')
            ->where($where)
            ->count();
        $Page  = new \Think\Page($count,20);
        $list = M('request_log')
            ->where($where)
            ->limit($Page->firstRow.','.$Page->listRows)
            ->order('id desc')
            ->select();

        $search_params = [
            'url_name' => $url_name,
            'admin_name' => $admin_name,
        ];
        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count, 'search_params' => $search_params]);
        $this->display();
    }

}