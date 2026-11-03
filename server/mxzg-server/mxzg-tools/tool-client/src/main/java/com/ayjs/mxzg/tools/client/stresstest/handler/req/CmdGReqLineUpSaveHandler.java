package com.ayjs.mxzg.tools.client.stresstest.handler.req;

import com.ayjs.mxzg.common.util.MessageUtils;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.ayjs.mxzg.tools.client.client.ClientCMD;
import com.ayjs.mxzg.tools.client.client.base.ClientRequestHandler;
import com.ayjs.mxzg.tools.client.client.network.ClientSession;
import lombok.extern.slf4j.Slf4j;

/**
 * 英雄上阵保存
 */
@Slf4j
public class CmdGReqLineUpSaveHandler implements ClientRequestHandler<BattleGMsg.GReqLineUpSave.Builder> {

    @Override
    public int getMessageId() {
        return ClientCMD.HERO_LINE_UP_SAVE;
    }

    @Override
    public void customHandler(ClientSession client, BattleGMsg.GReqLineUpSave.Builder builder) {
        BattleGMsg.PSLineUpData.Builder builder2 = BattleGMsg.PSLineUpData.newBuilder();
        builder2.setType(builder.getLineData().getType());
        builder2.setGoddessType(builder.getLineData().getGoddessType());
        builder2.setTime(builder.getLineData().getTime());

        for (int i = 0; i < builder.getLineData().getHeroListCount(); i++) {
            BattleGMsg.PSLineUpHeroData.Builder builder1 = BattleGMsg.PSLineUpHeroData.newBuilder();
            BattleGMsg.PSLineUpHeroData old = builder.getLineData().getHeroList(i);

            builder1.setHeroId(client.getReplaceHeroId(old.getHeroId()));

            builder1.setPosition(old.getPosition());
            builder1.setHp(old.getHp());
            builder2.addHeroList(builder1);
        }

        MessageUtils.setMessageBuilderFieldValue(builder, "lineData", builder2.build());

    }
}
