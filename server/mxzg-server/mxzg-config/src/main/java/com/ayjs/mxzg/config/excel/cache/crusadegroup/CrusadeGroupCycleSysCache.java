package com.ayjs.mxzg.config.excel.cache.crusadegroup;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupCycle;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;

/**
 * 讨伐团周期表
 */
@Slf4j
@Component
public class CrusadeGroupCycleSysCache extends BaseExcelCache<CCrusadeGroupCycle> {

    @Override
    public String getFileName() {
        return "crusadegroupcycle";
    }

    @Override
    protected void loadAfterReady() {
        Collection<CCrusadeGroupCycle> all = getAll();
        CCrusadeGroupCycle last = null;
        for(CCrusadeGroupCycle cycle : all){
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
    public CCrusadeGroupCycle getNowCycle(){
        LocalDateTime localDateTime = LocalDateTime.now();
        List<CCrusadeGroupCycle> all = getAll();
        CCrusadeGroupCycle nowCycle = null;
        for(CCrusadeGroupCycle cycle : all){
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
    public CCrusadeGroupCycle getFirstCycle(){
        return getAll().get(0);
    }

    /**
     * 根据赛季和阶段获取周期表
     * @param round
     * @param stage
     * @return
     */
    public CCrusadeGroupCycle getCycleBy(int round, int stage){
        List<CCrusadeGroupCycle> all = getAll();
        for(CCrusadeGroupCycle cycle : all){
            if(cycle.getRound() == round && cycle.getStage_type().ordinal() == stage){
                return cycle;
            }
            if(cycle.getRound() > round){
                break;
            }
        }
        return null;
    }

    /**
     * 根据赛季和阶段获取周期表
     * @param round
     * @param stage
     * @return
     */
    public CCrusadeGroupCycle getAfterCycle(int round, int stage){
        LocalDateTime now = LocalDateTime.now();
        List<CCrusadeGroupCycle> all = getAll();
        for(CCrusadeGroupCycle cycle : all){
            if(cycle.getStart_time().isAfter(now) && cycle.getRound() == round && cycle.getStage_type().ordinal() == stage){
                return cycle;
            }
            if(cycle.getRound() > round){
                break;
            }
        }
        return null;
    }

    /**
     * 根据赛季和阶段获取周期表
     * @param round
     * @param stage
     * @return
     */
    public CCrusadeGroupCycle getLastCycle(int round, int stage){
        List<CCrusadeGroupCycle> all = getAll();
        CCrusadeGroupCycle lastFinishCycle = null;
        for(CCrusadeGroupCycle cycle : all){
            if(cycle.getRound() == round && cycle.getStage_type().ordinal() == stage){
                lastFinishCycle = cycle;
            }
            if(cycle.getRound() > round){
                break;
            }
        }
        return lastFinishCycle;
    }

}
