package com.ayjs.mxzg.message.module.role.message;

import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.message.cross.CrossMessage;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import lombok.Builder;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * 更新跨服角色信息
 */
@Data
@Builder
public class CrossRoleUpdateMessage implements CrossMessage {
    /**
     * 角色id
     */
    private long id;
    /**
     * 账号id
     */
    private long userId;
    private int serverId;
    private String nick;
    private int headId;
    private int borderId;
    private int imageId;
    private int level;
    private long createTime;
    private long clanId;
    private String clanName;
    private int arenaScore;//pvp分数
    private int areaId;
    private boolean isOnline;//是否在线
    private int fighting;//当前战力
    private int maxFighting;//历史最高战力
    private List<HeroBriefData> heroBrief; // 主线阵营简要信息
    private long lastOfflineTime;
    private String place;
    private int formationId;
    private boolean assistanceUnlock;

    public CrossRole toCrossRole() {
        CrossRole crossRole = new CrossRole();
        fillCrossRole(crossRole);
        return crossRole;
    }
    
    public void fillCrossRole(CrossRole crossRole) {
    	crossRole.setId(id);
        crossRole.setUserId(userId);
        crossRole.setServerId(serverId);
        crossRole.setNick(nick);
        crossRole.setHeadId(headId);
        crossRole.setBorderId(borderId);
        crossRole.setImageId(imageId);
        crossRole.setLevel(level);
        crossRole.setCreateTime(createTime);
        crossRole.setClanId(clanId);
        crossRole.setClanName(Objects.isNull(clanName) ? "" : clanName);
        crossRole.setArenaScore(arenaScore);
        crossRole.setAreaId(areaId);
        crossRole.setOnline(isOnline);
        if (crossRole.getMaxFighting() != maxFighting) {
            crossRole.setMaxFighting(maxFighting);
        }
        if (crossRole.getFighting() != fighting) {
            crossRole.setFighting(fighting);
            crossRole.setFightRankTime(TimeDateUtil.getCurrentTimeInt());
        }
        if (Objects.isNull(heroBrief)) {
            crossRole.setHeroBrief(new ArrayList<>());
        } else {
            crossRole.setHeroBrief(heroBrief);
        }
        crossRole.setLastOfflineTime(lastOfflineTime);
        crossRole.setPlace(Objects.isNull(place) ? "" : place);
        crossRole.setFormationId(formationId);
        crossRole.setAssistanceUnlock(assistanceUnlock);
    }
    
    

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CrossRoleUpdateMessage that = (CrossRoleUpdateMessage) o;
        return id == that.id;
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
