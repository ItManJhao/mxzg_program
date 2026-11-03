<?php
namespace Home\Controller;
use Think\Controller;
class IndexController extends PublicController {
    public function index(){
    	$this->display();
	}

	public function listshow(){
		$id=I('get.id');
		if (!$id) {
			 $this->error('参数错误！','');
		}
		$categorys=M('Category')->where(array('id'=>$id,'status'=>1))->find();
		if ($categorys['pid']==0){
			$pid=$id;
		}else{
			$pid = $categorys['pid'];
		}
		$this->assign('cate_pid', $pid);
		$this->assign('categorys', $categorys);
		$html=$categorys['html'];
		$model=$categorys['model'];
		$table = model(model($id),'Model','name');

		$DB_PREFIX = C('DB_PREFIX');

		$count = M('Content')->where(array('pid in ('.catid_str($id,$model).') and status = 1'))->count();
		if ($count>$categorys['page']) {
			$p = getpage($count,$categorys['page']);
			$list = M('Content as a')->join("".$DB_PREFIX."content_".$table." as b on b.id = a.id")->where(array('a.pid in ('.catid_str($id,$model).') and a.status = 1'))->order('a.id DESC')->limit($p->firstRow, $p->listRows)->select();
			$this->assign('list', $list);
			$this->assign('page', $p->show());
		}else{
			$p = getpage($count,$categorys['page']);
			$list = M('Content as a')->join("".$DB_PREFIX."content_".$table." as b on b.id = a.id")->where(array('a.pid in ('.catid_str($id,$model).') and a.status = 1'))->order('a.id DESC')->select();
			$this->assign('list', $list);
		}
		$this->assign('cate_id', $id);
    	$this->display($html);
	}
	
	public function details(){
		$id=I('get.id');
		$pid=I('get.pid');
		if (!$id) {
			 $this->error('参数错误！','');
		}
		if (!$pid) {
			 $this->error('参数错误！','');
		}
		$html=M('Category')->where(array('id'=>$pid))->find();
		if ($html['pid']==0) {
			$html['pid'] = $pid;
		}
		$cont_html=$html['cont_html'];
		$DB_PREFIX = C('DB_PREFIX');
		$table = model(model($pid),'Model','name');
		$info=M('Content as a')->join("".$DB_PREFIX."content_".$table." as b on b.id = a.id")->where(array('a.id'=>$id))->find();
		$info['view']=$info['view']+1;
		M('Content')->where(array('id' => $id))->save($info);
		$new_pre['id']=array('gt',$id);
		$new_next['id']=array('lt',$id);
		$pre=M('Content')->where(array('pid'=>$pid))->where($new_pre)->order('id asc')->limit('1')->find();
		$next=M('Content')->where(array('pid'=>$pid))->where($new_next)->order('id desc')->limit('1')->find();
		$this->assign('info', $info);
		$this->assign('pre', $pre);
		$this->assign('next', $next);
		$this->assign('cate_pid', $html['pid']);
		$this->assign('cate_id', $pid);
    	$this->display($cont_html);
	}

	public function massage(){
		$data=I('post.');
		if (isEmp($data)) {
			$res=[
				"status"=>0,
			];
		}else{
			$data['time'] = time();
			$re=M('Massage')->add($data);
			if ($re) {
				$res=[
					"status"=>1,
				];
			}else{
				$res=[
					"status"=>0,
				];
			}
		}
		$this->ajaxReturn($res,'JSON');
	}


	public function search(){
		$get=I('get.keywords');
		$data['title'] = array('like',"%$get%");
		$search=M("Content")->where($data)->where('status = 1')->select(); 
		$this->assign('search', $search);
		$this->display();
	}

}