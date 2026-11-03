<?php 


//获取详情页其他相关内容
function list_nin_cont($id,$pid){
	$where['a.id'] = array('not in',$id);//不查询现在浏览的这篇内容
	$table = model(model($pid),'Model','name');
	$DB_PREFIX = C('DB_PREFIX');

	$list = M('Content as a')->join("".$DB_PREFIX."content_".$table." as b on b.id = a.id")->where(array('a.pid in ('.catid_str($pid,model($pid)).')'))->where($where)->order('a.order asc,a.id desc')->select();
	return $list;
}


