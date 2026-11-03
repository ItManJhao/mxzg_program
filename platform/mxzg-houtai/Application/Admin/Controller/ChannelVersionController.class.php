<?php
namespace Admin\Controller;
use Think\Controller;

/*
 * 渠道版本配置管理
 */
class ChannelVersionController extends PublicController{

    /*搜索*/
    public function index(){

        $count = $this->platform_db->table('channel_version')->count();
        $Page  = new \Think\Page($count,20);
        $list = $this->platform_db->table('channel_version')
            ->field('channel_version.*,ch1.name as channel_name')
            ->join("left join channel as ch1 on ch1.id=channel_version.c_id")
            ->where($where)
            ->order('id desc')
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();

        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count]);
        $this->display();
    }

    public function add(){
        //获取所有的大渠道
        $channels = M('channel')->where('parent_id>0')->select();
        $this->assign(['channels' => $channels]);
        $this->display();
    }

    public function edit(){
        $id = I('id', 0);
        $channel_version_info = $this->platform_db->table('channel_version')->where('id = '.$id.'')->find();
        //获取所有的子渠道
        $channels = M('channel')->where('parent_id>0')->select();
        $this->assign(['channel_version_info' => $channel_version_info, 'channels' => $channels]);
        $this->display();
    }

    /*添加*/
    public function ajax_add(){
        $cid_str = I('post.cid_str');
        if(empty($cid_str)){
            $status = ['status'=>0,'message'=>'请选择渠道'];
            $this->ajaxReturn($status);
        }else{
            $cid_arr = explode('-', $cid_str);
            $c_son_id = $cid_arr['0'];
            $c_id = $cid_arr['1'];
        }
        $package_version = I('post.package_version');
        if(empty($package_version)){
            $status = ['status'=>0,'message'=>'请输入包版本'];
            $this->ajaxReturn($status);
        }
        $version = I('post.version');
        if(empty($version)){
            $status = ['status'=>0,'message'=>'请输入资源版本'];
            $this->ajaxReturn($status);
        }
        $is_past = I('post.is_past', 0);
        $now_time = time();

        // $channel_version_info = $this->platform_db->table('channel_version')->where("c_son_id=$c_son_id")->find();
        // if($channel_version_info){
        //     $status = ['status'=>0,'message'=>'渠道已经添加过，请重新选择'];
        //     $this->ajaxReturn($status);
        // }
        $data = [
            'c_id' => $c_id,
            'c_son_id' => $c_son_id,
            'package_version' => $package_version,
            'version' => $version,
            'is_past' => $is_past,
            'updated_at' => $now_time,
            'created_at' => $now_time,
        ];
        $save = $this->platform_db->table('channel_version')->add($data);

        if ($save) {
            $status = ['status'=>1,'message'=>'添加成功~'];
        }else{
            $status = ['status'=>0,'message'=>'添加失败'];
        }

        $this->ajaxReturn($status);
    }

    /*更新*/
    public function ajax_updata(){
        $id = I('post.id');
        $package_version = I('post.package_version');
        if(empty($package_version)){
            $status = ['status'=>0,'message'=>'请输入包版本'];
            $this->ajaxReturn($status);
        }
        $version = I('post.version');
        if(empty($version)){
            $status = ['status'=>0,'message'=>'请输入资源版本'];
            $this->ajaxReturn($status);
        }
        $is_past = I('post.is_past', 0);

        $now_time = time();
        $data = [
            'package_version' => $package_version,
            'version' => $version,
            'is_past' => $is_past,
            'updated_at' => $now_time,
        ];
        $save = $this->platform_db->table('channel_version')->where("id=" . $id)->save($data);
        if ($save) {
            $status = ['status'=>1,'message'=>'修改成功~'];
        }else{
            $status = ['status'=>0,'message'=>'修改失败'];
        }
        $this->ajaxReturn($status);
    }

}