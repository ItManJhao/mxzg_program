<?php


/**
    * 功能：邮件发送函数
    * @param string $to 目标邮箱
    * @param string $subject 邮件主题（标题）
    * @param string $to 邮件内容
    * @return bool true
    */
function sendMail($to, $subject, $content) {
    vendor('phpmailer.class#smtp'); 
    vendor('phpmailer.class#phpmailer');
    $mail = new \PHPMailer();
    $config_data = C('MAIL_CONFIG');
    // 装配邮件服务器
    if ($config_data['MAIL_SMTP']) {
        $mail->IsSMTP();
    }
    $mail->SMTPDebug = false;
    
    $mail->Host = $config_data['MAIL_HOST'];  //这里的参数解释见下面的配置信息注释
    $mail->Port = $config_data['MAIL_PORT'];
    $mail->SMTPAuth = $config_data['MAIL_SMTPAUTH'];  
    $mail->Username = $config_data['MAIL_USERNAME'];
    $mail->Password = $config_data['MAIL_PASSWORD'];
    $mail->SMTPSecure = $config_data['MAIL_SECURE'];
    $mail->CharSet = $config_data['MAIL_CHARSET'];
    // 装配邮件头信息
    $mail->From = $config_data['MAIL_USERNAME'];
    $mail->AddAddress($to);
    $mail->FromName = $config_data['MAIL_FROMNAME'];
    $mail->IsHTML($config_data['MAIL_ISHTML']);
    // 装配邮件正文信息
    $mail->Subject = $subject;
    $mail->Body = $content;
    // 发送邮件
    if (!$mail->send()) {
        // //输出错误信息
        // echo 'Mailer Error: ' . $mail->ErrorInfo;
        // exit;
        return FALSE;
    } else {
        return TRUE;
    }
}

//处理道具数据按照不同的类型为二级分类
function getItemTypeData($item_list, $is_split=1){
    $item_data = [];        //用于处理数据的显示
    $item_class_arr = [];   //用于页面二级下拉框筛选
    foreach($item_list as $item_val){
        $item_data[$item_val['id']] = $item_val;
        if($item_val['type'] == 1){     //金币类型
            $item_class_arr[1][] = [
                'id' => $item_val['id'],
                'name' => $item_val['name'],
                'quality' => $item_val['quality']
            ];
        }elseif($item_val['type'] == 2){    //钻石类型
            $item_class_arr[2][] = [
                'id' => $item_val['id'],
                'name' => $item_val['name'],
                'quality' => $item_val['quality']
            ];
        }elseif($item_val['type'] == 3){    //角色经验类型
            $item_class_arr[3][] = [
                'id' => $item_val['id'],
                'name' => $item_val['name'],
                'quality' => $item_val['quality']
            ];
        }elseif($item_val['type'] == 5){    //英雄经验类型
            $item_class_arr[5][] = [
                'id' => $item_val['id'],
                'name' => $item_val['name'],
                'quality' => $item_val['quality']
            ];
        }elseif($item_val['type'] == 8){    //精灵类型
            $item_class_arr[8][] = [
                'id' => $item_val['id'],
                'name' => $item_val['name'],
                'quality' => $item_val['quality']
            ];
        }elseif($item_val['type'] == 6 && $item_val['type_label'] == 1){    //装备类型
            if($is_split == 0){
                $item_class_arr[6][] = [
                    'id' => $item_val['id'],
                    'name' => $item_val['name'],
                    'quality' => $item_val['quality']
                ];
            }else{
                $item_class_arr[61][] = [
                    'id' => $item_val['id'],
                    'name' => $item_val['name'],
                    'quality' => $item_val['quality']
                ];
            }
        }elseif($item_val['type'] == 6 && $item_val['type_label'] == 5){    //宝石类型
            if($is_split == 0){
                $item_class_arr[6][] = [
                    'id' => $item_val['id'],
                    'name' => $item_val['name'],
                    'quality' => $item_val['quality']
                ];
            }else{
                $item_class_arr[65][] = [
                    'id' => $item_val['id'],
                    'name' => $item_val['name'],
                    'quality' => $item_val['quality']
                ];
            }
        }elseif($item_val['type'] == 12){    //神装类型
            $item_class_arr[12][] = [
                'id' => $item_val['id'],
                'name' => $item_val['name'],
                'quality' => $item_val['quality']
            ];
        }elseif($item_val['type'] == 17){    //灵器类型
            $item_class_arr[17][] = [
                'id' => $item_val['id'],
                'name' => $item_val['name'],
                'quality' => $item_val['quality']
            ];
        }elseif($item_val['type'] == 18){    //宠物类型
            $item_class_arr[18][] = [
                'id' => $item_val['id'],
                'name' => $item_val['name'],
                'quality' => $item_val['quality']
            ];
        }else{    //道具类型
            $item_class_arr[6][] = [
                'id' => $item_val['id'],
                'name' => $item_val['name'],
                'quality' => $item_val['quality']
            ];
        }
    }
    return [
        'item_data' => $item_data,
        'item_class_arr' => $item_class_arr
    ];

}

if (!function_exists('filterSpecialStr')) {
    /**
     * 过滤特殊字符
     * @param string $start_time 开始时间戳
     * @param string $end_time   结束时间戳
     */
    function filterSpecialStr($str) {
        $filter_arr = [
            " ",
            "\r\n",
            "\r",
            "\n"
        ];
        return str_replace($filter_arr, "", $str);
    }
}

//计算除法（乘以100再保留两位小数，四舍五入）
function getDivision($molecule, $denominator){
    if(empty($molecule) || empty($denominator)){
        return sprintf("%.2f", 0);
    }
    return sprintf("%.2f", $molecule*100/$denominator);
}
//计算除法（保留两位小数，四舍五入）
function getDivisionSpecial($molecule, $denominator,$digit = 2){
    if(empty($molecule) || empty($denominator)){
        return sprintf("%." . $digit . "f", 0);
    }
    return sprintf("%." . $digit . "f", $molecule/$denominator);
}

//获取日志表的表名后缀
function getLogTable($month = 'month', $date = '') {
    if(empty($date)){
        $date = date('Y_m');
    }else{
        $date = date('Y_m', strtotime($date));
    }

    if($month == 'month'){
        $date_begin = '_monthly_';
    }
    return $date_begin . $date;
}

//检查表是否存在
function checkTable($db = '', $table = '') {
    if(!empty($db) && !empty($table)){
        $is_exist = $db->query("SHOW TABLES LIKE '$table'");
        if( $is_exist ){
            $res = true;
        }else{
            $res = false;
        }
    }else{
        $res = false;
    }
    return $res;
}

//连接游戏的数据库
function connectionDb($server_info = array(), $data_log = 'data')
{
    $db = (object)[];
    if (!empty($server_info)) {
        $db_arr = [
            'DB_TYPE' => 'mysqli',
            'DB_HOST' => $server_info['db_host'],
            'DB_USER' => $server_info['db_user'],
            'DB_PWD' => $server_info['db_password'],
            'DB_PORT' => $server_info['db_port'],
        ];
        if ($data_log == 'data') {
            $db_arr['DB_NAME'] = $server_info['db_game_database'];
            C('DB_GAME_DATA_' . $server_info['id'], $db_arr);
            $db = M('',NULL,'DB_GAME_DATA_' . $server_info['id']);
        } else {
            $db_arr['DB_NAME'] = $server_info['db_log_database'];
            C('DB_GAME_LOG_' . $server_info['id'], $db_arr);
            $db = M('',NULL,'DB_GAME_LOG_' . $server_info['id']);
        }
    }
    return $db;
}

if (!function_exists('getTimeslotDays')) {
    /**
     * 计算两个时间段的天数（包含当天）
     * @param string $start_time 开始时间戳
     * @param string $end_time   结束时间戳
     */
    function getTimeslotDays($start_time, $end_time) {
        $start_time = strtotime(date('Y-m-d', $start_time));
        $end_time = strtotime(date('Y-m-d', $end_time));
        return (($end_time-$start_time)/86400) + 1;
    }
}

if (!function_exists('arraySort')) {
    /**
     * 二维数组根据某个字段排序
     * @param array $array 要排序的数组
     * @param string $keys   要排序的键字段
     * @param string $sort  排序类型  SORT_ASC     SORT_DESC 
     * @return array 排序后的数组
     */
    function arraySort($array, $key, $sort = SORT_DESC) {
        $keysValue = [];
        foreach ($array as $k => $v) {
            $keysValue[$k] = $v[$key];
        }
        array_multisort($keysValue, $sort, $array);
        return $array;
    }
}

if (!function_exists('curlRequest')) {
    /**
     * 请求curl
     * @param $url
     * @param string $request_type，get、post两种
     * @param array $data (post请求时要传，get请求为空即可)
     * @return mixed
     */
    function curlRequest($url, $request_type = 'get', $data=[], $time_out=20)
    {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        if ($request_type == 'post') {
            curl_setopt($ch, CURLOPT_POST, 1);              //post请求
            curl_setopt($ch, CURLOPT_POSTFIELDS, $data);    //post请求参数
        }
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, FALSE);
        curl_setopt($ch, CURLOPT_TIMEOUT, $time_out);
        $response = curl_exec($ch);
        curl_close($ch);
        return $response;
    }
}

/**
 * @return 连接Redis
 */
function connectRedis(){
    $redis = new \Redis();
    $redis->connect(C('REDIS_HOST'),C('REDIS_PORT'));
    if(!empty(C('REDIS_PASSWORD'))){
        $redis->auth(C('REDIS_PASSWORD'));
    }
    return $redis;
}

if (!function_exists('pay_to_game')) {
    /**
     * 订单请求到研发支付回调接口
     * @param $params
     * @param $pay_key
     * @param $pay_url
     * @return mixed
     */
    function pay_to_game($queryURL)
    {
        // // echo $pay_url;
        // ksort($params);
        // // var_dump($params);exit;
        // $sign_str ='';
        // foreach($params as $val){
        //    $sign_str .= $val;
        // }
        // $sign_str .= $pay_key;
        // $params['sign'] = strtolower(md5($sign_str));
        // $param_str = http_build_query($params);
        // if(!empty($extraData)){
        //     $extraData_arr = explode('&', $extraData);//转成数组
        //     $res = array();
        //     foreach ($extraData_arr as $k=>$v) {
        //         $arr = explode('=', $v);
        //         $res[$arr[0]] = isset($arr[1]) ? $arr[1] : '';
        //     }
        //     $params['extraData'] = json_encode($res);
        // }else{
        //     $params['extraData'] = json_encode($_REQUEST);
        // }
        // $queryURL = $pay_url . '?' . http_build_query($params);
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $queryURL);
        // curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_HEADER, 0);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT,20);
        // curl_setopt($ch, CURLOPT_POSTFIELDS, $params);
        $return = curl_exec($ch);
        $res = json_decode($return, true);
        curl_close($ch);
        if (isset($res['code'])) {
            $gresult['code'] = $res['code'];
            $gresult['result'] = $res['code'] == '200' ? 'success' : 'error';
            $gresult['repeat'] = $res['code'] == -11 ? 'yes' : 'no';
        } else {
            $gresult['code'] = '';
            $gresult['result'] = 'error';
            $gresult['repeat'] = 'no';
        }

        $gresult['debug'] = $res;
        // $gresult['request_url'] = $queryURL;

        return $gresult;
    }
}

/* 获取路由 */
function getRote(){
    $route_str = $_SERVER['PHP_SELF'];
    $route_t = '';
    if(!empty($route_str)){
        $route_arr = explode('/admin.php/', $route_str);
        $route_str = $route_arr[1];
        $route_arr = explode('.', $route_str);
        $route_str = $route_arr[0];
        $route_arr_r = explode('/', $route_str);
        $route_str_zuo = $route_arr_r[0];
        $route_arr_zuo = explode('_', $route_str_zuo);
        $route_str_zuo = '';
        foreach($route_arr_zuo as $route_arr_zuo_val){
            $route_str_zuo .= ucfirst($route_arr_zuo_val);
        }
        $route_str_you = $route_arr_r[1];
        $route_t = $route_str_zuo . '/' . $route_str_you;
    }
    return $route_t;
}

/**
 * 删除目录及目录下所有文件或删除指定文件
 * @param str $path   待删除目录路径
 * @param int $delDir 是否删除目录，1或true删除目录，0或false则只删除文件保留目录（包含子目录）
 * @return bool 返回删除状态
 */
function delDirAndFile($path, $delDir = FALSE) {
    $handle = opendir($path);
    if ($handle) {
        while (false !== ( $item = readdir($handle) )) {
            if ($item != "." && $item != "..")
                is_dir("$path/$item") ? delDirAndFile("$path/$item", $delDir) : unlink("$path/$item");
        }
        closedir($handle);
        if ($delDir)
            return rmdir($path);
    }else {
        if (file_exists($path)) {
            return unlink($path);
        } else {
            return FALSE;
        }
    }
}

 /* 传id获取，名称 */
function get_title($table,$field,$field_val,$val){
    $re = M($table)->where(array(''.$field.'' => $field_val))->getField($val);
    return $re;
}

/* 分类名称 */
function cate_title($id,$title = 'title'){
    $re = M('Category')->where(array('id' => $id))->getField($title);
    return $re;
}

//传一个标识内容，获取网站配置内容
function Config($name,$title = 'content'){
    $re = M('Config')->where(array('name' => $name,'status'=>1))->getField($title);
    return $re;
}

//获取模型表名
function model($pid,$table = 'Category',$title = 'model'){
    $re = M($table)->where(array('id' => $pid))->getField($title);
    return $re;
}

/* 传递一个id 找出下面所有子分类包括自身 */
function catid_str($catid,$model){
        $cate= M('Category');
        $list=$cate->where(array('model' => array('eq', $model), 'status' => array('eq', 1)))->select();
        $list=getSubs($list,$catid);
        $str='';
        foreach($list as $k1=>$v1){
            $str.=$v1['id'].',';
        }
        $str=substr($str,0,-1); 
        if($str==''){
            $str=$catid;
        }else{
            $str=$catid.','.$str;
        }
        return $str;
}

/* 传递一个id 找出下面所有子分类包括自身 */
function catid_strs($catid){
        $list = M('Category')->where(array('status' => array('eq', 1)))->select();
        $list = getSubs($list,$catid);
        $str ='';
        foreach($list as $k1=>$v1){
            $str.=$v1['id'].',';
        }
        $str=substr($str,0,-1); 
        if($str==''){
            $str=$catid;
        }else{
            $str=$catid.','.$str;
        }
        return $str;
}

/* 传递一个id 找出下面所有子分类包括自身 */
function getSubs($categorys,$catId=0,$level=1){ 
  $subs=array(); 
  foreach($categorys as $item){ 
    if($item['pid']==$catId){ 
      $item['level']=$level; 
      $subs[]=$item; 
      $subs=array_merge($subs,getSubs($categorys,$item['id'],$level+1)); 
    }     
  } 
  return $subs; 
} 


function getpage($count, $pagesize = 5) {
    $p = new Think\Page($count, $pagesize);
    $p->setConfig('prev', '上一页');
    $p->setConfig('next', '下一页');
    $p->setConfig('last', '末页');
    $p->setConfig('first', '首页');
    return $p;
}

function countnav($catid, $sql='Navs', $pid = 'pid'){
    $csql =  M($sql)->field('count(*) as c_num')->where(array($pid=>$catid))->find();
    return $csql['c_num'];
}
function countcate($catid, $sql='Category', $pid = 'pid'){
    $csql =  M($sql)->field('count(*) as c_num')->where(array($pid=>$catid))->find();
    return $csql['c_num'];
}


function format_bytes($size, $delimiter = '') {
    $units = array('B', 'KB', 'MB', 'GB', 'TB', 'PB');
    for ($i = 0; $size >= 1024 && $i < 5; $i++) $size /= 1024;
    return round($size, 2) . $delimiter . $units[$i];
}

function isEmp($arr){
foreach($arr as $a){
    if(trim($a)==null) return true;
}
    return false;
}

// /**
//  * 功能：邮件发送函数
//  * @param string $to 目标邮箱
//  * @param string $subject 邮件主题（标题）
//  * @param string $to 邮件内容
//  * @return bool true
//  */
//  function SendMail($to, $subject, $content) {
//     vendor('phpmailer.class#smtp'); 
//     vendor('phpmailer.class#phpmailer');    //注意这里的大小写哦，不然会出现找不到类，PHPMailer是文件夹名字，class#phpmailer就代表class.phpmailer.php文件名
//     $mail = new PHPMailer();
//     $mail->Encoding = "base64";
//     $mail->Port= 465;  //这是腾讯云邮箱的端口，如果是其他的请看官方说明
//     $mail->SMTPDebug  = FALSE;  
//     if (C('MAIL_SMTP')) {
//         $mail->IsSMTP();
//     }
//     $mail->Host = C('MAIL_HOST');  //这里的参数解释见下面的配置信息注释
//     $mail->SMTPAuth = C('MAIL_SMTPAUTH');  
//     $mail->Username = C('MAIL_USERNAME');
//     $mail->Password = C('MAIL_PASSWORD');
//     $mail->SMTPSecure = C('MAIL_SECURE');
//     $mail->CharSet = C('MAIL_CHARSET');
//     // 装配邮件头信息
//     $mail->From = C('MAIL_USERNAME');
//     $mail->AddAddress($to);
//     $mail->FromName = C('MAIL_FROMNAME');
//     $mail->IsHTML(C('MAIL_ISHTML'));
//     // 装配邮件正文信息
//     $mail->Subject = $subject;
//     $mail->Body = $content;
//     // 发送邮件
//     if (!$mail->Send()) {
//         return FALSE;
//     } else {
//         return TRUE;
//     }
//  }

function dd($content){
    $re=dump($content);
    return $re;
}

/***
 
家谱树的应用 ,如面包屑导航 首页 > 手机类型 > CDMA手机 >诺基亚N9
***/

/* 父级分类id */
function cate_pid($id,$pid = 'pid'){
    $re = M('Category')->where(array('id' => $id))->getField($pid);
    return $re;
}
 
 
function cate_tub($id) {
    $tree = array();
    $arr=M('Category')->where('id = '.$id.'')->find();
    if(cate_pid($arr['pid'])!=0) {
       $tree = cate_pid($arr['pid']).','.$arr['pid'].','.$id;
    }else if ($arr['pid']!=0) {
       $tree = $arr['pid'].','.$id;
    }
    else{
       $tree = $id;
    }
    $ini['id']=array('in',$tree);
    $tnb_title=M('Category')->where($ini)->field("id,title")->select();
    return $tnb_title;
}

function isMobile(){
    // 如果有HTTP_X_WAP_PROFILE则一定是移动设备
    if (isset ($_SERVER['HTTP_X_WAP_PROFILE']))
        return true;
 
    //此条摘自TPM智能切换模板引擎，适合TPM开发
    if(isset ($_SERVER['HTTP_CLIENT'])
 &&'PhoneClient'==$_SERVER['HTTP_CLIENT'])
        return true;
    //如果via信息含有wap则一定是移动设备,部分服务商会屏蔽该信息
    if (isset ($_SERVER['HTTP_VIA']))
        //找不到为flase,否则为true
        return stristr($_SERVER['HTTP_VIA'],
'wap') ? true : false;
    //判断手机发送的客户端标志,兼容性有待提高
    if (isset ($_SERVER['HTTP_USER_AGENT'])) {
        $clientkeywords = array(
            'nokia','sony','ericsson','mot','samsung','htc','sgh','lg','sharp','sie-','philips','panasonic','alcatel','lenovo','iphone','ipod','blackberry','meizu','android','netfront','symbian','ucweb','windowsce','palm','operamini','operamobi','openwave','nexusone','cldc','midp','wap','mobile'
        );
        //从HTTP_USER_AGENT中查找手机浏览器的关键字
        if (preg_match("/("
. implode('|', $clientkeywords) . ")/i", strtolower($_SERVER['HTTP_USER_AGENT'])))
 {
            return true;
        }
    }
    //协议法，因为有可能不准确，放到最后判断
    if (isset ($_SERVER['HTTP_ACCEPT'])) {
        // 如果只支持wml并且不支持html那一定是移动设备
        // 如果支持wml和html但是wml在html之前则是移动设备
        if ((strpos($_SERVER['HTTP_ACCEPT'],
'vnd.wap.wml') !== false) && (strpos($_SERVER['HTTP_ACCEPT'],
'text/html') === false || (strpos($_SERVER['HTTP_ACCEPT'],
'vnd.wap.wml') < strpos($_SERVER['HTTP_ACCEPT'],
'text/html')))) {
            return true;
        }
    }
    return false;
}