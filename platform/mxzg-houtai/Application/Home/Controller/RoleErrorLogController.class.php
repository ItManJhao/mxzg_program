<?php
namespace Home\Controller;

use Think\Controller;

/*
 * 记录玩家报错信息
 */
class RoleErrorLogController extends PublicController{
 

    /**
     * 记录玩家报错信息
     */
    public function Record(){
        $retutn = [
            'code' => 0,
            'msg' => ''
        ];
        $data = I('data', '');
        if(empty($data)){
            $retutn['msg'] = '没数据';
            $this->ajaxReturn($retutn);
        }

        $data = json_decode($data, true);
        $data_log = [];
        foreach($data as $val){
            $data_log[] = [
                'sid' => !empty($val['sid']) ? $val['sid'] : '0',
                'rid' => !empty($val['rid']) ? $val['rid'] : '0',
                'exceptionName' => !empty($val['exceptionName']) ? $val['exceptionName'] : '',
                'className' => !empty($val['className']) ? $val['className'] : '',
                'methodName' => !empty($val['methodName']) ? $val['methodName'] : '',
                'message' => !empty($val['message']) ? $val['message'] : '',
                'lineNumber' => !empty($val['lineNumber']) ? $val['lineNumber'] : '',
                'stackTrace' => !empty($val['stackTrace']) ? $val['stackTrace'] : '',
                'time' => !empty($val['time']) ? $val['time'] : '',
            ];
        }
        
        $res = $this->data_analysis_db->table('role_error_log')->addAll($data_log);
        if(!$res){
            $retutn['msg'] = '记录玩家报错信息失败';
            $this->ajaxReturn($retutn);
        }
        $retutn = [
            'code' => 1,
            'msg' => '记录玩家报错信息成功'
        ];
        $this->ajaxReturn($retutn);
    }


}