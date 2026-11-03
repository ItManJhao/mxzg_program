<?php
namespace Admin\Controller;
use Think\Controller;
class RootlistController extends PublicController{
    public function index(){
        $list = M('bms_users_root')->order('id asc')->select();
        $this->assign(['list'=>$list]);
        $this->display();
    }

    public function add(){
        // $channels = M('channel')->order('id desc')->field('id,name')->select();
        // $this->assign(['channels'=>$channels]);
        $this->display();
    }

    public function edit($id=''){
        $re = M('bms_users_root')->where('id = '.$id.'')->find();
        // $channels = M('channel')->order('id asc')->field('*')->select();
        // $channels_tree = getTree($channels);    //渠道按照树形结构返回
//        var_dump(json_encode($channels_tree));exit;
        // $this->assign(['re'=>$re,'channels_tree'=>$channels_tree]);
        $this->assign(['re'=>$re]);
        $this->display();
    }

    /*添加*/
    public function ajax_add(){
        $data = I('post.');

        // if ($data['channels_id']) {//处理渠道id
        //     $channels_id = '';
        //     foreach ($data['channels_id'] as $key => $channels) {
        //         $channels_id .= $channels.','; 
        //     }
        //     $data['channels_id'] = $channels_id;
        // }
        if ($data['menu_id']) {//后台菜单
            $menu_id = '';
            foreach ($data['menu_id'] as $key => $menu) {
                $menu_id .= $menu.','; 
            }
            $data['menu_id'] = $menu_id;
        }

        $data['created_at'] = time();

        $save = M('bms_users_root')->add($data);
        if ($save) {
            $status = ['status'=>1,'message'=>'添加成功~'];
        }else{
            $status = ['status'=>0,'message'=>'添加失败'];
        }

        $this->ajaxReturn($status);
    }

    /*更新*/
    public function ajax_updata(){
        $data = I('post.');

        // if ($data['channels_id']) {//处理渠道id
        //     $channels_id = '';
        //     foreach ($data['channels_id'] as $key => $channels) {
        //         $channels_id .= $channels.','; 
        //     }
        //     $data['channels_id'] = $channels_id;
        // }else{
        //     $data['channels_id'] = "";
        // }

        if ($data['menu_id']) {//后台菜单
            $menu_id = '';
            foreach ($data['menu_id'] as $key => $menu) {
                $menu_id .= $menu.','; 
            }
            $data['menu_id'] = $menu_id;
        }else{
            $data['menu_id'] = "";
        }

        $save = M('bms_users_root')->where('id = '.$data['id'].'')->save($data);
        if ($save || $save === 0) {
            $status = ['status'=>1,'message'=>'修改成功~'];
        }else{
            $status = ['status'=>0,'message'=>'修改失败'];
        }
        $this->ajaxReturn($status);
    }

    /*修改状态*/
    public function ajax_updata_status(){
        $data = I('post.');
        $save = M('bms_users_root')->where('id = '.$data['id'].'')->save($data);
        if ($save) {
            $status = ['status'=>1,'message'=>'状态修改成功~'];
        }else{
            $status = ['status'=>0,'message'=>'状态修改失败'];
        }
        $this->ajaxReturn($status);
    }

    /*删除*/
//    public function ajax_delete(){
//        $data = I('post.');
//        $is_cate = M('bms_users')->where('root_id = '.$data['id'].'')->find();
//        if ($is_cate) {
//             $status = ['status'=>0,'message'=>'该权限组下面存在组员'];
//        }else{
//            $delete = M('bms_users_root')->where('id = '.$data['id'].'')->delete();
//            if ($delete) {
//                $status = ['status'=>1,'message'=>'权限组删除成功~'];
//            }else{
//                $status = ['status'=>0,'message'=>'权限组删除失败'];
//            }
//        }
//        $this->ajaxReturn($status);
//    }

    /*搜索*/
    // public function search(){
    //     $key = I('get.keyword');
    //     $data['name'] = array('like',"%$key%");
    //     $search = M("bms_users_root")->where($data)->order('id desc,`orderby` asc')->select(); 
    //     $list = $this->_tree($search);
    //     $this->assign(['list'=>$list,'keyword'=>$key]);
    //     $this->display();
    // }
    
}