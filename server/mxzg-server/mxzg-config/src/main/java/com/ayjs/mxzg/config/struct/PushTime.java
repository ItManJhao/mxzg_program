package com.ayjs.mxzg.config.struct;


import com.alibaba.fastjson.JSONArray;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 推送时间规则
 */
@Getter
@Setter
public class PushTime {
    List<Integer> week;
    List<String> time;

    //3分钟延时
    private static final int yanshi = 3 * 60;
    //记录当前周几,用于记录每天已经发送的文本模板
    private int weekNow = -1;
    //key:CPushNotification idx  vlaue:已经推送的时间
    private Map<Integer, List<String>> pushInfoTimeMap = new ConcurrentHashMap<>();

    /**
     * 判断时间是否满足条件
     *
     * @param idx
     * @return
     */
    public boolean isTime(int idx) {
        int weekNow_ = DateTimeUtil.getDayOfWeek_();//当前周几
        if (weekNow != weekNow_) {//已经到了第二天，清除前一天已经发送的文本模板
            pushInfoTimeMap.clear();
            weekNow = weekNow_;
        }
        if (time == null || time.isEmpty()) {//没有时间配置
            return false;
        }
        if (!isWeek(weekNow_)) {
            return false;
        }
        //将11:30时间转换成1130
        List<String> timeList = transfTime();
        int nowTime = DateTimeUtil.currentSecond();
        for (String timeS : timeList) {
            if (checkAlreadyPush(idx, timeS)) {//已经发送过
                continue;
            }
            int setTime = DateTimeUtil.customTime(timeS);
            if (nowTime - setTime >= 0 && nowTime - setTime <= yanshi) {
                addAlreadyPush(idx, timeS);//添加已经发送记录
                return true;
            }
        }
        return false;
    }

    //判断是否已经发送
    private boolean checkAlreadyPush(int idx, String timeS) {
        if (!pushInfoTimeMap.containsKey(idx)) {
            return false;
        }
        List<String> timeList = pushInfoTimeMap.get(idx);
        return timeList.contains(timeS);
    }

    //增加已经发送的时间点
    private void addAlreadyPush(int idx, String timeS) {
        List<String> timeList = pushInfoTimeMap.get(idx);
        if (timeList == null) {
            timeList = new ArrayList<>();
            pushInfoTimeMap.put(idx, timeList);
        }
        timeList.add(timeS);
    }

    //将11:30时间转换成1130
    private List<String> transfTime() {
        List<String> resultStr = new ArrayList<>();
        for (String timeStr : time) {
            String[] str = timeStr.split(":");
            resultStr.add(str[0] + str[1]);
        }
        return resultStr;
    }

    //周几是否满足
    private boolean isWeek(int weekNow) {
        if (week == null || week.isEmpty()) {//每天
            return true;
        }
        return week.contains(weekNow);
    }

    @Override
    public String toString() {
        return "PushTime{" +
                "week=" + week +
                ", time=" + time +
                '}';
    }

}
