package com.ayjs.mxzg.gameserver.module.godRelic.service;

import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.common.base.IRegister;
import com.ayjs.mxzg.config.excel.cache.GodRelicTargetSysCache;
import com.ayjs.mxzg.config.excel.cache.magicTower.MagicTowerTargetSysCache;
import com.ayjs.mxzg.config.excel.entity.CGodRelicTarget;
import com.ayjs.mxzg.config.excel.entity.magicTower.CMagicTowerTarget;
import com.ayjs.mxzg.config.struct.GodRelicTargetType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
@Component
public class GodRelicTargetHelper implements IRegister<GodRelicTargetChecker> {

    private Map<GodRelicTargetType, GodRelicTargetChecker> map = new HashMap<>();

    @Override
    public void registerBean(GodRelicTargetChecker bean) {
        GodRelicTargetChecker old = map.put(bean.getType(), bean);
        if (Objects.nonNull(old)) {
            throw new RuntimeException(String.format("对象重复{%s}-{%s}", old.getClass().getName(), bean.getClass().getName()));
        }
    }

    @Autowired
    private GodRelicTargetSysCache godRelicTargetSysCache;
    @Autowired
    private MagicTowerTargetSysCache magicTowerTargetSysCache;

    public boolean verify(int targetId, List<BattleResult> objects) {
        CGodRelicTarget config = godRelicTargetSysCache.getById(targetId);
        return map.get(config.getTarget().getType()).verify(config.getTarget(), objects);
    }

    public boolean magicTowerVerify(int targetId, List<BattleResult> objects) {
        CMagicTowerTarget config = magicTowerTargetSysCache.getById(targetId);
        return map.get(config.getTarget().getType()).verify(config.getTarget(), objects);
    }
}
