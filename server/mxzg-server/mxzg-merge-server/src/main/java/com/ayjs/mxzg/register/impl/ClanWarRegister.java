package com.ayjs.mxzg.register.impl;

import com.ayjs.mxzg.gameserver.module.clanwar.domain.ClanWarInfo;
import com.ayjs.mxzg.processor.ProcessorType;
import com.ayjs.mxzg.register.MergeRegister;
import com.ayjs.mxzg.repository.manager.MergeRepositoryManager;
import com.ayjs.mxzg.service.DataProcessorMetaManager;

/**
 * @Author: CWJ
 * @Date: 2020/11/10
 **/
public class ClanWarRegister implements MergeRegister {
    @Override
    public void register(DataProcessorMetaManager dataProcessorMetaManager) {
        dataProcessorMetaManager.doRegister(ClanWarInfo.class, ProcessorType.TRUNCATE_ALL, 0, MergeRepositoryManager.DATA_SIGN);
    }
}
