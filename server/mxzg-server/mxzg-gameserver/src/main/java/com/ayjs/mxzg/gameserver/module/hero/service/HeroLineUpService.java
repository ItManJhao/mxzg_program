/**
 *
 */
package com.ayjs.mxzg.gameserver.module.hero.service;

import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.base.IRegister;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.exception.ErrorCodeException;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.BattleFormationSysCache;
import com.ayjs.mxzg.config.excel.cache.BattleMatrixAdditionSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.entity.CBattleFormation;
import com.ayjs.mxzg.config.excel.entity.CBattleMatrixAddition;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.module.battle.domain.Formation;
import com.ayjs.mxzg.gameserver.module.battle.service.FormationService;
import com.ayjs.mxzg.gameserver.module.fetter.domain.FetterGoddess2;
import com.ayjs.mxzg.gameserver.module.fetter.domain.FetterTaskReward;
import com.ayjs.mxzg.gameserver.module.fetter.service.FetterService;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHerosCommand;
import com.ayjs.mxzg.gameserver.module.hero.dao.HeroLineUpDao;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.event.AllHeroFightChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroFightChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.LineUpChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.RoleFightChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroPosition;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroSnapshot;
import com.ayjs.mxzg.gameserver.module.hero.struct.LineUpPredicate;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.event.MaxFightingEvent;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.message.module.role.message.HeroBriefData;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.protocol.BattleGMsg.PSLineUpData;
import com.ayjs.mxzg.protocol.BattleGMsg.PSLineUpHeroData;
import com.ayjs.mxzg.template.constant.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;


/**
 * @author YY
 *
 */
@Slf4j
@Observer
@Service
public class HeroLineUpService implements IRegister<LineUpPredicate> {

    @Autowired
    private HeroLineUpDao heroLineUpDao;
    @Autowired
    private HeroService heroService;
    @Autowired
    private FetterService fetterService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private BattleFormationSysCache battleFormationSysCache;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private FormationService formationService;
    @Autowired
    private BattleMatrixAdditionSysCache battleMatrixAdditionSysCache;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;

    private static Map<LineUpType, LineUpPredicate> predicateMap = new HashMap<>();

    @Override
    public void registerBean(LineUpPredicate bean) {
        if (predicateMap.containsKey(bean.lineUpType())) {
            throw new RuntimeException("阵型预判处理" + bean.lineUpType() + "重复注册");
        }
        predicateMap.put(bean.lineUpType(), bean);
    }

    public List<HeroLineUp> getHeroLineUps(long rid) {
        List<HeroLineUp> heroLineUps = heroLineUpDao.list("rid", rid);
        List<HeroLineUp> updateList = new ArrayList<>();
        for (HeroLineUp heroLineUp : heroLineUps) {
            if (fixLineUp(heroLineUp)) {
                updateList.add(heroLineUp);
            }
        }
        if (!updateList.isEmpty()) {
            heroLineUpDao.update(updateList);
        }
        return heroLineUps;
    }

    private boolean fixLineUp(HeroLineUp heroLineUp) {
        if (heroLineUp.getFormationId() != 0) {
            return false;
        }
        heroLineUp.setFormationId(1);
        //不修复挂机阵容
        if (heroLineUp.getType() == LineUpType.LANG_UP.getValue()) {
            return true;
        }
        Map<Integer, CBattleMatrixAddition> matrixMap = battleMatrixAdditionSysCache.getMatrix(1);
        int index = 0;
        List<HeroPosition> heroList = new ArrayList<>(heroLineUp.getFormationMap().values());
        for (CBattleMatrixAddition matrixAddtion : matrixMap.values()) {
            if (matrixAddtion.getIs_open() == 0) {
                continue;
            }
            if (index >= heroList.size()) {
                break;
            }
            HeroPosition heroPos = heroList.get(index);
            heroPos.setPos(matrixAddtion.getPosition());
            index++;
        }
        return true;
    }

    /**
     * 英雄是否在阵上
     * @param rid
     * @param heroId
     * @return true在阵上
     */
    public boolean isHeroLineUp(long rid, long heroId) {
        List<HeroLineUp> lineUpList = getHeroLineUps(rid);
        for (HeroLineUp lineUp : lineUpList) {
            if (lineUp.getFormationMap().containsKey(heroId)) {
                return true;
            }
        }
        return false;
    }


    public boolean isHeroLockInLineUp(long rid, long heroId) {
        List<HeroLineUp> lineUpList = getHeroLineUps(rid);
        for (HeroLineUp lineUp : lineUpList) {
            CBattleFormation cBattleFormation = battleFormationSysCache.getOrThrow(lineUp.getType());
            if (cBattleFormation.getLock_hero() == 1 && lineUp.getFormationMap().containsKey(heroId)) {
                return true;
            }
        }
        return false;
    }

    public boolean isHeroDeletes(long rid, List<Long> heroIds) {
        List<HeroLineUp> lineUpList = getHeroLineUps(rid);
        for (HeroLineUp heroLineUp : lineUpList) {
            CBattleFormation cBattleFormation = battleFormationSysCache.getOrThrow(heroLineUp.getType());
            if (cBattleFormation.getDel_hero() == 1) {
                List<Long> heroList = new ArrayList<>(heroLineUp.getFormationMap().keySet());
                heroList.removeAll(heroIds);
                if (heroLineUp.getFormationMap().keySet().size() != 0 && heroList.isEmpty()) {
                    return true;
                }
            }
        }
        return false;
    }

    public int getHeroLockInLineUp(long rid, long heroId) {
        List<HeroLineUp> lineUpList = getHeroLineUps(rid);
        for (HeroLineUp lineUp : lineUpList) {
            CBattleFormation cBattleFormation = battleFormationSysCache.getOrThrow(lineUp.getType());
            if (cBattleFormation.getLock_hero() == 1 && lineUp.getFormationMap().containsKey(heroId)) {
                return lineUp.getType();
            }
        }
        return -1;
    }

    /**
     * 玩家英雄是否在某个阵型上
     * @param rid
     * @param heroId
     * @param lineUpType
     * @return
     */
    public boolean isHeroInLineUp(long rid, long heroId, LineUpType lineUpType) {
        HeroLineUp heroLineUp = this.getLineUpByType(rid, lineUpType);
        return heroLineUp.getFormationMap().containsKey(heroId);
    }

    /**
     * 获取某个类型的布阵信息
     * @param rid
     * @param lineUpType
     * @return
     */
    public HeroLineUp getLineUpOr(long rid, LineUpType lineUpType, LineUpType orUpType) {
        HeroLineUp heroLineUp = getLineUpByType(rid, lineUpType);
        if (heroLineUp.getFormationMap().isEmpty()) {
            return getLineUpByType(rid, orUpType);
        }
        return heroLineUp;
    }

    /**
     * 获取某个类型的布阵信息
     * @param rid
     * @param lineUpType
     * @return
     */
    public HeroLineUp getLineUpByType(long rid, LineUpType lineUpType) {
        List<HeroLineUp> lineUpList = getHeroLineUps(rid);
        HeroLineUp heroLineUp = null;
        for (HeroLineUp lineUp : lineUpList) {
            if (lineUp.getType() == lineUpType.getValue()) {
                heroLineUp = lineUp;
            }
        }
        if (heroLineUp == null) {
            heroLineUp = new HeroLineUp();
            heroLineUp.setRid(rid);
            heroLineUp.setType(lineUpType.getValue());
            heroLineUp.setFormationMap(new HashMap<>());
            heroLineUp.setFormationId(1);
            heroLineUpDao.add(heroLineUp);
        }
        return heroLineUp;
    }

    /**
     * 获取玩家主线阵营简要信息
     */
    public List<HeroBriefData> getMainHeroBrief(long rid) {
        List<HeroBriefData> list = new ArrayList<>();
        HeroLineUp mainHeroLineUp = getLineUpByType(rid, LineUpType.MAIN);
        for (HeroPosition heroPosition : mainHeroLineUp.getFormationMap().values()) {
            Hero hero = heroService.getHero(rid, heroPosition.getHeroId());
            if (Objects.nonNull(hero)) {
                list.add(heroService.toHeroBriefData(hero, heroPosition.getPos()));
            }
        }
        return list;
    }

    public void updateHeroLineUp(HeroLineUp heroLineUp) {
        heroLineUpDao.update(heroLineUp);
    }

    public void updateHeroLineUps(List<HeroLineUp> heroLineUps) {
        heroLineUpDao.update(heroLineUps);
    }

    /**
     * 保存布阵信息
     * @param rid
     * @param lineUpData
     */
    public HeroLineUp saveLineUpFormation(long rid, PSLineUpData lineUpData) {
        Role role = roleService.getOrThrow(rid);
        int formationId = lineUpData.getFormationId();
        Map<Integer, CBattleMatrixAddition> matrixMap = battleMatrixAdditionSysCache.getMatrix(formationId);
        if (matrixMap == null) {
            throw new ErrorCodeException(ErrorCode.HERO_LINEUP_MATRIX_ERROR.getValue(), "无效的布阵类型" + formationId);
        }
        Formation heroFormation = formationService.getFormation(rid);
        Asserts.isTrue(heroFormation.isUnlock(formationId), ErrorCode.FORMATION_NOT_UNLOCK.getValue(), "阵法未解锁");

        LineUpType lineUpType = LineUpType.valueOf(lineUpData.getType());
        if (lineUpType == null) {
            throw new ErrorCodeException(ErrorCode.HERO_LINEUP_TYPE_ERROR.getValue(), "无效的阵容类型" + lineUpData.getType());
        }
        //时空冒险英雄不能阵容英雄不能上阵重复
        if (lineUpType == LineUpType.SPACE_TIME_WEAPON) {
            HeroLineUp heroLineUp = this.getLineUpByType(rid, LineUpType.SPACE_TIME_IMPETUS);
            for (PSLineUpHeroData data : lineUpData.getHeroListList()) {
                Asserts.isTrue(heroLineUp.getFormationMap().get(data.getHeroId()) == null,
                        ErrorCode.SPACE_TIME_HERO_LINEUP_REPEA.getValue(), "英雄上阵重复");
            }
        }
        if (lineUpType == LineUpType.SPACE_TIME_IMPETUS) {
            HeroLineUp heroLineUp = this.getLineUpByType(rid, LineUpType.SPACE_TIME_WEAPON);
            for (PSLineUpHeroData data : lineUpData.getHeroListList()) {
                Asserts.isTrue(heroLineUp.getFormationMap().get(data.getHeroId()) == null,
                        ErrorCode.SPACE_TIME_HERO_LINEUP_REPEA.getValue(), "英雄上阵重复");
            }
        }

        HeroLineUp heroLineUp = this.getLineUpByType(rid, lineUpType);
        if (lineUpData.getGoddessType() != 0) {
            FetterGoddess2 fetterGoddess = fetterService.load(rid);
            if (!fetterGoddess.getActiveType().contains(lineUpData.getGoddessType())) {
                throw new ErrorCodeException(ErrorCode.GODDESS_NOT_UNLOCK.getValue(), "女神未解锁");
            }
        } else {
            Asserts.isTrue(heroLineUp.getGoddessType() == 0, ErrorCode.GODDESS_CANT_UN_EQUIP.getValue(),
                    String.format("女神不能卸载{%s},原先：{%s}", heroLineUp.getGoddessType(), lineUpData.getGoddessType()));
        }

        LineUpPredicate lineUpPredicate = predicateMap.get(lineUpType);
        if (lineUpPredicate == null) {
            lineUpPredicate = predicateMap.get(LineUpType.MAIN);
        }

        CBattleFormation cbattleFormation = battleFormationSysCache.getOrThrow(lineUpType.getValue());

        Map<Long, HeroPosition> heroPos = new HashMap<>();
        Set<Integer> position = new HashSet<>();

        Set<Integer> heroTypes = new HashSet<>();
        for (PSLineUpHeroData data : lineUpData.getHeroListList()) {
            if (data.getHeroId() == 0) {
                continue;
            }

            CBattleMatrixAddition config = matrixMap.get(data.getPosition());

            if (config == null) {
                throw new ErrorCodeException(ErrorCode.HERO_LINEUP_MATRIX_UNUSE.getValue(), "该布阵类型不支持该站位：" + data.getPosition());
            }

            if (config.getIs_open() == 0) {
                continue;
            }

            if (position.contains(data.getPosition())) {
                throw new ErrorCodeException(ErrorCode.HERO_LINEUP_POS_REPEA.getValue(), "上阵位置重复:" + data.getPosition());
            }

            if (data.getPosition() == 9 && !role.isAssistanceUnlock()) {
                continue;
            }

            HeroSnapshot hero = lineUpPredicate.pickHero(rid, data.getHeroId());
            if (hero == null) {
                heroPos.remove(data.getHeroId());
                log.error("saveLineUpFormation 没有找到该英雄rid:{} hero_id:{}", rid, data.getHeroId());
                continue;
//                throw new ErrorCodeException(ErrorCode.HERO_NOT_EXIST.getValue(), "没有找到该英雄:" + data.getHeroId());
            }
            //重复的英雄上阵数据跳过
            if (heroTypes.contains(hero.getType())) {
                continue;
            }
            heroTypes.add(hero.getType());
            if (heroPos.containsKey(hero.getId())) {
                throw new ErrorCodeException(ErrorCode.HERO_LINEUP_REPEA.getValue(), "英雄重复上阵:" + hero.getId());
            }
            if (hero.getLevel() < cbattleFormation.getHero_need_level()) {
                throw new ErrorCodeException(ErrorCode.HERO_LINEUP_NOT_MATCH.getValue(), "英雄不符合上阵要求:" + hero.getLevel());
            }


            HeroPosition heroPosition = new HeroPosition();
            heroPosition.setHeroId(hero.getId());
            heroPosition.setPos(data.getPosition());
            heroPosition.setHeroType(hero.getType());
            if (hero.getRid() != 0 && hero.getRid() != rid) {
                heroPosition.setOwnerId(hero.getRid());
            }
            heroPos.put(heroPosition.getHeroId(), heroPosition);
            position.add(data.getPosition());
        }
        if (heroPos.isEmpty()) {
            throw new ErrorCodeException(ErrorCode.HERO_LINEUP_EMPTY.getValue(), "英雄阵容为空");
        }
        //检查阵容合法
        lineUpPredicate.checkLineUp(heroPos);
        //检查阵容是否有重复英雄
        checkRepeatHeroType(rid, heroPos);

        boolean isLineUpChange = false;
        if (!heroPos.equals(heroLineUp.getFormationMap()) || heroLineUp.getGoddessType() != lineUpData.getGoddessType()
                || heroLineUp.getFormationId() != formationId) {
            isLineUpChange = true;
        }

        heroLineUp.setTime(TimeDateUtil.getCurrentTimeInt());
        heroLineUp.setGoddessType(lineUpData.getGoddessType());
        heroLineUp.getFormationMap().clear();
        heroLineUp.getFormationMap().putAll(heroPos);
        heroLineUp.setFormationId(formationId);
        this.updateHeroLineUp(heroLineUp);
        lineUpPredicate.handleAfterLineUpSaved(heroLineUp);
        if (isLineUpChange) {
            //阵容发生了变化
            eventBus.post(LineUpChangeEvent.of(heroLineUp));
        }
        return heroLineUp;
    }

    /**
     * 检测是否可以有重复英雄
     * @param rid
     * @param heroPos
     */
    private void checkRepeatHeroType(long rid, Map<Long, HeroPosition> heroPos) {
        FetterTaskReward fetterTask = fetterService.getFetterTask(rid);
        Set<Integer> heroTypes = new HashSet<>();
        //检测是否激活第一契约
        if (!fetterTask.getContracts().contains(1)) {
            //没有激活则不允许英雄重复
            for (HeroPosition data : heroPos.values()) {
                if (heroTypes.contains(data.getHeroType())) {
                    throw new ErrorCodeException(ErrorCode.HERO_LINEUP_REPEAT.getValue(), "英雄布阵不允许重复");
                }
                heroTypes.add(data.getHeroType());
            }
        } else {
            //激活则只允许一个重复
            boolean onlyOne = true;
            for (HeroPosition data : heroPos.values()) {
                if (heroTypes.contains(data.getHeroType())) {
                    if (onlyOne) {
                        onlyOne = false;
                    } else {
                        throw new ErrorCodeException(ErrorCode.HERO_LINEUP_ONE_REPEAT.getValue(), "英雄布阵只允许一个重复");
                    }
                }
                heroTypes.add(data.getHeroType());
            }
        }
    }

    @Subscribe
    private void listen(HeroFightChangeEvent event) {
        HeroLineUp heroLineUp = getLineUpByType(event.getHero().getRid(), LineUpType.MAIN);
        boolean isInMain = heroLineUp.getFormationMap().containsKey(event.getHero().getId());
        if (!isInMain) {
            return;
        }
        updateRoleFighting(event.getHero().getRid(), event.getGameEvent());
    }

    @Subscribe
    private void listen(AllHeroFightChangeEvent event) {
        HeroLineUp heroLineUp = getLineUpByType(event.getRid(), LineUpType.MAIN);
        boolean isInMain = false;
        for (Hero hero : event.getHeros()) {
            if (heroLineUp.getFormationMap().containsKey(hero.getId())) {
                isInMain = true;
                break;
            }
        }
        if (!isInMain) {
            return;
        }
        updateRoleFighting(event.getRid(), event.getGameEvent());
    }


    /**
     * 计算战力(计算战力使用主线队伍)
     * @param rid
     * @return
     */
    public void updateRoleFighting(long rid, GameEvent gameEvent) {
        Role role = roleService.getOrThrow(rid);

        //TODO 战力计算不正确。存在很大误差（比实际战力少）。
        int oriFighting = role.getFighting();
        HeroLineUp heroLineUp = getLineUpByType(rid, LineUpType.MAIN);
        int fighting = this.getLineUpFighting(heroLineUp);
        role.setFighting(fighting);
        if (role.getMaxFighting() < fighting) {
            int oldMaxFighting = role.getMaxFighting();
            role.setMaxFighting(fighting);
            eventBus.post(MaxFightingEvent.of(rid, role.getMaxFighting(), oldMaxFighting));//抛出最高战力变动事件
        }
        roleService.updateRole(role);
        if (oriFighting != fighting) {
            eventBus.post(RoleFightChangeEvent.of(rid, gameEvent, oriFighting, role.getFighting()));
        }
    }

    /**
     * 获取阵型战力
     * @param heroLineUp
     * @return
     */
    public int getLineUpFighting(HeroLineUp heroLineUp) {
        List<Hero> heroList = new ArrayList<>();
        for (Long heroId : heroLineUp.getFormationMap().keySet()) {
            Hero hero = heroService.getHero(heroLineUp.getRid(), heroId);
            if (hero != null) {
                heroList.add(hero);
            }
        }
        int fighting = 0;
        QueryHerosCommand command = QueryHerosCommand.createOf(heroList);
        commandBus.invoke(command);
        for (HeroDo heroDo : command.getHeroDos()) {
            heroDo.initAttribute();
            fighting += battleTemplate.computeStrength(heroDo);
        }
        return fighting;
    }

    /**
     * 清理英雄所在的布阵信息
     * @param rid
     * @param heroList
     */
    public void clearHeroLineUp(long rid, List<Hero> heroList) {
        List<HeroLineUp> lineUpList = this.getHeroLineUps(rid);
        Set<HeroLineUp> updateSet = new HashSet<>();
        for (HeroLineUp heroLineUp : lineUpList) {
            for (Hero hero : heroList) {
                if (heroLineUp.getFormationMap().containsKey(hero.getId())) {
                    heroLineUp.getFormationMap().remove(hero.getId());
                    updateSet.add(heroLineUp);
                }
            }
        }
        if (!updateSet.isEmpty()) {
            this.updateHeroLineUps(new ArrayList<>(updateSet));
        }
    }

    @Subscribe
    private void listen(LoginEvent event) {
        HeroLineUp heroLineUp = getLineUpByType(event.getRid(), LineUpType.MAIN);
        for (long heroId : heroLineUp.getFormationMap().keySet()) {
            Hero hero = heroService.getHero(event.getRid(), heroId);
            heroService.computeStrength(hero, GameEvent.HERO_ON_LOGIN);
        }
    }

    /**
     * 根据布阵类型和职业获取布阵英雄
     *
     * @param rid
     * @param job
     */
    public List<Long> getHeroLineUp_typeAndJob(long rid, int job, LineUpType lineUpType) {
        List<HeroLineUp> lineUpList = this.getHeroLineUps(rid);
        List<Long> heroIds = new ArrayList<>();
        for (HeroLineUp heroLineUp : lineUpList) {
            if (heroLineUp.getType() != lineUpType.getValue()) {
                continue;
            }
            for (long heroId : heroLineUp.getFormationMap().keySet()) {
                Hero hero = heroService.getHero(rid, heroId);
                CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getType());
                if (cHeroType.getOccupation() != job) {
                    continue;
                }
                heroIds.add(heroId);
            }
        }
        return heroIds;
    }
}
