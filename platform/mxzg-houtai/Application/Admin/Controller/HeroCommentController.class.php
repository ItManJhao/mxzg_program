<?php
namespace Admin\Controller;

use Think\Controller;

/*
 * 英雄评论
 */
class HeroCommentController extends PublicController{

    protected $data_db;
    /*搜索*/
    public function index(){
        $hero = $this->platform_db->table('hero')->select();
        $hero_re = [];
        foreach($hero as $hero_val){
            $hero_re[$hero_val['id']] = $hero_val;
        }
        //记录搜索条件
        $hero_ids = I('hero_ids', '');
        //组建搜索条件的值
        $search_params = [
            'hero_ids' => $hero_ids,
        ];

        $redis = connectRedis();
        if(!empty($hero_ids)){
            $hero_ids = explode(',', $hero_ids);
            $hero_comment_data = $redis->hmGet('cross_hero_comment:data', $hero_ids);
        }else{
            $hero_comment_data = $redis->hGetAll('cross_hero_comment:data');
        }
        $list = [];
        foreach($hero_comment_data as $hero_comment_val){
            $hero_comment_val = json_decode($hero_comment_val, true);
            $hero_id = 0;
            $hero_name = '';
            if(isset($hero_re[$hero_comment_val['heroType']])){
                $hero_id = $hero_comment_val['heroType'];
                $hero_name = $hero_re[$hero_comment_val['heroType']]['name'];
            }
            foreach($hero_comment_val['commentDetailMap'] as $comment_val){
                $list[] = [
                    'id' => $comment_val['id'],
                    'rid' => $comment_val['rid'],
                    'context' => $comment_val['context'],
                    'hateCount' => $comment_val['hateCount'],
                    'likeCount' => $comment_val['likeCount'],
                    'localDateTime' => $comment_val['localDateTime'],
                    'hero_id' => $hero_id,
                    'hero_name' => $hero_name,
                    'idCount' => $hero_comment_val['idCount'],      //评论个数
                    'likeCounts' => $hero_comment_val['likeCount'],  //英雄喜欢次数
                ];
            }
        }
        
        $this->assign(['list'=>$list, 'hero_list' => $hero, 'search_params' => $search_params]);
        $this->display();
    }

    //删除评论
    public function ajax_delComment(){

        $hero_id = I('hero_id', '0');
        $comment_id = I('comment_id', '0');
        if(empty($hero_id) || empty($comment_id)){
            $status = ['status'=>0,'message'=>'参数出错，请返回重试'];
        }
        //2020-7-15更新
        $send_data = [
            'heroType' => $hero_id,
            'commentId' => $comment_id,
        ];
        $error_msg = '';
        $center_server_info = C("CENTER_SERVER_INFO");
        $send_url = "http://" . $center_server_info['HOST'] . ':' . $center_server_info['PORT'] . C("HERO_COMMENT_DELETE");
        $send_url .= '?' . http_build_query($send_data);
        $result = curlRequest($send_url, 'get');
        $result_arr = json_decode($result, true);
        $status = $result_arr['code'];
        if($status != 200){
            $error_msg .= '删除评论失败，原因：' . $result_arr['msg'] . '；';
        }


        // //实例化中心库数据库
        // $data_center_db = M('',null,'DB_DATA_CENTER');
        // $server_cross_list = $data_center_db->table("cross_config")->select();
        // $send_data = [
        //     'heroType' => $hero_id,
        //     'commentId' => $comment_id,
        // ];
        // $error_msg = '';
        // foreach($server_cross_list as $server_cross_val){
        //     $server_cross_val['port'] = 20004;
        //     $send_url = "http://" . $server_cross_val['ip'] . ':' . $server_cross_val['port'] . C("HERO_COMMENT_DELETE");
        //     $send_url .= '?' . http_build_query($send_data);
        //     $result = curlRequest($send_url, 'get');
        //     $result_arr = json_decode($result, true);
        //     $status = $result_arr['code'];
        //     if($status != 200){
        //         $error_msg .= '跨服id【' . $server_cross_val['id'] . '】：删除评论失败，原因：' . $result_arr['msg'] . '；';
        //     }
        // }

        if (empty($error_msg)) {
            $status = ['status'=>1,'message'=>'删除评论成功~'];
        }else{
            $status = ['status'=>0,'message'=>$error_msg];
        }
        $this->ajaxReturn($status);
    }

}