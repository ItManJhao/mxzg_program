package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CPushNotification;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 推送通知
 */
@Component
public class PushNotificationSysCache extends BaseExcelCache<CPushNotification> {

    //根据推送类型区分，key:类型push_type   value:推送集合
    private Map<Integer, List<CPushNotification>> map_CPushNotification;

    @Override
    public String getFileName() {
        return "pushnotification";
    }

    @Override
    protected void loadAfterReady() {
        Map<Integer, List<CPushNotification>> temp = new HashMap<>();
        for (CPushNotification template : this.getAll()) {
            List<CPushNotification> list = temp.get(template.getPush_type());
            if (list == null) {
                list = new ArrayList<>();
                temp.put(template.getPush_type(), list);
            }
            list.add(template);
//            System.out.println(template.getTimeScript().toString());
        }
        map_CPushNotification = temp;
    }

    //获取定点推送模板
    public List<CPushNotification> getCPushNotifications_fixed() {
        return new ArrayList<>(map_CPushNotification.get(2));
    }
}
