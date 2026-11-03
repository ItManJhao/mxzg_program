package com.ayjs.mxzg.gameserver.module.border.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeConstants;
import com.ayjs.mxzg.config.excel.cache.BorderSysCache;
import com.ayjs.mxzg.config.excel.entity.CBorder;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.border.constant.BorderActiveType;
import com.ayjs.mxzg.gameserver.module.border.domain.Border;
import com.ayjs.mxzg.gameserver.module.border.event.RoleBorderEvent;
import com.ayjs.mxzg.gameserver.module.border.service.BorderService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.BroderGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2019/10/28
 **/
@Component
public class BorderHandler extends ProtocolHandler {
    @Autowired
    private BorderService borderService;
    @Autowired
    private BorderSysCache borderSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private EventBus eventBus;

    /***
     * 发送数据
     * @param playerContext
     * @param req
     */
    @CMD(id = CmdCode._32001)
    public void sendData(PlayerContext playerContext, BroderGMsg.GReqBorderData req) {
        BroderGMsg.GResBorderData.Builder builder = BroderGMsg.GResBorderData.newBuilder();
        Role role = roleService.getOrThrow(playerContext.getId());
        boolean usedActive = false;
        CBorder freeConfig = null;
        for (CBorder config : borderSysCache.getAll()) {
            Border border = borderService.get(playerContext.getId(), config.getIcon());
            freeConfig = config.getActive_type() == BorderActiveType.FREE.getType() ? config : freeConfig;
            if (border == null && config.getActive_type() == BorderActiveType.FREE.getType()) {
                //激活未激活的免费头像框
                border = borderService.load(playerContext.getId(), config.getIcon());
                if (!border.isActive()) {
                    border.setExpireTime(config.getLimit_time());
                    borderService.update(border);
                }
            }
            if (border != null) {
                if (border.isActive()) {
                    builder.addUnits(borderService.builderUnit(border));
                } else {
                    if (role.getBorderId() == border.getConfigId()) {
                        usedActive = true;
                    }
                }
            }
        }
        playerContext.write(CmdCode._32001, builder.build());
        //正在使用的过期了，将边框设置为免费头像框
        if (usedActive) {
            role.setBorderId(freeConfig.getIcon());
            roleService.updateRole(role);
            BroderGMsg.GResUseBorder.Builder useBuilder = BroderGMsg.GResUseBorder.newBuilder();
            useBuilder.setIdx(freeConfig.getIcon());
            playerContext.write(CmdCode._32003, useBuilder.build());
        }
    }


    @CMD(id = CmdCode._32002)
    public void activeBorder(PlayerContext playerContext, BroderGMsg.GReqUseBorder req) {
        int idx = req.getIdx();
        long rid = playerContext.getId();
        CBorder config = borderSysCache.getOrThrow(idx);
        Asserts.isTrue(config.getActive_type() == BorderActiveType.ITEM.getType(), ErrorCode.BORDER_NOT_EXIST.getValue(), String.format("激活类型不是道具激活，配置id[%s],激活类型[%s],", idx, config.getActive_type()));
        Border border = borderService.load(rid, idx);
        Asserts.isTrue(!border.isActive(), ErrorCode.BORDER_ACTIVATED.getValue(), String.format("头像框[%s]已激活，不能重复激活！", idx));

        thingService.cost(rid, ImmutableThingUtil.fromJson(config.getCondition()), GameEvent.BORDER);

        if (config.getLimit_time() > 0) {
            border.setExpireTime(DateTimeUtil.tomorrowBreak() + config.getLimit_time() * TimeConstants.ONE_DAY_SECOND);
        } else {
            border.setExpireTime(config.getLimit_time());
        }
        borderService.update(border);

        BroderGMsg.GResActiveBorder.Builder builder = BroderGMsg.GResActiveBorder.newBuilder();
        builder.setUnit(borderService.builderUnit(border));

        playerContext.write(CmdCode._32002, builder.build());
    }

    @CMD(id = CmdCode._32003)
    public void useBorder(PlayerContext playerContext, BroderGMsg.GReqUseBorder req) {
        Border border = borderService.get(playerContext.getId(), req.getIdx());
        Role role = roleService.getOrThrow(playerContext.getId());
        Asserts.notNull(border, ErrorCode.BORDER_NOT_ACTIVE.getValue(), String.format("头像框未激活,头像框id：%s", req.getIdx()));
        Asserts.isTrue(border.isActive(), ErrorCode.BORDER_NOT_ACTIVE.getValue(), String.format("头像框[%s]已过期！,过期时间[%s]", req.getIdx(), border.getExpireTime()));
        Asserts.isTrue(role.getBorderId() != req.getIdx(), ErrorCode.BORDER_HAD_USE.getValue(), String.format("头像框[%s]已使用！", req.getIdx()));
        role.setBorderId(border.getConfigId());
        roleService.updateRole(role);

        BroderGMsg.GResUseBorder.Builder builder = BroderGMsg.GResUseBorder.newBuilder();
        builder.setIdx(req.getIdx());
        playerContext.write(CmdCode._32003, builder.build());

        eventBus.post(RoleBorderEvent.of(playerContext.getId(), req.getIdx()));
    }
}
