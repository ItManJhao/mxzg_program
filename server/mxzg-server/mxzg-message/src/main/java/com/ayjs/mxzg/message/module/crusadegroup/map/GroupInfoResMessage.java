package com.ayjs.mxzg.message.module.crusadegroup.map;

import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.dto.GroupMember;
import lombok.Value;

import java.util.List;

/**
 * 讨伐团信息
 */
@Value(staticConstructor = "valueOf")
public class GroupInfoResMessage implements CrusadeGroupMessage {

    private int groupId;    //  讨伐团id
    private String groupName;   //团名称
    private int emblem;     //团徽
    private List<GroupMember> members;  //成员列表
    private int renameNumber;   //改名次数
}
