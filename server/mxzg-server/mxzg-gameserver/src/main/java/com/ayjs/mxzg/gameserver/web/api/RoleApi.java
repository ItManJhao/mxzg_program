package com.ayjs.mxzg.gameserver.web.api;

import com.alibaba.fastjson.JSON;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.OfflineEvent;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.push.service.PushNotificationService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.constant.ServerParamType;
import com.ayjs.mxzg.gameserver.module.server.domain.ServerParam;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.web.constant.WebErrorCode;
import com.ayjs.mxzg.gameserver.web.event.RoleForbidChatEvent;
import com.ayjs.mxzg.gameserver.web.event.RoleForbidEvent;
import com.ayjs.mxzg.gameserver.web.support.WebResult;
import com.ayjs.mxzg.protocol.LoginGMsg.GResOffline;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Stream;

@Slf4j
@RestController
@RequestMapping("/role")
public class RoleApi {

    @Autowired
    private RoleService roleService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private ServerParamService serverParamService;
    @Autowired
    private PushNotificationService pushNotificationService;

    /**
     * 封禁，禁言操作
     * /role/loginChatForbid
     *
     * @param rids          rid列表都好分割
     * @param type          类型，1封号，2禁言
     * @param forbidEndTime 封禁的结束时间，小于当前时间为解禁，大于当前时间为封禁
     * @return
     */
    @RequestMapping(value = "/loginChatForbid", method = RequestMethod.GET)
    public String loginChatForbid(@RequestParam(name = "rids") String rids, @RequestParam(name = "type") int type,
                                  @RequestParam(name = "forbidEndTime") int forbidEndTime) {
        try {
            if (StringUtils.isNotBlank(rids)) {
                String[] ridArray = rids.split(",");

                int nowTime = TimeDateUtil.getCurrentTimeInt();

                Set<Long> forbidSet = new HashSet<>();
                for (String ridStr : ridArray) {
                    Role role = roleService.getOrThrow(Long.parseLong(ridStr));
                    if (type == 1) {
                        // 封号
                        role.setForbidEndTime(forbidEndTime);
                        if (forbidEndTime > nowTime) {
                            forbidSet.add(role.getId());
                        }
                    } else if (type == 2) {
                        // 禁言
                        role.setForbidWordsEndTime(forbidEndTime);
                        forbidSet.add(role.getId());
                    }
                    roleService.updateRole(role);
                }

                if (!forbidSet.isEmpty()) {
                    if (type == 1) {
                        // 通知封号
                        eventBus.post(RoleForbidEvent.of(forbidSet, forbidEndTime));
                    } else if (type == 2) {
                        // 通知禁言
                        eventBus.post(RoleForbidChatEvent.of(forbidSet, forbidEndTime));
                    }
                }
                return GJsonUtils.toJson(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
            } else {
                return GJsonUtils.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), "RIDS EMPTY"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            return GJsonUtils.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), "EXCEPTION"));
        }
    }


    /**
     * 踢玩家下线
     * /role/offlineAll
     *
     * @param defend_end_time
     * @return
     */
    @RequestMapping("/offlineAll")
    public String offlineAll(int defend_end_time) {

        GResOffline.Builder builder = GResOffline.newBuilder();
        builder.setType(2);
        contextManager.writeAll(CmdCode._1003, builder.build());
        contextManager.getAllOnline().stream().filter(playerContext -> playerContext.getId() > 0)
                .forEach(player -> contextManager.playerOffline(player, OfflineEvent.RoleApi_offlineAll));

        ServerParam serverParam = serverParamService.get(ServerParamType.DEFEND_END_TIME);
        if (serverParam == null) {
            serverParam = new ServerParam();
            serverParam.setSpKey(ServerParamType.DEFEND_END_TIME.getValue());
            serverParam.setSpValue(defend_end_time + "");
            serverParamService.add(serverParam);
        } else {
            serverParam.setSpValue(defend_end_time + "");
            serverParamService.update(serverParam);
        }

        return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
    }

    /**
     * 角色信息
     * /role/roleInfo
     * @param server_id
     * @param user_id
     * @return
     */
    @RequestMapping(value = "/roleInfo", method = RequestMethod.GET)
    public String roleInfo(@RequestParam(name = "server_id") int server_id, @RequestParam(name = "user_id") String user_id) {
        long userId = ConvertUtils.toLong(user_id);
        Role role = roleService.getByUserId(server_id, userId);
        if (Objects.isNull(role)) {
            return JSON.toJSONString(WebResult.of(WebErrorCode.FAIL.getCode(), "role is null"));
        }
        Map<String, String> result = new HashMap<>();
        result.put("role_id", ConvertUtils.toString(role.getId()));
        result.put("role_name", role.getNick());
        result.put("role_level", ConvertUtils.toString(role.getLevel()));

        return GJsonUtils.toJson(WebResult.of(WebErrorCode.SUCCESS.getCode(), GJsonUtils.toJson(result)));
    }

    /**
     * 推送
     * /role/push
     * @param roleId
     * @param title
     * @param context
     * @return
     */
    @RequestMapping(value = "/push", method = RequestMethod.GET)
    public String push(@RequestParam(name = "role_id", required = false) String roleId,
                       @RequestParam(name = "title", required = false) String title,
                       @RequestParam(name = "context", required = false) String context) {
        try {
            if (StringUtils.isBlank(roleId)) {
                return JSON.toJSONString(WebResult.of(WebErrorCode.FAIL.getCode(), "role id is null", "role id is null"));
            }
            if ("All".equalsIgnoreCase(roleId)) {
                roleService.getAllRole().forEach(role -> {
                    pushNotificationService.sendPushInfo(role.getId(), title, context);
                });
            } else {
                String[] rids = roleId.split(",");
                Stream.of(rids).forEach(strRid -> {
                    if (StringUtils.isNotBlank(strRid)) {
                        long rid = ConvertUtils.toLong(strRid);
                        pushNotificationService.sendPushInfo(rid, title, context);
                    }
                });
            }

            log.info("roleId :{} title:{} content:{}", roleId, title, context);
        } catch (Exception e) {
            e.printStackTrace();
            log.error("push error,", e);
            return JSON.toJSONString(WebResult.of(WebErrorCode.FAIL.getCode(), e.getMessage(), e.getMessage()));
        }
        return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
    }
}
