package com.ayjs.mxzg.config.excel.cache.tweakCube;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.tweakCube.CTweakCubeTrenchOpen;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2020/9/8
 **/
@Component
public class TweakCubeTrenchOpenSysCache extends BaseExcelCache<CTweakCubeTrenchOpen> {

    @Override
    public String getFileName() {
        return "tweakcubetrenchopen";
    }
}
