/**
 *
 */
package com.ayjs.mxzg.gameserver.module.rune.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.PageUtil;
import com.ayjs.mxzg.config.excel.cache.RunesCombineSysCache;
import com.ayjs.mxzg.config.excel.cache.RunesTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.RunesTypeSysCache.RuneDataTemplate;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.CRunesCombine;
import com.ayjs.mxzg.config.excel.entity.CRunesType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.role.constant.EntryType;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.rune.domain.RuneInfo;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneChangeEvent;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneCombineEvent;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneWashEvent;
import com.ayjs.mxzg.gameserver.module.rune.service.RuneInfoService;
import com.ayjs.mxzg.gameserver.module.tweakCube.service.TweakCubeService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.RuneGMsg.GReqRuneCombine;
import com.ayjs.mxzg.protocol.RuneGMsg.GReqRuneDisCombine;
import com.ayjs.mxzg.protocol.RuneGMsg.GReqRuneOnOff;
import com.ayjs.mxzg.protocol.RuneGMsg.GReqRuneWash;
import com.ayjs.mxzg.protocol.RuneGMsg.GReqRuneWashSave;
import com.ayjs.mxzg.protocol.RuneGMsg.GReqRunesList;
import com.ayjs.mxzg.protocol.RuneGMsg.GResRune;
import com.ayjs.mxzg.protocol.RuneGMsg.GResRuneCombine;
import com.ayjs.mxzg.protocol.RuneGMsg.GResRuneDisCombine;
import com.ayjs.mxzg.protocol.RuneGMsg.GResRuneOnOff;
import com.ayjs.mxzg.protocol.RuneGMsg.GResRuneWash;
import com.ayjs.mxzg.protocol.RuneGMsg.GResRuneWashSave;
import com.ayjs.mxzg.protocol.RuneGMsg.GResRunesDelList;
import com.ayjs.mxzg.protocol.RuneGMsg.GResRunesList;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * @author YY
 *
 */
@Controller
public class RuneInfoHandler extends ProtocolHandler {

    @Autowired
    private RuneInfoService runeInfoService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private TweakCubeService tweakCubeService;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private RunesTypeSysCache runesTypeSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private RunesCombineSysCache runesCombineSysCache;
    @Autowired
    private EventBus eventBus;

    /**
     * 背包中的符文
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._29001)
    public void getRuneList(PlayerContext playerContext, GReqRunesList msg) {

        List<RuneInfo> list = runeInfoService.getRunes(playerContext.getId());
        int page = msg.getPage();
        if(page <= 0) {
        	page = 1;
        }
        List<RuneInfo> pageList = PageUtil.pageN(list, page, systemSysCache.getRunePageSize());
        GResRunesList.Builder builder = GResRunesList.newBuilder();
        for (RuneInfo runeInfo : pageList) {
            builder.addList(runeInfoService.serialize(runeInfo));
        }
        builder.setPage(page);
        playerContext.write(CmdCode._29001, builder.build());
    }

    /**
     * 穿戴
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._29002)
    public void runeOnOff(PlayerContext playerContext, GReqRuneOnOff msg) {
        if (msg.getSign() != 0 && msg.getSign() != 1) {
            // 参数错误
            playerContext.writeError(ErrorCode.ERROR_PARAM, msg.getSign());
            return;
        }
        if (msg.getPlace() != 1 && msg.getPlace() != 2) {
            // 参数错误
            playerContext.writeError(ErrorCode.ERROR_PARAM, msg.getPlace());
            return;
        }
        if (msg.getRuneId() < 1) {
            // 参数错误
            playerContext.writeError(ErrorCode.ERROR_PARAM, msg.getRuneId());
            return;
        }

        Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
        if (hero == null) {
            // 未找到该英雄
            playerContext.writeError(ErrorCode.HERO_NOT_EXIST, msg.getHeroId());
            return;
        }
        if (msg.getPlace() == 1 && systemSysCache.getElf1UnlockLevel() > tweakCubeService.getTweakCubeLvAndStage(hero)[0]) {
            playerContext.writeError(ErrorCode.RUNE_LOCK);
            return;
        }
        if (msg.getPlace() == 2 && systemSysCache.getElf2UnlockStar() > hero.getStar()) {
            playerContext.writeError(ErrorCode.RUNE_LOCK);
            return;
        }

        RuneInfo rune = runeInfoService.getRune(playerContext.getId(), msg.getRuneId());
        if (rune == null) {
            // 未找到该符文
            playerContext.writeError(ErrorCode.RUNE_NOT_EXIST);
            return;
        }
        if (msg.getSign() == 0) {
            // 卸下
            if (rune.getHeroId() != 0) {
                rune.setHeroId(0);
                rune.setPlace(0);
                runeInfoService.updateRune(rune);

                // 通知背包添加刚卸下来的符文
                sendUpdateBackPackRunes(playerContext, Collections.singletonList(rune));
            }
            
            
            
        } else {
            // 穿上
            if (rune.getHeroId() != 0) {
                // 该符文已经装备在其他英雄上
                playerContext.writeError(ErrorCode.RUNE_USED);
                return;
            }
            List<RuneInfo> runeList = new ArrayList<>();
            RuneInfo oriRune = runeInfoService.getRuneOnHero(playerContext.getId(), hero.getId(), msg.getPlace());
            if (oriRune != null) {
                oriRune.setHeroId(0);
                oriRune.setPlace(0);
                runeList.add(oriRune);
            }
            rune.setHeroId(hero.getId());
            rune.setPlace(msg.getPlace());
            runeList.add(rune);
            runeInfoService.updateRunes(runeList);

            // 通知更新背包
            sendUpdateBackPackRunes(playerContext, runeList);
        }
        
        //英雄换精灵
      	eventBus.post(RuneChangeEvent.of(hero, GameEvent.RUNE_CHANGE));
        
        playerContext.write(CmdCode._29002, GResRuneOnOff.getDefaultInstance());
    }

    private void sendUpdateBackPackRunes(PlayerContext playerContext, List<RuneInfo> runeList) {
        GResRune.Builder builder = GResRune.newBuilder();
        for (RuneInfo runeInfo : runeList) {
            builder.addRuneData(runeInfoService.serialize(runeInfo));
        }
        playerContext.write(CmdCode._29011, builder.build());
    }

    /**
     * 同步客户端从背包删除符文
     */
    public static void sendDelBackPackRunes(PlayerContext playerContext, long runeId) {
        GResRunesDelList.Builder builder = GResRunesDelList.newBuilder();
        builder.addList(runeId);
        playerContext.write(CmdCode._29021, builder.build());
    }

    public static void sendDelBackPackRunes(PlayerContext playerContext, List<RuneInfo> delRuneList) {
        GResRunesDelList.Builder builder = GResRunesDelList.newBuilder();
        for (RuneInfo runeInfo : delRuneList) {
            builder.addList(runeInfo.getId());
        }
        playerContext.write(CmdCode._29021, builder.build());
    }

    /**
     * 分解
     */
    @CMD(id = CmdCode._29003)
    public void runeDisCombine(PlayerContext playerContext, GReqRuneDisCombine msg) {
        Role role = roleService.getOrThrow(playerContext.getId());

        RuneInfo runeInfo = runeInfoService.getRune(playerContext.getId(), msg.getRuneId());
        if (runeInfo == null) {
            // 没找到该符文
            playerContext.writeError(ErrorCode.RUNE_NOT_EXIST);
            return;
        }
        if (runeInfo.getHeroId() != 0) {
            // 装备着的符文不能分解
            playerContext.writeError(ErrorCode.RUNE_CANT_RESOLVE);
            return;
        }
        CRunesType cRunesType = runesTypeSysCache.getByType(runeInfo.getTypeId());
        runeInfoService.deleteRune(runeInfo, GameEvent.RUNE_RESOLVE);

        // 发放奖励
        thingService.add(role.getId(), cRunesType.getValue(), GameEvent.RUNE_RESOLVE);
        // 通知删除符文背包
        sendDelBackPackRunes(playerContext, runeInfo.getId());

        playerContext.write(CmdCode._29003, GResRuneDisCombine.getDefaultInstance());
    }

    /**
     * 合成
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._29004, entry = EntryType.MAIN_SMITH_SHOP)
    public void runeCombine(PlayerContext playerContext, GReqRuneCombine msg) {
        Role role = roleService.getOrThrow(playerContext.getId());

        Set<Long> eleRuneIds = new HashSet<>(msg.getListList());
        if (eleRuneIds.size() != msg.getListCount()) {
            playerContext.writeError(ErrorCode.ERROR_PARAM);
            //参数有误
            return;
        }
        if (eleRuneIds.contains(msg.getRuneId())) {
            //参数有误
            playerContext.writeError(ErrorCode.ERROR_PARAM);
            return;
        }
        RuneInfo mainRune = runeInfoService.getRune(playerContext.getId(), msg.getRuneId());
        if (mainRune == null) {
            // 没找到该符文
            playerContext.writeError(ErrorCode.RUNE_NOT_EXIST);
            return;
        }
        List<RuneInfo> eleRunes = new ArrayList<>();
        for (Long eleRuneId : eleRuneIds) {
            RuneInfo eleRune = runeInfoService.getRune(playerContext.getId(), eleRuneId);
            if (eleRune == null) {
                // 没有找到该符文
                playerContext.writeError(ErrorCode.RUNE_NOT_EXIST);
                return;
            }
            eleRunes.add(eleRune);
        }
        // 素材符文数量+主符文小于两个
        if (eleRunes.size() + 1 < 2) {
            //符文数量不对
            playerContext.writeError(ErrorCode.RUNE_NOT_ENOUGH);
            return;
        }

        CRunesType mainCfgType = runesTypeSysCache.getByType(mainRune.getTypeId());
        // 总共加的经验
        int totalExp = 0;
        for (RuneInfo eleRune : eleRunes) {
            if (eleRune.getHeroId() != 0) {
                //素材符文必须是没有装备的
                playerContext.writeError(ErrorCode.RUNE_NOT_IDLE);
                return;
            }
            CRunesType cfgType = runesTypeSysCache.getByType(eleRune.getTypeId());

            if (cfgType.getRare() > mainCfgType.getRare()) {
                //等级高的材料
                playerContext.writeError(ErrorCode.RUNE_NEED_LOW);
                return;
            }
            totalExp += cfgType.getPoint();
        }

        CRunesCombine combineCfg = runesCombineSysCache.getByType(mainCfgType.getType());
        int remainExp = totalExp - combineCfg.getNeed_point();
        if (remainExp < 0) {
            //所需符文经验不足
            playerContext.writeError(ErrorCode.RUNE_NEED_EXP);
            return;
        }

        RuneDataTemplate runeDataTemplate = runesTypeSysCache.randomRune(combineCfg.getCombine_target());

        ImmutableThing cost = ImmutableThing.of(ItemType.IT_GOLD, combineCfg.getCost_gold());
        thingService.cost(role.getId(), cost, GameEvent.RUNE_COMBINE);

        // 删除素材符文
        runeInfoService.deleteRunes(eleRunes, GameEvent.RUNE_COMBINE);
        // 同步扣除背包信息到客户端
        sendDelBackPackRunes(playerContext, eleRunes);

        mainRune.setTypeId(runeDataTemplate.getType_id());
        mainRune.setAbilityId(runeDataTemplate.getAbility_id());
        mainRune.getSkillMap().clear();
        mainRune.getSkillMap().putAll(runeDataTemplate.getSkillMap());
        mainRune.setExp(runeDataTemplate.getExp());
        runeInfoService.updateRune(mainRune);

        sendUpdateBackPackRunes(playerContext, Collections.singletonList(mainRune));

        Rewards rewardList = null;
        if (remainExp > 0) {
            // 溢出的能量补偿
        	ImmutableThing reward = ImmutableThing.of(systemSysCache.getElfCombineReturn(), remainExp);
            rewardList = thingService.add(role.getId(), reward, GameEvent.RUNE_COMBINE, NoticeType.SLIENT);
        }
        GResRuneCombine.Builder builder = GResRuneCombine.newBuilder();
        builder.setRuneId(mainRune.getId());
        if (rewardList != null) {
            builder.addAllList(PbUtil.buildReward(rewardList.getThingSet().asList()));
        }
        playerContext.write(CmdCode._29004, builder.build());

        eventBus.post(RuneCombineEvent.of(role.getId()));
    }

    /**
     * 重铸
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._29005)
    public void runeWash(PlayerContext playerContext, GReqRuneWash msg) {
        RuneInfo mainRune = runeInfoService.getRune(playerContext.getId(), msg.getRuneId());
        if (mainRune == null) {
            // 没找到该符文
            playerContext.writeError(ErrorCode.RUNE_NOT_EXIST);
            return;
        }
        Role role = roleService.getOrThrow(playerContext.getId());
        CRunesType cRunesType = runesTypeSysCache.getByType(mainRune.getTypeId());

        thingService.cost(role.getId(), cRunesType.getRandom_cost(), GameEvent.RUNE_WASH);
        RuneDataTemplate washRuneType = runesTypeSysCache.randomRune(mainRune.getTypeId());

        // 保存临时属性
        mainRune.setWashAbilityId(washRuneType.getAbility_id());
        mainRune.getWashSkillMap().clear();
        mainRune.getWashSkillMap().putAll(washRuneType.getSkillMap());
        runeInfoService.updateRune(mainRune);

        this.sendUpdateBackPackRunes(playerContext, Collections.singletonList(mainRune));

        GResRuneWash.Builder builder = GResRuneWash.newBuilder();
        builder.setRuneId(mainRune.getId());
        playerContext.write(CmdCode._29005, builder.build());

        eventBus.post(RuneWashEvent.of(role.getId()));
    }

    /**
     * 符文重铸保存
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._29014)
    public void runeWashSave(PlayerContext playerContext, GReqRuneWashSave msg) {
        RuneInfo mainRune = runeInfoService.getRune(playerContext.getId(), msg.getRuneId());
        if (mainRune == null) {
            // 没找到该符文
            playerContext.writeError(ErrorCode.RUNE_NOT_EXIST);
            return;
        }
        if (mainRune.getWashAbilityId() == 0) {
            // 还没有洗练符文
            playerContext.writeError(ErrorCode.RUNE_NOT_WASH);
            return;
        }
        
        mainRune.setAbilityId(mainRune.getWashAbilityId());
        mainRune.getSkillMap().clear();
        mainRune.getSkillMap().putAll(mainRune.getWashSkillMap());
        mainRune.setWashAbilityId(0);
        mainRune.getWashSkillMap().clear();
        runeInfoService.updateRune(mainRune);

        sendUpdateBackPackRunes(playerContext, Collections.singletonList(mainRune));

        if(mainRune.getHeroId() != 0) {
        	Hero hero = heroService.getHero(playerContext.getId(), mainRune.getHeroId());
        	if(hero != null) {
        		// 刷新战力
              	eventBus.post(RuneChangeEvent.of(hero, GameEvent.RUNE_CHANGE));
        	}
        }
        
        GResRuneWashSave.Builder builder = GResRuneWashSave.newBuilder();
        builder.setRuneId(mainRune.getId());
        playerContext.write(CmdCode._29014, builder.build());
    }
}
