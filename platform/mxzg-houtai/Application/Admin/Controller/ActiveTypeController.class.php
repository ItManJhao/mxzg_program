<?php
namespace Admin\Controller;
use Think\Controller;
use Think\Db;

class ActiveTypeController extends PublicController{

    /*搜索*/
    public function index(){
        //记录搜索条件
        $id = I('id', '');
        $name = I('name', '');

        $where = "1 ";
        if(!empty($id)){
            $where .= "and bat.id=$id ";
        }
        if(!empty($name)){
            $where .= "and bat.name like '%{$name}%' ";
        }

        $count = M('bms_active_type')
            ->alias('bat')
            ->where($where)
            ->count();
        $Page  = new \Think\Page($count,50);
        $list = M('bms_active_type')
            ->alias('bat')
            ->field('bat.*')
            ->where($where)
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
        $show = $Page->show();
        $search_params = [
            'id' => $id,
            'name' => $name,
        ];
        $this->assign(['list'=>$list,'count'=>$count,'page'=>$show,'active_type' => $active_type, 'search_params' => $search_params]);
        $this->display();
    }


    public function add(){
        $this->display();
    }

    public function edit(){
        $id = I('id', 0);
        //获取活动数据
        $active_type_info = M('bms_active_type')->where('id = '.$id.'')->find();
        $this->assign(['active_type_info'=>$active_type_info]);
        $this->display();
    }

    /*添加*/
    public function ajax_add(){
        $params = I('post.');
        $now_time = time();
        $data = [
            'id' => $params['id'],
            'name' => $params['name'],
            'desc' => $params['desc'],
            'updated_at' => $now_time,
            'created_at' => $now_time,
        ];
        $save = M('bms_active_type')->add($data);
        if ($save) {
            $status = ['status'=>1,'message'=>'添加成功~'];
        }else{
            $status = ['status'=>0,'message'=>'添加失败'];
        }
        $this->ajaxReturn($status);
    }

    /*添加*/
    public function ajax_updata(){
        $params = I('post.');
//        $id = $params['id'];
        //判断渠道id是否有修改
        if($params['new_id'] != $params['old_id']){     //修改渠道id
            //判断渠道id是否已经存在
            $is_channel_id = M('bms_active_type')->where('id = '.$params['new_id'].' and id != '.$params['old_id'])->getField('id');
            if ($is_channel_id) {
                $status = ['status'=>0,'message'=>'该活动类型id已存在'];
                $this->ajaxReturn($status);
            }
        }

        $now_time = time();
        $data = [
            'id' => $params['new_id'],
            'name' => $params['name'],
            'desc' => $params['desc'],
            'updated_at' => $now_time,
        ];
        $save = M('bms_active_type')->where("id=" . $params['old_id'])->save($data);
        if ($save) {
            $status = ['status'=>1,'message'=>'编辑成功~'];
        }else{
            $status = ['status'=>0,'message'=>'编辑失败'];
        }
        $this->ajaxReturn($status);
    }


}