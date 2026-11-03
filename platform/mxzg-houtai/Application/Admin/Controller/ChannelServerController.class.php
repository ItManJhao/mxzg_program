<?php
namespace Admin\Controller;
use Think\Controller;

/*
 * 渠道的服务器配置管理
 */
class ChannelServerController extends PublicController{

    /*搜索*/
    public function index(){
        //记录搜索条件
        $c_son_id = I('c_son_id', '');
        $sid = I('sid', '');
        $show_name = I('show_name', '');
        $sort = I('sort', '');

        $where = "1 ";
        if(!empty($c_son_id)){
            $where .= "and sc.c_son_id=$c_son_id ";
        }
        if(!empty($sid)){
            $where .= "and sc.sid=$sid ";
        }
        if(!empty($show_name)){
            $where .= "and sc.show_name like '%{$show_name}%' ";
        }
        if(!empty($sort)){
            $where .= "and sc.sort=$sort ";
        }

        $count = M('server_channel')
            ->alias('sc')
            ->join("left join channel as ch on ch.id=sc.c_son_id")
            ->join("left join server on server.id=sc.sid")
            ->where($where)
            ->count();
        $Page  = new \Think\Page($count, 40);
        $list = M('server_channel')
            ->alias('sc')
            ->field('sc.*,ch.name as channel_name,server.server_name,big_server.name as big_server_name')
            ->join("left join channel as ch on ch.id=sc.c_son_id")
            ->join("left join server on server.id=sc.sid")
            ->join("left join big_server on big_server.id=sc.big_server_id")
            ->where($where)
            ->limit($Page->firstRow.','.$Page->listRows)
            ->order('id desc')
            ->select();
        //获取所有的子渠道
        $channels = M('channel')->where('parent_id!=0')->select();
        //获取所有的服务器
        $servers = M('server')->select();
        $search_params = [
            'c_son_id' => $c_son_id,
            'sid' => $sid,
            'show_name' => $show_name,
            'sort' => $sort,
        ];
        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    public function add(){
        //获取所有的子渠道
        $channels = M('channel')->where('parent_id!=0')->select();
        //获取所有的服务器
        $servers = M('server')->select();
        //获取所有的大区
        $big_servers = M('big_server')->select();

        $big_servers_data = [];
        foreach($big_servers as $big_servers_val){
            $big_servers_data[$big_servers_val['c_son_id']][] = $big_servers_val;
        }
        // var_dump($big_servers_data);exit;
        $this->assign(['channels' => $channels, 'servers' => $servers, 'big_servers_data' => $big_servers_data]);
        $this->display();
    }

    public function edit(){
        $id = I('id', 0);
        $server_channel_info = M('server_channel')->where('id = ' . $id)->find();
        //获取所有的子渠道
        $channels = M('channel')->where('parent_id!=0')->select();
        //获取所有的服务器
        $servers = M('server')->select();
        //获取所有的大区
        $big_servers = M('big_server')->select();

        $big_servers_data = [];
        foreach($big_servers as $big_servers_val){
            $big_servers_data[$big_servers_val['c_son_id']][] = $big_servers_val;
        }
        $server_channel_info['big_servers'] = $big_servers_data[$server_channel_info['c_son_id']];
//        var_dump($servers);exit;
        $this->assign(['server_channel_info' => $server_channel_info, 'channels' => $channels, 'servers' => $servers, 'big_servers_data' => $big_servers_data]);
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
        if(empty($params['sid'])){
            $status = ['status'=>0,'message'=>'请选择服务器'];
            $this->ajaxReturn($status);
        }
        if(empty($params['big_server_id'])){
            $status = ['status'=>0,'message'=>'请选择大区'];
            $this->ajaxReturn($status);
        }
        $is_info = M('server_channel')
            ->where('
                c_son_id = ' . $c_son_id .' and 
                sid = '.$params['sid'].' 
            ')
            ->getField('id');

        if ($is_info) {
            $status = ['status'=>0,'message'=>'渠道和服务器已经存在'];
        }else{
            $now_time = time();
            $data = [
                'sid' => $params['sid'],
                'c_id' => $c_id,
                'c_son_id' => $c_son_id,
                'show_name' => $params['show_name'],
                'sort' => $params['sort'],
                'device_type' => $params['device_type'],
                'big_server_id' => $params['big_server_id'],
                'created_at' => $now_time,
            ];
            $save = M('server_channel')->add($data);

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
            $status = ['status'=>0,'message'=>'参数出错，请返回重试'];
            $this->ajaxReturn($status);
        }
        $server_channel_info = M('server_channel')->where('id = ' . $id)->find();
        if(!$server_channel_info){
            $status = ['status'=>0,'message'=>'参数出错，请返回重试'];
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
        if(empty($params['sid'])){
            $status = ['status'=>0,'message'=>'请选择服务器'];
            $this->ajaxReturn($status);
        }
        if(empty($params['big_server_id'])){
            $status = ['status'=>0,'message'=>'请选择大区'];
            $this->ajaxReturn($status);
        }
        $is_info = M('server_channel')
            ->where('
                c_son_id = ' . $c_son_id . ' and 
                sid = '.$params['sid'].' and 
                id != '.$id.'
            ')
            ->getField('id');

        if ($is_info) {
            $status = ['status'=>0,'message'=>'渠道和服务器已经存在'];
        }else{
            $data = [
                'sid' => $params['sid'],
                'c_id' => $c_id,
                'c_son_id' => $c_son_id,
                'show_name' => $params['show_name'],
                'sort' => $params['sort'],
                'device_type' => $params['device_type'],
                'big_server_id' => $params['big_server_id'],
            ];
            $save = M('server_channel')->where("id=" . $id)->save($data);

            if ($save) {
                $status = ['status'=>1,'message'=>'修改成功~'];
            }else{
                $status = ['status'=>0,'message'=>'修改失败'];
            }

        }
        $this->ajaxReturn($status);
    }

    /*删除*/
    public function ajax_delete(){
        $now_time = time();
        $params = I('post.');
        $server_channel_info = M('server_channel')->where("id=" . $params['id'])->find();
        if ($server_channel_info) {
            M('server_channel')->where("id=" . $params['id'])->delete();
            $status = ['status'=>1,'message'=>'删除成功~'];
        }else{
            $status = ['status'=>0,'message'=>'参数出错，删除失败'];
        }
        $this->ajaxReturn($status);
    }

}