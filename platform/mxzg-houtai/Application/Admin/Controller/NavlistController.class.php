<?php
namespace Admin\Controller;
use Think\Controller;

/*
 * 菜单的配置管理
 */
class NavListController extends PublicController{
    public function index(){
        $keyword = I('get.keyword', '');
        if(!empty($keyword)){
            $data['name'] = array('like',"%{$keyword}%");
        }
        $search = M("bms_nav")->where($data)->order('`orderby` asc,id asc')->select();
        $min_pid = -1;
        foreach($search as $search_val){
            if($min_pid == -1){
                $min_pid = $search_val['pid'];
            }elseif($min_pid > $search_val['pid']){
                $min_pid = $search_val['pid'];
            }
        }
        $list = $this->_tree($search, $min_pid);
//        $list = $this->listMenu();
        $search_params = [
            'role_id' => $role_id,
        ];
        $this->assign(['list'=>$list,'search_params'=>$search_params]);
        $this->display();
    }

    public function add(){
        $search = M("bms_nav")->order('`orderby` asc,id asc')->select();
        $cate = $this->_tree($search);
//        $cate = $this->listMenu();
        $this->assign(['cate'=>$cate]);
        $this->display();
    }

    public function edit($id=''){
        $re = M('bms_nav')->where('id = '.$id.'')->find();
        $cate = $this->listMenu();
        $this->assign(['re'=>$re,'cate'=>$cate]);
        $this->display();
    }

    /*添加*/
    public function ajax_add(){
        $data = I('post.');
        $data['created_at'] = time();
        $save = M('bms_nav')->add($data);
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
        $save = M('bms_nav')->where('id = '.$data['id'].'')->save($data);
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
        $save = M('bms_nav')->where('id = '.$data['id'].'')->save($data);
        if ($save) {
            $status = ['status'=>1,'message'=>'状态修改成功~'];
        }else{
            $status = ['status'=>0,'message'=>'状态修改失败'];
        }
        $this->ajaxReturn($status);
    }

    /*修改状态*/
    public function ajax_delete(){
        $data = I('post.');
        $is_cate = M('bms_nav')->where('pid = '.$data['id'].'')->find();
        if ($is_cate) {
             $status = ['status'=>0,'message'=>'该菜单下面存在子菜单'];
        }else{
            $delete = M('bms_nav')->where('id = '.$data['id'].'')->delete();
            if ($delete) {
                $status = ['status'=>1,'message'=>'菜单删除成功~'];
            }else{
                $status = ['status'=>0,'message'=>'菜单删除失败'];
            }
        }
        $this->ajaxReturn($status);
    }

//    /*搜索*/
//    public function search(){
//        $key = I('get.keyword');
//        $data['name'] = array('like',"%$key%");
//        $data['type'] = 0;
//        $search = M("bms_nav")->where($data)->order('`orderby` asc,id asc')->select();
//        $list = $this->_tree($search);
//        $this->assign(['list'=>$list,'keyword'=>$key]);
//        $this->display();
//    }
    
}