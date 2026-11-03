package com.ayjs.mxzg.gameserver.module.crusadegroup.group.handler;

import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.dao.CrusadeGroupDao;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.CrusadeGroup;
import com.ayjs.mxzg.protocol.CrusadeGroupGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class GroupPusher {

    @Autowired
    private CrusadeGroupDao crusadeGroupDao;
    @Autowired
    private ContextManager contextManager;

    /**
     * 推送阶段变化给所有人
     */
    public void pushStageChange(){
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        CrusadeGroupGMsg.GPushStageChange.Builder builder = CrusadeGroupGMsg.GPushStageChange.newBuilder();
        builder.setStage(crusadeGroup.getStage());

        contextManager.writeAll(CmdCode._75649, builder.build());
    }

}
