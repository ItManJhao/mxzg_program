package com.ayjs.mxzg.message.module.teamArena.message;

import com.ayjs.rpc.RemoteMessage;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

/**
 * 队伍阵容数据返回
 *
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Getter
@Setter
@Builder
public class TeamArenaLineUpResMessage implements RemoteMessage {

    private long teamId;
    private long attackTeam;
    private List<byte[]> battleVos;
    private List<Integer> fighting;

}
