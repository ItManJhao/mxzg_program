package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CClanSkillBase;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.Comparator;
import java.util.HashMap;
import java.util.Map;

@Component
public class ClanSkillBaseSysCache extends BaseExcelCache<CClanSkillBase> {

    @Getter
    private int maxLv;

    private Map<String, CClanSkillBase> indexMap = new HashMap<>();

    private String indexStr(int level, int attrType) {
        return String.format("{%s}-{%S}", level, attrType);
    }

    @Override
    protected void loadAfterReady() {
        maxLv = getAll().stream().max(Comparator.comparingInt(CClanSkillBase::getLevel)).get().getLevel();
        Map<String, CClanSkillBase> indexMap_ = new HashMap<>();
        getAll().forEach(config -> {
            indexMap_.putIfAbsent(indexStr(config.getLevel(), config.getAttr_type()), config);
        });
        indexMap = indexMap_;
    }

    public CClanSkillBase getByLevelAndType(int level, int attrType) {
       CClanSkillBase cClanSkillBase =  indexMap.get(indexStr(level, attrType));
        ConfigAsserts.notNull(cClanSkillBase,
                () -> String.format("CClanSkillBase配置数据不存在level:{%s},attrType:{%s}", level, attrType));
       return cClanSkillBase;
    }

    @Override
    public String getFileName() {
        return "clanskillbase";
    }


}