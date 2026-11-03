/**
 *
 */
package com.ayjs.mxzg.gameserver.module.task.handler;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.TavernChanceSysCache;
import com.ayjs.mxzg.config.excel.cache.TavernSysCache;
import com.ayjs.mxzg.config.excel.constant.TavernConst;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.excel.entity.CTavern;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PrivilegeType;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PrivilegeGift;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion010PrivilegeGiftService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.role.constant.EntryType;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.task.domain.TavernInfo;
import com.ayjs.mxzg.gameserver.module.task.domain.TavernTask;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskRefreshEvent;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskRewardEvent;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskStartEvent;
import com.ayjs.mxzg.gameserver.module.task.service.TavernInfoService;
import com.ayjs.mxzg.gameserver.module.task.service.TavernTaskService;
import com.ayjs.mxzg.gameserver.module.task.struct.TavernCondition;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.PubTaskGMsg.GReqLockUpPubTask;
import com.ayjs.mxzg.protocol.PubTaskGMsg.GReqOneKeyGetReward;
import com.ayjs.mxzg.protocol.PubTaskGMsg.GReqPubTaskAward;
import com.ayjs.mxzg.protocol.PubTaskGMsg.GReqPubTaskList;
import com.ayjs.mxzg.protocol.PubTaskGMsg.GReqPubTaskRefresh;
import com.ayjs.mxzg.protocol.PubTaskGMsg.GReqPubTaskStart;
import com.ayjs.mxzg.protocol.PubTaskGMsg.GResLockUpPubTask;
import com.ayjs.mxzg.protocol.PubTaskGMsg.GResOneKeyGetReward;
import com.ayjs.mxzg.protocol.PubTaskGMsg.GResPubTaskAward;
import com.ayjs.mxzg.protocol.PubTaskGMsg.GResPubTaskList;
import com.ayjs.mxzg.protocol.PubTaskGMsg.GResPubTaskRefresh;
import com.ayjs.mxzg.protocol.PubTaskGMsg.GResPubTaskStart;
import com.ayjs.mxzg.template.constant.ErrorCode;

/**
 * @author YY
 *
 */
@Controller
public class PubTaskHandler extends ProtocolHandler {

    @Autowired
    private RoleService roleService;
    @Autowired
    private TavernInfoService tavernInfoService;
    @Autowired
    private TavernChanceSysCache tavernChanceSysCache;
    @Autowired
    private TavernSysCache tavernSysCache;
    @Autowired
    private TavernTaskService tavernTaskService;
    @Autowired
    private Promotion010PrivilegeGiftService privilegeGiftService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private Promotion010PrivilegeGiftService promotion010PrivilegeGiftService;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;

    @CMD(id = CmdCode._13021)
    public void getPubTaskList(PlayerContext playerContext, GReqPubTaskList msg) {
    	TavernInfo pubInfo = tavernInfoService.getTavernInfo(playerContext.getId());
		List<TavernTask> tavernTaskList = tavernTaskService.getTavernTasks(playerContext.getId());
		
		if (pubInfo.getStatus() == -1) {
			List<TavernTask> newTasks = new ArrayList<>();
			for(int i = 0; i < TavernConst.FIRST_TASK.size(); i++) {
				//新号的默认配置任务
				TavernTask tavern = new TavernTask();
				tavern.setRid(playerContext.getId());
				tavern.setType(TavernConst.FIRST_TASK.get(i));
				tavern.setStatus(0);
				tavern.setStartTime(0);
				newTasks.add(tavern);
			}
			tavernTaskService.addTavernTasks(newTasks);
			tavernTaskList.addAll(newTasks);
			pubInfo.setStatus(1);
			tavernInfoService.updateTavernInfo(pubInfo);
		}

		GResPubTaskList.Builder builder = GResPubTaskList.newBuilder();
		// 获取酒馆表记录的任务
		for (TavernTask tavern : tavernTaskList) {
			builder.addList(tavernTaskService.serialize(tavern));
		}
		builder.setFreeRefresh(TavernConst.TAVERN_FRESHEN_TIMES - pubInfo.getFreeRefresh());
		builder.setLuxury(promotion010PrivilegeGiftService.isPrivilegeActive(playerContext.getId(), PrivilegeType.TAVERN_LUXURY) ? 1 : 0);
		builder.setHigh(promotion010PrivilegeGiftService.isPrivilegeActive(playerContext.getId(), PrivilegeType.TAVERN_HIGH) ? 1 : 0);
		builder.setAdventureCount(pubInfo.getAdventureCount());
		playerContext.write(CmdCode._13021, builder.build());
    }

    @CMD(id = CmdCode._13022, entry = EntryType.MAIN_PUB_TASK)
    public void pubTaskRefresh(PlayerContext playerContext, GReqPubTaskRefresh msg) {

        Role role = roleService.getOrThrow(playerContext.getId());
        TavernInfo tavernInfo = tavernInfoService.getTavernInfo(playerContext.getId());
        List<TavernTask> tavernTaskList = tavernTaskService.getTavernTasks(playerContext.getId());

        //删除未派遣任务
        List<TavernTask> unsendTask = new ArrayList<>();
        for (TavernTask tavernTask : tavernTaskList) {
            if (tavernTask.getStatus() == 0) {
                unsendTask.add(tavernTask);
            }
        }
        tavernTaskService.deleteTavernTasks(unsendTask);
        tavernTaskList.removeAll(unsendTask);

        //刷新
        boolean f = false;
        if (tavernInfo.getFreeRefresh() < TavernConst.TAVERN_FRESHEN_TIMES) {//免费刷
            tavernInfo.setFreeRefresh(tavernInfo.getFreeRefresh() + 1);//免费刷次数加1
            f = true;
        } else if (thingService.enough(playerContext.getId(), TavernConst.TAVERN_REFRESH_ITEM)) {//道具刷
            thingService.cost(role.getId(), TavernConst.TAVERN_REFRESH_ITEM, GameEvent.TAVERN_TASK_REFRESH);
            f = true;
        } else if (role.getGem() >= TavernConst.REFRESH_GEM) {//钻石刷
            ImmutableThing cost = ImmutableThing.of(ItemType.IT_GEM, TavernConst.REFRESH_GEM);
            thingService.cost(role.getId(), cost, GameEvent.TAVERN_TASK_REFRESH);
            f = true;
        }
        Asserts.isTrue(f, ErrorCode.TAVERN_REFRESH_NUM.getValue(), "酒馆刷新道具不足");

        tavernInfo.setGemRefresh(tavernInfo.getGemRefresh() + 1);//今天刷新次数加1

        //酒馆特权
        List<Integer> privilegeList = new ArrayList<>();
        if (tavernInfo.getGemRefresh() >= 3) {
            // 特权2，每天第三次刷新出5星（橙色）
            PrivilegeGift luxuryPrivilege = privilegeGiftService.getPrivilegeGift(role.getId(), PrivilegeType.TAVERN_LUXURY);
            if (luxuryPrivilege != null && luxuryPrivilege.getBuyTime() > 0 && tavernInfo.getLuxuryRefresh() == 0) {
            	privilegeList.add(5);
            	tavernInfo.setLuxuryRefresh(1);
            }
        }

        if (tavernInfo.getGemRefresh() >= 1) {
            // 特权1，每天第一次刷新出4星（紫色）
            PrivilegeGift highPrivilege = privilegeGiftService.getPrivilegeGift(role.getId(), PrivilegeType.TAVERN_HIGH);
            if (highPrivilege != null && highPrivilege.getBuyTime() > 0 && tavernInfo.getHighRefresh() == 0) {
            	privilegeList.add(4);
            	tavernInfo.setHighRefresh(1);
            }
        }
        
        List<Integer> starList = tavernChanceSysCache.randomStar(tavernInfo.getGemRefresh(), privilegeList);
        List<CTavern> cTavernList = tavernSysCache.randomTasks(tavernInfo.getRefreshCount(), tavernInfo.getLimitRefresh(), starList);
        List<TavernTask> newTasks = new ArrayList<>();
        for (CTavern cTavern : cTavernList) {
        	TavernTask tavern = new TavernTask();
    		tavern.setRid(playerContext.getId());
    		tavern.setType(cTavern.getIdx());
    		tavern.setStatus(0);
    		tavern.setStartTime(0);
            newTasks.add(tavern);
        }
        tavernInfoService.updateTavernInfo(tavernInfo);

        tavernTaskService.addTavernTasks(newTasks);
        tavernTaskList.addAll(newTasks);

        GResPubTaskRefresh.Builder builder = GResPubTaskRefresh.newBuilder();
        for (TavernTask tavern : tavernTaskList) {
            builder.addList(tavernTaskService.serialize(tavern));
        }
        builder.setFreeRefresh(TavernConst.TAVERN_FRESHEN_TIMES - tavernInfo.getFreeRefresh());
        builder.setLuxury(promotion010PrivilegeGiftService.isPrivilegeActive(playerContext.getId(), PrivilegeType.TAVERN_LUXURY) ? 1 : 0);
        builder.setHigh(promotion010PrivilegeGiftService.isPrivilegeActive(playerContext.getId(), PrivilegeType.TAVERN_HIGH) ? 1 : 0);
        playerContext.write(CmdCode._13022, builder.build());

        eventBus.post(TavernTaskRefreshEvent.of(role.getId(), 1, 1));
    }

    public void randomPubTaskTest(int refreshCount, TavernInfo tavernInfo) {
//        Map<Integer, Map<Integer, Integer>> starCountMap = new HashMap<>();
//
//        Map<Integer, Integer> starMap = new HashMap<>();
//
//        for (int i = 0; i < refreshCount; i++) {
//            CTavernChance tavernChance = DropUtil.randomDrop(tavernChanceSysCache.getAll());
//            List<CTavern> tavernList = tavernSysCache.getByStar(tavernChance.getStar(), tavernInfo.checkAndSetFirstRefresh(tavernChance.getStar()));
//
//
//            Integer starNum = starMap.get(tavernChance.getStar());
//            if (starNum == null) {
//                starNum = 0;
//            }
//            starMap.put(tavernChance.getStar(), starNum + 1);
//
//
//            Map<Integer, Integer> countMap = starCountMap.get(tavernChance.getStar());
//            if (countMap == null) {
//                countMap = new HashMap<>();
//                starCountMap.put(tavernChance.getStar(), countMap);
//            }
//            CTavern cTavern = DropUtil.randomDrop(tavernList);
//
//            Integer count = countMap.get(cTavern.getIdx());
//            if (count == null) {
//                count = 0;
//            }
//            countMap.put(cTavern.getIdx(), count + 1);
//        }
//
//        System.out.println("=====================================================");
//        for (Entry<Integer, Integer> entry : starMap.entrySet()) {
//            System.out.println(entry.getKey() + " " + entry.getValue());
//
//            Map<Integer, Integer> countMap = starCountMap.get(entry.getKey());
//            if (countMap == null) {
//                continue;
//            }
//            for (Entry<Integer, Integer> temp : countMap.entrySet()) {
//                System.out.println("\t" + temp.getKey() + " " + temp.getValue());
//            }
//        }
//        System.out.println("=====================================================");
    }

    @CMD(id = CmdCode._13023, entry = EntryType.MAIN_PUB_TASK)
    public void startTask(PlayerContext playerContext, GReqPubTaskStart msg) {
        TavernTask tavernTask = tavernTaskService.getTavernTask(playerContext.getId(), msg.getTaskId());
        if (tavernTask == null) {
            //没有找到该任务
            playerContext.writeError(ErrorCode.TAVERN_TASK_MISS);
            return;
        }
        if (tavernTask.getStatus() != 0) {
            //该任务已经派遣
            playerContext.writeError(ErrorCode.TAVERN_TASK_SEND);
            return;
        }

        CTavern cTavern = tavernSysCache.getOrThrow(tavernTask.getType());
        //冒险点数
        if (promotionControlService.isPromotionRunning(PromotionType.JIU_GUAN_CHANG_KE)) {
            //酒馆常客期间冒险点数打折
            List<ImmutableThing> costList = ImmutableThingUtil.multiplyThing(cTavern.getNeed_points(), (float) TavernConst.TAVERN_PROMOTION_DISCOUNT / 10000f);
            thingService.cost(playerContext.getId(), costList, GameEvent.TAVERN_TASK_DISPATCH);
        } else {
            thingService.cost(playerContext.getId(), cTavern.getNeed_points(), GameEvent.TAVERN_TASK_DISPATCH);
        }

        Set<Long> heroIds = tavernTaskService.getTaskingHeroIds(playerContext.getId());
        List<Hero> heroList = new ArrayList<>();
        for (Long heroId : msg.getHeroIdList()) {
            if (heroIds.contains(heroId)) {
                //该英雄已被派遣到任务中
                playerContext.writeError(ErrorCode.TAVERN_HERO_SEND);
                return;
            }
            Hero hero = heroService.getHero(playerContext.getId(), heroId);
            if (hero != null) {
                heroList.add(hero);
            }
        }


        //TODO 配置的格式应该合并为一个
        List<TavernCondition> conditionList = JsonUtil.getList(cTavern.getHero_condition(), TavernCondition.class);

        for (TavernCondition condition : conditionList) {
            if (condition.getStar() != 0) {
                for (Hero hero : heroList) {
                    if (hero.getStar() >= condition.getStar()) {
                        condition.setMatch(true);
                        break;
                    }
                }
            }
            if (condition.getElement() != 0) {
                for (Hero hero : heroList) {
                	CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getType());
                    if (cHeroType.getElem() >= condition.getElement()) {
                        condition.setMatch(true);
                        break;
                    }
                }
            }
            if (condition.getOccupation() != 0) {
                for (Hero hero : heroList) {
                	CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getType());
                    if (cHeroType.getOccupation() >= condition.getOccupation()) {
                        condition.setMatch(true);
                        break;
                    }
                }
            }
        }

        boolean allMatch = true;
        for (TavernCondition condition : conditionList) {
            if (!condition.isMatch()) {
                allMatch = false;
                break;
            }
        }
        if (!allMatch) {
            //派遣的英雄不满足任务要求
            playerContext.writeError(ErrorCode.TAVERN_HERO_NOT_MATCH);
            return;
        }

        for (Hero hero : heroList) {
            tavernTask.getHeros().add(hero.getId());
        }
        tavernTask.setStatus(1);
        tavernTask.setStartTime(TimeDateUtil.getCurrentTimeInt());
        tavernTaskService.updateTavernTask(tavernTask);

        GResPubTaskStart.Builder builder = GResPubTaskStart.newBuilder();
        builder.setTaskId(tavernTask.getId());
        playerContext.write(CmdCode._13023, builder.build());

        eventBus.post(TavernTaskStartEvent.of(playerContext.getId(), tavernTask.getType()));
    }

    @CMD(id = CmdCode._13024)
    public void getPubTaskAward(PlayerContext playerContext, GReqPubTaskAward msg) {
        TavernTask tavernTask = tavernTaskService.getTavernTask(playerContext.getId(), msg.getTaskId());
        if (tavernTask == null) {
            //没有找到该任务
            playerContext.writeError(ErrorCode.TAVERN_TASK_MISS);
            return;
        }
        if (tavernTask.getStatus() != 1) {
            //任务还没有派遣
            playerContext.writeError(ErrorCode.TAVERN_TASK_NOT_SEND);
            return;
        }
        CTavern cTavern = tavernSysCache.getOrThrow(tavernTask.getType());

        //任务剩余时长
        int remainTime = Math.max(tavernTask.getStartTime() + cTavern.getTime() - DateTimeUtil.currentSecond(), 0);
        //快速完成所需钻石
        int costGem = Math.min(remainTime / TavernConst.TAVERN_QUICKEN_TIME * TavernConst.TAVERN_QUICKEN_COST,
                TavernConst.TAVERN_QUICKEN_COST_MAX);

        Role role = roleService.getOrThrow(playerContext.getId());

        if (costGem > 0) {
            ImmutableThing cost = ImmutableThing.of(ItemType.IT_GEM, costGem);
            thingService.cost(role.getId(), cost, GameEvent.TAVERN_TASK_RETURN);
        }

        tavernTaskService.deleteTavernTask(tavernTask);

        Rewards rewardList = thingService.add(role.getId(), cTavern.getItem(), GameEvent.TAVERN_TASK);

        GResPubTaskAward.Builder builder = GResPubTaskAward.newBuilder();
        builder.setTaskId(tavernTask.getId());
        builder.setUsedGem(costGem);
        builder.addAllList(PbUtil.buildReward(rewardList.getThingSet().asList()));
        playerContext.write(CmdCode._13024, builder.build());

        List<Integer> idxList = new ArrayList<>();
        idxList.add(tavernTask.getType());
        eventBus.post(TavernTaskRewardEvent.of(playerContext.getId(), idxList));
    }

    /**
     * 任务上锁或解锁
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13026)
    public void editPubTaskLock(PlayerContext playerContext, GReqLockUpPubTask msg) {
        GResLockUpPubTask.Builder builder = GResLockUpPubTask.newBuilder();

        TavernTask tavernTask = tavernTaskService.getTavernTask(playerContext.getId(), msg.getTaskId());
        Asserts.notNull(tavernTask, ErrorCode.TAVERN_TASK_MISS.getValue(), () -> String.format("没有找到该任务{%s}", msg.getTaskId()));

        Asserts.isTrue(!(tavernTask.getTaskLock() == 1 && msg.getTaskLock() == 1), ErrorCode.TAVERN_TASK_UP_LOCK.getValue(), "任务已经上锁。");

        Asserts.isTrue(!(tavernTask.getTaskLock() == 0 && msg.getTaskLock() == 0), ErrorCode.TAVERN_TASK_UNLOCK.getValue(), "任务未上锁，无需解锁");

        if (msg.getTaskLock() == 1) {
            tavernTask.setTaskLock(1);
        } else if (msg.getTaskLock() == 0) {
            tavernTask.setTaskLock(0);
        }
        tavernTaskService.updateTavernTask(tavernTask);

        builder.setTaskId(msg.getTaskId());
        builder.setTaskLock(msg.getTaskLock());
        playerContext.write(CmdCode._13026, builder.build());
    }

    @CMD(id = CmdCode._13028)
    public void oneKeyGetReward(PlayerContext playerContext, GReqOneKeyGetReward msg) {
        GResOneKeyGetReward.Builder builder = GResOneKeyGetReward.newBuilder();

        List<TavernTask> taskList = tavernTaskService.getTavernTasks(playerContext.getId());

        List<ImmutableThing> rewardList = new ArrayList<>();
        List<TavernTask> deleteTask = new ArrayList<>();
        List<Integer> idxList = new ArrayList<>();

        taskList.forEach(task -> {
            CTavern cTavern = tavernSysCache.getOrThrow(task.getType());
            int nowTime = DateTimeUtil.currentSecond();
            if (task.getStatus() == 1 && cTavern.getTime() + task.getStartTime() <= nowTime) {
                rewardList.addAll(cTavern.getItem());
                deleteTask.add(task);
                idxList.add(task.getType());
            }
        });

        taskList.removeAll(deleteTask);
        tavernTaskService.deleteTavernTasks(deleteTask);

        thingService.add(playerContext.getId(), ImmutableThingUtil.mergeThing(rewardList), GameEvent.TAVERN_TASK);

        //返回剩余任务列表
        taskList.forEach(tavernTask -> {
            builder.addList(tavernTaskService.serialize(tavernTask));
        });

        playerContext.write(CmdCode._13028, builder.build());

        //抛出事件
        eventBus.post(TavernTaskRewardEvent.of(playerContext.getId(), idxList));
    }

}
