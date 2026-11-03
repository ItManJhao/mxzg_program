package com.ayjs.mxzg.gameserver.web.api;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanMember;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.web.constant.WebErrorCode;
import com.ayjs.mxzg.gameserver.web.support.WebResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Objects;

/**
 * @Author: CWJ
 * @Date: 2020/6/4
 **/
@Slf4j
@RequestMapping("/clan")
@RestController
public class ClanApi {

    @Autowired
    private ClanService clanService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private RoleService roleService;

    @RequestMapping(value = "/resetDesc", method = RequestMethod.GET)
    public String getChatLog(@RequestParam("clanId") long clanId, @RequestParam("desc") String desc) {
        try {
            Clan clan = clanService.getOrThrow(clanId);
            clan.setClanDesc(desc == null ? "" : desc);
            clanService.updateClan(clan);
            return JsonUtil.toJson(WebResult.of(WebErrorCode.SUCCESS.getCode(), String.format("修改公会公告成功{%s}-{%s}", clanId, desc)));
        } catch (Exception e) {
            return JsonUtil.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), String.format("修改公会公告失败{%s}-{%s}", clanId, desc)));
        }

    }

    @RequestMapping(value = "/chargePosition", method = RequestMethod.GET)
    public String chargePosition(@RequestParam("clanId") long clanId, @RequestParam("rid") long rid, @RequestParam("position") int position) {
        try {
            Clan clan = clanService.getOrThrow(clanId);
            ClanMember member = clanService.selectClanMemberOne(clanId, rid);

            if (Objects.isNull(member)) {
                return JsonUtil.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), String.format("公会成员不存在{%s}-{%s}", clanId, rid)));
            }
            if (position < 1 || position > 3) {
                return JsonUtil.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), String.format("职位错误{%s}", position)));
            }

            if (member.getPosition() == position) {
                return JsonUtil.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), String.format("设置的职位相同{%s}", position)));
            }

            if (member.getPosition() == 1) {
                clan.setClanHeadRid(0);
                clan.setClanHeadName("");
                clanService.updateClan(clan);
            }
            member.setPosition(position);
            if (member.getPosition() == 1) {
                long oldHeadId = clan.getClanHeadRid();
                ClanMember oldHead = clanService.selectClanMemberOne(clanId, oldHeadId);
                if (oldHead != null) {
                    oldHead.setPosition(3);
                    clanService.updateClanMember(oldHead);
                }
                clan.setClanHeadRid(rid);
                clan.setClanHeadName(roleService.getOrThrow(rid).getNick());
                clanService.updateClan(clan);
            }
            clanService.updateClanMember(member);
//            eventBus.post(ClanJobChangeEvent.of(clanId, 0, rid,
//                    ClanJobEnum., ClanJobEnum., DateTimeUtil.currentSecond()));

            return JsonUtil.toJson(WebResult.of(WebErrorCode.SUCCESS.getCode(), String.format("修改公会职位成功{%s}-{%s} {%s}", clanId, rid, position)));
        } catch (Exception e) {
            log.error("", e);
            return JsonUtil.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), String.format("修改公会职位失败{%s}-{%s}  {%s} ", clanId, rid, position)));
        }

    }

}
