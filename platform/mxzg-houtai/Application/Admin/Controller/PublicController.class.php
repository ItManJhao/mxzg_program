<?php
namespace Admin\Controller;
use Think\Controller;
class PublicController extends Controller{
    protected $platform_db;
    protected $data_analysis_db;
    
    protected $item_class = [     //道具类型（用于区分道具）
        '1' => [
            'id' => 1,
            'name' => '金币'
        ],
        '2' => [
            'id' => 2,
            'name' => '钻石'
        ],
        '3' => [
            'id' => 3,
            'name' => '角色经验'
        ],
        '5' => [
            'id' => 5,
            'name' => '英雄经验'
        ],
        '8' => [
            'id' => 8,
            'name' => '精灵（符文）'
        ],
        '61' => [
            'id' => 61,
            'name' => '装备'
        ],
        '65' => [
            'id' => 65,
            'name' => '宝石'
        ],
        '12' => [
            'id' => 12,
            'name' => '神装'
        ],
        '17' => [
            'id' => 17,
            'name' => '灵器'
        ],
        '18' => [
            'id' => 18,
            'name' => '宠物'
        ],
        '6' => [
            'id' => 6,
            'name' => '道具'
        ],
    ];

    protected $item_desc = [     //道具名称
        '1' => '金币',
        '2' => '钻石',
        '3' => '角色经验',
        '4' => '公会经验',
        '5' => '英雄经验',
        '6' => '道具',
        '7' => '英雄本体',
        '8' => '精灵',
        '9' => '英雄本体',
        '10' => '废弃',
        '11' => '酒管冒险点数',
        '12' => '神装',
        '13' => '皮肤激活卡',
        '14' => '神装道具',
        '15' => '神职经验',
        '16' => '召唤周卡',
        '17' => '灵器',
        '18' => '宠物',
    ];

    protected $item = [     //道具
        '1' => '1--金币',
        '2' => '2--钻石',
        '3' => '3--角色经验',
        '4' => '4--公会经验',
        '5' => '5--英雄经验',
        '6' => '6--道具',
//        '7' => '7--英雄本体',
        '8' => '8--精灵',
        '11' => '11--酒管冒险点数',
        '12' => '12--神装',
        '13' => '13--皮肤激活卡',
        '14' => '14--神装道具',
        '15' => '15--神职经验',
        '16' => '16--召唤周卡',
        '17' => '17--灵器',
        '18' => '18--宠物',
    ];

    protected $fetter_goddess = [     //羁绊女神
        '10101' => '皇家守卫·伊娜',
        '10201' => '宝箱守护者·格蕾',
        '10301' => '裁决之镰·娜娜琪',
        '10401' => '机械纪元·妮可',
        '10501' => '核爆瓦力·尤米',
    ];

    protected $profession = [     //职业
        '1' => [
            'id' => 1,
            'name' => '战士'
        ],
        '2' => [
            'id' => 2,
            'name' => '法师'
        ],
        '3' => [
            'id' => 3,
            'name' => '牧师'
        ],
        '4' => [
            'id' => 4,
            'name' => '坦克'
        ]
    ];

    protected $five_elements = [     //火水木光暗五行
        '1' => [
            'id' => 1,
            'name' => '火'
        ],
        '2' => [
            'id' => 2,
            'name' => '水'
        ],
        '3' => [
            'id' => 3,
            'name' => '木'
        ],
        '4' => [
            'id' => 4,
            'name' => '光'
        ],
        '5' => [
            'id' => 5,
            'name' => '暗'
        ]
    ];
    protected $server_where = "status>0 and type=0 and id not in(998,999,1000,9998,9999)";
    protected $channel_where = "parent_id>0 and id not in(100000,100002,200000,400002,600002,700002,900002,1000000)";


    public function _initialize(){

        //实例化mxag_platform数据库
        $this->platform_db = M('');
        //实例化mxag_data_analysis数据库
        $this->data_analysis_db = M('',null,'DB_DATA_ANALYSIS');

    	$admin_user_id = session('admin_user_id');
	   	$admin_user_time = session('admin_user_time');

	   	if (empty($admin_user_id) || empty($admin_user_time)){
	   		$this->redirect('login/index');
	   	}else{
	   		$menu = M('bms_nav')->where('status = 1 and pid = 0 and type = 0')->order('`orderby` asc,id asc')->field('id,name,pid')->select();
	   		$user = M('bms_users')->where(array('id' => $admin_user_id,'status'=>1))->find();
	   		if (!$user) {
	   			$this->redirect('login/index');
	   		}
	   		/*获取权限*/
	   		$user_root = M('bms_users_root')->where('id = "'.$user['root_id'].'"')->find();
	   		$user_root['menu_id'] = explode(',',$user_root['menu_id']);//后台菜单权限
        	$this->assign(['menu'=>$menu,'user'=>$user,'user_root'=>$user_root]);
	   	}

	   	//特殊处理时间参数的问题
        if(isset($_GET['start_time'])){
            $_GET['start_time'] = urldecode($_GET['start_time']);
        }
        if(isset($_GET['end_time'])){
            $_GET['end_time'] = urldecode($_GET['end_time']);
        }
        
    }

    public function __construct() {
        parent::__construct();
        //校验用户是否登录
        $this->checkAdminSession();
        //校验用户的权限
        $this->checkAuthority();
    }
    public function checkAdminSession() {
	    $nowtime = time();
	    $s_time = session('logintime');
	    if (($nowtime - $s_time) > 60*60*2) {
	        session('admin_user_id',null);
	        session('admin_user_time',null);
	        $this->error('当前用户未登录或登录超时，请重新登录', U('index/index'));
	    } else {
	        session('logintime',$nowtime);
	    }
	}
    public function checkAuthority() {
        $route_t = getRote();
        if(!empty($route_t)){
            $list = M('bms_nav')->where('url=' . "'$route_t'")->find();
            if(!$list){
                if($_SERVER['REQUEST_METHOD'] == 'POST'){
                    $this->ajaxReturn(['status'=>0,'message'=>'操作不存在，请联系管理员！！！']);
                }
                echo "<script>alert('操作不存在，请联系管理员！！！');</script>";exit;
            }
            //记录操作日志
            if($route_t != 'Chat/ajax_ChatLog'){
                $data = [
                    'url' => $route_t,
                    'url_name' => $list['name'],
                    'params' => json_encode($_REQUEST),
                    'admin_id' => session('admin_user_id'),
                    'admin_name' => session('belongs_to'),
                    'created_at' => time()
                ];
                $data['admin_id'] = session('admin_user_id');
                $data['created_at'] = time();
                $id = M('request_log')->add($data);
            }

            $admin_menu_ids = session('admin_menu_id');
            $admin_menu_arr = explode(',', $admin_menu_ids);
            if(!in_array($list['id'], $admin_menu_arr)){
                if($_SERVER['REQUEST_METHOD'] == 'POST'){
                    $this->ajaxReturn(['status'=>0,'message'=>'您的权限不足，请再接再厉！！！']);
                }
                echo "<script>alert('您的权限不足，请再接再厉！！！');</script>";exit;
            }
        }
    }

    /*后台菜单分类*/
    protected function listMenu(){
        $list = M('bms_nav')->where('type = 0')->order('`orderby` asc,id asc')->select();
        return $this->_tree($list);
    }

    protected function _tree($arr, $pid = 0, $level = 0){
        static $tree = array();
        foreach ($arr as $v) {
            if ($v['pid'] == $pid) {
                //$v['level'] = str_repeat('├', $level);
                $v['level'] = $level;
                $tree[] = $v;
                $this->_tree($arr, $v['id'], $level + 1);
            }
        }
        return $tree;
    }

    /*更新排序*/
    public function order($id,$order,$table,$type,$type_id){
        $re= M($table)->where(array("$type_id" => $id))->save(array("$type" => $order));
        if ($re) {
            $data = [
                "status" => 1,//如果状态为1，返回msg的值
                "msg" => "排序更新成功~",
            ];
        } else {
            $data = [
                "status" => 0,//如果状态为0，返回msg的值
                "msg" => "排序更新失败，请稍后重试！",
            ];
        }
        $this->ajaxReturn($data);
    }

}