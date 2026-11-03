<?php

/**
 * 获取随机字符串
 */
if (!function_exists('getRandstr')) {
    function getRandstr($cut_leng = 11){
        $str='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890';
        $randStr = str_shuffle($str);//打乱字符串
        $rands= substr($randStr, 0, $cut_leng);//substr(string,start,length);返回字符串的一部分
        return $rands;
    }
}

if (!function_exists('out')) {
    /**
     * 返回成功的json数组
     * @param array $data
     * @return \Illuminate\Http\JsonResponse
     */
    function out($data = [],$msg='ok',$code=200)
    {
        $result = [
            // 'data' => !empty($data) ? json_encode($data) : json_encode((object)$data),
            'data' => $data,
            'msg' => $msg,
            'code' => $code,
        ];
        echo json_encode($result);
        exit;
    }
}

if (!function_exists('success')) {
    /**
     * @dsec 返回成功的json数组
     * @param  string $msg
     * @return mixed
     */
    function success($msg = '操作成功')
    {
        $result = [
            'message' => $msg,
            'code' => 200,
        ];
        echo json_encode($result);
        exit;
    }
}


if (!function_exists('error')) {
    /**
     * 返回成功的json数组
     * @param  string $msg
     * @return mixed
     */
    function error($msg = '操作失败', $code = 10001)
    {
        $result = [
            'message' => $msg,
            'code' => $code,
        ];
        echo json_encode($result);
        exit;
    }
}

if (!function_exists('getOrderSign')) {
    /**
     * @dsec 订单生成签名，用于验签
     * @param array $data
     * @return \Illuminate\Http\JsonResponse
     */
    function getOrderSign($data = [], $paykey='')
    {
        ksort($data);
        $sign_str ='';
        foreach($data as $key=>$val){
           $sign_str .= $key . '=' . $val . '&';
        }
        $sign_str .= 'PayKey=' . $paykey;
        return strtolower(md5($sign_str));
    }
}


// 不想改动影响ANDROID
if (!function_exists('getOrderSignIos')) {
    /**
     * @dsec 订单生成签名，用于验签
     * @param array $data
     * @return \Illuminate\Http\JsonResponse
     */
    function getOrderSignIos($data = [], $paykey='', $paykeyvalue='')
    {
        //ksort($data);
        $sign_str ='';
        foreach($data as $key=>$val){
           $sign_str .= $key . '=' . $val . '&';
        }
        $sign_str .= $paykey.'=' . $paykeyvalue;
        return strtolower(md5($sign_str));
    }
}

// 不想改动影响ANDROID-获取原始数据
if (!function_exists('getOrderSignStr')) {
    /**
     * @dsec 订单生成签名，用于验签
     * @param array $data
     * @return \Illuminate\Http\JsonResponse
     */
    function getOrderSignStr($data = [], $paykey='', $paykeyvalue='')
    {
       // ksort($data);
        $sign_str ='';
        foreach($data as $key=>$val){
           $sign_str .= $key . '=' . $val . '&';
        }
        $sign_str .= $paykey.'=' . $paykeyvalue;
        return $sign_str;
    }
}






if (!function_exists('getSign')) {
    /**
     * 值按照排序拼接上时间戳，md5加密
     * @param array $data
     * @return \Illuminate\Http\JsonResponse
     */
    function getSign($data = [], $key='')
    {
        ksort($data);
        $sign_str ='';
        foreach($data as $val){
           $sign_str .= $val;
        }
        $sign_str .= empty($key) ? $data['time'] : $key;
        return strtolower(md5($sign_str));
    }
}

if (!function_exists('getPage')) {
    /**
     * 返回成功的json数组
     * @param array $data
     * @return \Illuminate\Http\JsonResponse
     */
    function getPage($count,$limit=100)
    {
        if($count < $limit){
            $page_all = 1;
        }else{
            $page_all = ceil($count/$limit);
        }
        return $page_all;
    }
}

if (!function_exists('pay_to_game')) {
    /**
     * 订单请求到研发支付回调接口
     * @param $params
     * @param $pay_key
     * @param $pay_url
     * @return mixed
     */
    function pay_to_game($pay_url, $params, $pay_key, $extraData='')
    {
        // echo $pay_url;
        ksort($params);
        // var_dump($params);exit;
        $sign_str ='';
        foreach($params as $val){
           $sign_str .= $val;
        }
        $sign_str .= $pay_key;
        $params['sign'] = strtolower(md5($sign_str));
        $param_str = http_build_query($params);
        if(!empty($extraData)){
            $extraData_arr = explode('&', $extraData);//转成数组
            $res = array();
            foreach ($extraData_arr as $k=>$v) {
                $arr = explode('=', $v);
                $res[$arr[0]] = isset($arr[1]) ? $arr[1] : '';
            }
            $params['extraData'] = json_encode($res);
        }else{
            $params['extraData'] = json_encode($_REQUEST);
        }
        $queryURL = $pay_url . '?' . http_build_query($params);
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

        $gresult['param'] = $param_str;
        $gresult['debug'] = $res;
        $gresult['request_url'] = $queryURL;

        return $gresult;
    }
}


if (!function_exists('UrlBase64Decode')) {
    /**
     * base64是否是url解密方式
     * @param  string $msg
     * @return mixed
     */
    function UrlBase64Decode($str, $is_url = '0')
    {
        if($is_url == 1){
            $data = str_replace(array('-','_'),array('+','/'),$str);
            $mod4 = strlen($data) % 4;
            if ($mod4) {
                $data .= substr('====', $mod4);
            }
            return base64_decode($data);
        }
        return base64_decode($str);
    }
}
if (!function_exists('UrlBase64Encode')) {
    /**
     * base64是否是url加密方式
     * @param  string $msg
     * @return mixed
     */
    function UrlBase64Encode($str, $is_url = '0')
    {
        if($is_url == 1){
            $data = base64_encode($str);
            $data = str_replace(array('+','/','='),array('-','_',''),$data);
            return $data;
        }
        return base64_encode($str);
    }
}
/**
 * @desc    base64解密参数
 * @param String cut_leng 截取掉的长度
 */
if (!function_exists('decryptParam')) {
    function decryptParam($cut_leng = 11, $data_str='') {
        if(empty($data_str)){
            if(isset($_REQUEST['str'])){
                $str = substr($_REQUEST['str'], $cut_leng);
                $param_str = base64_decode($str);
                $param_arr = explode('&', $param_str);//转成数组
                $res = array();
                foreach ($param_arr as $k=>$v) {
                    $arr = explode('=', $v);
                    $res[$arr[0]] = isset($arr[1]) ? $arr[1] : '';
                }
                $_REQUEST = $res;
            }
        }else{
            $str = substr($data_str, $cut_leng);
            $param_str = base64_decode($str);
            $res = json_decode($param_str, true);
            return $res;
        }
        
    }
}
if (!function_exists('encryptOut')) {
    /**
     * 对返回结果用base64加密输出
     * @param array $data
     * @return \Illuminate\Http\JsonResponse
     */
    function encryptOut($data = [],$msg='ok',$code=200, $is_china=0)
    {
        $result = [
            // 'data' => !empty($data) ? json_encode($data) : json_encode((object)$data),
            'data' => $data,
            'msg' => $msg,
            'code' => $code,
        ];
        $random_str = getRandstr();
        if($is_china == 1){
            $res_ser = base64_encode(json_encode($result, JSON_UNESCAPED_UNICODE));
        }else{
            $res_ser = base64_encode(json_encode($result));
        }
        
        $strs = $random_str . $res_ser;
        echo json_encode(['cb' => $strs]);
        exit;
    }
}
if (!function_exists('encryptSuccess')) {
    /**
     * @dsec 对返回结果用base64加密输出
     * @param  string $msg
     * @return mixed
     */
    function encryptSuccess($msg = '操作成功')
    {
        $result = [
            'msg' => $msg,
            'code' => 200,
        ];
        $random_str = getRandstr();
        $res_ser = base64_encode(json_encode($result));
        $strs = $random_str . $res_ser;
        echo json_encode(['cb' => $strs]);
        exit;
    }
}
if (!function_exists('encryptError')) {
    /**
     * 对返回结果用base64加密输出
     * @param  string $msg
     * @return mixed
     */
    function encryptError($msg = '操作失败', $code = 10001)
    {
        $result = [
            'msg' => $msg,
            'code' => $code,
        ];
        $random_str = getRandstr();
        $res_ser = base64_encode(json_encode($result));
        $strs = $random_str . $res_ser;
        echo json_encode(['cb' => $strs]);
        exit;
    }
}


/**
 * 加密
 * @param String input 加密的字符串
 * @param String key   解密的key
 * @return HexString
 */
if (!function_exists('aesencrypt')) {
    function aesencrypt($str = '', $key='') {
        // // $data = base64_encode(mcrypt_encrypt( MCRYPT_RIJNDAEL_128, $key, $str, 'cbc', 'wangjieshiwowang'));
        // // return $data;
        // $data = openssl_encrypt($str, 'AES-128-ECB', $key, OPENSSL_RAW_DATA, $key);

        // // $data = strtolower(bin2hex($data));
        // $data = bin2hex($data);

        // return $data;

        // $encryption_key = base64_decode($key);
        // $iv = openssl_random_pseudo_bytes(openssl_cipher_iv_length('AES-128-ECB'));
        $iv = 'asasasasasasasas';
        $encrypted = openssl_encrypt($str, 'AES-128-CBC', $key, 0, $iv);
        return $encrypted;
        return base64_encode($encrypted);
    }
}

/**
 * 解密
 * @param String input 解密的字符串
 * @param String key   解密的key
 * @return String
 */
if (!function_exists('aesdecrypt')) {
    function aesdecrypt($str, $key='') {
        // // $data = mcrypt_decrypt( MCRYPT_RIJNDAEL_128, $key, base64_decode($str), 'cbc', 'wangjieshiwowang');
        // // $data = rtrim(rtrim($data), "\x00..\x1F");
        // // return $data;
        // $decrypted = openssl_decrypt(hex2bin($str), 'AES-128-ECB', $key, OPENSSL_RAW_DATA, $key);
        // // $decrypted = openssl_decrypt($str, 'AES-128-ECB', $key, OPENSSL_RAW_DATA);
        // return $decrypted;


        // $encryption_key = base64_decode($key);
        // list($encrypted_data, $iv) = explode('::', base64_decode($str), 2);
        return openssl_decrypt($str, 'AES-128-CBC', $key, OPENSSL_RAW_DATA);
    }
}



/**
 * 对象 转 数组
 *
 * @param object $obj 对象
 * @return array | bool
 */
if (!function_exists('object_to_array')) {
    function object_to_array($obj)
    {
        $obj = (array)$obj;
        foreach ($obj as $k => $v) {
            if (gettype($v) == 'resource') {
                return false;
            }
            if (gettype($v) == 'object' || gettype($v) == 'array') {
                $obj[$k] = (array)object_to_array($v);
            }
        }

        return $obj;
    }
}

if (!function_exists('outData')) {
    /**
     *  返回成功的json数组
     * @param array $data
     * @param string $msg
     * @return \Illuminate\Http\JsonResponse
     */
    function outData($data = [], $msg = 'ok')
    {
        $result = [
            'message' => $msg,
            'statusCode' => 200,
            'data' => $data,
        ];
        return Response::json($result);
    }
}

if (!function_exists('lists')) {
    /**
     * @param $columnList
     * @param array $data
     * @param string $key
     * @param array $columnsName 要隐藏的列
     * @return mixed
     */
    function lists($columnList, $data = [], $key = 'id', $columnsName = [])
    {
        if (!empty($columnsName)) {
            foreach ($columnList as &$v) {
                if (in_array($v['key'], $columnsName)) {
                    $v['hidden'] = true;    //显示隐藏
                }
            }
        }

        $listData = [
            'query' => [
                "allowPaging" => true,
                "startRow" => 1,
                "key" => $key,          //默认列表显示值
                "columnList" => $columnList,
            ],
            'pageInfo' => [
                "pageNum" => $data['current_page'],
                "pageSize" => $data['per_page'],
                "count" => $data['total'],
                "pageCount" => $data['last_page'],
                "pojoList" => []
            ],
            'rows' => $data['data'],
            'sql' => isset($data['sql']) ? $data['sql'] : '',
        ];

        return Response::json($listData);
    }
}

if (!function_exists('lists_customcolumns')) {
    /**
     * @param string $pageName 请求方法
     * @param string $currentRouteName 当前路由名
     * @param array $columnList 要显示的列表功能
     * @param \App\Http\Requests\Request $request 前端求接收对像
     * @return $this|array|mixed|string
     */
    function lists_customcolumns($pageName = '', $currentRouteName = '', $columnList = [], $request = null)
    {
        if (empty($pageName)) {
            return '';
        }

        if ($pageName == 'custom') {
            return view('admin.common.customcolumns.query')
                ->with('currentRouteName', $currentRouteName);
        } else if ($pageName == 'getColumns') {
            foreach ($columnList as &$v) {
                $v['text'] = $v['header'];
                $v['id'] = $v['key'];
            }
            return $columnList;
        } else if ($pageName == 'hiddenColumns') {
            //通过session设置要显示隐藏的列,通过路由来确认唯一值
            $columnsName = \Session::get($currentRouteName);
            if (empty($columnsName)) {
                return [];
            }
            return json_encode($columnsName);
        } else if ($pageName == 'saveColumns') {
            $configObj = json_decode($request->input('configObj'), true);
            $columnsName = isset($configObj['columnsName']) ? $configObj['columnsName'] : '';
            if (!empty($columnsName)) {
                $columnsName = explode(',', $columnsName);
            }

            //根据当前路由别名设置显示隐藏值
            \Session::put($currentRouteName, $columnsName);
            return success();
        }
        return '';
    }
}

if (!function_exists('lists_where')) {
    /**
     * 获取用户列表条件
     * @param array $requestData
     * @return array
     */
    function lists_where($requestData = [])
    {
        $where = [];
        if (isset($requestData['conditions'])) {
            array_walk($requestData['conditions'], function ($value) use (&$where) {
                $where[$value['key']] = $value['value'];
            });
        }

        return $where;
    }
}

if (!function_exists('lists_sort')) {
    /**
     * 获取用户列表条件
     * @param array $requestData
     * @return array
     */
    function lists_sort($requestData = [])
    {
        $sort = [];
        if (isset($requestData['sortInfo']) && !empty($requestData['sortInfo'])) {
            $sort = explode(" ", $requestData['sortInfo']);

        }

        return $sort;
    }
}



if (!function_exists('get_sql')) {
    /**
     * 获取最后一条sql语句    待测试
     * @param string $connection
     * @return mixed
     */
    function get_sql($connection = 'mysql')
    {
        //\DB::connection($connection)->enableQueryLog(); // 开启查询日志
        $sql = DB::connection($connection)->getQueryLog();
        $query = end($sql);

        $tmp = str_replace('?', '"' . '%s' . '"', $query['query']);
        $tmp = vsprintf($tmp, $query['bindings']);
        $tmp = str_replace("\\", "", $tmp);

        $query['sql'] = $tmp;
        return $query;
    }
}

if (!function_exists('lists_page')) {
    /**
     * 获取用户列表条件
     * @param array $requestData
     * @return array
     */
    function lists_page($requestData = [])
    {
        $pageData = [];
        $pageData['pageSize'] = isset($requestData['pageInfo']['pageSize']) ? $requestData['pageInfo']['pageSize'] : 20;
        $pageData['pageNum'] = isset($requestData['pageInfo']['pageNum']) ? $requestData['pageInfo']['pageNum'] : 1;

        return $pageData;
    }
}

if (!function_exists('cdnrs')) {
    /*
     * @desc cdn函数获取资源
     * @param1 资源的文件位置
     */
    function cdnrs($path = '')
    {
        $test = true;
        if ($test) {
            echo '/asset/' . $path;
        } else {
            $domin = Config::get('app.url');
            echo $domin . '/asset/' . $path;
        }
    }
}

if (!function_exists('copy_dir')) {
    /*
     * @desc src文件源，dst目标文件
     * @param1 资源的文件位置
     */
    function copy_dir($src, $dst)
    {
        $dir = opendir($src);
        @mkdir($dst);
        while (false !== ($file = readdir($dir))) {
            if (($file != '.') && ($file != '..')) {
                if (is_dir($src . '/' . $file)) {
                    copy_dir($src . '/' . $file, $dst . '/' . $file);
                    continue;
                } else {
                    copy($src . '/' . $file, $dst . '/' . $file);
                }
            }
        }
        closedir($dir);
    }
}


if (!function_exists('menu_to_tree')) {
    /**
     * 把返回的数据集转换成Tree
     * @param null $list 要转换的数据集
     * @param string $pk 主键
     * @param string $pid parent标记字段
     * @param string $child 子级元素
     * @return array
     */
    function menu_to_tree($list = null, $pk = 'id', $pid = 'parent_id', $child = '_child')
    {
        // 创建Tree
        $tree = [];
        if (null === $list) {
            // 默认直接取查询返回的结果集合
            return $tree;
        }

        if (is_array($list)) {
            // 创建基于主键的数组引用
            $refer = array();

            foreach ($list as $key => $data) {
                $_key = is_object($data) ? $data->$pk : $data[$pk];
                $refer[$_key] =& $list[$key];
            }
            foreach ($list as $key => $data) {
                // 判断是否存在parent
                $parentId = is_object($data) ? $data->$pid : $data[$pid];
                $is_exist_pid = false;
                foreach ($refer as $k => $v) {
                    if ($parentId == $k) {
                        $is_exist_pid = true;
                        break;
                    }
                }
                if ($is_exist_pid) {
                    if (isset($refer[$parentId])) {
                        $parent =& $refer[$parentId];
                        $parent[$child][] =& $list[$key];
                    }
                } else {
                    $tree[] =& $list[$key];
                }
            }
        }
        return $tree;
    }
}

/**
 * 判断文件的MIME类型是否为图片
 * @param $mimeType
 * @return bool
 */
function isImage($mimeType)
{
    return starts_with($mimeType, 'image/');
}


/**
 * 读取目录树文件
 * @param $pathName
 * @return array|null
 */
function recurDir($pathName)
{
    //将结果保存在result变量中
    $result = array();
    $temp = array();
    //判断传入的变量是否是目录
    if (!is_dir($pathName) || !is_readable($pathName)) {
        return null;
    }
    //取出目录中的文件和子目录名,使用scandir函数
    $allFiles = scandir($pathName);
    //遍历他们
    foreach ($allFiles as $fileName) {
        //判断是否是.和..因为这两个东西神马也不是。。。
        if (in_array($fileName, array('.', '..'))) {
            continue;
        }
        //路径加文件名
        $fullName = $pathName . '/' . $fileName;
        //如果是目录的话就继续遍历这个目录
        if (is_dir($fullName)) {
            //将这个目录中的文件信息存入到数组中
            $result[$fileName] = recurDir($fullName);
        } else {
            //如果是文件就先存入临时变量
            $temp[] = $fileName;
        }
    }
    //取出文件
    if ($temp) {
        foreach ($temp as $f) {
            $result[] = $f;
        }
    }
    return $result;
}


function read_file_content($file_path)
{
    if (!file_exists($file_path)) {
        return 'file no exits';
    }

    $fp = fopen($file_path, "r");
    $str = "";
    while (!feof($fp)) {
        $str .= fgets($fp);//逐行读取。如果fgets不写length参数，默认是读取1k。
    }
    $str = str_replace("\r\n", "<br />", $str);

    return $str;
}


if (!function_exists('create_random_str')) {
    /*
     * @desc 生成随机的字符串
     * @param1 $length int 生成的字符串长度
     * @param2 $type,生成的字符串包括的字符类型 'passwd' 包括数字,大小写字母,特殊字符,'num'生成数字,'alpha'生成大小字母,其它为字母加字符串
     * @return 返回生成好的随机字符串
     */
    function create_random_str($length = 8, $type = '')
    {
        switch ($type) {
            case 'passwd':
                $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_ []{}<>~`+=,.;:/?|';
                break;
            case 'num';
                $chars = '0123456789';
                break;
            case 'alpht';
                $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
                break;
            default:
                $chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
                break;
        }

        $new_str = '';
        for ($i = 0; $i < $length; $i++) {
            $new_str .= $chars[mt_rand(0, strlen($chars) - 1)];
        }
        return $new_str;
    }
}


//拼音相关函数start
if (!function_exists('getFirstChar')) {
    /**
     * @description 获取汉子首字母
     * @param string
     * @return mixed
     * @author
     * @create 2014-09-17 21:46:52
     **/
    function getFirstChar($s0)
    {
        $fChar = ord($s0{0});
        if ($fChar >= ord("A") and $fChar <= ord("z")) return strtoupper($s0{0});
        $s1 = get_encoding($s0, 'GB2312');
        $s2 = get_encoding($s1, 'UTF-8');
        if ($s2 == $s0) {
            $s = $s1;
        } else {
            $s = $s0;
        }
        $asc = ord($s{0}) * 256 + ord($s{1}) - 65536;
        if ($asc >= -20319 and $asc <= -20284) return "A";
        if ($asc >= -20283 and $asc <= -19776) return "B";
        if ($asc >= -19775 and $asc <= -19219) return "C";
        if ($asc >= -19218 and $asc <= -18711) return "D";
        if ($asc >= -18710 and $asc <= -18527) return "E";
        if ($asc >= -18526 and $asc <= -18240) return "F";
        if ($asc >= -18239 and $asc <= -17923) return "G";
        if ($asc >= -17922 and $asc <= -17418) return "I";
        if ($asc >= -17417 and $asc <= -16475) return "J";
        if ($asc >= -16474 and $asc <= -16213) return "K";
        if ($asc >= -16212 and $asc <= -15641) return "L";
        if ($asc >= -15640 and $asc <= -15166) return "M";
        if ($asc >= -15165 and $asc <= -14923) return "N";
        if ($asc >= -14922 and $asc <= -14915) return "O";
        if ($asc >= -14914 and $asc <= -14631) return "P";
        if ($asc >= -14630 and $asc <= -14150) return "Q";
        if ($asc >= -14149 and $asc <= -14091) return "R";
        if ($asc >= -14090 and $asc <= -13319) return "S";
        if ($asc >= -13318 and $asc <= -12839) return "T";
        if ($asc >= -12838 and $asc <= -12557) return "W";
        if ($asc >= -12556 and $asc <= -11848) return "X";
        if ($asc >= -11847 and $asc <= -11056) return "Y";
        if ($asc >= -11055 and $asc <= -10247) return "Z";
        return null;
    }
}

if (!function_exists('get_encoding')) {
    /**
     * @description 自动检测内容编码进行转换
     * @param string data
     * @param string to  目标编码
     * @return string
     **/
    function get_encoding($data, $to)
    {
        $encode_arr = array('UTF-8', 'ASCII', 'GBK', 'GB2312', 'BIG5', 'JIS', 'eucjp-win', 'sjis-win', 'EUC-JP');
        $encoded = mb_detect_encoding($data, $encode_arr);
        $data = mb_convert_encoding($data, $to, $encoded);
        return $data;
    }
}

if (!function_exists('pinyin1')) {
    function pinyin1($zh)
    {
        $ret = "";
        $s1 = iconv("UTF-8", "gb2312", $zh);
        $s2 = iconv("gb2312", "UTF-8", $s1);
        if ($s2 == $zh) {
            $zh = $s1;
        }
        for ($i = 0; $i < strlen($zh); $i++) {
            $s1 = substr($zh, $i, 1);
            $p = ord($s1);
            if ($p > 160) {
                $s2 = substr($zh, $i++, 2);
                $ret .= getFirstChar($s2);
            } else {
                $ret .= $s1;
            }
        }
        return $ret;
    }
}

//拼音相关函数end


function get_ip()
{
    //判断服务器是否允许$_SERVER
    if (isset($_SERVER)) {
        if (isset($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            $realIp = $_SERVER['HTTP_X_FORWARDED_FOR'];
        } elseif (isset($_SERVER['HTTP_CLIENT_IP'])) {
            $realIp = $_SERVER['HTTP_CLIENT_IP'];
        } else {
            $realIp = $_SERVER['REMOTE_ADDR'];
        }
    } else {
        //不允许就使用getenv获取
        if (getenv("HTTP_X_FORWARDED_FOR")) {
            $realIp = getenv("HTTP_X_FORWARDED_FOR");
        } elseif (getenv("HTTP_CLIENT_IP")) {
            $realIp = getenv("HTTP_CLIENT_IP");
        } else {
            $realIp = getenv("REMOTE_ADDR");
        }
    }

    return $realIp;
}

/**
 * @param $url
 * @param $data
 * @return mixed
 */
function curlData($url, $data = [])
{
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, FALSE);
    curl_setopt($ch, CURLOPT_TIMEOUT, 20);
    $response = curl_exec($ch);
    curl_close($ch);
    return $response;
}

if (!function_exists('curlRequest')) {
    /**
     * 请求curl
     * @param $url
     * @param string $request_type，get、post两种
     * @param array $data (post请求时要传，get请求为空即可)
     * @return mixed
     */
    function curlRequest($url, $request_type = 'get', $data = [])
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
        curl_setopt($ch, CURLOPT_TIMEOUT, 20);
        $response = curl_exec($ch);
        curl_close($ch);
        return $response;
    }
}

/**
 * 复制文件夹
 * @param $source
 * @param $dir
 */
function copyDir($source, $dir)
{
    if (!file_exists($dir)) mkdir($dir);
    $handle = opendir($source);
    while (($item = readdir($handle)) !== false) {
        if ($item == '.' || $item == '..') continue;
        $_source = $source . '/' . $item;
        $_dir = $dir . '/' . $item;
        if (is_file($_source)) copy($_source, $_dir);
        if (is_dir($_source)) copyDir($_source, $_dir);
    }
    closedir($handle);
}

// if (!function_exists('getRandStr')) {
//     function getRandStr($len = 6)
//     {
//         $chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-@#~';
//         mt_srand((double)microtime() * 1000000 * getmypid());
//         $password = '';
//         while (strlen($password) < $len)
//             $password .= substr($chars, (mt_rand() % strlen($chars)), 1);
//         return $password;
//     }
// }

/**
 * 只替换字符串中第一次出现的字符
 * @param $search
 * @param $replace
 * @param $str
 * @return mixed
 */
if (!function_exists('replaceStrOnce')) {
    function replaceStrOnce($search, $replace, $str)
    {
        return substr_replace($str, $replace, strpos($str, $search), strlen($search));
    }
}

/**
 * 初始化时间筛选条件，用于大数据报表
 * @param $where
 * @param string $startDate
 * @param string $endDate
 */
if (!function_exists('initWhen')) {
    function initWhen(&$where, $startDate = '', $endDate = '')
    {
        $dt = new \Carbon\Carbon();
        if (empty($where['startdate'])) {
            $where['startdate'] = $startDate ?: $dt->startOfDay()->toDateTimeString();
        }
        if (empty($where['enddate'])) {
            $where['enddate'] = $endDate ?: $dt->endOfDay()->toDateTimeString();
        }
    }
}

/**
 * 补齐时间筛选条件（如果存在的话）
 * 0 -> day
 * 1 -> month
 * 2 -> year
 * @param $where
 * @param int $by
 * @param bool $isTimeStamp
 */
if (!function_exists('finishWhen')) {
    function finishWhen(&$where, $by = 0, $isTimeStamp = false)
    {
        if (!empty($where['startdate'])) {
            $dt = new \Carbon\Carbon($where['startdate']);
            if ($by == 0) {
                $where['startdate'] = $dt->startOfDay()->toDateTimeString();
            } elseif ($by == 1) {
                $where['startdate'] = $dt->startOfMonth()->toDateTimeString();
            } elseif ($by == 2) {
                $where['startdate'] = $dt->startOfYEAR()->toDateTimeString();
            }
            if ($isTimeStamp) {
                $where['startdate'] = strtotime($where['startdate']);
            }
        }
        if (!empty($where['enddate'])) {
            $dt = new \Carbon\Carbon($where['enddate']);
            if ($by == 0) {
                $where['enddate'] = $dt->endOfDay()->toDateTimeString();
            } elseif ($by == 1) {
                $where['enddate'] = $dt->endOfMonth()->toDateTimeString();
            } elseif ($by == 2) {
                $where['enddate'] = $dt->endOfYear()->toDateTimeString();
            }
            if ($isTimeStamp) {
                $where['enddate'] = strtotime($where['enddate']);
            }
        }
    }
}

if (!function_exists('getAdminIdsKey')) {
    function getAdminIdsKey($gradation = '')
    {
        $gradation = $gradation ?: getGradation();
        $arr = [];
        for ($i = 1; $i <= $gradation; $i++) {
            $arr[] = "admin_id_{$i}";
        }
        return $arr;
    }
}

if (!function_exists('getAdminNamesKey')) {
    /**
     * @param int $gradation
     * @return array
     */
    function getAdminNamesColumnList($gradation)
    {
        $arr = [];
        for ($i = 1; $i <= $gradation; $i++) {
            $key = "admin_name_{$i}";
            $text = \App\Dao\Sys\RoleDao::$gradationRoleNameMapping[$i];
            $arr[] = ['key' => $key, 'header' => $text, 'width' => 50, 'align' => 'center'];
        }
        return $arr;
    }
}

/**
 * 当前登录用户的层级
 * @return array|null
 */
if (!function_exists('getGradation')) {
    function getGradation()
    {
        $authAdmin = getAuthAdmin();
        return $authAdmin['gradation'];
    }
}

/**
 * 下一层级
 * @return array|null
 */
if (!function_exists('getNextGradation')) {
    function getNextGradation($gradation = '')
    {
        $gradation = $gradation ?: getGradation();
        return $gradation == 4 ? $gradation : $gradation + 1;
    }
}

/**
 * 当前登录用户的admin_id限制
 * @return array|null
 */
if (!function_exists('getSelfAdminWhere')) {
    function getSelfAdminWhere()
    {
        // 非管理员只能看见自己推广的数据
        $authAdmin = \getAuthAdmin();
        $gradation = $authAdmin['gradation'];
        $adminId = $authAdmin['id'];

        if (isSuperAdmin($adminId) || isXyAdmin($adminId)) {
            return null;
        } else {
            $field = "admin_id_{$gradation}";
            return ['field' => $field, 'value' => $adminId];
        }
    }
}

/**
 * 是否为超管
 * @param string $adminId
 * @return bool
 */
if (!function_exists('isSuperAdmin')) {
    function isSuperAdmin($adminId = '')
    {
        $session = getAuthAdmin();
        $adminId = $adminId ?: $session['id'];
        return $adminId == \App\Dao\Sys\AdminDao::SUPER_ADMIN_ID;
    }
}

/**
 * 是否为超管
 * @param string $adminId
 * @return bool
 */
if (!function_exists('isAdmin')) {
    function isXyAdmin($adminId = '')
    {
        $session = getAuthAdmin();
        $adminId = $adminId ?: $session['id'];
        return $adminId == \App\Dao\Sys\AdminDao::XY_ADMIN_ID;
    }
}

/**
 * 是否为最基础角色（推广组员）
 * @param string $adminId
 * @return bool
 */
if (!function_exists('isBasicAdmin')) {
    function isBasicAdmin($adminId = '')
    {
        if ($adminId) {
            $admin = (new \App\Dao\Sys\AdminDao)->getById($adminId);
            $gradation = $admin['gradation'];
        } else {
            $session = getAuthAdmin();
            $gradation = $session['gradation'];
        }
        return $gradation == \App\Dao\Sys\AdminDao::BASIC_ADMIN_GRADATION;
    }
}

/**
 * 将数组所有int的value转为string
 * @param array $array
 */
if (!function_exists('formatReqArray')) {
    function formatReqArray(&$array)
    {
        foreach ($array as &$value) {
            if (is_int($value)) {
                $value = strval($value);
            }
        }
    }
}

/** 获取会话
 * @return array
 */
if (!function_exists('getAuthAdmin')) {
    function getAuthAdmin()
    {
        $key = \Config::get('system.LOGIN_SESSION_KEY');
        $session = \Session::get($key);
        return $session;
    }
}

if (!function_exists('getSql')) {
    /**
     * @param \Illuminate\Database\Query\Builder | \Illuminate\Database\Events\QueryExecuted | array $query
     * @return mixed
     */
    function getSql($query)
    {
        if ($query instanceof \Illuminate\Database\Query\Builder) { // 构建器用到
            $sql = $query->toSql();
            $bindings = $query->getBindings();
        } elseif ($query instanceof \Illuminate\Database\Events\QueryExecuted) { // QueryListener中用到
            $sql = $query->sql;
            $bindings = $query->bindings;
        } else { // \DB::getQueryLog返回值
            $sql = $query['query'];
            $bindings = $query['bindings'];
            if ($bindings && !is_array($bindings)) {
                $bindings = [$bindings];
            }
        }
        foreach ($bindings as $v) {
            if (is_string($v)) {
                $v = "'{$v}'";
            }
            $sql = replaceStrOnce('?', $v, $sql);
        }
        return $sql;
    }
}

if (!function_exists('getDeveloperPhone')) {
    function getDeveloperPhone()
    {
        return [
            13610045692,
        ];
    }
}

if (!function_exists('getDeveloperMail')) {
    /**
     * 接收预警邮件的开发者邮箱, 包含手机邮箱（将包含getDeveloperPhone号码的邮箱）
     * @param bool $includePhoneEmail
     * @return array
     */
    function getDeveloperMail($includePhoneEmail = false)
    {
        $email = [
            'liuyc@fanyue.com',
        ];
        if ($includePhoneEmail) {
            $phones = getDeveloperPhone();
            $phoneEmails = array_map('getPhoneMail', $phones);
            $email = array_merge($email, $phoneEmails);
        }
        return $email;
    }
}

if (!function_exists('getPhoneCarrier')) {
    /**
     * 查询手机运营商
     * @param $phone
     * @return string
     */
    function getPhoneCarrier($phone)
    {
        $r = file_get_contents("https://tcc.taobao.com/cc/json/mobile_tel_segment.htm?tel=$phone");
        $r = iconv('GB2312//IGNORE', 'UTF-8', $r);
        preg_match("/catName:'(.*)',/", $r, $m);
        return $m[1] ?: null;
    }
}

if (!function_exists('getPhoneMail')) {
    /**
     * 获取手机邮箱，用于发送免费短信(手机需要开启短信通知才行)
     * @param $phone
     * @return null|string
     */
    function getPhoneMail($phone)
    {
        $carrier = getPhoneCarrier($phone);
        if ($carrier == '中国移动') {
            $mailHost = '139.com';
        } elseif ($carrier == '中国联通') {
            $mailHost = 'wo.cn';
        } elseif ($carrier == '中国电信') {
            $mailHost = '189.cn';
        } else {
            return null;
        }
        return "{$phone}@{$mailHost}";
    }
}

if (!function_exists('sendEmail')) {
    /**
     * 发送纯文本的邮件
     * @param string|array $to
     * @param string $content
     * @param string $subject
     * @param string|array|null $cc
     * @return bool
     */
    function sendEmail($content, $subject = '自动通知', $to = [], $cc = null)
    {
        $to = $to ?: getDeveloperMail(true);
        Mail::raw($content, function ($m) use ($to, $cc, $subject) {
            /** @var \Illuminate\Mail\Message $m */
            $m->to($to)->subject($subject)->cc(env('MAIL_FROM_ADDRESS')); // 抄送自己避免网易的554 DT:SPM
            if ($cc) $m->cc($cc);
        });
        return count(Mail::failures()) < 1;
    }
}

if (!function_exists('sendEmailWithView')) {
    /**
     * 发送视图模板的邮件
     * @param $to
     * @param $view
     * @param $data
     * @param string $subject
     * @param null $cc
     * @return bool
     */
    function sendEmailWithView($view, $data, $subject = '自动通知', $to = [], $cc = null)
    {
        $to = $to ?: getDeveloperMail(true);
        Mail::send($view, $data, function ($m) use ($to, $cc, $subject) {
            /** @var \Illuminate\Mail\Message $m */
            $m->to($to)->subject($subject)->cc(env('MAIL_FROM_ADDRESS')); // 抄送自己避免网易的554 DT:SPM
            if ($cc) $m->cc($cc);
        });
        return count(Mail::failures()) < 1;
    }
}

if (!function_exists('getLandingUrl')) {
    function getLandingUrl($path)
    {
        return \Config::get('system.xy_cdn_url') . $path . 'index.html';
    }
}

if (!function_exists('getLandingTemplateUrl')) {
    function getLandingTemplateUrl($path)
    {
        return \Config::get('system.xy_cdn_url') . '/newadminpk' . $path;
    }
}

if (!function_exists('getAndroidUrl')) {
    function getAndroidUrl($path)
    {
        if ($path && substr($path, 0, 4) != 'http') {
            $path = \Config::get('system.android_download_url') . $path;
        }
        return $path;
    }
}

if (!function_exists('getIosUrl')) {
    function getIosUrl($path)
    {
        if ($path && substr($path, 0, 4) != 'http') {
            $path = \Config::get('system.ios_download_url') . $path;
        }
        return $path;
    }
}

if (!function_exists('getH5Url')) {
    function getH5Url($path)
    {
        if ($path && substr($path, 0, 4) != 'http') {
            $path = \Config::get('system.h5_share_url') . $path;
        }
        return $path;
    }
}

if (!function_exists('getCdnUrl')) {
    function getCdnUrl($path)
    {
        if ($path && substr($path, 0, 4) != 'http') {
            $path = \Config::get('system.cps_cdn_url') . $path;
        }
        return $path;
    }
}

if (!function_exists('List2Tree')) {
    /**
     * 把返回的数据集转换成Tree
     * @param array $rows 要转换的数据集
     * @param string $id 主键id
     * @param string $pid parent标记字段
     * @param string $child 子节点存放的位置
     * @return array
     */
    function List2Tree($rows, $id = 'id', $pid = 'pid', $child = 'child')
    {
        $items = $childIds = [];

        foreach ($rows as $row) {
            $items[$row[$id]] = $row;
        }

        foreach ($items as $item) {
            $items[$item[$pid]][$child][$item[$id]] = &$items[$item[$id]];
            $childIds[] = $item[$id];
        }

        foreach ($childIds as $childId) {
            unset($items[$childId]);
        }

        return isset(current($items)[$child]) ? current($items)[$child] : [];
    }
}


if (!function_exists('array_depth')) {
    /**
     * 获取数组维度
     * @param $array
     * @return int
     */
    function array_depth($array)
    {
        $max_indentation = 1;

        $array_str = print_r($array, true);
        $lines = explode("\n", $array_str);

        foreach ($lines as $line) {
            $indentation = (strlen($line) - strlen(ltrim($line))) / 4;

            if ($indentation > $max_indentation) {
                $max_indentation = $indentation;
            }
        }

        return intval(ceil(($max_indentation - 1) / 2) + 1);
    }
}

if (!function_exists('tree2Select')) {
    /**
     * @param $tree
     * @param $keyCallBack
     * @param $valueCallBack
     * @param $classCallBack
     * @param int $level
     * @param string $child
     * @return array
     */
    function tree2Select($tree, $keyCallBack, $valueCallBack, $classCallBack, $level = 1, $child = 'child')
    {
        $options = [];
        foreach ($tree as $node) {
            $key = call_user_func($keyCallBack, $node);
            $value = call_user_func($valueCallBack, $node);
            $class = call_user_func($classCallBack, $node);
            $options[] = "<option class='l{$level} {$class}' value='{$value}'>{$key}</option>";
            if (array_key_exists($child, $node) && $subTree = $node[$child]) {
                $subLevel = $level + 1;
                $subOptions = tree2Select($subTree, $keyCallBack, $valueCallBack, $classCallBack, $subLevel, $child);
                $options = array_merge($options, $subOptions);
            }
        }
        return $options;
    }
}

if (!function_exists('getTableHeader')) {
    /**
     * 按查询结果数组的顺序获取列头
     * @param array $exportColumns Dao类中的$exportColumns
     * @param array $data Dao类的查询结果
     * @return array
     */
    function getTableHeader($exportColumns, $data)
    {
        $header = [];
        $row = current($data);
        if (is_array($row)) { // 空数据
            foreach ($row as $k => $v) {
                $header[] = isset($exportColumns[$k]) ? $exportColumns[$k] : $k;
            }
        } else {
            $header = array_values($exportColumns);
        }
        return $header;
    }
}

if (!function_exists('getExportList')) {
    /**
     * 调整列表顺序并增加列头
     * @param $exportColumns
     * @param $data
     * @return array
     */
    function getExportList($exportColumns, $data)
    {
        $array = [];

        // 调整顺序
        foreach ($exportColumns as $key => $columnName) {
            foreach ($data as $i => $datum) {
                $array[$i][$key] = isset($datum[$key]) ? $datum[$key] : '';
            }
        }

        // 增加列头
        $header = getTableHeader($exportColumns, $array);
        array_unshift($array, $header);
        return $array;
    }
}

if (!function_exists('mergeItems')) {
    /**
     * 合并不同的数据
     * @param mixed ...$args
     * @return array
     */
    function mergeItems(...$args)
    {
        $itemsArray = current(func_get_args()); // 多个不同维度的数据，例如玩家的充值数据 与 玩家的登录数据
        $uniqueKeys = current(array_splice($itemsArray, 0, 1)); // 唯一键，例如['c_uid', 'gid']

        $data = [];
        foreach ($itemsArray as $i => $items) {
            foreach ($items as $item) {         // 每种数据都使用相同的唯一键
                $uniqueKeyNames = [];
                foreach ($uniqueKeys as $uniqueKey) {
                    $uniqueKeyNames[] = isset($item[$uniqueKey]) ? $item[$uniqueKey] : '';
                }
                $key = join('_', $uniqueKeyNames);
                $data[$key] = isset($data[$key]) ? array_merge($data[$key], $item) : $item;
            }
        }

        return $data;
    }
}

if (!function_exists('filterSortData')) {
    /**
     * 排序字段过滤，防止A页面排序字段在跳转B页面之后查询报错
     * @param $sortData
     * @param $columns
     * @param $defaultData
     */
    function filterSortData(&$sortData, $columns, $defaultData) {
        $fields = array_column($columns, 'key');
        $sortData = $sortData && in_array($sortData[0], $fields) ? $sortData : $defaultData;
    }
}