<?php
namespace Admin\Controller;
use Think\Controller;

/*
 * 渠道的配置管理
 */
class ChannelController extends PublicController{

    /*搜索*/
    public function index(){
        //记录搜索条件
        $id = I('id', '');
        $parent_name = I('parent_name', '');
        $name = I('name', '');

        $where = "1 ";
        if(!empty($id)){
            $where .= "and ch1.id=$id";
        }
        if(!empty($parent_name)){
            $where .= "and ch2.name like '%{$parent_name}%'";
        }
        if(!empty($name)){
            $where .= "and ch1.name like '%{$name}%'";
        }

        $count = M('channel')
            ->alias('ch1')
            ->field('ch1.*,ch2.name as parent_name')
            ->join("left join channel as ch2 on ch2.id=ch1.parent_id")
            ->where($where)
            ->count();
        $Page  = new \Think\Page($count,20);
        $list = M('channel')
            ->alias('ch1')
            ->field('ch1.*,ch2.name as parent_name')
            ->join("left join channel as ch2 on ch2.id=ch1.parent_id")
            ->where($where)
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
        $search_params = [
            'id' => $id,
            'parent_name' => $parent_name,
            'name' => $name,
        ];
        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count, 'search_params' => $search_params]);
        $this->display();
    }

    public function add(){
        //获取父渠道（大渠道）
        $parent_channels = M('channel')->where('parent_id=0')->select();
        $this->assign(['parent_channels' => $parent_channels]);
        $this->display();
    }

    public function edit(){
        $id = I('id', 0);
        $channel_info = M('channel')->where('id = '.$id.'')->find();
        //获取父渠道（大渠道）
        $parent_channels = M('channel')->where('parent_id=0')->select();
        $this->assign(['channel_info' => $channel_info, 'parent_channels' => $parent_channels]);
        $this->display();
    }

    /*添加*/
    public function ajax_add(){
        $params = I('post.');
        if(empty($params['id'])){
            $status = ['status'=>0,'message'=>'请填写渠道id'];
            $this->ajaxReturn($status);
        }
        if(empty($params['name'])){
            $status = ['status'=>0,'message'=>'请填写渠道名称'];
            $this->ajaxReturn($status);
        }
        $is_channel_id = M('channel')->where('id = '.$params['id'].'')->getField('id');
        $is_channel_name = M('channel')->where('name = "'.$params['name'].'"')->getField('id');

        if ($is_channel_id) {
            $status = ['status'=>0,'message'=>'该渠道ID已存在'];
        }else{
            $now_time = time();
            $data = [
                'id' => $params['id'],
                'parent_id' => $params['parent_id'],
                'name' => $params['name'],
                'desc' => $params['desc'],
                'updated_at' => $now_time,
                'created_at' => $now_time,
            ];
            $save = M('channel')->add($data);

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
        //判断渠道id是否有修改
        if($params['new_id'] != $params['old_id']){     //修改渠道id
            //判断渠道id是否已经存在
            $is_channel_id = M('channel')->where('id = '.$params['new_id'].' and id != '.$params['old_id'])->getField('id');
            if ($is_channel_id) {
                $status = ['status'=>0,'message'=>'该渠道ID已存在'];
                $this->ajaxReturn($status);
            }
        }

        $now_time = time();
        $data = [
            'id' => $params['new_id'],
            'parent_id' => $params['parent_id'],
            'name' => $params['name'],
            'desc' => $params['desc'],
            'updated_at' => $now_time,
        ];
        $save = M('channel')->where("id=" . $params['old_id'])->save($data);
        if ($save) {
            $status = ['status'=>1,'message'=>'修改成功~'];
        }else{
            $status = ['status'=>0,'message'=>'修改失败'];
        }
        $this->ajaxReturn($status);
    }

}