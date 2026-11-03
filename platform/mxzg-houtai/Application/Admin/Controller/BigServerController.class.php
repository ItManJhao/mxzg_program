<?php
namespace Admin\Controller;
use Think\Controller;

/*
 * 大区配置管理
 */
class BigServerController extends PublicController{

    /*搜索*/
    public function index(){
        //记录搜索条件
        $name = I('name', '');
        $c_son_id = I('c_son_id', '');

        $where = "1 ";
        if(!empty($c_son_id)){
            $where .= "and bs.c_son_id=$c_son_id ";
        }
        if(!empty($name)){
            $where .= "and bs.name like '%{$name}%' ";
        }

        $count = M('big_server')
            ->alias('bs')
            ->join("left join channel as ch1 on ch1.id=bs.c_son_id")
            ->join("left join channel as ch2 on ch2.id=bs.c_id")
            ->where($where)
            ->count();
        $Page  = new \Think\Page($count,20);
        $list = M('big_server')
            ->alias('bs')
            ->field('bs.*,ch1.name as channel_name,ch2.name as parent_name')
            ->join("left join channel as ch1 on ch1.id=bs.c_son_id")
            ->join("left join channel as ch2 on ch2.id=bs.c_id")
            ->where($where)
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
        //获取所有的子渠道
        $channels = M('channel')->where('parent_id!=0')->select();
        $search_params = [
            'name' => $name,
            'c_son_id' => $c_son_id,
        ];
        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count, 'channels' => $channels, 'search_params' => $search_params]);
        $this->display();
    }

    public function add(){
        //获取所有的子渠道
        $channels = M('channel')->where('parent_id!=0')->select();

        $this->assign(['channels' => $channels]);
        $this->display();
    }

    public function edit(){
        $id = I('id', 0);
        $big_server_info = M('big_server')->where('id = ' . $id)->find();
        //获取所有的子渠道
        $channels = M('channel')->where('parent_id!=0')->select();
        $this->assign(['big_server_info' => $big_server_info, 'channels' => $channels]);
        $this->display();
    }

    /*添加*/
    public function ajax_add(){
        $params = I('post.');
        $cid_str = $params['cid_str'];
        if(empty($cid_str)){
            $status = ['status'=>0,'message'=>'请选择渠道'];
            $this->ajaxReturn($status);
        }else{
            $cid_arr = explode('-', $cid_str);
            $c_son_id = $cid_arr['0'];
            $c_id = $cid_arr['1'];
        }
        $is_info = M('big_server')
            ->where("
                c_son_id = " . $c_son_id . " and 
                name = '".$params['name']."' 
            ")
            ->getField('id');

        if ($is_info) {
            $status = ['status'=>0,'message'=>'大区已经在当前渠道存在，不能重复添加'];
        }else{
            $now_time = time();
            $data = [
                'name' => $params['name'],
                'sort' => $params['sort'],
                'c_id' => $c_id,
                'c_son_id' => $c_son_id,
                'created_at' => $now_time,
            ];
            $save = M('big_server')->add($data);
            if ($save) {
                $status = ['status'=>1,'message'=>'添加成功~'];
            }else{
                $status = ['status'=>0,'message'=>'添加失败'];
            }
        }
        $this->ajaxReturn($status);
    }

    /*更新*/
    public function ajax_updata(){
        $params = I('post.');
        $id = $params['id'];    //主键id
        if(empty($id)){
            $status = ['status'=>0,'message'=>'参数出错，请返回重试1'];
            $this->ajaxReturn($status);
        }
        $big_server_info = M('big_server')->where('id = ' . $id)->find();
        if(!$big_server_info){
            $status = ['status'=>0,'message'=>'参数出错，请返回重试2'];
            $this->ajaxReturn($status);
        }

        $cid_str = $params['cid_str'];
        if(empty($cid_str)){
            $status = ['status'=>0,'message'=>'请选择渠道'];
            $this->ajaxReturn($status);
        }else{
            $cid_arr = explode('-', $cid_str);
            $c_son_id = $cid_arr['0'];
            $c_id = $cid_arr['1'];
        }
        $is_info = M('big_server')
            ->where("
                c_son_id = " . $c_son_id . " and 
                name = '".$params['name']."' and 
                id != " . $id . "
            ")
            ->getField('id');

        if ($is_info) {
            $status = ['status'=>0,'message'=>'大区已经在当前渠道存在，不能重复添加'];
        }else{
            $data = [
                'name' => $params['name'],
                'sort' => $params['sort'],
                'c_id' => $c_id,
                'c_son_id' => $c_son_id,
            ];
            $save = M('big_server')->where("id=" . $id)->save($data);

            if ($save) {
                $status = ['status'=>1,'message'=>'修改成功~'];
            }else{
                $status = ['status'=>0,'message'=>'修改失败'];
            }

        }
        $this->ajaxReturn($status);
    }

}