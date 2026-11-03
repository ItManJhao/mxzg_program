package com.ayjs.mxzg.tools.client.client.network;

import com.ayjs.mxzg.common.netty.GameMessage;
import com.ayjs.mxzg.protocol.HeroGMsg;
import com.ayjs.mxzg.protocol.LoginGMsg;
import com.ayjs.mxzg.protocol.PvpGMsg;
import com.ayjs.mxzg.tools.client.client.ClientCMD;
import com.ayjs.mxzg.tools.client.client.base.BackPack;
import com.google.protobuf.Message;
import io.netty.channel.Channel;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * 客户端session
 *
 * @author tangyangbo 2019/8/6 17:01
 */
@Slf4j
@Getter
@Setter
public class ClientSession {

    private int id;
    private Channel channel;
    private String openid;
    private long userId;
    private int platform;
    private String pwd;
    private long rid;
    private String nickname;
    private int level;
    /**
     * 消息编号
     */
    private int clientIndex;
    private int serverId;
    private String sessionId;
    // 已经发送的任务编号
    private int sendIndex;
    /**
     * 聊天间隔
     */
    private int chatPerTime;
    /**
     * 聊天文本
     */
    private String chatContext;
    // 连接状态
    private ConnectStatus connectStatus = ConnectStatus.CONNECT;

    private int lastStateTime;

    private Map<Integer, BackPack> backpackDataMap = new HashMap<>();
    private Map<Long, HeroGMsg.ResHeroData> heroDataMap = new HashMap<>();

    /***
     * 替代id
     */
    private Map<Long, Long> heroIdReplace = new HashMap<>();

    private List<PvpGMsg.PSRankPlayerData> pvpList = new ArrayList<>();

    private int loginTime;


    public ClientSession(String openid, int serverId) {
        this.openid = openid;
        this.serverId = serverId;
    }


    public void sendHeartBeat() {
        writeAndFlush(ClientCMD.HEART_BEAT, LoginGMsg.GReqHeartBeat.getDefaultInstance());
    }


    public boolean writeAndFlush(int messageId, Message protoMessage) {
        if (Objects.isNull(channel) || !channel.isActive()) {
            log.error("client.getChannel() is null or not active," + rid);
            return false;
        }
        GameMessage message = new GameMessage();
        message.setCmd(messageId);
        message.setMsg(protoMessage.toByteArray());
        channel.writeAndFlush(message);
        return true;
    }

    public void putHeroToMap(HeroGMsg.ResHeroData resHeroData) {
        heroDataMap.put(resHeroData.getHeroId(), resHeroData);
    }

    public long getReplaceHeroId(long srcHeroId) {
        Long heroId = heroIdReplace.get(srcHeroId);
        if (srcHeroId == 0) {
            heroIdReplace.put(srcHeroId, 0l);
            return 0;
        }
        if (heroId == null) {
            List<HeroGMsg.ResHeroData> heroStarSort = heroDataMap.values().stream().sorted(new Comparator<HeroGMsg.ResHeroData>() {
                @Override
                public int compare(HeroGMsg.ResHeroData o1, HeroGMsg.ResHeroData o2) {
                    return o2.getStar() - o1.getStar();
                }
            }).collect(Collectors.toList());
            for (HeroGMsg.ResHeroData heroData : heroStarSort) {
                if (!heroIdReplace.containsValue(heroData.getHeroId())) {
                    heroId = heroData.getHeroId();
                    heroIdReplace.put(srcHeroId, heroId);
                }
            }
        }
        return heroId == null ? 0 : heroId;
    }

}


