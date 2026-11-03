<?php

import('Function.String');
import('Function.Url');

include_once DIR_CONFIG . '/error_code.php';

class BaseController extends Controller {

	/**
	 * 淘汰此方法，改用printJson
	 * @param unknown $err
	 * @param string $msg
	 */
    protected function dieError($err, $msg = '') {
    	$ret['error'] = $err;
    	if ($msg) {
    		$ret['msg'] = $msg;
    	}
        $ret['dfherror'] = 1;
    	echo json_encode($ret);
    	exit();
    }

    /**
     * 是否在白名单内
     * @param string $open_id
     * @param string $ip
     * @return boolean
     */
    protected function inWhiteList($open_id, $ip) {
    	global $db;

    	$white_list = $db->getRows("select * from white_list");

    	if($white_list){
    		foreach ($white_list as $v) {
    			if ($v['ip'] && $v['ip'] == $ip) {
    				return true;
    			}

    			if ($v['open_id']) {
    				$real_open_id = getFileExt($open_id);

    				if ($v['open_id'] == $open_id || $v['open_id'] == $real_open_id) {
    					return true;
    				}
    			}
    		}
    	}
    	return false;
    }

    /**
     * 是否在审核白名单内
     * @param string $open_id
     * @param string $ip
     * @return boolean
     */
    protected function inReviewWhiteList($open_id, $ip) {
        global $db;

        $white_list = $db->getRows("select * from review_white_list");

        if($white_list){
            foreach ($white_list as $v) {
                if ($v['ip'] && $v['ip'] == $ip) {
                    return true;
                }

                if ($v['open_id']) {
                    $real_open_id = getFileExt($open_id);

                    if ($v['open_id'] == $open_id || $v['open_id'] == $real_open_id) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    /**
     * 加载不同的SDK处理类
     * @param string $sdk_class
     * @return AbstractSDK
     */
    protected function loadSDK($sdk_class) {
    	$sdk_class_path = DIR_MODELS . '/' . $sdk_class . '.php';
    	if (!file_exists($sdk_class_path)) {
    		printJson('PARAMS_ERROR', "SDK $sdk_class not accept. $sdk_class_path not exists.");
    	}
    	include $sdk_class_path;

    	return new $sdk_class;
    }

	/**
	 * 传入版本号 返回服务器ID
	 * @param string
	 * @return server_id
	 */
	protected function verServer($ver){
        if(!$ver) return false;
        global $db;
        $sql = "select * from verserver where ver = '{$ver}'";
        $server_id = $db->getField($sql,'server_id');
        if($server_id){
            return $server_id;
        }else{
            return false;
        }
    }
}
?>
