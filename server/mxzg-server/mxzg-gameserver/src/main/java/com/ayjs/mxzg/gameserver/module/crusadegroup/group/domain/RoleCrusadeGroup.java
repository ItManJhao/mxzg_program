/**
 *
 */
package com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain;

import com.ayjs.mxzg.common.base.SpringProxy;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.config.excel.constant.CrusadeGroupConst;
import com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.event.CityOpenEvent;
import com.ayjs.mxzg.message.module.crusadegroup.group.dto.Territory;
import com.ayjs.mxzg.protocol.CrusadeGroupGMsg;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;


@Entity
@Table(name = "role_crusade_group", comment = "个人讨伐团信息")
@Getter
@Setter
public class RoleCrusadeGroup extends AbstractEntity {

    @Id
    @Column(name = "rid", readOnly = true)
    private long rid;

    @Column(name = "open_push", comment = "活动开启后是否推送过")
    private boolean openPush;

    @Column(name = "registration", comment = "是否报名")
    private boolean registration;

    @Column(name = "knighthood_id", comment = "爵位id")
    private int knighthoodId;

    @Column(name = "force_nature", comment = "自然之力（神兵精华）")
    private long forceNature;

    @Column(name = "force_nature_total", comment = "自然之力（累计获取的神兵精华）")
    private long forceNatureTotal;

    @Column(name = "productivity", comment = "生产效率")
    private int productivity;

    @Column(name = "marks", comment = "标记的领地列表")
    private Map<Integer, String> marks = new HashMap<>();

    @Column(name = "heroes", comment = "上阵的英雄列表")
    private Map<Integer, CrusadeGroupHero> heroes = new HashMap<>();

    @Column(name = "last_occupation_id", comment = "最后占领的id，该领地作为玩家视野中心点")
    private int lastOccupationId;

    @Column(name = "territory_info", comment = "领地信息列表")
    private Map<Integer, Territory> territoryInfo = new HashMap<>();

    @Column(name = "last_settlement_time", comment = "最后结算时间，玩家主动收取的时间")
    private LocalDateTime lastSettlementTime = LocalDateTime.now();

    @Column(name = "recovery_physical_time", comment = "恢复体力时间")
    private LocalDateTime recoveryPhysicalTime = LocalDateTime.now();

    @Column(name = "shenBinMap", comment = "玩家获得的神兵")
    private Map<Integer, Long> shenBinMap = new HashMap<>();//key:item_type  value:数量

    @Column(name = "max_fighting", comment = "玩家最大战力")
    private int maxFighting;

    @Column(name = "boss_hurt", comment = "终极boss伤害总数")
    private long bossHurt;

    /**
     * 设置出生点
     * @param territory
     */
    public void initialize(Territory territory){
        occupationTerritory(territory);
        LocalDateTime now = LocalDateTime.now();
        this.knighthoodId = CrusadeGroupConst.CRUSADE_GROUP_INIT_KNIGHTHOOD_ID;
        this.lastSettlementTime = now;
        this.recoveryPhysicalTime = now;;
    }

    /**
     * 占领领地
     * @param territory
     */
    public void occupationTerritory(Territory territory){
        this.lastOccupationId = territory.getId();
        this.territoryInfo.put(territory.getId(), territory);
    }

    /**
     * 添加英雄
     * @param hero
     */
    public void addHero(CrusadeGroupHero hero) {
        this.heroes.put(hero.getId(), hero);
    }

    /**
     * 验证英雄id
     * @param heroId
     */
    public boolean verificationHeroId(long heroId){
        return this.heroes.values().stream().noneMatch(hero-> hero.getHeroId() == heroId);
    }


    public List<CrusadeGroupHero> getHeroesBy(List<CrusadeGroupGMsg.PSHero> heroes){
        return null;
    }

    /**
     * 检测指定的英雄列表是否满足需要的体力值
     * @param needPhysicalStrength
     * @param heroIds
     * @return
     */
    public boolean checkPhysicalStrength(int needPhysicalStrength, List<Long> heroIds){
        List<CrusadeGroupHero> heroes = this.heroes.values().stream().filter(crusadeGroupHero -> heroIds.contains(crusadeGroupHero.getHeroId())).collect(Collectors.toList());
        return heroes.stream().allMatch(crusadeGroupHero -> crusadeGroupHero.getPhysicalStrength() >= needPhysicalStrength);
    }

    /**
     * 修改最大战力
     * @param fighting
     * @return 是否有更新
     */
    public boolean updateMaxFighting(int fighting){
        if(this.maxFighting < fighting){
            this.maxFighting = fighting;
            return true;
        }
        return false;
    }

    /**
     * 获取评价
     * @param npcFighting
     * @return
     */
    public EvaluationType getEvaluation(int npcFighting){
        if(this.maxFighting == 0 || npcFighting == 0){
            return EvaluationType.EVENLY_MATCHED;
        }
        //这里用万分比来计算
        int fightRatio = (int) (this.maxFighting * 10000L / npcFighting);

        Optional<EvaluationType> type = Stream.of(EvaluationType.values()).filter(evaluationType -> evaluationType.check(fightRatio)).findFirst();
        return type.get();
    }

    /**
     * 添加标记的领地id
     * @param markId
     * @param name
     */
    public void mark(int markId, String name){
        this.marks.put(markId, name);
    }

    /**
     * 取消标记的领地id
     * @param markId
     */
    public void unMark(int markId){
        this.marks.remove(markId);
    }

    /**
     * 取消英雄上阵
     *
     * @param heroId
     * @param clean 是否清除体力
     */
    public void cancelHero(long heroId, boolean clean) {
        Optional<CrusadeGroupHero> heroBox = this.heroes.values().stream().filter(crusadeGroupHero -> crusadeGroupHero.getHeroId() == heroId).findFirst();
        if (heroBox.isPresent()) {
            cancelHero(heroBox.get().getId(), clean);
        }
    }

    /**
     * 取消英雄上阵
     * @param boxId
     * @param clean
     * @return 是否取消成功
     */
    public boolean cancelHero(int boxId, boolean clean) {
        CrusadeGroupHero hero = this.heroes.get(boxId);
        if(hero == null || hero.getHeroId() == 0){
            return false;
        }

        for (Territory territory : this.territoryInfo.values()) {
            if(territory.getHeroId() == hero.getHeroId()){
                territory.cancelDevelopment();
                EventBus eventBus = SpringProxy.getBean(EventBus.class);
                eventBus.post(CityOpenEvent.of(rid, 1,1));
            }
        }
        hero.clean(clean);
        return true;
    }

    /**
     * 根据boxId获取英雄
     * @param boxId
     * @return
     */
    public CrusadeGroupHero getHero(int boxId){
        return this.heroes.get(boxId);
    }

    /**
     * 获取领地
     * @param territoryId
     * @return
     */
    public Territory getTerritory(int territoryId){
        return this.territoryInfo.get(territoryId);
    }

    /**
     * 开发领地，并返回开发结果
     * @param territoryId
     * @param heroId
     * @return
     */
    public boolean developmentTerritory(int territoryId, long heroId){
        Territory territory = this.territoryInfo.get(territoryId);
        if(territory == null){
            return false;
        }

        cancelDevelopment(territoryId);

        Optional<CrusadeGroupHero> heroBox = getHeroBy(heroId);
        if(!heroBox.isPresent()){
           return false;
        }

        CrusadeGroupHero hero = heroBox.get();
        if(hero.getDevelopmentTerritoryId() != 0){
            Territory development = this.territoryInfo.get(hero.getDevelopmentTerritoryId());
            if (development != null) {
                development.cancelDevelopment();
            }
        }

        EventBus eventBus = SpringProxy.getBean(EventBus.class);
        eventBus.post(CityOpenEvent.of(rid, 1, 1));

        territory.setHeroId(heroId);
        hero.setDevelopmentTerritoryId(territoryId);
        return true;
    }

    /**
     * 取消开发
     * @param territoryId
     */
    public void cancelDevelopment(int territoryId){
        Territory territory = this.territoryInfo.get(territoryId);
        if(territory == null || territory.getHeroId() == 0){
            return;
        }

        Optional<CrusadeGroupHero> hero = getHeroBy(territory.getHeroId());
        if (hero.isPresent()) {
            hero.get().giveUpDevelopment();
        }

        territory.cancelDevelopment();
    }

    /**
     * 获取领地的开发英雄
     *
     * @param heroId
     */
    public Optional<CrusadeGroupHero> getHeroBy(long heroId) {
        return this.heroes.values().stream().filter(crusadeGroupHero -> crusadeGroupHero.getHeroId() == heroId).findFirst();
    }

    /**
     * 放弃领地
     * @param territoryId
     */
    public void giveUpTerritory(int territoryId){
        cancelDevelopment(territoryId);
        this.territoryInfo.remove(territoryId);
    }

    /**
     * 消耗指定英雄列表的体力
     * @param costEnergy
     * @param heroIds
     */
    public void costEnergy(int costEnergy, List<Long> heroIds){
        List<CrusadeGroupHero> heroes = this.heroes.values().stream().filter(crusadeGroupHero -> heroIds.contains(crusadeGroupHero.getHeroId())).collect(Collectors.toList());
        for (CrusadeGroupHero hero : heroes) {
            hero.costEnergy(costEnergy);
        }
    }

    /**
     * 增加恢复时间
     * @param second
     */
    public void addRecoveryPhysicalTime(long second){
        this.recoveryPhysicalTime = this.recoveryPhysicalTime.plusSeconds(second);
    }

    /**
     * 更新累计神兵精华（用于未上榜显示）
     *
     * @param updateNum
     */
    public void updateForceNatureTotal(long updateNum){
        this.forceNatureTotal +=updateNum;
    }

    /**
     * 更新累计终极boss伤害（用于未上榜显示）
     *
     * @param updateNum
     */
    public void updateBossHurt(long updateNum){
        this.bossHurt +=updateNum;
    }

    /**
     * 获取领地数量
     *
     * @return
     */
    public int getTerritoryNum() {
        return this.territoryInfo.size();
    }
}
