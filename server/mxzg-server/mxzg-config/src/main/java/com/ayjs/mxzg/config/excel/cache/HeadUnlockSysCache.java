package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CHeadUnlock;
import com.ayjs.mxzg.config.struct.TargetType;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.stream.Collectors;

@Component
public class HeadUnlockSysCache extends BaseExcelCache<CHeadUnlock> {

    //免费解锁头像
    private Set<Integer> unlockHeadList = new HashSet<>();

    //任务类型对应的头像集
    private Map<TargetType, List<CHeadUnlock>> idsMap = new HashMap<>();

    @Override
    public String getFileName() {
        return "headunlock";
    }


    @Override
    protected void loadAfterReady() {

        //解锁等级等于1级的头像及免费头像
        unlockHeadList = getAll().stream().filter(headUnlock -> headUnlock.getUnlock_type() == 1 ||
                (headUnlock.getUnlock_task().getType() == TargetType.ADVENTURE_LEVEL && headUnlock.getUnlock_task().getTarget() == 1))
                .map(CHeadUnlock::getIcon).collect(Collectors.toSet());

        Map<TargetType, List<CHeadUnlock>> idsMapTemp = new HashMap<>();
        getAll().stream().filter(headUnlock -> headUnlock.getUnlock_task().getType() != null).forEach(headUnlock -> {
            List<CHeadUnlock> headList = idsMapTemp.computeIfAbsent(headUnlock.getUnlock_task().getType(),
                    k -> new ArrayList<>());
            headList.add(headUnlock);
        });
        idsMap = idsMapTemp;
    }

    /**
     * 获取免费头像
     *
     * @return
     */
    public Set<Integer> getUnlockHeadList() {
        return unlockHeadList;
    }

    /**
     * 获取同类型所有装备配置
     */
    public List<CHeadUnlock> getUnlockHeadId(TargetType targetType) {
        return idsMap.get(targetType);
    }
}
