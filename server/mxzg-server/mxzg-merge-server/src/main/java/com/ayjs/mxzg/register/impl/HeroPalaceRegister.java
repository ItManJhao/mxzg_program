package com.ayjs.mxzg.register.impl;

import com.ayjs.mxzg.gameserver.module.heropalace.domain.HeroPalace;
import com.ayjs.mxzg.processor.ProcessorType;
import com.ayjs.mxzg.register.MergeRegister;
import com.ayjs.mxzg.service.DataProcessorMetaManager;

/**
 * @Author: CWJ
 * @Date: 2020/11/10
 **/
public class HeroPalaceRegister implements MergeRegister {
    @Override
    public void register(DataProcessorMetaManager dataProcessorMetaManager) {
        dataProcessorMetaManager.doRegisterGame(HeroPalace.class, ProcessorType.HERO_PALACE, 0);
    }
}
