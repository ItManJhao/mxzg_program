<?php
namespace app\controller;

class Game extends \core\lss {

    function  __construct() {
        parent::__construct();
    }

    // 验证兑换码
    public function checkCode() {
        $role_id = $this->getParam('role_id',0);
        $code = $this->getParam('code',0);
        $new_time = time();
        if(empty($code)){
            out([], '参数错误，请稍后再试', 31401);
        }
        if(empty($role_id)){
            out([], '参数错误，请稍后再试', 31401);
        }
        try {
            $this->db->begin();     //开始mysqli事务
            //获取兑换码信息
            $sql = "
                select gift_code.*,gift.gift_item,gift.sid,gift.c_son_id,gift.start_time,gift.end_time,gift.type as gift_type,gift.use_num 
                from gift_code 
                left join gift ON gift.id=gift_code.gift_id
                where gift_code.code='$code'
            ";
            $code_info = $this->db->db_sql($sql);
            if(!$code_info){
                out([], '兑换码不存在', 31402);
            }
            $code_info = $code_info[0];
            //获取角色详细信息
            $sql = "
                select *
                from user_server 
                where role_id='$role_id'
            ";
            $role_info = $this->db->db_sql($sql);
            if(!$role_info){
                throw new \Exception("参数错误，请稍后再试", 31401);
            }
            $role_info = $role_info[0];

            //判断兑换码是否在有效期内
            if($code_info['start_time'] > $new_time){
                throw new \Exception("兑换码未到使用时间", 31404);
            }
            if($code_info['end_time'] < $new_time){
                throw new \Exception("兑换码已过期", 31404);
            }

            //判断兑换码渠道是否符合
            if(!empty($code_info['c_son_id']) && !in_array($role_info['c_son_id'], explode(',', $code_info['c_son_id'])))
            {
                throw new \Exception("兑换码不能在当前区服使用1", 31401);
            }

            //判断兑换码区服是否符合
            if(!empty($code_info['sid']) && !in_array(-1, explode(',', $code_info['sid'])) && !in_array($role_info['sid'], explode(',', $code_info['sid'])))
            {
                throw new \Exception("兑换码不能在当前区服使用2", 31401);
            }

            //判断兑换码是否使用过
            if($code_info['gift_type'] == 0 && !empty($code_info['role_id'])){           //普通码
                throw new \Exception("兑换码已经被使用过", 31403);
            }

            //判断玩家当前礼包使用次数是否够了
            $sql = "
                select count(id) as use_count  
                from gift_code_log 
                where gift_id=" . $code_info['gift_id'] . "
                and role_id='$role_id'
            ";
            $gift_code_log = $this->db->db_sql($sql);
            if($code_info['gift_type'] == 0){
                $use_num = $code_info['use_num'];
            }else{
                $use_num = 1;
            }
            if($gift_code_log && $gift_code_log[0]['use_count']>=$use_num){
                throw new \Exception("您已经使用过其他兑换码", 31405);
            }

            // $this->db->db_tabel('gift_code_log');
            // $where = "
            //     where gift_id=" . $code_info['gift_id'] . "
            //     and role_id='$role_id'
            // ";
            // $gift_code_log = $this->db->db_find('*', $where);
            // if($gift_code_log){
            //     throw new \Exception("您已经使用过其他兑换码", 31405);
            // }

            if($code_info['gift_type'] == 0){
                //修改兑换码使用数据
                $update_data = [
                    'role_id' => $role_id,
                    'use_time' => $new_time
                ];
                $this->db->db_tabel('gift_code');
                $res = $this->db->db_update($update_data, "where code='$code'");    //更新数据
            }
            
            //添加兑换码使用流水日志
            $keyarr = [
                'code','role_id','gift_id','gift_name','mark','created_at'
            ];
            $valuearr = [
                "'$code'",$role_id,$code_info['gift_id'],"'" . $code_info["gift_name"] . "'","'" . $code_info["mark"] . "'",$new_time
            ];
            $this->db->db_tabel('gift_code_log');
            $ret = $this->db->db_insert($keyarr, $valuearr);    //插入数据，获取主键uid
            $return_data = [[
                'role_id' => $role_id,
                'code' => $code,
                'gift_item' => json_decode($code_info["gift_item"], true)
            ]];
            $this->db->commit();         //提交mysqli事务
        } catch (\Exception $e) {
            $this->db->rollBack();         //回滚mysqli事务
            out(array(),$e->getMessage(),$e->getcode());
        }
        out($return_data);
    }


}

