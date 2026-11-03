<?php
import('Function.Client');
import('Function.Url');
import('Function.Date');
import('Function.Array');
import('Function.Http');
class Chek_goods{

	//校验角色 购买商品是否符合购买要求
    public function verify($server_id,$role_id,$goods_id,$platform){
        switch ($platform) {
            //IOS 商品信息
           case 'yaowanios':
                //单角色只能购买1次
                $buy_ones = array(60,61,62,63,64,81,82,83,84,85,86);
                if(in_array($goods_id, $buy_ones)){
                    $this->getCharge($server_id,$role_id,$goods_id,1,1);
                }

                //新服礼包 开服60天内出售
                $new_gift = array(44,45,46);

                if(in_array($goods_id, $new_gift)){
                    $this->getCharge($server_id,$role_id,$goods_id,2,'',60);
                }

                //开服礼包
                $open_gift = array(71,72,73,74,75);
                if(in_array($goods_id, $open_gift)){
                    $this->getCharge($server_id,$role_id,$goods_id,4,2,7,3);
                }

                //周卡
                switch ($goods_id) {
                    //月卡 30天
                    case 51:
                        $this->getCharge($server_id,$role_id,$goods_id,3,'',29);
                        break;
                    //周卡 7天
                    case 54:
                        $this->getCharge($server_id,$role_id,$goods_id,3,'',6);
                        break;
                    //年卡 365天
                    case 52:
                        $this->getCharge($server_id,$role_id,$goods_id,3,'',364);
                        break;
                }

                break;
        }

        //单角色每天购买一次
        $buy_everyday_one = array(31,32,33,131,132,133,231,232,233);
        if(in_array($goods_id, $buy_everyday_one)){
            $this->getCharge($server_id,$role_id,$goods_id,5,1);
        }
    }

    /**
     * @param  [type] $server_id 区服
     * @param  [type] $role_id   角色id
     * @param  [type] $goods_id  商品id
     * @param  [type] $type       1、限制购买次数礼包  2、新服礼包  3、周卡--年卡---月卡   4、音乐礼包 系列
     * @param  [type] $num       单角色购买次数
     * @param  string $day       持续购买天数
     * @param  string $times     开服几天后
     */
    public function getCharge($server_id,$role_id,$goods_id,$type,$num='',$day='',$times=''){
        global $db;
        $sql =  "SELECT * FROM charge WHERE role_id={$role_id} AND server_id={$server_id} AND goods_id='{$goods_id}' AND status=2 ORDER BY create_time DESC";
        //获取区服信息
        $s_sql  =  "SELECT * FROM server WHERE id ={$server_id}";
        $server = $db->getFirstRow($s_sql);
        if(!$server){
            addLog('SERVER_ERROS','服务器错误');
            printJson('SERVER_ERROS', "服务器错误");
        }
        // dump([$server_id,$role_id,$goods_id,$type,$num,$server]);die;
        switch ($type) {
            //次数礼包   限制购买多少次
            case 1:
                $charge = $db->getRows($sql);
                if($charge && (count($charge) >= $num) ){

                    addLog('BUY_ERROS', "单角色只能购买{$num}次,已经超过购买次数");
                    printJson('BUY_ERROS', "单角色只能购买{$num}次,已经超过购买次数");
                }
                break;

            //新服礼包 开服多少天内里面的期限 才可购买
            case 2:
                $eday = 86400 * $day + $server['open_time'];
                if( time()>$eday ){
                    addLog('BUY_ERROS', "已超过开服{$day}天内的购买时间,不可购买");
                    printJson('BUY_ERROS', "已超过开服{$day}天内的购买时间,不可购买");
                }
                break;
            //周卡--年卡---月卡   --时间期限内不可重复购买
            case 3:
                $charge = $db->getFirstRow($sql);
                if($charge){
                    //订单
                    $eday = 86400 * $day + $charge['create_time'];
                    if(time() <= $eday){
                        addLog('BUY_ERROS', "购买{$day}天内不能再次购买");
                        printJson('BUY_ERROS', "购买{$day}天内不能再次购买");
                    }
                }
                break;
            //音乐礼包 ---开服多少天后 才能买 然后持续多少天--然后只能买多少次
            case 4:
                //开服多少天才可以购买
                $sday = 86400 * ($times-1) + $server['open_time'];
                //持续多少天
                $eday = 86400 * ($day +$times-1) + $server['open_time'];
                if(time()< $sday){
                    addLog('BUY_ERROS', "开服第{$times}天才可购买");
                    printJson('BUY_ERROS', "开服第{$times}天才可购买");
                }
                if(time() > $eday){
                    addLog('BUY_ERROS', "已超过持续{$day}天的购买时间");
                    printJson('BUY_ERROS', "已超过持续{$day}天的购买时间");
                }

                $charge = $db->getRows($sql);
                if($charge && (count($charge) >= $num) ){
                    addLog('BUY_ERROS', "单角色只能购买{$num}次,已经超过购买商品次数");
                    printJson('BUY_ERROS', "单角色只能购买{$num}次,已经超过购买商品次数");
                }
                break;
            //头衔福利礼包、星级员工礼包 ---每多少天购买多少次
            case 5:
                $stime  = strtotime('today'); //今天的时间
                $etime  = $stime+86400; //今天的时间
                $sql =  "SELECT * FROM charge WHERE role_id={$role_id} AND server_id={$server_id} AND goods_id='{$goods_id}' AND status<>0 AND create_time>=$stime AND create_time<$etime ORDER BY create_time DESC";

               $charge = $db->getRows($sql);
                if($charge && (count($charge) >= $num) ){
                    addLog('BUY_ERROS', "此商品每天仅可购买$num次");
                    printJson('BUY_ERROS', "此商品每天仅可购买$num次");
                }
                break;
        }
    }
}
