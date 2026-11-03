package com.ayjs.mxzg.cross.module.crusadegroup.group.domain;

import lombok.Value;

import java.util.Set;

@Value(staticConstructor = "of")
public class ServerInfo {
    // 服务器id
    private int serverId;
    // 报名的玩家id列表
    private Set<Long> applicant;

    /**
     * 获取报名数量
     * @return
     */
    public int getEntriesNumber(){
        return this.applicant.size();
    }

}
