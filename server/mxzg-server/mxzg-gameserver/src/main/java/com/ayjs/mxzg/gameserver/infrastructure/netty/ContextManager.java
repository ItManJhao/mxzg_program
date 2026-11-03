/**
 *
 */
package com.ayjs.mxzg.gameserver.infrastructure.netty;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.netty.GameMessage;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.event.LogoutEvent;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.protobuf.GeneratedMessage;
import io.netty.channel.Channel;
import io.netty.util.ReferenceCountUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.LongPredicate;
import java.util.stream.Collectors;

/**
 * @author YY
 */
@Slf4j
@Service
public class ContextManager implements Lifecycle {

    @Autowired
    private RoleService roleService;
    @Autowired
    private EventBus eventBus;
    /** 服务器状态 */
    private volatile boolean shutdown;

    private Map<Long, PlayerContext> onlinePlayer = new ConcurrentHashMap<>();

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.LOW, Integer.MAX_VALUE, "CONTEXT_MANAGER");
    }

    @Override
    public void stop() throws Exception {
        this.shutdown = true;
        for (PlayerContext context : this.onlinePlayer.values()) {
            playerOffline(context, OfflineEvent.ContextManager_stop);
        }
    }

    public void addToOnline(PlayerContext playerContext) {
        if (this.shutdown) {
            playerContext.writeError(ErrorCode.SERVER_MAINTENANCE);
        }
        if (playerContext.getId() > 0){
            onlinePlayer.put(playerContext.getId(), playerContext);
        } else {
        	StackTraceElement[] elements = new RuntimeException().getStackTrace();
        	for(StackTraceElement element : elements) {
        		log.error(element.toString());
        	}
        }
    }

    public PlayerContext getOnline(long rid) {
        return onlinePlayer.get(rid);
    }

    public int onlineNum() {
        return onlinePlayer.size();
    }

    public boolean isOnline(long rid) {
        return onlinePlayer.containsKey(rid);
    }

    public void playerOffline(long rid, int eventId) {
        PlayerContext playerContext = getOnline(rid);
        if (Objects.nonNull(playerContext)) {
            playerOffline(playerContext, eventId);
        }
    }

    public void playerOffline(PlayerContext playerContext, int eventId) {
        long rid = playerContext.getId();
        playerContext.setLogin(false);
        PlayerContext onlinePlayerContext = onlinePlayer.get(rid);

        // netty 断开事件不是同一个连接，只处理断开连接
        if (eventId == OfflineEvent.NettyHandler_channelInactive && onlinePlayerContext != null
                && playerContext != onlinePlayerContext) {
            playerContext.stopActor();
            Channel channel = playerContext.getChannel();
            if (Objects.nonNull(channel)) {
                channel.close();
            }
            log.debug("playerOffline rid:{}, event:{} oldPlayerContext:{} onlinePlayerContext:{}",
                    rid, eventId, playerContext, onlinePlayerContext);
            return;
        }

        if (rid > 0 && onlinePlayer.remove(rid) != null) {
            Role role = roleService.getOrThrow(rid);
            role.setOnline(0);
            role.setLastOfflineTime(TimeDateUtil.getCurrentTime());
            roleService.updateRole(role);

            playerContext.stopActor();

            // 其他下线逻辑
            eventBus.post(LogoutEvent.of(rid, eventId, role.getUserId(), role.getPlatform(),
                    role.getLevel(), (int) (role.getLastOfflineTime() / 1000),
                    (int) (role.getLastOfflineTime() - role.getLastLoginTime()) / 1000));
            log.warn("rid:{} offline event:{}", rid, eventId);
        }
    }

    public Collection<PlayerContext> getAllOnline() {
        return onlinePlayer.values().stream().filter(playerContext -> playerContext.getId() > 0).collect(Collectors.toList());
    }

    public Set<Long> getOnlineRids() {
        return onlinePlayer.keySet().stream().filter(rid -> rid > 0).collect(Collectors.toSet());
    }

    public void write(long rid, int cmd, GeneratedMessage msg) {
        PlayerContext playerContext = getOnline(rid);
        if (playerContext == null) {
            return;
        }
        playerContext.write(cmd, msg);
    }

    public void writeError(long rid, ErrorCode errorCode, Object... params) {
        PlayerContext playerContext = getOnline(rid);
        if (playerContext == null) {
            return;
        }
        playerContext.writeError(errorCode, params);
    }


    public void writeAll(int cmd, GeneratedMessage msg) {
        GameMessage message = new GameMessage();
        message.setCmd(cmd);
        message.setMsg(msg.toByteArray());
        onlinePlayer.values().forEach(playerContext -> {
            playerContext.write(message, msg);
        });
        ReferenceCountUtil.release(message);
    }

    public void writeSome(Collection<Long> rids, int cmd, GeneratedMessage msg) {
        GameMessage message = new GameMessage();
        message.setCmd(cmd);
        message.setMsg(msg.toByteArray());
        for (long rid : rids) {
            PlayerContext playerContext = onlinePlayer.get(rid);
            if (playerContext != null) {
                playerContext.write(message, msg);
            }
        }
        ReferenceCountUtil.release(message);
    }

    /**
     * 按条件给玩家发送数据
     */
    public void write(int cmd, GeneratedMessage msg, LongPredicate condition) {
        GameMessage message = new GameMessage();
        message.setCmd(cmd);
        message.setMsg(msg.toByteArray());
        onlinePlayer.values().forEach(playerContext -> {
            try {
                if (playerContext != null && condition.test(playerContext.getId())) {
                    playerContext.write(message, msg);
                }
            } catch (Exception e){
                log.error("rid:{} message cmd :{}",playerContext.getId(),message.getCmd() );
                e.printStackTrace();
            }
        });
        ReferenceCountUtil.release(message);
    }
}
