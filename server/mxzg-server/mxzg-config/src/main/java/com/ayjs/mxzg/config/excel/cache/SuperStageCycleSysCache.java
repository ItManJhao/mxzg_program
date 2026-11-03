package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CSuperStageCycle;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;

/**
 * 段位赛周期表
 */
@Slf4j
@Component
public class SuperStageCycleSysCache extends BaseExcelCache<CSuperStageCycle> {

    @Override
    public String getFileName() {
        return "superstagecycle";
    }

    @Override
    protected void loadAfterReady() {
        Collection<CSuperStageCycle> all = getAll();
        CSuperStageCycle last = null;
        for(CSuperStageCycle cycle : all){
            if(last != null){
                if(last.getIdx() + 1 != cycle.getIdx() || last.getStart_time().isAfter(cycle.getStart_time())){
                    throw new RuntimeException(String.format("段位周期表没有按照时间先后顺序排列lastIdx = %s, nextIdx = %s", last.getIdx(), cycle.getIdx()));
                }
            }
            last = cycle;
        }
    }

    /**
     * 获取当前周期
     * @return
     */
    public CSuperStageCycle getNowCycle(){
        LocalDateTime localDateTime = LocalDateTime.now();
        List<CSuperStageCycle> all = getAll();
        CSuperStageCycle nowCycle = null;
        for(CSuperStageCycle cycle : all){
            if(cycle.getStart_time().isBefore(localDateTime)){
                nowCycle = cycle;
            } else {
                break;
            }
        }
        return nowCycle;
    }

    /**
     * 获取第一个周期开始
     * @return
     */
    public CSuperStageCycle getFirstCycle(){
        return getAll().get(0);
    }

    /**
     * 根据赛季和阶段获取周期表
     * @param season
     * @param stage
     * @return
     */
    public CSuperStageCycle getCycleBy(int season, int stage){
        List<CSuperStageCycle> all = getAll();
        for(CSuperStageCycle cycle : all){
            if(cycle.getSeason() == season && cycle.getStage_type().ordinal() == stage){
                return cycle;
            }
            if(cycle.getSeason() > season){
                break;
            }
        }
        return null;
    }

    /**
     * 根据赛季和阶段获取周期表
     * @param season
     * @param stage
     * @return
     */
    public CSuperStageCycle getAfterCycle(int season, int stage){
        LocalDateTime now = LocalDateTime.now();
        List<CSuperStageCycle> all = getAll();
        for(CSuperStageCycle cycle : all){
            if(cycle.getStart_time().isAfter(now) && cycle.getSeason() == season && cycle.getStage_type().ordinal() == stage){
                return cycle;
            }
            if(cycle.getSeason() > season){
                break;
            }
        }
        return null;
    }

    /**
     * 根据赛季和阶段获取周期表
     * @param season
     * @param stage
     * @return
     */
    public CSuperStageCycle getLastCycle(int season, int stage){
        List<CSuperStageCycle> all = getAll();
        CSuperStageCycle lastFinishCycle = null;
        for(CSuperStageCycle cycle : all){
            if(cycle.getSeason() == season && cycle.getStage_type().ordinal() == stage){
                lastFinishCycle = cycle;
            }
            if(cycle.getSeason() > season){
                break;
            }
        }
        return lastFinishCycle;
    }

}
