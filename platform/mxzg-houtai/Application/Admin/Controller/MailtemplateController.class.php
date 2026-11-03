<?php
namespace Admin\Controller;
use Think\Controller;

/**
 * Class MailtemplateController
 * @package Admin\Controller.
 * @desc 邮件模板管理
 */
class MailtemplateController extends PublicController{

    public function index(){
        //记录搜索条件
        $title = I('title', '');

        $where = "1 ";
        if(!empty($title)){
            $where .= "and mt.title like '%{$title}%' ";
        }

        $count = M('mail_template')
            ->where($where)
            ->count();
        $Page  = new \Think\Page($count,50);
        $list = M('mail_template')
            ->alias('mt')
            ->field('mt.*,bms_users.name as admin_name')
            ->join("left join bms_users on bms_users.id=mt.admin_id")
            ->where($where)
            ->order('id desc')
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
        $show = $Page->show();
        $search_params = [
            'title' => $title,
        ];
        $this->assign(['list'=>$list,'count'=>$count,'page'=>$show, 'search_params' => $search_params]);
        $this->display();
    }

    public function add(){
        //获取所有的礼包道具
        $item_list = M('gift_item')->select();
        
        $this->assign(['item_data' => $item_list]);
    	$this->display();
    }

    public function edit(){
        $id = I('id', 0);
        $mail_template_info = M('mail_template')->where('id = '.$id.'')->find();
        //获取所有的礼包道具
        $item_list = M('gift_item')->select();
        // $item_data = [];
        // foreach($item_list as $item_val){
        //     $item_data[$item_val['type']][] = $item_val;
        // }
        // $item_type_type = [];
        // foreach($this->item as $item_type_key=>$item_type_val){
        //     $item_type_type[] = [
        //         'id' => $item_type_key,
        //         'name' => $item_type_val
        //     ];
        // }

        //处理道具数据
        if(isset($mail_template_info['item_data']) && !empty($mail_template_info['item_data'])){
            $gift_item_data = json_decode($mail_template_info['item_data'], true);
            // foreach($gift_item_data as &$gift_item_val){
            //     $gift_item_val['item_data'] = $item_data[$gift_item_val['item_type_type']];
            // }
        }
        $this->assign(['mail_template_info' => $mail_template_info, 'item_data' => $item_list, 'gift_item_data' => $gift_item_data]);
        $this->display();
    }

    /*添加*/
    public function ajax_add(){
        $params = I('post.');
        if(empty($params['title'])){
            $status = ['status'=>0,'message'=>'请输入模板标题'];
            $this->ajaxReturn($status);
        }
        if(empty($params['content'])){
            $status = ['status'=>0,'message'=>'请输入模板内容'];
            $this->ajaxReturn($status);
        }
        $now_time = time();
        $gift_item_arr = [];
        foreach($params['item_type'] as $item_key=>$item_val){
            $gift_item_arr[] = [
                'item_type' => $item_val,
                'item_num' => $params['gift_item_num'][$item_key]
            ];
        }
        $item_data = json_encode($gift_item_arr);
        $data = [
            'title' => $params['title'],
            'content' => $params['content'],
            'item_data' => $item_data,
            'admin_id' => session('admin_user_id'),
            'updated_at' => $now_time,
            'created_at' => $now_time
        ];
        $id = M('mail_template')->add($data);
        if($id){
            $status = ['status'=>1,'message'=>'添加成功~'];
        }else{
            $status = ['status'=>0,'message'=>'添加失败'];
        }
        $this->ajaxReturn($status);
    }

    /*更新*/
    public function ajax_updata(){
        $params = I('post.');
        if(empty($params['title'])){
            $status = ['status'=>0,'message'=>'请输入模板标题'];
            $this->ajaxReturn($status);
        }
        if(empty($params['content'])){
            $status = ['status'=>0,'message'=>'请输入模板内容'];
            $this->ajaxReturn($status);
        }
        $now_time = time();
        $gift_item_arr = [];
        foreach($params['item_type'] as $item_key=>$item_val){
            $gift_item_arr[] = [
                'item_type' => $item_val,
                // 'item_type_type' => $params['item_type_type'][$item_key],
                'item_num' => $params['gift_item_num'][$item_key]
            ];
        }
        $item_data = json_encode($gift_item_arr);
        $data = [
            'title' => $params['title'],
            'content' => $params['content'],
            'item_data' => $item_data,
            'admin_id' => session('admin_user_id'),
            'updated_at' => $now_time,
        ];
        $res = M('mail_template')->where("id=" . $params['id'])->save($data);
        if($res){
            $status = ['status'=>1,'message'=>'修改成功~'];
        }else{
            $status = ['status'=>0,'message'=>'修改失败'];
        }
        $this->ajaxReturn($status);
    }


}