package com.ayjs.mxzg.tools.client.stresstest.handler.resp;

import com.ayjs.mxzg.protocol.RoleGMsg;
import com.ayjs.mxzg.tools.client.client.ClientCMD;
import com.ayjs.mxzg.tools.client.client.base.ClientResponseHandler;
import com.ayjs.mxzg.tools.client.client.network.ClientSession;

public class CmdGResRoleUpgradeRewardHandler implements ClientResponseHandler<RoleGMsg.GResRoleUpgradeReward> {
    @Override
    public int getMessageId() {
        return ClientCMD.ROLE_UPGRADE;
    }

    @Override
    public void handler(ClientSession client, RoleGMsg.GResRoleUpgradeReward gResRoleUpgradeReward) {
        client.setLevel(gResRoleUpgradeReward.getLevelCurrent());
    }
}
