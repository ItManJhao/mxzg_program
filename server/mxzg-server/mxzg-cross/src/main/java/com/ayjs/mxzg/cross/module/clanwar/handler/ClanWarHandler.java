/**
 *
 */
package com.ayjs.mxzg.cross.module.clanwar.handler;

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.struct.ClanJobEnum;
import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.cross.module.clan.domain.CrossClan;
import com.ayjs.mxzg.cross.module.clan.service.CrossClanService;
import com.ayjs.mxzg.cross.module.clanwar.domain.ClanWarCross;
import com.ayjs.mxzg.cross.module.clanwar.domain.ClanWarStageControl;
import com.ayjs.mxzg.cross.module.clanwar.domain.ClanWarTeam;
import com.ayjs.mxzg.cross.module.clanwar.service.ClanWarCrossService;
import com.ayjs.mxzg.cross.module.clanwar.service.ClanWarService;
import com.ayjs.mxzg.cross.module.clanwar.service.ClanWarStageControlService;
import com.ayjs.mxzg.cross.module.clanwar.service.ClanWarTeamService;
import com.ayjs.mxzg.cross.module.clanwar.struct.ClanWarBattling;
import com.ayjs.mxzg.cross.module.clanwar.struct.ClanWarRoadInfo;
import com.ayjs.mxzg.cross.module.crossrole.service.CrossRoleService;
import com.ayjs.mxzg.cross.module.hero.service.HeroService;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.CSClanWarBattling;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.CSClanWarBattling.CSClanWarBattlingBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.CSClanWarInfo;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.CSClanWarInfo.CSClanWarInfoBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.CSClanWarRoad;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.CSClanWarRoad.CSClanWarRoadBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.CSClanWarRoadDetail;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.CSClanWarRoadDetail.CSClanWarRoadDetailBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.CSClanWarTeam;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.CSClanWarTeam.CSClanWarTeamBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ReqAdjustRoadSortMessage;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ReqClanWarReportRewardMessage;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ReqClanWarStageMessage;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ReqGmClanWarChangeStageMessage;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ReqSaveRoadFormationMessage;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ReqScanBattlingInfoMessage;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ReqScanHisBattlingInfoMessage;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ReqScanMemberRoadInfoMessage;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ReqScanRoadInfoMessage;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ReqScanWarInfoMessage;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResAdjustRoadSortMessage;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResAdjustRoadSortMessage.ResAdjustRoadSortMessageBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResClanWarStageMessage;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResClanWarStageMessage.ResClanWarStageMessageBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResSaveRoadFormationMessage;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResSaveRoadFormationMessage.ResSaveRoadFormationMessageBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResScanBattlingInfoMessage;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResScanBattlingInfoMessage.ResScanBattlingInfoMessageBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResScanHisBattlingInfoMessage;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResScanHisBattlingInfoMessage.ResScanHisBattlingInfoMessageBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResScanMemberRoadInfoMessage;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResScanMemberRoadInfoMessage.ResScanMemberRoadInfoMessageBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResScanRoadInfoMessage;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResScanRoadInfoMessage.ResScanRoadInfoMessageBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResScanWarInfoMessage;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ResScanWarInfoMessage.ResScanWarInfoMessageBuilder;
import com.ayjs.mxzg.message.module.hero.message.HeroMessage.ResHeroMessage;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.module.clanwar.constant.ClanWarResult;
import com.ayjs.mxzg.module.clanwar.constant.ClanWarRoad;
import com.ayjs.mxzg.module.clanwar.constant.ClanWarStage;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Objects;

/**
 * @author YY
 *
 */
@Slf4j
@Controller
public class ClanWarHandler implements MessageHandler {

    @Autowired
    private CrossRoleService crossRoleService;
    @Autowired
    private CrossClanService crossClanService;
    @Autowired
    private ClanWarStageControlService clanWarStageControlService;
    @Autowired
    private ClanWarCrossService clanWarCrossService;
    @Autowired
    private ClanWarTeamService clanWarTeamService;
    @Autowired
    private ClanWarService clanWarService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private MessageHelper messageHelper;

    /**
     * 查看公会战信息
     * @param playerContext
     * @param msg
     */
    @RemoteMethod
    public void scanWarInfo(ReqScanWarInfoMessage message, Connection connection) {
        CrossRole role = crossRoleService.getNotThrow(message.getRid());
        if (role == null) {
            log.warn("玩家{}查看公会战信息时没有找到跨服中的角色数据", message.getRid());
            return;
        }

        ClanWarStageControl control = clanWarStageControlService.getClanWarStage();

        ResScanWarInfoMessageBuilder builder = ResScanWarInfoMessage.builder();
        builder.rid(message.getRid());
        builder.roundStartTime(control.getRoundStartTime());
        builder.roundEndTime(control.getRoundEndTime());
        builder.stage(control.getStage());
        builder.nextStageTime(control.getNextStageTime());
        builder.firstRoundTime(control.getFirstRoundTime());

        if (role.getClanId() > 0) {
            if (control.getStage() == ClanWarStage.PREPARE || control.getStage() == ClanWarStage.ADJUST) {
                //备战与调整阶段
                ClanWarCross mainInfo = clanWarCrossService.getThisRoundCross(role.getClanId());
                if (mainInfo != null) {
                    ClanWarCross targetInfo = clanWarCrossService.getThisRoundCross(mainInfo.getTargetClanId());
                    List<CSClanWarInfo> warInfos = new ArrayList<>();
                    warInfos.add(serializeWarInfo(mainInfo, true));
                    warInfos.add(serializeWarInfo(targetInfo, false));
                    builder.warInfos(warInfos);
                    builder.canJoin(mainInfo.getJoinMembers().contains(role.getId()) ? 1 : 0);
                }
            } else {
                //开战与刚结束阶段
                ClanWarCross mainInfo = clanWarCrossService.getThisRoundCross(role.getClanId());
                if (mainInfo != null) {
                    ClanWarBattling mainBattling = clanWarService.getBattlingInfo(role.getClanId());
                    if (mainBattling != null) {
                        ClanWarBattling targetBattling = clanWarService.getBattlingInfo(mainInfo.getTargetClanId());
                        List<CSClanWarInfo> warInfos = new ArrayList<>();
                        warInfos.add(serializeWarInfo(mainBattling));
                        warInfos.add(serializeWarInfo(targetBattling));
                        builder.warInfos(warInfos);
                    }
                    builder.canJoin(mainInfo.getJoinMembers().contains(role.getId()) ? 1 : 0);
                    builder.isWin(mainInfo.getIsWin());
                }
            }
        }
        connection.send(builder.build());
    }

    /**
     * 序列化开战阶段的公会战信息
     * @param warBattling
     * @return
     */
    private CSClanWarInfo serializeWarInfo(ClanWarBattling warBattling) {
        CrossClan clan = crossClanService.get(warBattling.getClanId());

        CSClanWarInfoBuilder builder = CSClanWarInfo.builder();
        if (Objects.nonNull(clan)){
            builder.clanId(clan.getId());
            builder.name(clan.getClanName());
            builder.serverId(clan.getServerId());
        } else {
            builder.clanId(warBattling.getClanId());
            builder.name("");
            builder.serverId(warBattling.getServerId());
        }
        List<CSClanWarRoad> roads = new ArrayList<>();
        for (ClanWarRoadInfo roadInfo : warBattling.getRoadTeamMap().values()) {
            CSClanWarRoadBuilder roadBuilder = CSClanWarRoad.builder();
            roadBuilder.road(roadInfo.getRoad());
            roadBuilder.battling(roadInfo.getResult() == ClanWarResult.NONE ? 1 : 0);
            roadBuilder.total(roadInfo.getTeams().size());
            int aliveCount = 0;
            for (ClanWarTeam team : roadInfo.getTeams()) {
                if (team.getAlive() == 1 || team.getShowAlive() == 1) {
                    aliveCount++;
                }
            }
            roadBuilder.alive(aliveCount);
            roads.add(roadBuilder.build());
        }
        builder.roads(roads);
        return builder.build();
    }

    /**
     * 序列化备战阶段的公会战信息
     * @param warInfo
     * @return
     */
    private CSClanWarInfo serializeWarInfo(ClanWarCross warInfo, boolean isMyClan) {
        CrossClan clan = crossClanService.get(warInfo.getClanId());

        CSClanWarInfoBuilder builder = CSClanWarInfo.builder();
        if (Objects.nonNull(clan)) {
            builder.clanId(clan.getId());
            builder.name(clan.getClanName());
            builder.serverId(clan.getServerId());
        } else {
            builder.clanId(warInfo.getClanId());
            builder.name("");
            builder.serverId(warInfo.getServerId());
        }

        if (isMyClan) {
            Map<Integer, Integer> roadCountMap = new HashMap<>();
            for (Long rid : warInfo.getBattleMembers()) {
                ClanWarTeam team = clanWarTeamService.getClanWarTeam(rid);
                Integer count = roadCountMap.get(team.getRoad());
                if (count == null) {
                    count = 0;
                }
                roadCountMap.put(team.getRoad(), count + 1);
            }
            List<CSClanWarRoad> roads = new ArrayList<>();
            for (Entry<Integer, Integer> entry : roadCountMap.entrySet()) {
                CSClanWarRoadBuilder roadBuilder = CSClanWarRoad.builder();
                roadBuilder.road(entry.getKey());
                roadBuilder.battling(0);
                roadBuilder.total(entry.getValue());
                roadBuilder.alive(entry.getValue());
                roads.add(roadBuilder.build());
            }
            builder.roads(roads);
        }
        return builder.build();
    }


    /**
     * 查看路况信息
     */
    @RemoteMethod
    public void scanRoadInfo(ReqScanRoadInfoMessage message, Connection connection) {

        Asserts.isTrue(clanWarService.isCanScanClanWar(), ErrorCode.WAR_NOT_OPEN.getValue(), "公会战还没有开始");

        CrossRole role = crossRoleService.getOrThrow(message.getRid());
        Asserts.isTrue(role.getClanId() > 0, ErrorCode.WAR_NOT_IN_CLAN.getValue(), "你还没有加入任何公会");

        ClanWarCross mainInfo = clanWarCrossService.getThisRoundCross(role.getClanId());
        Asserts.isTrue(mainInfo != null, ErrorCode.WAR_NOT_IN_BATTLE.getValue(), "你的公会没有匹配到对战公会");

        ResScanRoadInfoMessageBuilder builder = ResScanRoadInfoMessage.builder();
        builder.rid(message.getRid());

        List<ClanWarTeam> teams = new ArrayList<>();
        for (long rid : mainInfo.getBattleMembers()) {
            ClanWarTeam team = clanWarTeamService.getClanWarTeam(rid);
            teams.add(team);
        }
        Map<Integer, List<ClanWarTeam>> roadTeamMap = ListMapUtil.fillListMap(teams, ClanWarTeam::getRoad);

        List<CSClanWarRoadDetail> details = new ArrayList<>();
        for (Entry<Integer, List<ClanWarTeam>> entry : roadTeamMap.entrySet()) {
            details.add(serializeRoadDetail(entry.getKey(), entry.getValue()));
        }
        builder.details(details);
        connection.send(builder.build());
    }

    private CSClanWarRoadDetail serializeRoadDetail(int road, List<ClanWarTeam> teamList) {
        teamList.sort(Comparator.comparingInt(ClanWarTeam::getSort));

        CSClanWarRoadDetailBuilder builder = CSClanWarRoadDetail.builder();
        builder.road(road);
        List<CSClanWarTeam> teams = new ArrayList<>();
        for (ClanWarTeam team : teamList) {
            teams.add(serializeWarTeam(team));
        }
        builder.teams(teams);
        return builder.build();
    }

    private CSClanWarTeam serializeWarTeam(ClanWarTeam team) {
        CSClanWarTeamBuilder builder = CSClanWarTeam.builder();
        builder.rid(team.getRid());
        CrossRole role = crossRoleService.getOrThrow(team.getRid());
        builder.name(role.getNick());
        int posMin = Integer.MAX_VALUE;
        for (HeroVo hero : team.getBattlerVo().getHeros()) {
            if (hero.getPos() < posMin) {
                builder.heroLevel(hero.getLevel());
                builder.heroType(hero.getHero_type());
                builder.heroStar(hero.getStar());
                builder.fashionId(hero.getFashionId());
                builder.evolveLevel(hero.getEvolve().getLevel());
                builder.evolveType(hero.getEvolve().getType());
                posMin = hero.getPos();
            }
        }
        builder.fighting(team.getFighting());
        return builder.build();
    }

    /**
     * 保存布阵数据
     */
    @RemoteMethod
    public void saveRoadFormation(ReqSaveRoadFormationMessage message, Connection connection) {
        ClanWarRoad warRoad = ClanWarRoad.valueOf(message.getRoad());
        Asserts.isTrue(warRoad != null, ErrorCode.ERROR_PARAM.getValue(), "参数错误");

        Asserts.isTrue(clanWarService.isPrepareStage(), ErrorCode.WAR_NOT_IN_PREPARE.getValue(), "当前不在公会战备战阶段");

        CrossRole role = crossRoleService.getOrThrow(message.getRid());
        Asserts.isTrue(role.getClanId() > 0, ErrorCode.WAR_NOT_IN_CLAN.getValue(), "你还没有加入任何公会");

        ClanWarCross mainInfo = clanWarCrossService.getThisRoundCross(role.getClanId());
        Asserts.isTrue(mainInfo != null, ErrorCode.WAR_NOT_IN_BATTLE.getValue(), "你的公会没有匹配到对战公会");

        Asserts.isTrue(mainInfo.getJoinMembers().contains(role.getId()), ErrorCode.WAR_NOT_ALLOW.getValue(), "本次的公会战你还不具备参战资格");

        synchronized (mainInfo) {
            BattlerVo battlerVo = GsonUtils.fromJson(message.getBattlerVoJson(), BattlerVo.class);

            ClanWarTeam myTeam = clanWarTeamService.getClanWarTeam(role.getId());
            myTeam.setBattlerVo(battlerVo);
            myTeam.setFighting(message.getFighting());

            if (mainInfo.getBattleMembers().contains(role.getId())) {
                //找到原来的位置
                if (myTeam.getRoad() != warRoad.getRoad()) {
                    //改变战路则需要重新排序，添加到新战路的末尾，把原本战路中后面的队伍进行序号调整
                    int maxSort = 1;
                    List<ClanWarTeam> oriRoadTeams = new ArrayList<>();
                    for (long rid : mainInfo.getBattleMembers()) {
                        ClanWarTeam memberTeam = clanWarTeamService.getClanWarTeam(rid);
                        if (memberTeam.getRoad() == warRoad.getRoad() && memberTeam.getSort() > maxSort) {
                            maxSort = memberTeam.getSort();
                        }
                        if (memberTeam.getRoad() == myTeam.getRoad() && memberTeam.getRid() != myTeam.getRid()) {
                            oriRoadTeams.add(memberTeam);
                        }
                    }
                    oriRoadTeams.sort(Comparator.comparingInt(ClanWarTeam::getSort));
                    List<ClanWarTeam> updateTeams = new ArrayList<>();
                    resortTeam(oriRoadTeams, updateTeams);

                    myTeam.setRoad(warRoad.getRoad());
                    myTeam.setSort(maxSort);
                    updateTeams.add(myTeam);
                    clanWarTeamService.updateTeams(updateTeams);
                } else {
                    //没有改变战路则表示玩家只是重新布阵，不需要调整位置
                    clanWarTeamService.updateTeam(myTeam);
                }
            } else {
                int maxSort = 1;
                for (long rid : mainInfo.getBattleMembers()) {
                    ClanWarTeam memberTeam = clanWarTeamService.getClanWarTeam(rid);
                    if (memberTeam.getRoad() == warRoad.getRoad() && memberTeam.getSort() > maxSort) {
                        maxSort = memberTeam.getSort();
                    }
                }

                myTeam.setRoad(warRoad.getRoad());
                myTeam.setSort(maxSort);
                clanWarTeamService.updateTeam(myTeam);

                mainInfo.getBattleMembers().add(role.getId());
                clanWarCrossService.update(mainInfo);
                //添加玩家布阵队列
            }
        }
        ResSaveRoadFormationMessageBuilder builder = ResSaveRoadFormationMessage.builder();
        builder.rid(message.getRid());
        builder.road(message.getRoad());
        connection.send(builder.build());
    }

    /**
     * 调整队伍出战分路与出战顺序
     */
    @RemoteMethod
    public void adjustRoadSort(ReqAdjustRoadSortMessage message, Connection connection) {
        ClanWarRoad warRoad = ClanWarRoad.valueOf(message.getRoad());
        Asserts.isTrue(warRoad != null, ErrorCode.ERROR_PARAM.getValue(), "参数错误");

        //备战阶段只能对自己调整
        if (clanWarService.isPrepareStage()) {
            adjustMyRoadSort(message, connection);
        } else if (clanWarService.isAdjustStage()) {
            //调整阶段只能会长进行调整
            adjustMemberRoadSort(message, connection);
        } else {
            Asserts.isTrue(false, ErrorCode.WAR_FORMATION_LOCK.getValue(), "公会战当前阶段无法调整队伍编排");
        }
    }

    private void adjustMyRoadSort(ReqAdjustRoadSortMessage message, Connection connection) {
        CrossRole role = crossRoleService.getOrThrow(message.getRid());
        Asserts.isTrue(role.getClanId() > 0, ErrorCode.WAR_NOT_IN_CLAN.getValue(), "你还没有加入任何公会");

        ClanWarCross mainInfo = clanWarCrossService.getThisRoundCross(role.getClanId());
        Asserts.isTrue(mainInfo != null, ErrorCode.WAR_NOT_IN_BATTLE.getValue(), "你的公会没有匹配到对战公会");

        Asserts.isTrue(mainInfo.getBattleMembers().contains(message.getRid()), ErrorCode.WAR_HAS_NO_TEAM.getValue(), "你还没有布阵到公会战当中");

        ClanWarTeam myTeam = clanWarTeamService.getClanWarTeam(role.getId());
        Asserts.isTrue(myTeam.getRoad() != message.getRoad() || myTeam.getSort() != message.getSort(), ErrorCode.WAR_ROAD_NO_CHANGE.getValue(), "战路编排没有发生变化");

        if (myTeam.getRoad() == message.getRoad()) {
            adjustSameRoad(mainInfo, myTeam, message.getSort());
        } else {
            adjustDifferentRoad(mainInfo, myTeam, message.getRoad(), message.getSort());
        }
        ResAdjustRoadSortMessageBuilder builder = ResAdjustRoadSortMessage.builder();
        builder.rid(message.getRid());
        builder.targetRid(myTeam.getRid());
        builder.road(myTeam.getRoad());
        builder.sort(myTeam.getSort());
        connection.send(builder.build());
    }

    private void adjustSameRoad(ClanWarCross warInfo, ClanWarTeam team, int sort) {
        if (team.getSort() == sort) {
            return;
        }

        List<ClanWarTeam> oriRoadTeams = new ArrayList<>();
        for (long rid : warInfo.getBattleMembers()) {
            if (rid == team.getRid()) {
                continue;
            }
            ClanWarTeam memberTeam = clanWarTeamService.getClanWarTeam(rid);
            if (memberTeam.getRoad() != team.getRoad()) {
                continue;
            }
            oriRoadTeams.add(memberTeam);
        }
        if (oriRoadTeams.isEmpty()) {
            //当前战路只有自己一个，不做任何处理
            return;
        }
        //队伍排序从1开始
        sort = sort - 1;
        if (sort < 0) {
            return;
        }
        oriRoadTeams.sort(Comparator.comparingInt(ClanWarTeam::getSort));
        if (sort > oriRoadTeams.size()) {
            sort = oriRoadTeams.size();
        }

        List<ClanWarTeam> updateList = new ArrayList<>();
        //插入到队伍指定的位置中
        oriRoadTeams.add(sort, team);
        resortTeam(oriRoadTeams, updateList);

        if (!updateList.isEmpty()) {
            clanWarTeamService.updateTeams(updateList);
        }
    }

    private void adjustDifferentRoad(ClanWarCross warInfo, ClanWarTeam team, int road, int sort) {
        //原来的战路
        List<ClanWarTeam> oriRoadTeams = new ArrayList<>();
        //新的战路
        List<ClanWarTeam> newRoadTeams = new ArrayList<>();

        for (long rid : warInfo.getBattleMembers()) {
            if (rid == team.getRid()) {
                continue;
            }
            ClanWarTeam memberTeam = clanWarTeamService.getClanWarTeam(rid);
            if (memberTeam.getRoad() == team.getRoad()) {
                oriRoadTeams.add(memberTeam);
            }
            if (memberTeam.getRoad() == road) {
                newRoadTeams.add(memberTeam);
            }
        }
        List<ClanWarTeam> updateList = new ArrayList<>();
        if (!oriRoadTeams.isEmpty()) {
            oriRoadTeams.sort(Comparator.comparingInt(ClanWarTeam::getSort));
            resortTeam(oriRoadTeams, updateList);
        }
        //队伍排序从1开始
        sort = sort - 1;
        if (sort < 0) {
            sort = 0;
        }
        if (sort > newRoadTeams.size()) {
            sort = newRoadTeams.size();
        }
        newRoadTeams.sort(Comparator.comparingInt(ClanWarTeam::getSort));
        newRoadTeams.add(sort, team);
        team.setRoad(road);
        resortTeam(newRoadTeams, updateList);

        if (!updateList.isEmpty()) {
            clanWarTeamService.updateTeams(updateList);
        }
    }

    /**
     * 重新排序队伍
     * @param roadTeams
     * @param updateList
     */
    private void resortTeam(List<ClanWarTeam> roadTeams, List<ClanWarTeam> updateList) {
        for (int i = 0; i < roadTeams.size(); i++) {
            ClanWarTeam memberTeam = roadTeams.get(i);
            //序号从1开始
            if (memberTeam.getSort() != i + 1) {
                memberTeam.setSort(i + 1);
                updateList.add(memberTeam);
            }
        }
    }


    private void adjustMemberRoadSort(ReqAdjustRoadSortMessage message, Connection connection) {
        CrossRole role = crossRoleService.getOrThrow(message.getRid());
        Asserts.isTrue(role.getClanId() > 0, ErrorCode.WAR_NOT_IN_CLAN.getValue(), "你还没有加入任何公会");

        ClanWarCross mainInfo = clanWarCrossService.getThisRoundCross(role.getClanId());
        Asserts.isTrue(mainInfo != null, ErrorCode.WAR_NOT_IN_BATTLE.getValue(), "你的公会没有匹配到对战公会");
        Asserts.isTrue(
                message.getPos() == ClanJobEnum.CLAN_PRESIDENT.getJobKey()
                        || message.getPos() == ClanJobEnum.CLAN_VICE_PRESIDENT.getJobKey(),
                ErrorCode.WAR_ONLY_LEADER_ADJUST.getValue(), "调整阶段只有会长和副会长可以进行操作");

        Asserts.isTrue(mainInfo.getBattleMembers().contains(message.getTargetRid()), ErrorCode.WAR_NOT_JOIN.getValue(), "该成员没有参与到公会战中");

        ClanWarTeam targetTeam = clanWarTeamService.getClanWarTeam(message.getTargetRid());
        Asserts.isTrue(targetTeam.getRoad() != message.getRoad() || targetTeam.getSort() != message.getSort(), ErrorCode.WAR_ROAD_NO_CHANGE.getValue(), "战路编排没有发生变化");

        if (targetTeam.getRoad() == message.getRoad()) {
            adjustSameRoad(mainInfo, targetTeam, message.getSort());
        } else {
            adjustDifferentRoad(mainInfo, targetTeam, message.getRoad(), message.getSort());
        }
        ResAdjustRoadSortMessageBuilder builder = ResAdjustRoadSortMessage.builder();
        builder.rid(message.getRid());
        builder.targetRid(targetTeam.getRid());
        builder.road(targetTeam.getRoad());
        builder.sort(targetTeam.getSort());
        connection.send(builder.build());
    }

    /**
     * 查看某一路的当前战况
     */
    @RemoteMethod
    public void scanBattlingInfo(ReqScanBattlingInfoMessage message, Connection connection) {
        ClanWarRoad warRoad = ClanWarRoad.valueOf(message.getRoad());
        Asserts.isTrue(warRoad != null, ErrorCode.ERROR_PARAM.getValue(), "参数错误");

        Asserts.isTrue(clanWarService.isBattleStage(), ErrorCode.WAR_NOT_IN_BATTLING.getValue(), "当前不在公会战对抗阶段");

        CrossRole role = crossRoleService.getOrThrow(message.getRid());
        Asserts.isTrue(role.getClanId() > 0, ErrorCode.WAR_NOT_IN_CLAN.getValue(), "你还没有加入任何公会");

        ClanWarBattling mainBattling = clanWarService.getBattlingInfo(role.getClanId());
        Asserts.isTrue(mainBattling != null, ErrorCode.WAR_NOT_IN_BATTLE.getValue(), "你的公会没有匹配到对战公会");

        ClanWarCross mainWarInfo = clanWarCrossService.getThisRoundCross(mainBattling.getClanId());

        ClanWarBattling targetBattling = clanWarService.getBattlingInfo(mainWarInfo.getTargetClanId());
        ClanWarCross targetWarInfo = clanWarCrossService.getThisRoundCross(targetBattling.getClanId());

        ResScanBattlingInfoMessageBuilder builder = ResScanBattlingInfoMessage.builder();
        builder.rid(message.getRid());

        ClanWarRoadInfo mainRoadInfo = mainBattling.getRoadTeamMap().get(warRoad.getRoad());
        ClanWarRoadInfo targetRoadInfo = targetBattling.getRoadTeamMap().get(warRoad.getRoad());

        if (mainWarInfo.getMainAttack() == 1) {
            if (mainRoadInfo.getCurrBattleDetail() != null) {
                builder.detail(mainRoadInfo.getCurrBattleDetail());
            }
        }
        if (targetWarInfo.getMainAttack() == 1) {
            if (targetRoadInfo.getCurrBattleDetail() != null) {
                builder.detail(targetRoadInfo.getCurrBattleDetail());
            }
        }
        List<CSClanWarBattling> battling = new ArrayList<>();
        battling.add(serializeWarBattling(mainBattling, mainRoadInfo));
        battling.add(serializeWarBattling(targetBattling, targetRoadInfo));
        builder.battling(battling);
        connection.send(builder.build());
    }


    private CSClanWarBattling serializeWarBattling(ClanWarBattling battling, ClanWarRoadInfo roadInfo) {
        CSClanWarBattlingBuilder builder = CSClanWarBattling.builder();
        builder.clanId(battling.getClanId());
        List<CSClanWarTeam> teams = new ArrayList<>();
        for (ClanWarTeam team : roadInfo.getTeams()) {
            if (team.getAlive() != 1 && team.getShowAlive() != 1) {
                continue;
            }
            teams.add(serializeWarTeam(team));
        }
        builder.teams(teams);
        builder.serverId(battling.getServerId());
        return builder.build();
    }


    /**
     * 查看某一路的历史战况
     */
    @RemoteMethod
    public void scanHisBattleInfo(ReqScanHisBattlingInfoMessage message, Connection connection) {
        ClanWarRoad warRoad = ClanWarRoad.valueOf(message.getRoad());
        Asserts.isTrue(warRoad != null, ErrorCode.ERROR_PARAM.getValue(), "参数错误");

        Asserts.isTrue(clanWarService.isCanScanHisBattle(), ErrorCode.WAR_NOT_IN_BATTLING.getValue(), "当前不在公会战对抗阶段");

        CrossRole role = crossRoleService.getOrThrow(message.getRid());
        Asserts.isTrue(role.getClanId() > 0, ErrorCode.WAR_NOT_IN_CLAN.getValue(), "你还没有加入任何公会");

        ClanWarBattling mainBattling = clanWarService.getBattlingInfo(role.getClanId());
        Asserts.isTrue(mainBattling != null, ErrorCode.WAR_NOT_IN_BATTLE.getValue(), "你的公会没有匹配到对战公会");

        ClanWarRoadInfo roadInfo = mainBattling.getRoadTeamMap().get(warRoad.getRoad());

        ResScanHisBattlingInfoMessageBuilder builder = ResScanHisBattlingInfoMessage.builder();
        builder.rid(message.getRid());
        if (roadInfo != null) {
            builder.hisInfo(roadInfo.getHisDetailList());
        }
        connection.send(builder.build());
    }

    /**
     * 查看某个公会成员的布路信息
     */
    @RemoteMethod
    public void scanMemberRoadInfo(ReqScanMemberRoadInfoMessage message, Connection connection) {
        CrossRole role = crossRoleService.getOrThrow(message.getRid());
        Asserts.isTrue(role.getClanId() > 0, ErrorCode.WAR_NOT_IN_CLAN.getValue(), "你还没有加入任何公会");

        ClanWarCross mainInfo = clanWarCrossService.getThisRoundCross(role.getClanId());
        Asserts.isTrue(mainInfo != null, ErrorCode.WAR_NOT_IN_BATTLE.getValue(), "你的公会没有匹配到对战公会");

        //这里的判断也包含了是否同公会的逻辑
        Asserts.isTrue(mainInfo.getBattleMembers().contains(message.getTargetRid()), ErrorCode.WAR_NOT_JOIN.getValue(), "该成员没有参与到公会战中");

        ClanWarTeam clanWarTeam = clanWarTeamService.getClanWarTeam(message.getTargetRid());

        ResScanMemberRoadInfoMessageBuilder builder = ResScanMemberRoadInfoMessage.builder();
        builder.rid(message.getRid());
        builder.playerId(message.getTargetRid());

        List<HeroVo> heroList = new ArrayList<>();
        heroList.addAll(clanWarTeam.getBattlerVo().getHeros());
        Collections.sort(heroList, Comparator.comparingInt(HeroVo::getPos));
        List<ResHeroMessage> heroData = new ArrayList<>();
        for (HeroVo hero : heroList) {
            ResHeroMessage model = heroService.serialize(hero);
            heroData.add(model);
        }
        builder.heroData(heroData);
        builder.fighting(clanWarTeam.getFighting());
        connection.send(builder.build());
    }

    @RemoteMethod
    public void gmChangeStage(ReqGmClanWarChangeStageMessage message) {
        System.out.println("ReqGmClanWarChangeStageMessage");
        clanWarService.gmTransformStage();
    }

    @RemoteMethod
    public void queryStageInfo(ReqClanWarStageMessage message) {
        ClanWarStageControl control = clanWarStageControlService.getClanWarStage();

        ResClanWarStageMessageBuilder builder = ResClanWarStageMessage.builder();
        builder.serverId(message.getServerId());
        builder.roundEndTime(control.getRoundEndTime());
        builder.battleClans(clanWarService.getServerBattlingClans(message.getServerId()));
        messageHelper.pushToMessage(builder.build());
    }

    @RemoteMethod
    public void clanRewardReport(ReqClanWarReportRewardMessage message) {
        ClanWarCross clanWarCross = clanWarCrossService.getFromCache(message.getClanId(), message.getRound());
        if (clanWarCross == null) {
            return;
        }
        clanWarCross.setReportStatus(1);
        clanWarCrossService.update(clanWarCross);
    }
}
