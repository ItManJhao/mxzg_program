package com.ayjs.mxzg.gameserver.module.inviteGift.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2019/11/21
 **/
@Entity
@Table(name = "invite_gift", comment = "邀请礼包")
@Getter
@Setter
public class InviteGift extends AbstractEntity {

    @Id
    @Column(name = "rid", comment = "角色id")
    private long rid;

    @Column(name = "invitor", comment = "邀请人")
    private long invitorId;

    @Column(name = "reward_ids", comment = "已领奖记录")
    private Map<Integer, Integer> rewardIds = new HashMap<>();

}
