package com.ayjs.mxzg.largecross.module.stagematch.battle.manager;

import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.config.excel.cache.SuperStageSysCache;
import com.ayjs.mxzg.config.excel.constant.PreliminariesConst;
import com.ayjs.mxzg.config.excel.constant.StageMatchConst;
import com.ayjs.mxzg.config.excel.entity.CSuperStage;
import com.ayjs.mxzg.largecross.module.stagematch.battle.constant.StageMatchConstant;
import com.ayjs.mxzg.largecross.module.stagematch.battle.dao.OpponentDao;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.Opponent;
import com.ayjs.mxzg.largecross.module.stagematch.preliminaries.domain.PreliminariesLadder;
import com.ayjs.mxzg.message.module.stagematch.dto.RankDto;
import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Multimap;

import java.util.*;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.ConcurrentNavigableMap;
import java.util.concurrent.ConcurrentSkipListMap;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

/**
 * 对手分组
 */
public class OpponentGroup {

    /** 分组id */
    private int groupId;
    /** 对手id, 段位id */
    private ConcurrentMap<Long, Integer> opponentStageMap = new ConcurrentHashMap<>();
    /** 段位id, 对手列表 */
    private Multimap<Integer, Long> stageOpponentMap = ArrayListMultimap.create();
    /** 角色id, 排行信息*/
    private ConcurrentMap<Long, RankDto> opponentRankInfo = new ConcurrentHashMap<>();
    /** 排名, 排行信息*/
    private ConcurrentMap<Integer, RankDto> rankInfos = new ConcurrentHashMap<>();
    /** 战力信息 */
    private ConcurrentNavigableMap<Integer,Long> fightMap = new ConcurrentSkipListMap<>();
    /** 角色战斗力映射 */
    private ConcurrentMap<Long, Integer> roleFightingMap = new ConcurrentHashMap<>();
    /** 巅峰赛排行榜 */
    private ConcurrentMap<Integer, RankDto> pinnacleRanking = new ConcurrentHashMap<>();

    /** 最小排名段位 */
    private RankDto minRankOpponent;

    private OpponentDao opponentDao;
    private SuperStageSysCache superStageSysCache;

    public int getGroupId(){
        return this.groupId;
    }

    public static OpponentGroup createOf(int groupId, OpponentDao opponentDao, SuperStageSysCache superStageSysCache){
        OpponentGroup group = new OpponentGroup();
        group.groupId = groupId;
        group.opponentDao = opponentDao;
        group.superStageSysCache = superStageSysCache;
        return group;
    }

    /**
     * 添加对手
     * @param opponent
     */
    public void addOpponent(Opponent opponent){
        Integer stageId = opponentStageMap.put(opponent.getRid(), opponent.getStageId());
        if(stageId == null){
            if(!stageOpponentMap.containsEntry(opponent.getStageId(), opponent.getRid())){
                stageOpponentMap.put(opponent.getStageId(), opponent.getRid());
            }
        }

        if(opponent.getRank() > 0){
            RankDto rankDto = RankDto.createOf(opponent.getRank(), opponent.getRid(), opponent.getEliteIntegral(), opponent.getStageId(), opponent.getHeadId(),
                    opponent.getBorderId(), opponent.getImage_id(), opponent.getName(), opponent.getFighting(), opponent.getLevel(), opponent.getServerId(), 0);
            opponentRankInfo.put(opponent.getRid(), rankDto);
            RankDto existRankDto = rankInfos.put(opponent.getRank(), rankDto);
            if(existRankDto != null && opponent.getRid() != existRankDto.getRid()){
                updateRank(opponent);
            }
        }

        fightMap.put(opponent.getFighting(), opponent.getRid());
        Integer fighting = roleFightingMap.put(opponent.getRid(), opponent.getFighting());
        if(fighting != null){
            fightMap.remove(fighting, opponent.getRid());
        }
    }


    /**
     * 添加巅峰赛排行榜
     * @param ladders
     */
    public void addPinnacleRanking(List<RankDto> ladders){
        this.pinnacleRanking.clear();
        for (int i = 0; i < ladders.size(); i++) {
            RankDto rankDto = ladders.get(i);
            this.pinnacleRanking.put(rankDto.getRank(), rankDto);
        }
    }

    /**
     * 添加天梯对象
     * @param rankDto
     */
    public void addLadder(RankDto rankDto){
        this.pinnacleRanking.put(rankDto.getRank(), rankDto);
    }

    /**
     * 根据巅峰赛排名获取列表
     * @param ranks
     * @return
     */
    public List<RankDto> getPinnacleRankBy(List<Integer> ranks){
        return ranks.stream().map(this.pinnacleRanking::get).collect(Collectors.toList());
    }

    /**
     * 根据排名获取排名信息
     * @param rank
     * @return
     */
    public RankDto getPinnacleRankBy(int rank){
        if(rank <= 0){
            return null;
        }
        return this.pinnacleRanking.get(rank);
    }

    /**
     * 重置
     */
    public void reset(){
        this.opponentStageMap.clear();
        this.stageOpponentMap.clear();
        this.opponentRankInfo.clear();
        this.roleFightingMap.clear();
        this.fightMap.clear();
        this.rankInfos.clear();
        this.pinnacleRanking.clear();
        this.minRankOpponent = null;
    }


    /**
     * 更新对手信息
     * @param challenger
     * @param stageChange
     * @return
     */
    public List<Opponent> updateOpponent(Opponent challenger, boolean stageChange){
        List<Opponent> opponents = updateRank(challenger);
        if(stageChange){
            updateStageCache(challenger);
        }
        return opponents;
    }

    /**
     * 遍历查找一个对手
     * @param challenger
     * @return
     */
    public Long pickOpponent(Opponent challenger){
        int stageId = challenger.getStageId();
        CSuperStage cSuperStage = superStageSysCache.getById(stageId);
        if(cSuperStage.getInitial_fighting_ratio() == 0){
            return pickOpponentByStage(challenger.getRid(), stageId);
        } else {
            Long opponentId = pickOpponentByFighting(challenger);
            if(opponentId == null){
                return pickOpponentByStage(challenger.getRid(), stageId);
            }
            return opponentId;
        }
    }

    /**
     * 遍历查找一个对手
     * @param challengerId
     * @param stageId
     * @return
     */
    public Long pickOpponentByStage(long challengerId, int stageId){
        boolean upperLimit = false;
        boolean lowerLimit = false;
        Long opponent = randomOpponent(stageId, challengerId);
        if(opponent != null){
            return opponent;
        }

        for(int i = 1; i < StageMatchConstant.MAX_STAGE_ID; i++){
            if(!upperLimit){
                int matchingId = stageId + i;
                CSuperStage cSuperStage = superStageSysCache.getById(matchingId);
                if(cSuperStage == null){
                    upperLimit = true;
                } else {
                    opponent = randomOpponent(matchingId, challengerId);
                }
            }

            if(!lowerLimit && opponent == null){
                int matchingId = stageId - i;
                CSuperStage cSuperStage = superStageSysCache.getById(matchingId);
                if(cSuperStage == null){
                    lowerLimit = true;
                } else {
                    opponent = randomOpponent(matchingId, challengerId);
                }
            }
            if(opponent != null || (upperLimit && lowerLimit)){
                break;
            }
        }
        return opponent;
    }

    /**
     * 根据段位随机对手，排除随机到自己
     * @param stageId
     * @param challengerId
     * @return
     */
    public Long randomOpponent(int stageId, long challengerId){
        boolean presence = stageOpponentMap.remove(stageId, challengerId);
        List<Long> opponents = (List<Long>)this.stageOpponentMap.get(stageId);
        try {
            if (opponents.isEmpty()) {
                return null;
            }
            if (opponents.size() == 1) {
                return opponents.get(0);
            }
            int index = RandomUtil.getRandomInt(0, opponents.size() - 1);
            return opponents.get(index);
        } finally {
            if(presence){
                stageOpponentMap.put(stageId, challengerId);
            }
        }
    }

    /**
     * 根据战力查找对手
     * @param challenger
     * @return
     */
    public Long pickOpponentByFighting(Opponent challenger){
        try {
            CSuperStage cSuperStage = superStageSysCache.getById(challenger.getStageId());
            for (int startRatio = cSuperStage.getInitial_fighting_ratio(); startRatio > 0; ) {
                int fighting = challenger.getFighting() < challenger.getMaxFighting() ? challenger.getMaxFighting() : challenger.getFighting();
                Long opponentId = getOpponentByFighting(fighting, challenger.getStageId(), startRatio);
                if (opponentId != null && opponentId != challenger.getRid()) {
                    return opponentId;
                }
                startRatio -= cSuperStage.getFighting_range_ratio();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }

    /**
     * 根据战力匹配段位
     * @param fighting 战力
     * @param stageId 当前段位
     * @param startRatio    开始的战力比例
     * @return
     */
    private Long getOpponentByFighting(int fighting, int stageId, int startRatio){
        CSuperStage cSuperStage = superStageSysCache.getById(stageId);
        int toFighting = fighting * startRatio / StageMatchConstant.PERCENTAGE;
        int fromRatio = startRatio - cSuperStage.getFighting_range_ratio();
        int fromFighting = fighting * fromRatio / StageMatchConstant.PERCENTAGE;
        ConcurrentNavigableMap<Integer, Long> fightRangeMap =  fightMap.subMap(fromFighting, toFighting);
        fightRangeMap.remove(fighting);

        List<Integer> removeList = new ArrayList<>();
        for (Entry<Integer, Long> opponentEntry : fightRangeMap.entrySet()) {
            Opponent opponent = opponentDao.get(opponentEntry.getValue());
            if(opponent.getStageId() > 9){
                removeList.add(opponentEntry.getKey());
            }
        }

        for (Integer fgt : removeList) {
            fightRangeMap.remove(fgt);
        }

        if(fightRangeMap.isEmpty()){
            return null;
        }

        int randomSize = Math.min(fightRangeMap.size(), StageMatchConstant.RANDOM_RANGE_SIZE);
        int randomIndex = RandomUtil.rand(0, randomSize);

        int i = 0;
        for (long opponentId : fightRangeMap.values()) {
            if(randomIndex == i){
                return  opponentId;
            }
            i++;
        }
        return null;
    }

    /**
     * 更新排名
     * @param challenger
     */
    public List<Opponent> updateRank(Opponent challenger){
        List<Opponent> rankUpdateList = new ArrayList<>();
        RankDto rankDto = this.opponentRankInfo.get(challenger.getRid());
        if(rankDto == null){
            if(challenger.getStageId() < StageMatchConst.SUPER_STAGE_RANK_MIN_STAGE){
                return Collections.emptyList();
            }
            if(minRankOpponent != null && !minRankOpponent.rankGreaterThan(challenger.getStageId(), challenger.getEliteIntegral())){
                return Collections.emptyList();
            }
            rankDto = RankDto.createOf(challenger.getRank(), challenger.getRid(), challenger.getEliteIntegral(), challenger.getStageId(), challenger.getHeadId(),
                    challenger.getBorderId(), challenger.getImage_id(), challenger.getName(), challenger.getFighting(), challenger.getLevel(), challenger.getServerId(), 0);
        } else {
            rankDto.update(challenger.getStageId(), challenger.getEliteIntegral(), challenger.getBattleTime());
        }

        this.opponentRankInfo.put(rankDto.getRid(), rankDto);

        List<RankDto> ranks = new ArrayList<>(this.opponentRankInfo.values());
        Collections.sort(ranks);

        int numberRankings = Math.min(ranks.size(), StageMatchConst.SUPER_STAGE_NUMBER_RANKINGS);
        ConcurrentMap<Long, RankDto> opponentRankInfo = new ConcurrentHashMap<>();
        ConcurrentMap<Integer, RankDto> rankInfos = new ConcurrentHashMap<>();
        for (int i = 1; i <= ranks.size(); i++) {
            RankDto rank = ranks.get(i - 1);
            Opponent opponent = opponentDao.get(rank.getRid());
            if(opponent == null){
                continue;
            }
            if(i > StageMatchConst.SUPER_STAGE_NUMBER_RANKINGS){
                opponent.setRank(0);
                opponentDao.update(opponent);
                rankUpdateList.add(opponent);
            } else {
                rank.setRank(i);
                if(opponent.updateRank(i)){
                    opponentDao.update(opponent);
                    rankUpdateList.add(opponent);
                }
                opponentRankInfo.put(rank.getRid(), rank);
                rankInfos.put(i, rank);
            }
        }

        this.rankInfos = rankInfos;
        this.opponentRankInfo = opponentRankInfo;
        if(numberRankings == StageMatchConst.SUPER_STAGE_NUMBER_RANKINGS){
            this.minRankOpponent = rankInfos.get(numberRankings);
        } else {
            this.minRankOpponent = null;
        }

        return rankUpdateList;
    }

    /**
     * 更新挑战者的段位缓存
     * @param challenger
     */
    public void updateStageCache(Opponent challenger){
        opponentStageMap.put(challenger.getRid(), challenger.getStageId());
        stageOpponentMap.remove(challenger.getLastStageId(), challenger.getRid());
        if(!stageOpponentMap.containsEntry(challenger.getStageId(), challenger.getRid())){
            stageOpponentMap.put(challenger.getStageId(), challenger.getRid());
        }
    }

    /**
     * 获取指定数量的头部排名
     * @param topNum
     * @return
     */
    public List<RankDto> getRankTop(int topNum){
        return IntStream.rangeClosed(1, topNum).filter(rankInfos::containsKey).mapToObj(rankInfos::get).filter(Objects::nonNull).collect(Collectors.toList());
    }

    /**
     * 交换排名
     * @param atkRank
     * @param defRank
     * @param opponent
     */
    public void exchangeRank(int atkRank, int defRank, Opponent opponent, PreliminariesLadder ladder) {
        RankDto rankDto = this.pinnacleRanking.get(atkRank);
        if(rankDto == null || atkRank == 0){
            rankDto = RankDto.createOf(atkRank, opponent.getRid(), opponent.getStageId(), opponent.getHeadId(), opponent.getBorderId(), opponent.getImage_id(), opponent.getName(),
                    opponent.getFighting(), opponent.getLevel(), opponent.getServerId(), ladder.getLikes());
        }
        RankDto defenderRank = this.pinnacleRanking.get(defRank);

        rankDto.setRank(defRank);
        rankDto.setStageId(opponent.getStageId());
        this.pinnacleRanking.put(rankDto.getRank(), rankDto);

        defenderRank.setRank(atkRank);
        if(defenderRank.getRank() > 0){
            this.pinnacleRanking.put(defenderRank.getRank(), defenderRank);
        }
    }

    /**
     * 获取最大排名 0是未上榜
     * @return
     */
    public int getMaxPinnacleRank(){
        return this.pinnacleRanking.size() < PreliminariesConst.PRELIMINARIES_RANKS_NUMBER ? this.pinnacleRanking.size() + 1 : 0;
    }

    /**
     * 获取排行榜
     * @return
     */
    public Map<Integer, RankDto> allRankMap(){
        return this.pinnacleRanking;
    }

    /**
     * 获取巅峰榜
     * @return
     */
    public List<RankDto> getPreliminariesRanking(int topNum){
        return IntStream.rangeClosed(1, topNum).filter(pinnacleRanking::containsKey).mapToObj(pinnacleRanking::get).filter(Objects::nonNull).collect(Collectors.toList());
    }


}
