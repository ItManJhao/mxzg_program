<?php 

use Think\Db;



// /**
//  * 计算公会可以加成的值
//  */
// function getClanSkillData($profession, $skill_arr)
// {
//     $data = [];
//     //获取加成配置
//     $clan_skill_config = M('clan_skill_config')->select();
//     foreach($profession as $profession_key=>$profession_val){
//         $data[$profession_key] = [
//             'id' => $profession_val['id'],
//             'name' => $profession_val['name'],
//             'level' => 0,
//             'skill_type_1' => '0%',
//             'skill_type_2' => '0%',
//             'skill_type_3' => '0%',
//             'skill_type_4' => '0%',
//             'skill_type_5' => 0,
//             'skill_type_6' => '0%',
//         ];
//         if(isset($skill_arr[$profession_val['id']])){
//             $skillType = $skill_arr[$profession_val['id']]['skillType'];
//             $level = $skill_arr[$profession_val['id']]['level'];
//             $data[$profession_key]['level'] = $level;
//             foreach($clan_skill_config as $config_val){
//                 if($skillType >= $config_val['id']){
//                     $level_re = $level;
//                 }else{
//                     $level_re = $level -1;
//                 }
//                 if($config_val['id'] != 5){
//                     $data[$profession_key]['skill_type_' . $config_val['id']] = $level_re * $config_val['num']/100 . '%';
//                 }else{
//                     $data[$profession_key]['skill_type_' . $config_val['id']] = $level_re * $config_val['num'];
//                 }

//             }
//         }
//     }
//     return $data;
// }
/**
 * 计算公会可以加成的值
 */
function getClanSkillData($profession, $skill_arr)
{
    $data = [];
    //获取加成配置
    $clan_skill_config = M('clan_skill_config')->order("occupation,ability asc")->select();
    foreach($profession as $profession_key=>$profession_val){
        if(isset($skill_arr[$profession_val['id']])){
            $skillType = $skill_arr[$profession_val['id']]['skillType'];
            $level = $skill_arr[$profession_val['id']]['level'];
            $data[$profession_key]['id'] = $profession_key;
            $data[$profession_key]['name'] = $profession_val['name'];
            $data[$profession_key]['level'] = $level;
            foreach($clan_skill_config as $config_val){
                if($profession_key == $config_val['occupation']){
                    if($skillType >= $config_val['type']){
                        $level_re = $level;
                    }else{
                        $level_re = $level -1;
                    }
                    if($config_val['type'] != 5){
                        $data[$profession_key]['skill_type_' . $config_val['ability']] = sprintf("%.1f", $level_re * $config_val['num']/100) . '%';
                    }else{
                        $data[$profession_key]['skill_type_' . $config_val['ability']] = $level_re * $config_val['num'];
                    }
                }
            }
        }
    }
    return $data;
}

/**
 * 毫秒转日期
 */
function getMsecToMescdate($msectime)
{
    $msectime = $msectime * 0.001;
    if (strstr($msectime, '.')) {
        sprintf("%01.3f", $msectime);
        list($usec, $sec) = explode(".", $msectime);
        $sec = str_pad($sec, 3, "0", STR_PAD_RIGHT);
    } else {
        $usec = $msectime;
        $sec = "000";
    }
    $date = date("Y-m-d H:i:s.x", $usec);
    return $mescdate = str_replace('x', $sec, $date);
}

/**
 * 计算目标时间与当前时间的差值
 * @param  [int]    $time  [目标时间戳]
 * @return [string]        [时间差]
 */
function calculateTime($time) {
    $len = strlen($time);
    if($len < 10){
        return '';
    }elseif(strlen($time) > 10) {  //毫秒
        $time = substr($time,0,10);
    }
    $now = time();
    $diff = $now - $time;

    $map = array(
        array('unit' => '天', 'value' => 86400),
        array('unit' => '时', 'value' => 3600),
        array('unit' => '分', 'value' => 60),
        array('unit' => '秒', 'value' => 1),
    );

    $format = '';
    $length = 0;
    foreach($map as $v){
        if($length >= 2) continue;
        if(($date = intval($diff / $v['value'])) > 0){
            $diff -= $date * $v['value'];
            $format .= $date . $v['unit'];
            $length++;
        }
    }
    return $format;
}
/**
 * 统计报表时间转换格式
 * @param  [type] $time [description]
 * @return [type]       [description]
 */
function statTimeFormat($time) {
    // $date = '';
    // if($time > 86400) {//天
    // 	$day = intval($time / 86400);
    // 	$date = $day.'d'.statTimeFormat($time % 86400);
    // }elseif($time > 3600) {//小时
    // 	$hour = intval($time / 3600);
    // 	$date = $hour.'h'.statTimeFormat($time % 3600);
    // }elseif($time > 60) {//分数
    // 	$min = intval($time / 60);
    // 	$date = $min.'m'.statTimeFormat($time % 60);
    // }elseif($time >= 0){//秒
    // 	$date = $time . "s";
    // }

    //2019-10-10-lby--修改时间格式为00:00:00
    if($time >= 3600){
        $hour = intval($time/3600);
        $time = $time % 3600;
    }else{
        $hour = '00';
    }
    if($time >= 60){
        $min = intval($time/60);
        $time = $time % 60;
    }else{
        $min = '00';
    }
    if($time > 0){
        $second = $time;
    }else{
        $second = '00';
    }
    $date = str_pad($hour,2,'0',STR_PAD_LEFT) . ':' . str_pad($min,2,'0',STR_PAD_LEFT) . ':' . str_pad($second,2,'0',STR_PAD_LEFT);
    return $date;
}

/* 获取内容 */
function get_val($table,$field_id = 'id',$field,$val){
    $re = M($table)->where(array(''.$field_id.'' => $field))->getField($val);
    return $re;
}

/*获取多个当前下面子信息*/
function get_list($table,$field_id = 'id',$field,$val,$str){
    $list = M($table)->where(array(''.$field_id.'' => $field))->field(''.$val.'')->select();
    foreach ($list as $key => $value) {
        $channels_list .= $value[''.$val.''].''.$str.''; 
    }
    return $channels_list;
}

/*获取多个当前下面子信息*/
function channels_list($table,$field_id = 'id',$field,$str){
    $list = M($table)->where(array(''.$field_id.'' => $field))->field('id,name')->select();
    foreach ($list as $key => $value) {
        $channels_list .= $value['id'].' - '.$value['name'].$str.''; 
    }
    return $channels_list;
}

function sub_channels_server($table,$field_id = 'id',$field,$str){
    $list = M($table)->where(array(''.$field_id.'' => $field))->field('id,server_name')->select();
    foreach ($list as $key => $value) {
        $channels_list .= $value['id'].' - '.$value['server_name'].$str.''; 
    }
    return $channels_list;
}

/**
 * 递归实现无限极分类
 * @param $array 分类数据
 * @param $pid 父ID
 * @param $level 分类级别
 * @return $list 分好类的数组 直接遍历即可 $level可以用来遍历缩进
 */

function getTree($array, $pid =0, $level = 0){

    //声明静态数组,避免递归调用时,多次声明导致数组覆盖
    static $list = [];
    foreach ($array as $key => $value){
        //第一次遍历,找到父节点为根节点的节点 也就是pid=0的节点
        if ($value['parent_id'] == $pid){
            //父节点为根节点的节点,级别为0，也就是第一级
            $value['level'] = $level;
            //把数组放到list中
            $list[] = $value;
            //把这个节点从数组中移除,减少后续递归消耗
            unset($array[$key]);
            //开始递归,查找父ID为该节点ID的节点,级别则为原级别+1
            getTree($array, $value['id'], $level+1);

        }
    }
    return $list;
}

if (!function_exists('getOnlyCode')) {
    function getOnlyCode($length = 10, $chars = '')
    {
        if (empty($chars)){
            $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ23456789";
        }
        for ($i = 0, $str = '', $lc = strlen($chars)-1; $i < $length; $i++){
            $str .= $chars[mt_rand(0, $lc)];
        }
        return $str;
    }
}

if (!function_exists('getPHPExcelRead')) {
    /**
     * 返回成功的json数组
     * @param array $data
     * @return \Illuminate\Http\JsonResponse
     */
    function getPHPExcelRead($file_name)
    {
        $excel_data = array();
        vendor('PHPExcel.PHPExcel');
        vendor('PHPExcel.PHPExcel.Writer.Excel2007');
        vendor('PHPExcel.PHPExcel.Writer.Excel5');
        Vendor("PHPExcel.PHPExcel.IOFactory");
        $file_suffix = substr(strrchr($file_name, '.'), 1);
        if ($file_suffix =='xlsx') {
            $objReader = \PHPExcel_IOFactory::createReader('Excel2007');
        } else if ($file_suffix =='xls') {
            $objReader = \PHPExcel_IOFactory::createReader('Excel5');
        }
        $excel_read = $objReader->load($file_name);
        return $excel_read;
    }
}


/*区服状态*/
function server_status($status){
    if ($status == 0) {
        $re = '未开放';
    }elseif ($status == 1) {
        $re = '爆满';
    }elseif ($status == 2) {
        $re = '流畅';
    }elseif ($status == 3) {
        $re = '维护';
    }
    return $re;
}

/*获取区服数组库配置*/
function server_db_list($id,$val){
    $vals = get_val('server','id',get_val('user_server','uid',$id,'server_id'),''.$val.'');
  
    return $vals;
}
 
function tree($data,$pid = 0,$level=1)
{
    static $treeArr = array();
    foreach ($data as $v)
    {
        if ($v['pid'] == $pid)
        {
            $v['level'] = $level;
            $treeArr[] = $v;
            tree($data, $v['id'], $level + 1);
        }
    }
    return $treeArr;
}

/* 传递一个id 找出下面所有子分类包括自身 */
function getSubIds($pid)
{
    $info = M('Category')->order(array('order','order'=>'desc'))->select();
    $list = tree($info,$pid);
    $res = array();
    foreach($list as $v)
    {
        $res[] = $v['id'];
    }
    $res[] = $pid;
    return $res;
}


/* 
*function：计算两个日期相隔多少年，多少月，多少天 
*param string $date1[格式如：2011-11-5] 
*param string $date2[格式如：2012-12-01] 
*return array array('年','月','日'); 
*/  
function diffDate($date1,$date2){  
    if(strtotime($date1)>strtotime($date2)){  
        $tmp=$date2;  
        $date2=$date1;  
        $date1=$tmp;  
    }  
    list($Y1,$m1,$d1)=explode('-',$date1);  
    list($Y2,$m2,$d2)=explode('-',$date2);  
    $Y=$Y2-$Y1;  
    $m=$m2-$m1;  
    $d=$d2-$d1;  
    if($d<0){  
        $d+=(int)date('t',strtotime("-1 month $date2"));  
        $m--;  
    }  
    if($m<0){  
        $m+=12;  
        $y--;  
    }

    if ($Y) {
        $str .= $Y.'年';
    }

    if ($m) {
        $str .= $m.'个月';
    }

    if ($d) {
        $str .= $d.'天';
    }

    return $str;  
}  

/*计算几分钟前、几小时前、几天前的几个函数*/
function format_date($start_time,$time){
    $t = $start_time - $time;
    if ($t === 0) {
        return $t;
    }else{
        $f = array(
            '31536000'=>'年',
            '2592000'=>'个月',
            '604800'=>'星期',
            '86400'=>'天',
            '3600'=>'小时',
            '60'=>'分钟',
            '1'=>'秒'
        );
        foreach ($f as $k=>$v)    {
            if (0 != $c = floor($t/(int)$k)) {
                return $c.$v;
            }
        }
    }
}

/*优先连接一个服务器*/
function priority_server(){
    $list = M('server')->order('id asc')->field('db_host,db_game_database,db_user,db_password,db_port,channel_id,sub_channel_id,id,server_name')->select();
 
    for($i = 0;$i < count($list);$i++){
        $sel_db = array(
            'DB_TYPE'   => 'mysql', // 数据库类型
            'DB_HOST'   => $list[$i]['db_host'], // 服务器地址
            'DB_NAME'   => $list[$i]['db_game_database'], // 数据库名
            'DB_USER'   => $list[$i]['db_user'], // 用户名
            'DB_PWD'    => $list[$i]['db_password'],  // 密码
            'DB_PORT'   => $list[$i]['db_port'], // 端口
            'DB_PREFIX' => '', // 数据库表前缀
            'DB_CHARSET'=> 'utf8', // 字符集
        );
        $conn = mysqli_connect($sel_db['DB_HOST'],$sel_db['DB_USER'],$sel_db['DB_PWD'],$sel_db['DB_NAME']);
        if ($conn) {
            $db = $list[$i];
            break;
        }
    }
    return $db;
}
