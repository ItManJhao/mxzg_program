<?php
namespace Admin\Controller;

use Think\Controller;

/*
 * 英雄养成日志
 */
class HeroTrainLogController extends PublicController{

    protected $db;

    /*搜索*/
    public function index(){

        //记录搜索条件
        $sid = I('sid', '9');
        $role_id = I('role_id', '');
        $oprate = I('oprate', 'all');

        //获取服务器信息
        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        if($server_info){
            $this->db = connectionDb($server_info, 'log');     //连接游戏数据库

            $where = "1 ";
            if(!empty($role_id)){
                $where .= "and rid='$role_id' ";
            }
            if($oprate == 1){
                $where .= "and delta>0 ";
            }elseif($oprate == 2){
                $where .= "and delta<0 ";
            }

            $table = 'item_log' . getLogTable();
            $count = $this->db->table($table)
                ->where($where)
                ->count();
            $Page  = new \Think\Page($count,20);
            $list = $this->db->table($table)
                ->where($where)
                ->order('rid desc')
                ->limit($Page->firstRow.','.$Page->listRows)
                ->select();
        }else{
            $count = 0;
            $Page  = new \Think\Page($count,20);
            $list = [];
        }

        //获取道具数据（只获取英雄）
        $item_data = M('gift_item')->select();
        $item_info_re = [];
        foreach($item_data as $item_val){
            $item_info_re[$item_val['id']] = $item_val;
        }
        unset($item_data);
        $role_arr = [];     //存储角色信息数据，避免重复查询

        foreach($list as &$list_val){
            if(!isset($role_arr[$list_val['rid']])){
                $role_arr[$list_val['rid']] = M('user_server')
                    ->alias('us')
                    ->field('us.*,ch1.name as channel_name,ch2.name as channel_name_son')
                    ->join("left join user on user.id=us.user_id")
                    ->join("left join channel as ch1 on ch1.id=user.c_id")
                    ->join("left join channel as ch2 on ch2.id=user.c_son_id")
                    ->where('role_id=' . $list_val['rid'])
                    ->find();
            }
            $list_val['role_name'] = $role_arr[$list_val['rid']]['role_name'];
            $list_val['user_id'] = $role_arr[$list_val['rid']]['user_id'];
            $list_val['channel_name'] = $role_arr[$list_val['rid']]['channel_name'];
            $list_val['channel_name_son'] = $role_arr[$list_val['rid']]['channel_name_son'];

            //处理道具数据
            if(isset($item_info_re[$list_val['type']])){
                $item_info = $item_info_re[$list_val['type']];
                $list_val['item_name'] = $item_info['name'];
                $list_val['item_type_name'] = $item_info['type_name'];
                $list_val['item_quality'] = $item_info['quality'];
            }else{
                $list_val['item_name'] = '';
                $list_val['item_type_name'] = '';
                $list_val['item_quality'] = 0;
            }

            //处理操作变量
            if($list_val['delta'] > 0){
                $list_val['oprate'] = '增加';
            }else{
                $list_val['oprate'] = '消耗';
            }
            $list_val['old'] = $list_val['curr'] - $list_val['delta'];
        }

        //获取所有的服务器
        $servers = M('server')->select();
        $search_params = [
            'role_id' => $role_id,
            'sid' => $sid,
            'item_type' => $item_type,
            'oprate' => $oprate,
        ];
        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

}