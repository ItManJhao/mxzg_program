<?php
namespace Admin\Controller;
use Think\Controller;

/*
 * 弹屏公告的配置管理
 */
class NoticeController extends PublicController{

    /*搜索*/
    public function index(){
        //记录搜索条件
        $name = I('name', '');
        $device_type = I('device_type', 0);
//        $c_son_id = I('c_son_id', '');

        $where = "is_show=1 ";
        if(!empty($name)){
            $where .= "and notice.name like '%{$name}%' ";
        }
        if($device_type == 0){
            $where .= "and notice.device_type in(0,1,2)";
        }else{
            $where .= "and notice.device_type in(0,$device_type)";
        }
//        if(!empty($c_son_id)){
//            $where .= "and notice.c_son_id=$c_son_id";
//        }

        $count = M('notice')->count();
        $Page  = new \Think\Page($count,20);
        $list = M('notice')
            ->field('notice.*')
            ->where($where)
            ->order('id desc')
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();

        //获取所有的子渠道
        $channels = M('channel')->where('parent_id!=0')->select();
        $search_params = [
            'name' => $name,
            'device_type' => $device_type,
//            'c_son_id' => $c_son_id,
        ];
        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count, 'search_params' => $search_params]);
        $this->display();
    }

    public function add(){
        //获取所有的子渠道
        $channels = M('channel')->where('parent_id!=0')->select();
        //获取区服分组
        $this->assign(['channels' => $channels]);
        $this->display();
    }

    public function edit(){
        $id = I('id', 0);
        $notice_info = M('notice')->where('id = '.$id.'')->find();
        //获取所有的子渠道
        $channels = M('channel')->where('parent_id!=0')->select();
        if(isset($notice_info['c_son_id']) && !empty($notice_info['c_son_id'])){
            $notice_info['c_son_id'] = explode(',', $notice_info['c_son_id']);
        }
        $this->assign(['notice_info' => $notice_info, 'channels' => $channels]);
        $this->display();
    }

    /*添加*/
    public function ajax_add(){
        $params = I('post.');
        $c_son_ids = $params['c_son_ids'];
        $c_son_id_str = implode(',', $c_son_ids);
        $now_time = time();

        $data = [
            'name' => $params['name'],
            'label' => $params['label'],
            'device_type' => $params['device_type'],
            'c_son_id' => $c_son_id_str,
            'status' => $params['status'],
            'content' => $params['content'],
            'sort' => $params['sort'],
            'start_time' => strtotime($params['start_time']),
            'end_time' => strtotime($params['end_time']),
            'updated_at' => $now_time,
            'created_at' => $now_time,
        ];
        $save = M('notice')->add($data);

        if ($save) {
            $status = ['status'=>1,'message'=>'添加成功~'];
        }else{
            $status = ['status'=>0,'message'=>'添加失败'];
        }

        $this->ajaxReturn($status);
    }

    /*更新*/
    public function ajax_updata(){
        $params = I('post.');
        $c_son_ids = $params['c_son_ids'];
        $c_son_id_str = implode(',', $c_son_ids);

        $now_time = time();
        $data = [
            'name' => $params['name'],
            'label' => $params['label'],
            'device_type' => $params['device_type'],
            'c_son_id' => $c_son_id_str,
            'status' => $params['status'],
            'content' => $params['content'],
            'sort' => $params['sort'],
            'start_time' => strtotime($params['start_time']),
            'end_time' => strtotime($params['end_time']),
            'updated_at' => $now_time,
        ];
        $save = M('notice')->where("id=" . $params['id'])->save($data);
        if ($save) {
            $status = ['status'=>1,'message'=>'修改成功~'];
        }else{
            $status = ['status'=>0,'message'=>'修改失败'];
        }
        $this->ajaxReturn($status);
    }
    /*删除*/
    public function ajax_delete(){
        $now_time = time();
        $params = I('post.');
        $notice_info = M('notice')->where("id=" . $params['id'])->find();
        if ($notice_info) {
            if($notice_info['end_time'] < $now_time){
                $data = [
                    'is_show' => 0,
                    'updated_at' => $now_time,
                ];
                M('notice')->where("id=" . $params['id'])->save($data);
                $status = ['status'=>1,'message'=>'删除成功~'];
            }else{
                $status = ['status'=>1,'message'=>'公告还没有结束，不能删除'];
            }
        }else{
            $status = ['status'=>0,'message'=>'参数出错，删除失败'];
        }
        $this->ajaxReturn($status);
    }

}