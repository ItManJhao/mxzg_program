<?php
namespace Admin\Model;
use Think\Model;
class GameModel extends Model {
//    protected $data_slave;
//    protected $log_slave;
//    public function _initialize($sid = '') {
////        $this->mod_master = M('faq_group',NULL,$this->master);
//        if(!empty($sid)){
//            C('DB_GAME_DATA_SLAVE.DB_NAME', 'mxzg_' . $sid . '_data');
////            C('DB_GAME_LOG_SLAVE.DB_NAME', 'mxzg_' . $sid . '_log');
//        }
//        $this->data_slave = M('role',NULL,'DB_GAME_DATA_SLAVE');
////        $this->log_slave = M('gm_command_log',NULL,'DB_GAME_LOG_SLAVE');
//    }
//
//    public function getRoleInfo($role_id) {
//        $data = $this->data_slave
//            ->table("role")
//            ->where("id = $role_id")->find();
//        return !empty($data)?$data:array();
//    }


}