<?php
namespace Home\Controller;

use Think\Controller;

/*
 * 接受管理员账号与密码
 */
class UserController extends PublicController{

    /**
     * 自动发送服务器到游戏那边
     */
    public function receive(){
        $retutn = [
            'code' => 0,
            'msg' => ''
        ];

        $now_time = time();
        $id = I('id', '');
        $name = I('name', '');
        $password = I('password', '');
        $belongs_to = I('belongs_to', '');
        $status = I('status', 1);
        if(empty($name)){
            $retutn['msg'] = '用户名不能为空';
            $this->ajaxReturn($retutn);
        }
        if(empty($password)){
            $retutn['msg'] = '密码不能为空';
            $this->ajaxReturn($retutn);
        }
        if(empty($belongs_to)){
            $retutn['msg'] = '名字不能为空';
            $this->ajaxReturn($retutn);
        }
        
        $data = [
            'name' => $name,
            'password' => $password,
            'belongs_to' => $belongs_to,
            'status' => $status,
            'updated_at' => $now_time,
        ];
        
        $user_info = $this->platform_db->table('bms_users')->where('id = '.$id.'')->find();
        if(!$user_info){    //添加
            $data['id'] = $id;
            $data['root_id'] = 1000;
            $data['created_at'] = $now_time;
            $res = $this->platform_db->table('bms_users')->add($data);
        }else{
            $res = $this->platform_db->table('bms_users')->where("id=$id")->save($data);
        }
        
        if(!$res){
            $retutn['msg'] = '平台接收失败';
            $this->ajaxReturn($retutn);
        }
        $retutn = [
            'code' => 200,
            'msg' => '平台接收成功'
        ];
        $this->ajaxReturn($retutn);
        
    }


}