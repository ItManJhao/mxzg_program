package com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.config.excel.constant.PreliminariesConst;
import com.ayjs.mxzg.message.module.stagematch.dto.RankDto;
import com.ayjs.mxzg.protocol.PinnacleGMsg.PSPinnacleRanker;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.google.common.collect.ImmutableList;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

/**
 * 巅峰赛等级排行
 */
@Service
@Slf4j
@Observer
public class PreliminariesRankService implements MessageHandler {

    private List<RankDto> list = new ArrayList<>(1000);

    private ConcurrentMap<Long, RankDto> roleRanking = new ConcurrentHashMap<>();

    /**
     * 替换排行榜
     * @param ranks
     */
    public void replaceRank(List<RankDto> ranks) {
        try {
            synchronized (this) {
                this.list.clear();
                this.list.addAll(ranks);
                this.roleRanking.clear();
                for (RankDto rankDto : ranks) {
                    this.roleRanking.put(rankDto.getRid(), rankDto);
                }
            }
        } catch (Exception e) {
            log.error("重载巅峰赛预赛榜异常", e);
        }
    }

    public List<RankDto> getAllList() {
        return ImmutableList.copyOf(list);
    }

    public int getRank(long rid) {
        RankDto rankDto = roleRanking.get(rid);
        return rankDto != null ? rankDto.getRank() : 0;
    }

    /**
     * 清空
     */
    public void clean(){
        this.list.clear();
        this.roleRanking.clear();
    }

    /**
     * 获取排行信息
     * @param rid
     * @return
     */
    public RankDto getRankDto(long rid){
        return roleRanking.get(rid);
    }


    /**
     * 修改排行点
     * @param rankDto
     */
    public void updateRanker(RankDto rankDto){
       synchronized (this){
           RankDto presence = this.roleRanking.put(rankDto.getRid(), rankDto);
           if(presence != null){
               this.list.remove(presence);
           }
           this.list.add(rankDto.getRank() - 1, rankDto);
       }
    }

    /**
     * 交换排名
     * @param challengerDto
     * @param opponent
     * @return 是否交换成功
     */
    public boolean exchangeRanking(RankDto challengerDto, RankDto opponent){
        synchronized (this) {
            int oldChallengerRank = getRank(challengerDto.getRid());
            int oldOpponentRank = getRank(opponent.getRid());
            if (challengerDto.getRank() == oldOpponentRank && opponent.getRank() == oldChallengerRank) {
                RankDto oldChallengerRankDto = this.roleRanking.put(challengerDto.getRid(), challengerDto);
                if(oldChallengerRankDto != null){
                    this.list.remove(oldChallengerRankDto);
                    this.list.add(challengerDto.getRank() - 1, challengerDto);
                }

                RankDto oldOpponentRankDto = this.roleRanking.put(opponent.getRid(), opponent);
                if(oldOpponentRankDto != null){
                    this.list.remove(oldOpponentRankDto);
                    if(challengerDto.getRank() > 0){
                        this.list.add(challengerDto.getRank() - 1, challengerDto);
                    }
                }
                return true;
            }
            return false;
        }
    }

    /**
     * 获取展示的排行榜
     * @return
     */
    public List<PSPinnacleRanker> getShowRank() {
        int toIndex = Math.min(PreliminariesConst.RANKS_SIZE, this.list.size());
        List<RankDto> ranks = list.subList(0, toIndex);
        List<PSPinnacleRanker> result = new ArrayList<>();
        ranks.forEach(rank -> {
            result.add(builder(rank));
        });
        return result;
    }


    public PSPinnacleRanker builder(RankDto rankData) {
        PSPinnacleRanker.Builder builder = PSPinnacleRanker.newBuilder();
        builder.setLevel(rankData.getLevel());
        if(rankData.getName() != null) {
        	builder.setName(rankData.getName());
        }
        builder.setRid(rankData.getRid());
        builder.setRank(rankData.getRank());
        builder.setFighting(rankData.getFighting());
        builder.setHeadId(rankData.getHeadId());
        builder.setBorderId(rankData.getBorderId());
        builder.setServerId(rankData.getServerId());
        builder.setLike(rankData.getLikes());
        builder.setStageId(rankData.getStageId());
        builder.setImageId(rankData.getImageId());
//      if(rankData.getClanName() != null) {
//        builder.setClanName(rankData.getClanName());
//      }
        return builder.build();
    }


}
