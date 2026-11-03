package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CAdventurereward;
import com.ayjs.mxzg.config.struct.ExcelCheckUtil;
import lombok.Getter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

@Component
public class AdventurerewardSysCache extends BaseExcelCache<CAdventurereward> {

    @Autowired
    private ExcelCheckUtil excelCheckUtil;


    @Getter
    private Map<Integer, Integer> maxBattleIdx = new HashMap<>();
    @Getter
    private Map<Integer, Map<Integer, CAdventurereward>> configMap = new HashMap<>();


    @Override
    public String getFileName() {
        return "adventurereward";
    }

    @Override
    protected void loadAfterReady() {
        Map<Integer, List<CAdventurereward>> collect = getAll().stream().collect(Collectors.groupingBy(CAdventurereward::getLevel));

        Map<Integer, Integer> maxBattleIdx_ = new HashMap<>();
        Map<Integer, Map<Integer, CAdventurereward>> configMap_ = new HashMap<>();

        collect.forEach((lv, list) -> {
            Optional<CAdventurereward> maxAdventure = list.stream().filter(cAdventurereward -> cAdventurereward.getType() == 1)
                    .max(Comparator.comparingInt(CAdventurereward::getMission));
            maxAdventure.ifPresent(advent -> maxBattleIdx_.put(lv, advent.getMission()));
            configMap_.put(lv, list.stream().collect(Collectors.toMap(CAdventurereward::getMission, Function.identity())));
        });
        maxBattleIdx = maxBattleIdx_;
        configMap = configMap_;
    }

    public CAdventurereward getNextBattleCAdventurereward(CAdventurereward cAdventurereward) {
        if (cAdventurereward.getMission() >= maxBattleIdx.getOrDefault(cAdventurereward.getLevel(), 0)) {
            return cAdventurereward;
        }
        Optional<CAdventurereward> nextAdvent = getAll().stream()
                .filter(advent -> cAdventurereward.getLevel() == advent.getLevel()
                        && advent.getType() == 1
                        && advent.getShow_mission() > cAdventurereward.getShow_mission()).findFirst();
        return nextAdvent.orElse(cAdventurereward);
    }

    @Override
    public boolean check(CAdventurereward cAdventurereward) {
        boolean result = excelCheckUtil.checkImmutableThing(cAdventurereward.getReward(), cAdventurereward.getIdx(), getFileName());
        if (!result) {
            return false;
        }
        return result;
    }

    public CAdventurereward getConfigByMissionIdAndLv(int missionId, int lv) {
        return configMap.getOrDefault(lv, Collections.emptyMap()).getOrDefault(missionId, null);
    }

    public Collection<CAdventurereward> getLvConfigs(int lv) {
        return configMap.getOrDefault(lv, Collections.emptyMap()).values();
    }
}