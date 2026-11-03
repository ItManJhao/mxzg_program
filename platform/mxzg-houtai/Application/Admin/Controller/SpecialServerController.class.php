<?php
namespace Admin\Controller;
use Think\Controller;

/*
 * 特殊服务器的配置管理
 */
class SpecialServerController extends PublicController{

    /*搜索*/
    public function index(){
        $count = $this->platform_db->table('special_server')->count();
        $Page  = new \Think\Page($count, 20);
        $server_list = $this->platform_db->table('special_server')->order('id desc')->limit($Page->firstRow.','.$Page->listRows)->select();
        $this->assign(['server_list' => $server_list, 'page' => $Page->show(), 'count' => $count]);
        $this->display();
    }

    public function add(){
        $this->display();
    }

    public function edit(){
        $id = I('id', 0);
        $server_info = $this->platform_db->table('special_server')->where('id = '.$id.'')->find();
        $this->assign(['server_info'=>$server_info]);
        $this->display();
    }

    /*添加*/
    public function ajax_add(){
        $params = I('post.');

        if (!$params['server_name']) {
            $status = ['status'=>0,'message'=>'请填写服务器名称'];
        }
        else if (!$params['extranet_host']) {
            $status = ['status'=>0,'message'=>'请填写服务器外网地址'];
        }
        else if (!$params['intranet_host']) {
            $status = ['status'=>0,'message'=>'请填写内网地址'];
        }
        else if (!$params['game_port']) {
            $status = ['status'=>0,'message'=>'请填写游戏端口'];
        }
        else if (!$params['http_port']) {
            $status = ['status'=>0,'message'=>'请填写HTTP端口'];
        }
        else{
            $is_server_name = $this->platform_db->table('special_server')->where('server_name = "'.$params['server_name'].'"')->getField('id');
            if ($is_server_name) {
                $status = ['status'=>0,'message'=>'该服务器名称已存在'];
            }else{
                $now_time = time();
                $data = [
                    'server_name' => $params['server_name'],
                    'extranet_host' => $params['extranet_host'],
                    'intranet_host' => $params['intranet_host'],
                    'game_port' => $params['game_port'],
                    'http_port' => $params['http_port'],
                    'note' => $params['note'],
                    'status' => $params['status'],
                    'admin_id' => session('admin_user_id'),
                    'updated_at' => $now_time,
                    'created_at' => $now_time,
                ];
                $add = $this->platform_db->table('special_server')->add($data);
                if ($add) {
                    $status = ['status'=>1,'message'=>'添加成功~'];
                }else{
                    $status = ['status'=>0,'message'=>'添加失败'];
                }
            }
        }
 
        $this->ajaxReturn($status);
    }

    /*更新*/
    public function ajax_updata(){
        $params = I('post.');

        if (!$params['id']) {
            $status = ['status'=>0,'message'=>'参数出错，请返回重试'];
        }
        else if (!$params['server_name']) {
            $status = ['status'=>0,'message'=>'请填写服务器名称'];
        }
        else if (!$params['extranet_host']) {
            $status = ['status'=>0,'message'=>'请填写服务器外网地址'];
        }
        else if (!$params['intranet_host']) {
            $status = ['status'=>0,'message'=>'请填写内网地址'];
        }
        else if (!$params['game_port']) {
            $status = ['status'=>0,'message'=>'请填写游戏端口'];
        }
        else if (!$params['http_port']) {
            $status = ['status'=>0,'message'=>'请填写HTTP端口'];
        }
        else{
            //判断服务器id是否正确
            $is_id = $this->platform_db->table('special_server')->where('id='.$params['id'])->getField('id');
            if(!$is_id){
                $status = ['status'=>0,'message'=>'数据不对，请返回重试'];
                $this->ajaxReturn($status);
            }

            //判断是否修改服务器名字是否重复
            $is_server_name = $this->platform_db->table('special_server')->where('id != '.$params['id'].' and server_name = "'.$params['server_name'].'"')->getField('id');
            if ($is_server_name) {
                $status = ['status'=>0,'message'=>'该服务器名称已存在'];
            }else{
                $now_time = time();
                $data = [
                    'server_name' => $params['server_name'],
                    'extranet_host' => $params['extranet_host'],
                    'intranet_host' => $params['intranet_host'],
                    'game_port' => $params['game_port'],
                    'http_port' => $params['http_port'],
                    'note' => $params['note'],
                    'status' => $params['status'],
                    'admin_id' => session('admin_user_id'),
                    'updated_at' => $now_time,
                ];
                $save = $this->platform_db->table('special_server')->where('id = '.$params['id'])->save($data);
                if ($save) {
                    $status = ['status'=>1,'message'=>'编辑成功~'];
                }else{
                    $status = ['status'=>0,'message'=>'编辑失败'];
                }
            }
        }
        $this->ajaxReturn($status);
    }



}