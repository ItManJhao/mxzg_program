<?php
namespace Common\Tag;
use Think\Template\TagLib;
class Myhtml extends TagLib{

    // 标签定义
	protected $tags   =  array(
		// 标签定义： attr 属性列表 close 是否闭合（0 或者1 默认1） alias 标签别名 level 嵌套层次
		'nav'   => array('attr' => 'key,item,type,pid,order,field','close' =>1),
		'minnav'   => array('attr' => 'key,item,type,pid,order,field','close' =>1),
		'article'   => array('attr' => 'key,item,model,limit,cateid,pid,order,field','close' =>1),
		'banner'   => array('attr' => 'key,item,pid,limit,order,field','close' =>1),
		'category'   => array('attr' => 'key,item,pid,type,limit,order,field','close' =>1),
		'mincategory'   => array('attr' => 'key,item,pid,limit,order,field','close' =>1),
		'mincategorys'   => array('attr' => 'key,item,pid,limit,order,field','close' =>1),
		'links'   => array('attr' => 'key,item,limit,order,field','close' =>1),
	);

	public function _article ($tag,$content){
		$model=!empty($tag['model'])?$tag['model']:'article';
		$limit=!empty($tag['limit'])?$tag['limit']:0;
		$field=!empty($tag['field'])?$tag['field']:'';
		$order=!empty($tag['order'])?$tag['order']:'a.order asc,a.id desc';
		$item=$tag['item'];
		$key=!empty($tag['key'])?$tag['key']:'key';
		$DB_PREFIX=C('DB_PREFIX');
		$re=M('model')->where(array('name' => $model))->find();
		if ($tag['cateid']!=null) {
			$where=!empty($tag['cateid'])?'pid='.$tag['cateid'].' and status=1':'status=1';
		}
		if ($tag['pid']!=null) {
			$where=!empty($tag['pid'])?'pid in ('.catid_str($tag['pid'],$re['id']).') and status=1':'status=1';
		}
		$str='<?php ';
		$str .= '$article=M("content as a")->join("'.$DB_PREFIX.'content_'.$model.' as b on b.id = a.id")->where("a.'.$where.'")->limit('.$limit.')->field("'. $field .'")->order("'.$order.'")->select();';//查询语句
		$str .= 'foreach ($article as $'.$key.'=>$'.$item.'):?>';
		$str .= $content;
		$str .='<?php endforeach; ?>';
		return $str;
	}


	public function _nav ($tag,$content){
		$item=$tag['item'];
		$key=!empty($tag['key'])?$tag['key']:'key';
		$type=!empty($tag['type'])?$tag['type']:1;
		$pid=!empty($tag['pid'])?$tag['pid']:0;
		$field=!empty($tag['field'])?$tag['field']:'';
		$order=!empty($tag['order'])?$tag['order']:'`order` asc,id asc';
		$str='<?php ';
		$str .= '$nav=M("Navs")->where("pid = '.$pid.' and status=1 and type_id='.$type.'")->field("'. $field .'")->order("`order` asc")->select();';//查询语句
		$str .= 'foreach ($nav as $'.$key.'=>$'.$item.'):?>';
		$str .= $content;
		$str .='<?php endforeach; ?>';
		return $str;
	}
	public function _minnav ($tag,$content){
		$item=$tag['item'];
		$key=!empty($tag['key'])?$tag['key']:'key';
		$type=!empty($tag['type'])?$tag['type']:1;
		$pid=!empty($tag['pid'])?$tag['pid']:0;
		$field=!empty($tag['field'])?$tag['field']:'';
		$limit=!empty($tag['limit'])?$tag['limit']:0;
		$order=!empty($tag['order'])?$tag['order']:'`order` asc,id asc';
		$str='<?php ';
		$str .= '$minnav=M("Navs")->where("type_id='.$type.' and status=1 and pid='.$pid.'")->field("'. $field .'")->order("`order` asc")->select();';//查询语句
		$str .= 'foreach ($minnav as $'.$key.'=>$'.$item.'):?>';
		$str .= $content;
		$str .='<?php endforeach; ?>';
		return $str;
	}

	public function _banner ($tag,$content){
		$item=$tag['item'];
		$key=!empty($tag['key'])?$tag['key']:'key';
		$field=!empty($tag['field'])?$tag['field']:'';
		$where=!empty($tag['pid'])?$tag['pid']:1;
		$limit=!empty($tag['limit'])?$tag['limit']:0;
		$order=!empty($tag['order'])?$tag['order']:'`order` asc,id asc';
		$str='<?php ';
		$str .= '$banner=M("Banner")->where("pid ='.$where.' and status=1")->limit('.$limit.')->field("'. $field .'")->order("'.$order.'")->select();';//查询语句
		$str .= 'foreach ($banner as $'.$key.'=>$'.$item.'):?>';
		$str .= $content;
		$str .='<?php endforeach; ?>';
		return $str;
	}

	public function _category($tag,$content){
		$item=$tag['item'];
		$key=!empty($tag['key'])?$tag['key']:'key';
		$limit=!empty($tag['limit'])?$tag['limit']:0;
		$field=!empty($tag['field'])?$tag['field']:'';
		$type=!empty($tag['type'])?$tag['type']:1;
		$where=!empty($tag['pid'])?$tag['pid']:0;
		$order=!empty($tag['order'])?$tag['order']:'`order` asc,id asc';
		$str='<?php ';
		$str .= '$category=M("Category")->where("pid ='.$where.' and status=1 and type = '.$type.'")->limit('.$limit.')->order("'.$order.'")->select();';//查询语句
		$str .= 'foreach ($category as $'.$key.'=>$'.$item.'):?>';
		$str .= $content;
		$str .='<?php endforeach; ?>';
		return $str;
	}

	public function _mincategory($tag,$content){
		$item=$tag['item'];
		$key=!empty($tag['key'])?$tag['key']:'key';
		$limit=!empty($tag['limit'])?$tag['limit']:0;
		$field=!empty($tag['field'])?$tag['field']:'';
		$where=!empty($tag['pid'])?$tag['pid']:0;
		$order=!empty($tag['order'])?$tag['order']:'`order` asc,id asc';
		$str='<?php ';
		$str .= '$mincategory=M("Category")->where("pid ='.$where.' and status=1")->limit('.$limit.')->order("'.$order.'")->select();';//查询语句
		$str .= 'foreach ($mincategory as $'.$key.'=>$'.$item.'):?>';
		$str .= $content;
		$str .='<?php endforeach; ?>';
		return $str;
	}
	public function _mincategorys($tag,$content){
		$item=$tag['item'];
		$key=!empty($tag['key'])?$tag['key']:'key';
		$limit=!empty($tag['limit'])?$tag['limit']:0;
		$field=!empty($tag['field'])?$tag['field']:'';
		$where=!empty($tag['pid'])?$tag['pid']:0;
		$order=!empty($tag['order'])?$tag['order']:'`order` asc,id asc';
		$str='<?php ';
		$str .= '$mincategorys=M("Category")->where("pid ='.$where.' and status=1")->limit('.$limit.')->order("'.$order.'")->select();';//查询语句
		$str .= 'foreach ($mincategorys as $'.$key.'=>$'.$item.'):?>';
		$str .= $content;
		$str .='<?php endforeach; ?>';
		return $str;
	}

	public function _links ($tag,$content){
		$item=$tag['item'];
		$key=!empty($tag['key'])?$tag['key']:'key';
		$limit=!empty($tag['limit'])?$tag['limit']:0;
		$field=!empty($tag['field'])?$tag['field']:'';
		$order=!empty($tag['order'])?$tag['order']:'`order` asc,id desc';
		$str='<?php ';
		$str .= '$links=M("Link")->where("status=1")->limit('.$limit.')->field("'. $field .'")->order("'.$order.'")->select();';//查询语句
		$str .= 'foreach ($links as $'.$key.'=>$'.$item.'):?>';
		$str .= $content;
		$str .='<?php endforeach; ?>';
		return $str;
	}
		
}