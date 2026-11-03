package com.ayjs.mxzg.config.excel.constant;

import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.common.excel.ExcelDictionaryField;
import org.springframework.stereotype.Component;

@Component
public class PetConst extends ExcelDictionaryCache {

    /**
     * 宠物开启英雄星级
     */
    @ExcelDictionaryField("open_pet_hero_star")
    public static int OPEN_PET_HERO_STAR = 0;

    /**
     * 宠物开启角色等级
     */
    @ExcelDictionaryField("open_pet_role_level")
    public static int OPEN_PET_ROLE_LEVEL = 0;

}
