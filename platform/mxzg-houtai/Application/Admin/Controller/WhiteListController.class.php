<?php
namespace Admin\Controller;
use Think\Controller;

/*
 * 白名单的配置管理
 */
class WhiteListController extends PublicController{

    /*搜索*/
    public function index(){
        //记录搜索条件
        $uid = I('uid', '');
        $ip = I('ip', '');
        $status = I('status', '-1');

        $where = "1 ";
        if($status != '-1'){
            $where .= "and status=$status ";
        }
        if(!empty($uid)){
            $where .= "and uid='$uid' ";
        }
        if(!empty($ip)){
            $where .= "and ip='$ip' ";
        }

        $count = M('white_list')
            ->alias('wl')
            ->join("left join user on user.id=wl.uid")
            ->join("left join channel as ch1 on ch1.id=user.c_son_id")
            ->join("left join channel as ch2 on ch2.id=user.c_id")
            ->where($where)
            ->count();
        $Page  = new \Think\Page($count,20);
        $list = M('white_list')
            ->alias('wl')
            ->field('wl.*,ch1.name as channel_name,ch2.name as parent_name')
            ->join("left join user on user.id=wl.uid")
            ->join("left join channel as ch1 on ch1.id=user.c_son_id")
            ->join("left join channel as ch2 on ch2.id=user.c_id")
            ->where($where)
            ->limit($Page->firstRow.','.$Page->listRows)
            ->order("id desc")
            ->select();
        $search_params = [
            'uid' => $uid,
            'ip' => $ip,
            'status' => $status,
        ];
        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count, 'search_params' => $search_params]);
        $this->display();
    }

    public function add(){
        $this->display();
    }

    /*添加*/
    public function ajax_add(){
        $uid = I('post.uid', 0);
        $ip = I('post.ip', '');
        $status = I('post.status', '0');
        $note = I('post.note', '');
        if(empty($uid) && empty($ip)){
            $status = ['status'=>0,'message'=>'至少填写一项'];
            $this->ajaxReturn($status);
        }
        $now_time = time();
        $data = [
            'uid' => $uid,
            'ip' => $ip,
            'note' => $note,
            'status' => $status,
            'created_at' => $now_time,
        ];
        $save = M('white_list')->add($data);
        if ($save) {
            $status = ['status'=>1,'message'=>'添加成功~'];
        }else{
            $status = ['status'=>0,'message'=>'添加失败'];
        }
        $this->ajaxReturn($status);
    }

    //编辑
    public function edit(){
        $id = I('id', 0);
        $white_info = M('white_list')->where("id=$id")->find();
        $this->assign(['white_info'=>$white_info]);
        $this->display();
    }

    /*编辑*/
    public function ajax_update(){
        $id = I('post.id', 0);
        $uid = I('post.uid', 0);
        $ip = I('post.ip', '');
        $status = I('post.status', '0');
        $note = I('post.note', '');
        if(empty($uid) && empty($ip)){
            $status = ['status'=>0,'message'=>'至少填写一项'];
            $this->ajaxReturn($status);
        }
        $now_time = time();
        $data = [
            'uid' => $uid,
            'ip' => $ip,
            'status' => $status,
            'note' => $note,
        ];
        $save = M('white_list')->where("id=$id")->save($data);
        if ($save) {
            $status = ['status'=>1,'message'=>'修改成功~'];
        }else{
            $status = ['status'=>0,'message'=>'修改失败'];
        }
        $this->ajaxReturn($status);
    }

    /*删除*/
    public function ajax_del(){
        $id = I('post.id', 0);
        if(empty($id)){
            $status = ['status'=>0,'message'=>'参数错误，请返回重试'];
            $this->ajaxReturn($status);
        }

        $save = M('white_list')->where("id=" . $id)->delete();
        if ($save) {
            $status = ['status'=>1,'message'=>'删除成功~'];
        }else{
            $status = ['status'=>0,'message'=>'删除失败'];
        }
        $this->ajaxReturn($status);
    }

}