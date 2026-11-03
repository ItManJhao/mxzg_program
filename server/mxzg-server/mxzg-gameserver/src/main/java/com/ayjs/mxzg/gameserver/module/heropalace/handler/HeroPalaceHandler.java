package com.ayjs.mxzg.gameserver.module.heropalace.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.HeroPalaceSysCache;
import com.ayjs.mxzg.config.excel.constant.HeroPalaceConst;
import com.ayjs.mxzg.config.excel.entity.CHeroPalace;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.heropalace.domain.HeroPalace;
import com.ayjs.mxzg.gameserver.module.heropalace.domain.HeroPalaceSelf;
import com.ayjs.mxzg.gameserver.module.heropalace.service.HeroPalaceService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.HeroPalaceGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * @Author: CWJ
 * @Date: 2020/3/24
 **/
@Controller
public class HeroPalaceHandler extends ProtocolHandler {

    @Autowired
    private HeroPalaceSysCache heroPalaceSysCache;

    @Autowired
    private HeroPalaceService heroPalaceService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private ServerConfig serverConfig;

    @CMD(id = CmdCode._63001)
    public void sendData(PlayerContext playerContext, HeroPalaceGMsg.GReqHeroPalaceData req) {
        Set<Integer> allType = heroPalaceSysCache.getAllType();
        HeroPalaceGMsg.GResHeroPalaceData.Builder builder = HeroPalaceGMsg.GResHeroPalaceData.newBuilder();
        HeroPalaceSelf heroPalaceSelf = heroPalaceService.loadPalaceSelf(playerContext.getId());
        Role role = roleService.getOrThrow(playerContext.getId());
        allType.forEach(type -> {
            HeroPalace heroPalace = heroPalaceService.loadPalace(type);
            HeroPalaceGMsg.PSHeroPalace.Builder heroPalaceBuilder = HeroPalaceGMsg.PSHeroPalace.newBuilder();
            heroPalaceBuilder.setType(type);
            if (heroPalace.getRankRid().size() > 0) {
                heroPalace.getRankRid().forEach(rid -> {
                    Role rankRole = roleService.getOrThrow(rid);
                    if (rankRole.getServerId() == role.getServerId()) {
                        heroPalaceBuilder.addRankRole(PbUtil.builderRoleInfo(rankRole));
                    }
                });
            }
            heroPalaceBuilder.setIsReward(heroPalaceSelf.getRewardType().contains(type));
            heroPalaceBuilder.setIsWorship(heroPalaceSelf.getWorshipType().contains(type));

            for (Integer subServerId : serverConfig.getSubServerIds()) {
                HeroPalaceGMsg.PSServerHeroPalace.Builder serverRankBuilder = HeroPalaceGMsg.PSServerHeroPalace.newBuilder();
                serverRankBuilder.setServerId(subServerId);
                heroPalace.getRankRid().forEach(rid -> {
                    Role rankRole = roleService.getOrThrow(rid);
                    if (rankRole.getServerId() == subServerId) {
                        serverRankBuilder.addRankRole(PbUtil.builderRoleInfo(rankRole));
                    }
                });
                heroPalaceBuilder.addServerRankRole(serverRankBuilder);
            }
            builder.addHeroPalace(heroPalaceBuilder);
        });
        playerContext.write(CmdCode._63001, builder.build());
    }

    @CMD(id = CmdCode._63002)
    public void worship(PlayerContext playerContext, HeroPalaceGMsg.GReqHeroPalaceWorship req) {
        HeroPalaceSelf heroPalaceSelf = heroPalaceService.loadPalaceSelf(playerContext.getId());
        HeroPalace heroPalace = heroPalaceService.loadPalace(req.getType());

        Asserts.isTrue(heroPalace.getRankRid().size() > 0, ErrorCode.HERO_PALACE_NOT_EXIST.getValue(),
                String.format("不存在膜拜对象{%s}-{%s}", heroPalace.getRankRid().size(), req.getType()));

        Asserts.isTrue(!heroPalaceSelf.getWorshipType().contains(req.getType()), ErrorCode.HERO_PALACE_NOT_EXIST.getValue(),
                String.format("已经膜拜{%s}", req.getType()));

        thingService.add(playerContext.getId(), HeroPalaceConst.heroPalaceLikeReward, GameEvent.HERO_PALACE_LIKE_REWARD);

        heroPalaceSelf.getWorshipType().add(req.getType());
        heroPalaceService.update(heroPalaceSelf);

        HeroPalaceGMsg.GResHeroPalaceData.Builder builder = HeroPalaceGMsg.GResHeroPalaceData.newBuilder();
        HeroPalaceGMsg.PSHeroPalace.Builder heroPalaceBuilder = HeroPalaceGMsg.PSHeroPalace.newBuilder();
        heroPalaceBuilder.setType(req.getType());
        heroPalace.getRankRid().forEach(rid -> {
            heroPalaceBuilder.addRankRole(PbUtil.builderRoleInfo(roleService.getOrThrow(rid)));
        });
        heroPalaceBuilder.setIsReward(heroPalaceSelf.getRewardType().contains(req.getType()));
        heroPalaceBuilder.setIsWorship(heroPalaceSelf.getWorshipType().contains(req.getType()));
        builder.addHeroPalace(heroPalaceBuilder);
        playerContext.write(CmdCode._63002, builder.build());
    }

    @CMD(id = CmdCode._63003)
    public void getReward(PlayerContext playerContext, HeroPalaceGMsg.GReqHeroPalaceGetReward req) {
        HeroPalaceSelf heroPalaceSelf = heroPalaceService.loadPalaceSelf(playerContext.getId());
        Role role = roleService.getOrThrow(playerContext.getId());
        HeroPalace heroPalace = heroPalaceService.loadPalace(req.getType());
        List<Long> rankIds=new ArrayList<>();
        for (Long ridTemp : heroPalace.getRankRid()) {
            if (role.getServerId() == roleService.getOrThrow(ridTemp).getServerId()) {
                rankIds.add(ridTemp);
            }
        }
        int rank = rankIds.indexOf(playerContext.getId());
        Asserts.isTrue(rank >= 0, ErrorCode.HERO_PALACE_NOT_EXIST.getValue(),
                String.format("不存在膜拜对象{%s}-{%s}", heroPalace.getRankRid().size(), req.getType()));

        Asserts.isTrue(!heroPalaceSelf.getRewardType().contains(req.getType()), ErrorCode.HERO_PALACE_TYPE_HAD_REWARD.getValue(),
                String.format("排名奖励已经领取{%s}", req.getType()));
        CHeroPalace cHeroPalace = heroPalaceSysCache.getAllByType(req.getType()).get(rank + 1);

        thingService.add(playerContext.getId(), cHeroPalace.getReward(), GameEvent.HERO_PALACE_RANK_REWARD);

        heroPalaceSelf.getRewardType().add(req.getType());
        heroPalaceService.update(heroPalaceSelf);

        HeroPalaceGMsg.GResHeroPalaceGetReward.Builder builder = HeroPalaceGMsg.GResHeroPalaceGetReward.newBuilder();
        builder.setType(req.getType());
        playerContext.write(CmdCode._63003, builder.build());
    }

}
