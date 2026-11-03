package com.ayjs.mxzg.message.module.stagematch.dto;

import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import lombok.Getter;
import lombok.Setter;

/**
 * 排行信息
 */
@Setter
@Getter
public class RankDto implements Comparable<RankDto>{

    private long rid;

    private int serverId;

    private String name;

    private int headId;

    private int borderId;

    private int imageId;

    private int rank;

    private int stageId;

    private int eliteIntegral;

    private int updateTime;

    private int fighting;

    private int level;

    private int likes;

    public static RankDto createOf(int rank, long rid, int eliteIntegral, int stageId, int headId, int borderId, int imageId, String name, int fighting,
                                   int level, int serverId, int likes){
        RankDto rankDto = new RankDto();
        rankDto.setRank(rank);
        rankDto.setRid(rid);
        rankDto.setEliteIntegral(eliteIntegral);
        rankDto.setStageId(stageId);
        rankDto.setUpdateTime(DateTimeUtil.currentSecond());
        rankDto.setHeadId(headId);
        rankDto.setBorderId(borderId);
        rankDto.setImageId(imageId);
        rankDto.setName(name);
        rankDto.setFighting(fighting);
        rankDto.setLevel(level);
        rankDto.setServerId(serverId);
        rankDto.setLikes(likes);
        return rankDto;
    }

    /**
     * 创建一个巅峰赛排名对象
     * @param rank
     * @param rid
     * @param stageId
     * @param headId
     * @param borderId
     * @param imageId
     * @param name
     * @param fighting
     * @param level
     * @param serverId
     * @param likes
     * @return
     */
    public static RankDto createOf(int rank, long rid, int stageId, int headId, int borderId, int imageId, String name, int fighting, int level, int serverId, int likes){
        return createOf(rank, rid, 0, stageId, headId, borderId, imageId, name, fighting, level, serverId, likes);
    }

    /**
     * 更新数据
     * @param stageId
     * @param eliteIntegral
     * @param updateTime
     */
    public void update(int stageId, int eliteIntegral, int updateTime){
        this.stageId = stageId;
        this.eliteIntegral = eliteIntegral;
        this.updateTime = updateTime;
    }

    /**
     * 排名是否能大于最低
     * @param stageId
     * @param eliteIntegral
     * @return
     */
    public boolean rankGreaterThan(int stageId, int eliteIntegral){
        return compare(stageId, eliteIntegral, TimeDateUtil.getCurrentTimeInt()) > 0 ? true : false;
    }

    /**
     *
     * @param stageId
     * @param eliteIntegral
     * @param updateTime
     * @return
     */
    public int compare(int stageId, int eliteIntegral, int updateTime){
        if(this.stageId > stageId){
            return -1;
        } else if(this.stageId < stageId){
            return 1;
        }

        if(this.eliteIntegral > eliteIntegral){
            return -1;
        } else if(this.eliteIntegral < eliteIntegral){
            return 1;
        }

        return Integer.compare(this.updateTime, updateTime);
    }


    @Override
    public int compareTo(RankDto o) {
        return compare(o.getStageId(), o.getEliteIntegral(), o.getUpdateTime());
    }
}
