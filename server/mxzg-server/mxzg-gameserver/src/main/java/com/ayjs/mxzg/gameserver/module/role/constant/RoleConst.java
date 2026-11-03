package com.ayjs.mxzg.gameserver.module.role.constant;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.common.excel.ExcelDictionaryField;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;
import org.springframework.stereotype.Component;

import java.util.Map;

@Component
public class RoleConst extends ExcelDictionaryCache {

    /**
     * 援助解锁英雄的星级
     */
    @ExcelDictionaryField("assistance_unlock_hero_star")
    public static int ASSISTANCE_UNLOCK_HERO_STAR	= 10;
    /**
     * 援助解锁英雄的数量
     */
    @ExcelDictionaryField("assistance_unlock_hero_num")
    public static int ASSISTANCE_UNLOCK_HERO_NUM = 6;


}
