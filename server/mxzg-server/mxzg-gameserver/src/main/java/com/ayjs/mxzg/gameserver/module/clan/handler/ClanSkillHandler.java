package com.ayjs.mxzg.gameserver.module.clan.handler;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.ClanSkillBaseSysCache;
import com.ayjs.mxzg.config.excel.cache.ClanSkillResetGemSysCache;
import com.ayjs.mxzg.config.excel.constant.ClanConst;
import com.ayjs.mxzg.config.excel.entity.CClanSkillBase;
import com.ayjs.mxzg.config.excel.entity.CClanSkillResetGem;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.HeroJobType;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.clan.constant.ClanConstant;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanSkill;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanSkillUpEvent;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanSkillService;
import com.ayjs.mxzg.gameserver.module.clan.struct.ClanSkillData;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.ClanGMsg;
import com.ayjs.mxzg.protocol.ClanGMsg.GReqClanSkillLight;
import com.ayjs.mxzg.protocol.ClanGMsg.GReqClanSkillList;
import com.ayjs.mxzg.protocol.ClanGMsg.GResClanRemoveSkill;
import com.ayjs.mxzg.protocol.ClanGMsg.GResClanSkillLight;
import com.ayjs.mxzg.protocol.ClanGMsg.GResClanSkillList;
import com.ayjs.mxzg.protocol.ClanGMsg.PSClanSkillData;
import com.ayjs.mxzg.template.constant.ErrorCode;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class ClanSkillHandler extends ProtocolHandler {

    @Autowired
    private ClanSkillService clanSkillService;
    @Autowired
    private ClanSkillBaseSysCache clanSkillBaseSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private ClanSkillResetGemSysCache clanSkillResetGemSysCache;

    /**
     * 公会技能
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._7031)
    public void clanSkillList(PlayerContext playerContext, GReqClanSkillList msg) {
        GResClanSkillList.Builder builder = GResClanSkillList.newBuilder();
        ClanSkill clanSkill = clanSkillService.selectClanSkill(playerContext.getId());
        builder.setNextRefreshTimes(clanSkill.getSkillReset());
        clanSkill.getSkillList().forEach((k, v) -> {
            PSClanSkillData.Builder res = PSClanSkillData.newBuilder();
            res.setProfessionType(v.getProfession());
            res.setStage(v.getLevel());
            res.setElemIdx(v.getSkillType());
            builder.addList(res);
        });
        playerContext.write(CmdCode._7031, builder.build());
    }

    /**
     * 点亮公会技能
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._7032)
    public void clanSkillUp(PlayerContext playerContext, GReqClanSkillLight msg) {
        Role role = roleService.getOrThrow(playerContext.getId());

        Asserts.isTrue(role.getClanId() != 0, ErrorCode.CLAN_NOT_EXIST.getValue(), "公会不存在");

        HeroJobType heroJobType = HeroJobType.valueOf(msg.getProfessionType());
        Asserts.isTrue(heroJobType != null, ErrorCode.CLAN_NOT_SKILL_TYPE.getValue(), "不存在该类型的公会技能，SkillType :" + msg.getProfessionType());

        ClanSkill clanSkill = clanSkillService.selectClanSkill(playerContext.getId());
        ClanSkillData clanSkillData = clanSkill.getSkillList().getOrDefault(msg.getProfessionType(), clanSkillService.addClanSkillData(msg.getProfessionType()));

        int maxSkillLevel = clanSkillBaseSysCache.getMaxLv();
        if (clanSkillData.getLevel() >= maxSkillLevel && clanSkillData.getSkillType() >= ClanConstant.CLAN_SKILL) {
            // 当前技能达满级
            playerContext.writeError(ErrorCode.CLAN_SKILL_MAX);
            return;
        }

        CClanSkillBase cModel = null;
        if (clanSkillData.getSkillType() < ClanConstant.CLAN_SKILL) {
            cModel = clanSkillBaseSysCache.getByLevelAndType(clanSkillData.getLevel(), clanSkillData.getSkillType() + 1);
        } else {
            cModel = clanSkillBaseSysCache.getByLevelAndType(clanSkillData.getLevel() + 1, 1);

            int minLevel = clanSkill.getSkillList().values().stream().mapToInt(ClanSkillData::getLevel).summaryStatistics().getMin();
            Asserts.isTrue(clanSkillData.getLevel() + 1 - minLevel <= ClanConst.CLAN_SKILL_LEVEL_GAP,ErrorCode.CLAN_SKILL_LEVEL_GAP.getValue(),"公会技能等级差超过上限");
        }

        // 扣费
        thingService.cost(playerContext.getId(), cModel.getCost_res(), GameEvent.CLAN_UP_SKILL);

        // 验证升级
        if (clanSkillData.getSkillType() == ClanConstant.CLAN_SKILL) {
            clanSkillData.setSkillType(1);
            clanSkillData.setLevel(clanSkillData.getLevel() + 1);
        } else {
            clanSkillData.setSkillType(clanSkillData.getSkillType() + 1);
        }
        // 升级
        clanSkill.getSkillList().put(msg.getProfessionType(), clanSkillData);
        clanSkillService.updateClanSkill(clanSkill);

        playerContext.write(CmdCode._7032, GResClanSkillLight.getDefaultInstance());

        eventBus.post(ClanSkillUpEvent.of(role.getId(), clanSkillData.getProfession(), GameEvent.CLAN_UP_SKILL));
    }

    /**
     * 重置公会技能
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._7033)
    public void clanRemoveSkill(PlayerContext playerContext, ClanGMsg.GReqClanRemoveSkill msg) {

        HeroJobType heroJobType = HeroJobType.valueOf(msg.getProfessionType());
        Asserts.isTrue(heroJobType != null, ErrorCode.CLAN_NOT_SKILL_TYPE.getValue(), "不存在该类型的公会技能，SkillType :" + msg.getProfessionType());

        ClanSkill clanSkill = clanSkillService.selectClanSkill(playerContext.getId());
        ClanSkillData clanSkillData = clanSkill.getSkillList().getOrDefault(msg.getProfessionType(), clanSkillService.addClanSkillData(msg.getProfessionType()));

        Asserts.isTrue(clanSkillData.getLevel() != 1 || clanSkillData.getSkillType() != 0,
                ErrorCode.CLAN_REMOVE_SKILL.getValue(), String.format("该职业技能未升级{%s}-{%s}", clanSkillData.getLevel(), clanSkillData.getSkillType()));

        int clanSkillResetNum = Math.min(clanSkill.getSkillReset(), clanSkillResetGemSysCache.getMaxTimes());
        CClanSkillResetGem clanSkillResetGem = clanSkillResetGemSysCache.getOrThrow(clanSkillResetNum);

        thingService.cost(playerContext.getId(), clanSkillResetGem.getNeed_gem(), GameEvent.CLAN_SKILL_RESET);

        clanSkill.setSkillReset(clanSkill.getSkillReset() + 1);

        List<ImmutableThing> rewardList = new ArrayList<>();
        for (CClanSkillBase cModel : clanSkillBaseSysCache.getAll()) {
            if (cModel.getLevel() < clanSkillData.getLevel()) {
                rewardList.addAll(cModel.getCost_res());
            } else if (cModel.getLevel() == clanSkillData.getLevel() && cModel.getAttr_type() <= clanSkillData.getSkillType()) {
                rewardList.addAll(cModel.getCost_res());
            }
        }

        clanSkillData.setLevel(1);
        clanSkillData.setSkillType(0);
        clanSkill.getSkillList().put(msg.getProfessionType(), clanSkillData);
        clanSkillService.updateClanSkill(clanSkill);

        rewardList = ImmutableThingUtil.mergeThing(rewardList);

        thingService.add(playerContext.getId(), rewardList, GameEvent.CLAN_UP_SKILL);

        playerContext.write(CmdCode._7033, GResClanRemoveSkill.getDefaultInstance());
    }
}
