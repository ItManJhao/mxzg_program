package com.ayjs.mxzg.config.excel.constant;


import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.common.excel.ExcelDictionaryField;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * @author hyx
 */
@Component
public class MailConst extends ExcelDictionaryCache {

    @ExcelDictionaryField("send_create_role_mail_num")
    public static int SEND_CREATE_ROLE_MAIL_NUM = 0;

    @ExcelDictionaryField("send_create_role_mail_day_limit")
    public static int SEND_CREATE_ROLE_MAIL_DAY_LIMIT = 0;

    @ExcelDictionaryField("open_service_day_mail_limit")
    public static int OPEN_SERVICE_DAY_MAIL_LIMIT = 0;

    /***
     * 创角邮件1
     */
    public static ImmutableList<ImmutableThing> createRoleMailRewardOne;

    /***
     * 创角邮件2
     */
    public static ImmutableList<ImmutableThing> createRoleMailRewardTwo;

    @Override
    public void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
        if (map.containsKey("create_role_mail_reward_one")) {
            createRoleMailRewardOne = ImmutableThingUtil.fromJson(map.get("create_role_mail_reward_one").getValue());
        }
        if (map.containsKey("create_role_mail_reward_two")) {
            createRoleMailRewardTwo = ImmutableThingUtil.fromJson(map.get("create_role_mail_reward_two").getValue());
        }
    }

}
