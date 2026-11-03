<?php
namespace Home\Controller;
use Think\Controller;
class PublicController extends Controller {
    protected $platform_db;
    protected $date;            //前一天日期
    protected $start_time;      //前一天开始时间戳
    protected $end_time;        //前一天结束时间戳
    protected $ovday_date;      //当天日期，凌晨前20分钟为前一天日期
    protected $ovday_hour;      //当天第几个小时，凌晨前20分钟为前一天最后一个小时
    protected $today_date;      //今天日期
    protected $today_hour;      //今天第几个小时
    protected $server_where = "status>0 and type=0 and id not in(998,999,1000,9998,9999)";
    protected $channel_where = "parent_id>0 and id not in(100000,100002,200000,400002,600002,700002,900002,1000000)";

	public function _initialize(){

        //实例化mxag_platform数据库
        $this->platform_db = M('');
        //实例化mxag_data_analysis数据库
        $this->data_analysis_db = M('',null,'DB_DATA_ANALYSIS');

        if(isset($_GET['date']) && !empty($_GET['date'])){
            if(!strtotime($_GET['date'])){
                echo '日期格式不对，请重新尝试！';
                exit;
            }
            $_GET['date'] = date('Y-m-d', strtotime($_GET['date']));
            $this->date = $_GET['date'];
            $this->ovday_date = $_GET['date'];
        }else{
            $this->date = date('Y-m-d', strtotime("-1 day"));
            //判断是凌晨前20分钟，则统计前一天的数据
            if(strtotime(date('Y-m-d') . ' 00:00:00') <= time() && strtotime(date('Y-m-d') . ' 00:20:00') >= time()){
                $this->ovday_date = date('Y-m-d', strtotime("-1 day"));
            }else{
                $this->ovday_date = date('Y-m-d');
            }
        }
        $this->start_time = strtotime($this->date);  //开始时间戳
        $this->end_time = $this->start_time + 86399;    //结束时间戳

        //当天小时的处理
        if(isset($_GET['hour'])){
            $this->ovday_hour = $_GET['hour'];
        }else{
            $this->ovday_hour = intval(date('H'));
        }
        if(strtotime(date('Y-m-d') . ' 00:00:00') <= time() && strtotime(date('Y-m-d') . ' 00:20:00') >= time()){
            $this->ovday_hour = 24;
        }

        //今天日期和小时的处理
        if(isset($_GET['today_date']) && !empty($_GET['today_date'])){
            $this->today_date = $_GET['today_date'];
        }else{
            $this->today_date = date('Y-m-d');
        }

        if(isset($_GET['today_hour'])){
            $this->today_hour = $_GET['today_hour'];
        }else{
            $this->today_hour = intval(date('H'));
        }
        if(empty($this->today_hour)){
            $this->today_hour = 24;
            $this->today_date = date('Y-m-d', strtotime($this->today_date) -86400);
        }

        
	}
}