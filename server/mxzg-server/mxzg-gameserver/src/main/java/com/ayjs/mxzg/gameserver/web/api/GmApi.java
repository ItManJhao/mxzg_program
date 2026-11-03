package com.ayjs.mxzg.gameserver.web.api;

import com.alibaba.fastjson.JSON;
import com.ayjs.mxzg.common.base.SpringProxy;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.config.excel.cache.*;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.battle.service.RoleMissionService;
import com.ayjs.mxzg.gameserver.module.blessingPool.service.BlessingPoolService;
import com.ayjs.mxzg.gameserver.module.champion.handler.ChampionTestHandler;
import com.ayjs.mxzg.gameserver.module.champion.service.ChampionService;
import com.ayjs.mxzg.gameserver.module.clanwar.handler.ClanWarTestHandler;
import com.ayjs.mxzg.gameserver.module.clanwar.service.ClanWarService;
import com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.event.BossKillEvent;
import com.ayjs.mxzg.gameserver.module.dreamland.domin.Dreamland;
import com.ayjs.mxzg.gameserver.module.dreamland.service.DreamlandService;
import com.ayjs.mxzg.gameserver.module.dungeon.domain.DungeonInfo;
import com.ayjs.mxzg.gameserver.module.dungeon.service.DungeonBackpackService;
import com.ayjs.mxzg.gameserver.module.dungeon.service.DungeonInfoService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.marquee.service.MarqueeService;
import com.ayjs.mxzg.gameserver.module.onlineReward.service.OnlineRewardService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.*;
import com.ayjs.mxzg.gameserver.module.prophetSummon.service.ProphetSummonService;
import com.ayjs.mxzg.gameserver.module.pvp.service.PvpSysInfoService;
import com.ayjs.mxzg.gameserver.module.recharge.service.RechargeService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.rune.service.RuneInfoService;
import com.ayjs.mxzg.gameserver.module.task.service.TavernInfoService;
import com.ayjs.mxzg.gameserver.web.constant.WebErrorCode;
import com.ayjs.mxzg.gameserver.web.support.WebResult;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/gm")
@Slf4j
public class GmApi {

    /**
     * 执行代码
     *
     * @param args
     * @return
     */
    @RequestMapping(value = "/execute", method = RequestMethod.GET)
    public String execute(@RequestParam(name = "args", required = false) String args) {
        // 调试代码
        log.info("gm execute ");


        return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
    }


    /**
     * 击杀boss
     *
     * @param args
     * @return
     */
    @RequestMapping(value = "/kill_boss", method = RequestMethod.GET)
    public String killBoss(@RequestParam(name = "args", required = false) String args) {
        // 调试代码
        log.info("gm execute ");

        eventBus.post(BossKillEvent.of());
        log.info("发布boss杀死事件");
        return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
    }

    /**
     * 修改月神庇护所
     *
     * @param args
     * @return
     */
    @RequestMapping(value = "/dungeon", method = RequestMethod.GET)
    public String updateDungeon(@RequestParam(name = "args", required = false) String args) {
        // 调试代码
        log.info("gm execute ");

        try {
            String[] param = args.split("_");//roleId_nowStage;
            String roleId = param[0];
            String nowStage = param[1];
            if (StringUtils.isBlank(roleId)) {
                return JSON.toJSONString(WebResult.of(WebErrorCode.FAIL.getCode(), "roleId id is null", "roleId id is null"));
            }
            if (StringUtils.isBlank(nowStage)) {
                return JSON.toJSONString(WebResult.of(WebErrorCode.FAIL.getCode(), "nowStage id is null", "nowStage id is null"));
            }
            long rid = ConvertUtils.toLong(roleId);
            Role role = roleService.getOrThrow(rid);
            if (role == null) {
                return JSON.toJSONString(WebResult.of(WebErrorCode.FAIL.getCode(), "role id is null", "role id is null"));
            }
            DungeonInfoService dungeonInfoService = SpringProxy.getBean(DungeonInfoService.class);
            DungeonInfo dungeonInfo = dungeonInfoService.select(rid);
            if (dungeonInfo == null) {
                return JSON.toJSONString(WebResult.of(WebErrorCode.FAIL.getCode(), "dungeonInfo id is null", "dungeonInfo id is null"));
            }
            int nowStage_ = ConvertUtils.toInt(nowStage);
            dungeonInfo.setNowStage(nowStage_);
            dungeonInfo.setStage(nowStage_ - 1);
            dungeonInfoService.update(dungeonInfo);
            log.info("roleId :{} nowStage:{}", roleId, nowStage);
        } catch (Exception e) {
            e.printStackTrace();
            log.error("dungeonInfo error,", e);
            return JSON.toJSONString(WebResult.of(WebErrorCode.FAIL.getCode(), e.getMessage(), e.getMessage()));
        }
        return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
    }


    /**
     * 执行代码
     *
     * @param args
     * @return
     */
    @RequestMapping(value = "/dreamland", method = RequestMethod.GET)
    public String updateDreamland(@RequestParam(name = "args", required = false) String args) {
        // 调试代码
        log.info("gm execute ");

        String[] argArray = args.split("_");
        long rid = Long.parseLong(argArray[0]);
        int level = Integer.parseInt(argArray[1]);
        Dreamland dreamland = dreamlandService.load(rid);
        dreamland.setCurLv(level);
        dreamland.setTodayMinLv(dreamland.getCurLv());
        dreamland.setTodayRewardLv(dreamland.getCurLv());
        dreamland.setTodayMaxLv(dreamland.getCurLv());
        dreamlandService.update(dreamland);
        log.info("玩家{}永恒梦境等级调整为{}", rid, level);
        return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
    }


    @Autowired
    private ThingService thingService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private BuyGemSysCache buyGemSysCache;
    @Autowired
    private RechargeService rechargeService;
    @Autowired
    private MainLevelSysCache mainLevelSysCache;
    @Autowired
    private EquipmenttypeSysCache equipmenttypeSysCache;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private HeroStarSysCache heroStarSysCache;
    @Autowired
    private HeroService heroService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private ClanWarService clanWarService;
    @Autowired
    private MailService mailService;
    @Autowired
    private PromotionControlSysCache promotionControlSysCache;
    @Autowired
    private ClanWarTestHandler clanWarTestHandler;
    @Autowired
    private RoleMissionService roleMissionService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private MarqueeService marqueeService;
    @Autowired
    private BlessingPoolService blessingPoolService;
    @Autowired
    private PvpSysInfoService pvpSysInfoService;
    @Autowired
    private ProphetSummonService prophetSummonService;
    @Autowired
    private Promotion016DragonInfoService promotion016DragonInfoService;
    @Autowired
    private OnlineRewardService onlineRewardService;
    @Autowired
    private ShelterShopPrizeSysCache shelterShopPrizeSysCache;
    @Autowired
    private DungeonBackpackService dungeonBackpackService;
    @Autowired
    private LotteryWeightSysCache lotteryWeightSysCache;
    @Autowired
    private TavernChanceSysCache tavernChanceSysCache;
    @Autowired
    private TavernSysCache tavernSysCache;
    @Autowired
    private HeroUpGradeSysCache heroUpGradeSysCache;
    @Autowired
    private ClanWorldBossStageSysCache clanWorldBossStageSysCache;
    @Autowired
    private ChampionService championService;
    @Autowired
    private ChampionTestHandler championTestHandler;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private Promotion053TrafficPermitService promotion053TrafficPermitService;
    @Autowired
    private PromotionTrafficPermitSysCache promotionTrafficPermitSysCache;
    @Autowired
    private RunesTypeSysCache runesTypeSysCache;
    @Autowired
    private RunesAbilitySysCache runesAbilitySysCache;
    @Autowired
    private RuneSkillTypeSysCache runeSkillTypeSysCache;
    @Autowired
    private RuneInfoService runeInfoService;
    @Autowired
    private TavernInfoService tavernInfoService;
    @Autowired
    private JewelTypeSysCache jewelTypeSysCache;
    @Autowired
    private DreamlandService dreamlandService;
    @Autowired
    private DreamlandLevelSysCache dreamlandLevelSysCache;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private DreamlandBuffSysCache dreamlandBuffSysCache;
    @Autowired
    private Promotion061ThreeDayTaskService promotion061ThreeDayTaskService;
    @Autowired
    private Promotion065HeroRollingService promotion065HeroRollingService;
}
