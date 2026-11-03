package com.ayjs.mxzg.gameserver.web.activity.struct;

import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;

import cn.hutool.http.HttpUtil;
import lombok.Data;

/**
 * 后台活动数据解析结构体
 *
 * @Author: CWJ
 * @Date: 2019/10/22
 **/
@Data
public class ActivityData {

    /**
     * id，唯一标识
     */
    private int id;
    /**
     * 开始时间
     */
    private int stime;
    /**
     * 结束时间
     */
    private int etime;
    /**
     * 清楚时间
     */
    private int ctime;
    /**
     * config data
     */
    private String data = "[]";
    /***
     * 活动类型
     */
    private int type_id;
    /**
     * 开服多少天数后任务开始计数
     */
    private int limit_days;
    
    public static void main(String[] args) {
    	ActivityData activityData = new ActivityData();
    	activityData.id = 1;
    	activityData.stime = TimeDateUtil.getTodayZeroTimeInt();
    	activityData.etime = TimeDateUtil.getTomorrowZeroTimeInt();
    	activityData.ctime = TimeDateUtil.getTomorrowZeroTimeInt();
    	activityData.type_id = 65;
    	activityData.limit_days = 0;
    	System.out.println(JsonUtil.toJson(activityData));
    	String json = "data={\"ctime\":1592668800,\"data\":\"[{}]\",\"etime\":1592668800,\"id\":1,\"limit_days\":0,\"stime\":1592582400,\"type_id\":65}";
    	
    	HttpUtil.post("http://127.0.0.1:9801/activity/addOrUpdateActivity", json);
	}
}
