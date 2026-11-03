package com.ayjs.mxzg.config.excel.cache;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CDreamlandBuff;

import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2019/12/11
 **/
@Component
public class DreamlandBuffSysCache extends BaseExcelCache<CDreamlandBuff> {

    @Getter
    private Map<Integer, List<CDreamlandBuff>> buffMap = new HashMap<>();

    @Override
    public String getFileName() {
        return "infinitebuff";
    }

    @Override
    protected void loadAfterReady() {
        buffMap = getAll().stream().collect(Collectors.groupingBy(CDreamlandBuff::getType));
    }
}
