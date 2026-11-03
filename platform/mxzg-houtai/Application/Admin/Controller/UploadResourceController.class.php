<?php
namespace Admin\Controller;
use Think\Controller;
use Think\Db;

/*
 * 上传资源管理
 */
class UploadResourceController extends PublicController{
    public function index(){
        $this->display();
    }
    
    /*上传星盘对应星级*/
    public function UpAstrolabeStar(){
        $this->display();
    }
    /*上传星盘对应星级*/
    public function ajax_UpAstrolabeStar(){
        $params = I('post.');
        //获取活动数据，解析活动数据excel文件
        $excel_data = array();
        $now_time = time();
        if( $params['data_file'] && file_exists(LSS . '/Uploads/Excel/' . $params["data_file"]) ){
            $excel_data = $this->getExcelData($params['data_file']);
        }
        foreach($excel_data as $excel_val){
            $insert_data[] = [
                'id' => $excel_val['idx'],
                'star' => $excel_val['star'],
                'created_at' => $now_time,
            ];
        }
        $save = $this->platform_db->table('astrolabe_star')->addAll($insert_data,[],true);
        if ($save) {
            $status = ['status'=>1,'message'=>'上传星盘对应星级成功~'];
        }else{
            $status = ['status'=>0,'message'=>'上传星盘对应星级失败'];
        }
        $this->ajaxReturn($status);
    }

    /*上传星盘对应技能*/
    public function UpAstrolabeSkill(){
        $this->display();
    }
    /*上传星盘对应技能*/
    public function ajax_UpAstrolabeSkill(){
        $params = I('post.');
        //获取活动数据，解析活动数据excel文件
        $excel_data = array();
        $now_time = time();
        if( $params['data_file'] && file_exists(LSS . '/Uploads/Excel/' . $params["data_file"]) ){
            $excel_data = $this->getExcelData($params['data_file']);
        }
        foreach($excel_data as $excel_val){
            $insert_data[] = [
                'id' => $excel_val['idx'],
                'name' => $excel_val['note'],
                'created_at' => $now_time,
            ];
        }
        $save = $this->platform_db->table('astrolabe_skill')->addAll($insert_data,[],true);
        if ($save) {
            $status = ['status'=>1,'message'=>'上传星盘对应星级成功~'];
        }else{
            $status = ['status'=>0,'message'=>'上传星盘对应星级失败'];
        }
        $this->ajaxReturn($status);
    }

    /*上传属性*/
    public function UpAttribute(){
        $this->display();
    }
    /*上传属性*/
    public function ajax_UpAttribute(){
        $params = I('post.');
        //获取活动数据，解析活动数据excel文件
        $excel_data = array();
        if( $params['data_file'] && file_exists(LSS . '/Uploads/Excel/' . $params["data_file"]) ){
            $excel_data = $this->getExcelData($params['data_file'], 1);
        }
        foreach($excel_data as $excel_val){
            $insert_data[] = [
                'id' => $excel_val['type'],
                'name' => $excel_val['name'],
            ];
        }
        $save = $this->platform_db->table('attribute')->addAll($insert_data,[],true);
        if ($save) {
            $status = ['status'=>1,'message'=>'上传属性成功~'];
        }else{
            $status = ['status'=>0,'message'=>'上传属性失败'];
        }
        $this->ajaxReturn($status);
    }

    /*上传圣龙等级属性*/
    public function UpDragonLevel(){
        $this->display();
    }
    /*上传圣龙等级属性*/
    public function ajax_UpDragonLevel(){
        $params = I('post.');
        //获取活动数据，解析活动数据excel文件
        $excel_data = array();
        if( $params['data_file'] && file_exists(LSS . '/Uploads/Excel/' . $params["data_file"]) ){
            $excel_data = $this->getExcelData($params['data_file']);
        }
        foreach($excel_data as $excel_val){
            $insert_data[] = [
                'id' => $excel_val['idx'],
                'level' => $excel_val['level'],
                'grade' => $excel_val['grade'],
                'attribute' => $excel_val['ability'],
            ];
        }
        $save = $this->platform_db->table('dragon_level')->addAll($insert_data,[],true);
        if ($save) {
            $status = ['status'=>1,'message'=>'上传圣龙等级属性成功~'];
        }else{
            $status = ['status'=>0,'message'=>'上传圣龙等级属性失败'];
        }
        $this->ajaxReturn($status);
    }

    /*上传圣物属性*/
    public function UpHolyThings(){
        $this->display();
    }
    /*上传圣物属性*/
    public function ajax_UpHolyThings(){
        $params = I('post.');
        //获取活动数据，解析活动数据excel文件
        $excel_data = array();
        if( $params['data_file'] && file_exists(LSS . '/Uploads/Excel/' . $params["data_file"]) ){
            $excel_data = $this->getExcelData($params['data_file']);
        }
        foreach($excel_data as $excel_val){
            $insert_data[] = [
                'id' => $excel_val['relic_type'],
                'star' => $excel_val['star'],
                'quality' => $excel_val['rare'],
                'attribute' => $excel_val['ability'],
                'skill' => $excel_val['skill'],
            ];
        }
        $save = $this->platform_db->table('holy_things')->addAll($insert_data,[],true);
        if ($save) {
            $status = ['status'=>1,'message'=>'上传圣物属性成功~'];
        }else{
            $status = ['status'=>0,'message'=>'上传圣物属性失败'];
        }
        $this->ajaxReturn($status);
    }


    /*上传宠物属性*/
    public function UpPet(){
        $this->display();
    }
    /*上传宠物属性*/
    public function ajax_UpPet(){
        $params = I('post.');
        //获取活动数据，解析活动数据excel文件
        $excel_data = array();
        if( $params['data_file'] && file_exists(LSS . '/Uploads/Excel/' . $params["data_file"]) ){
            $excel_data = $this->getExcelData($params['data_file']);
        }
        foreach($excel_data as $excel_val){
            $insert_data[] = [
                'id' => $excel_val['id'],
                'elem' => $excel_val['elem'],
                'quality' => $excel_val['rare'],
            ];
        }
        $save = $this->platform_db->table('pet_things')->addAll($insert_data,[],true);
        if ($save) {
            $status = ['status'=>1,'message'=>'上传宠物属性成功~'];
        }else{
            $status = ['status'=>0,'message'=>'上传宠物属性失败'];
        }
        $this->ajaxReturn($status);
    }

    /*上传宠物等级属性*/
    public function UpPetLevel(){
        $this->display();
    }
    /*上传宠物等级属性*/
    public function ajax_UpPetLevel(){
        $params = I('post.');
        //获取活动数据，解析活动数据excel文件
        $excel_data = array();
        if( $params['data_file'] && file_exists(LSS . '/Uploads/Excel/' . $params["data_file"]) ){
            $excel_data = $this->getExcelData($params['data_file']);
        }
        foreach($excel_data as $excel_val){
            $insert_data[] = [
                'id' => $excel_val['idx'],
                'pet_id' => $excel_val['id'],
                'level' => $excel_val['level'],
                'attribute' => $excel_val['attr'],
                'skill' => $excel_val['skill'],
                'skill_level' => $excel_val['skill_level'],
            ];
        }
        $save = $this->platform_db->table('pet_level')->addAll($insert_data,[],true);
        if ($save) {
            $status = ['status'=>1,'message'=>'上传宠物等级成功~'];
        }else{
            $status = ['status'=>0,'message'=>'上传宠物等级失败'];
        }
        $this->ajaxReturn($status);
    }


    private function getExcelData($data_file, $fixed_row=3){
        
        $data_file = LSS . '/Uploads/Excel/' . $data_file;
        $excel_read = getPHPExcelRead($data_file);
        //获取表格行数
        $rowCount = $excel_read->getActiveSheet()->getHighestRow();
        //获取表格列数
        $columnCount = $excel_read->getActiveSheet()->getHighestColumn();
        // $columnCount = 'D';

        /* 循环读取每个单元格的数据 */
        //行数循环
        //获取数据的key
        // $fixed_row = 3;
        for ($column = 'A'; $column <= $columnCount; $column++) {
            $cell_val = $excel_read->getActiveSheet()->getCell($column . $fixed_row)->getValue();
            if(is_object($cell_val)){
                $cell_val = $cell_val->__toString();
            }
            $data_key_arr[$column] = $cell_val;
        }
        $excel_data = [];
        for ($row = $fixed_row+1; $row <= $rowCount; $row++) {
            //列数循环 , 列数是以A列开始
            for ($column = 'A'; $column <= $columnCount; $column++) {
                $cell_val = $excel_read->getActiveSheet()->getCell($column . $row)->getValue();
                if(is_object($cell_val)){
                    $cell_val = $cell_val->__toString();
                }
                $excel_data[$row - $fixed_row - 1][$data_key_arr[$column]] = $cell_val;
            }
        }
        return $excel_data;
    }

}