<?php
namespace Admin\Controller;
use Think\Controller;
use Think\Db;

/*
 * 全局配置管理
 */
class GlobalConfigController extends PublicController{

    /*全局配置*/
    public function edit(){
        $global_config = $this->platform_db->table('global_config')->order("id desc")->find();
        $this->assign(['global_config' => $global_config]);
        $this->display();
    }
    /*全局配置*/
    public function ajax_updata(){
        $id = I('id', '0');
        if(!$id){
            $id = 0;
        }
        $role_nums_limit = I('role_nums_limit', '0');
        $is_server_full_tip = I('is_server_full_tip', '0');
        $global_config = $this->platform_db->table('global_config')->where("id=$id")->find();
        if($global_config){     //修改
            $data = [
                'role_nums_limit' => $role_nums_limit,
                'is_server_full_tip' => $is_server_full_tip,
            ];
            $res = $this->platform_db->table('global_config')->where("id=$id")->save($data);
        }else{                  //添加
            $data = [
                'role_nums_limit' => $role_nums_limit,
                'is_server_full_tip' => $is_server_full_tip,
                'created_at' => time(),
            ];
            $res = $this->platform_db->table('global_config')->where("id=$id")->add($data);
        }
        if ($res) {
            $status = ['status'=>1,'message'=>'提交成功~'];
        }else{
            $status = ['status'=>0,'message'=>'提交失败'];
        }
        $this->ajaxReturn($status);
    }


}