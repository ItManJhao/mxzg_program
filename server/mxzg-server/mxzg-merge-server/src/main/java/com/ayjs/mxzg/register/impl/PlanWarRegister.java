package com.ayjs.mxzg.register.impl;

import com.ayjs.mxzg.gameserver.module.planewar.domain.PlaneWarTurn;
import com.ayjs.mxzg.processor.ProcessorType;
import com.ayjs.mxzg.register.MergeRegister;
import com.ayjs.mxzg.repository.manager.MergeRepositoryManager;
import com.ayjs.mxzg.service.DataProcessorMetaManager;

/**
 * @Author: CWJ
 * @Date: 2020/11/10
 **/
public class PlanWarRegister implements MergeRegister {
    @Override
    public void register(DataProcessorMetaManager dataProcessorMetaManager) {
        dataProcessorMetaManager.doRegister(PlaneWarTurn.class, ProcessorType.RESERVE_SOURCE, 0, MergeRepositoryManager.DATA_SIGN);
    }
}
