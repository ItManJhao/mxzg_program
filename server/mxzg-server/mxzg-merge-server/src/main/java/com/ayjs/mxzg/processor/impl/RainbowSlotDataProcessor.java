package com.ayjs.mxzg.processor.impl;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.config.Config;
import com.ayjs.mxzg.gameserver.module.rainbow.domain.RainbowSlot;
import com.ayjs.mxzg.processor.DataProcessor;
import com.ayjs.mxzg.processor.ProcessorType;
import com.ayjs.mxzg.repository.manager.MergeRepositoryManager;
import com.ayjs.mxzg.repository.persister.MergeRepository;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/8/20
 **/
public class RainbowSlotDataProcessor implements DataProcessor {

    @Override
    public ProcessorType getType() {
        return ProcessorType.RAINBOW_SLOT;
    }

    @Override
    public void beforeMerge(Class<? extends AbstractEntity> clz, String source) {
        MergeRepository mergeRepository = MergeRepositoryManager.getInstance().get(Config.getInstance().getTarget(), source);
        List<RainbowSlot> rainbowSlots = mergeRepository.listAll(RainbowSlot.class);
        rainbowSlots.forEach(rainbowSlot -> {
            rainbowSlot.setRid(0);
            rainbowSlot.setEndTime(0);
        });
        mergeRepository.update(rainbowSlots);
    }

    @Override
    public void afterMerge(Class<? extends AbstractEntity> clz, String source) {

    }

}
