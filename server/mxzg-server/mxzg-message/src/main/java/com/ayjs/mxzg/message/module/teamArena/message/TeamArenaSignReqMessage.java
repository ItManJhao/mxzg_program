package com.ayjs.mxzg.message.module.teamArena.message;

import com.ayjs.mxzg.message.cross.CrossMessage;
import com.ayjs.mxzg.message.module.teamArena.domain.ArenaTeamMember;
import lombok.Builder;
import lombok.Getter;

import java.util.List;

/**
 * 报名
 *
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Getter
@Builder
public class TeamArenaSignReqMessage implements CrossMessage {

    private long teamId;
    private long captainId;
    private String teamName;
    private List<ArenaTeamMember> members;
    private int createTime;

}
