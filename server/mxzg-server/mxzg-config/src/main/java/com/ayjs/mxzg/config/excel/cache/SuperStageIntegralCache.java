package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CSuperStageIntegral;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.Collection;

/**
 * 段位分差表
 */
@Slf4j
@Component
public class SuperStageIntegralCache extends BaseExcelCache<CSuperStageIntegral> {

    @Override
    public String getFileName() {
        return "superstageintegral";
    }


    /**
     * 根据积分差获取积分配置
     * @param pointsDifference
     * @return
     */
    public CSuperStageIntegral getWith(int pointsDifference){
        Collection<CSuperStageIntegral> all = getAll();
        CSuperStageIntegral stageIntegral = null;
        for (CSuperStageIntegral cSuperStageIntegral : all) {
            if(pointsDifference < 0){
                CSuperStageIntegral minimalIntegral = null;
                if(pointsDifference < cSuperStageIntegral.getPoints_difference() ){
                    if(minimalIntegral == null || cSuperStageIntegral.getPoints_difference() < minimalIntegral.getPoints_difference()){
                        stageIntegral = cSuperStageIntegral;
                        minimalIntegral = cSuperStageIntegral;
                    }
                } else if(stageIntegral == null) {
                    stageIntegral = cSuperStageIntegral;
                    break;
                }
            } else {
                if(pointsDifference >= cSuperStageIntegral.getPoints_difference()){
                    stageIntegral = cSuperStageIntegral;
                } else if(stageIntegral == null) {
                    stageIntegral = cSuperStageIntegral;
                    break;
                }
            }
        }
        if(stageIntegral == null){
            log.error("该分差没有找到基础配置{}", pointsDifference);
        }
        return stageIntegral;
    }

}
