/**
 *
 */
package com.ayjs.mxzg.gameserver.module.friend.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.constant.FriendConst;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.friend.domain.BlackList;
import com.ayjs.mxzg.gameserver.module.friend.domain.FriendShip;
import com.ayjs.mxzg.gameserver.module.friend.domain.PrivateChat;
import com.ayjs.mxzg.gameserver.module.friend.domain.Relationship;
import com.ayjs.mxzg.gameserver.module.friend.domain.RelationshipReq;
import com.ayjs.mxzg.gameserver.module.friend.event.FriendAddEvent;
import com.ayjs.mxzg.gameserver.module.friend.event.FriendGiveEvent;
import com.ayjs.mxzg.gameserver.module.friend.service.BlackListService;
import com.ayjs.mxzg.gameserver.module.friend.service.FriendShipService;
import com.ayjs.mxzg.gameserver.module.friend.service.PrivateChatService;
import com.ayjs.mxzg.gameserver.module.friend.service.RelationshipReqService;
import com.ayjs.mxzg.gameserver.module.friend.service.RelationshipService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.message.module.role.dao.CrossRoleRedisDao;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.protocol.FriendGMsg;
import com.ayjs.mxzg.protocol.FriendGMsg.GReqFriendChatList;
import com.ayjs.mxzg.protocol.FriendGMsg.GReqFriendsAdd;
import com.ayjs.mxzg.protocol.FriendGMsg.GReqFriendsAgree;
import com.ayjs.mxzg.protocol.FriendGMsg.GReqFriendsDelete;
import com.ayjs.mxzg.protocol.FriendGMsg.GReqFriendsGive;
import com.ayjs.mxzg.protocol.FriendGMsg.GReqFriendsGiveAll;
import com.ayjs.mxzg.protocol.FriendGMsg.GReqFriendsList;
import com.ayjs.mxzg.protocol.FriendGMsg.GReqFriendsRequestList;
import com.ayjs.mxzg.protocol.FriendGMsg.GReqFriendsReward;
import com.ayjs.mxzg.protocol.FriendGMsg.GReqFriendsRewardAll;
import com.ayjs.mxzg.protocol.FriendGMsg.GReqFriendsSearch;
import com.ayjs.mxzg.protocol.FriendGMsg.GResFriendApplying;
import com.ayjs.mxzg.protocol.FriendGMsg.GResFriendChatList;
import com.ayjs.mxzg.protocol.FriendGMsg.GResFriendsAdd;
import com.ayjs.mxzg.protocol.FriendGMsg.GResFriendsAgree;
import com.ayjs.mxzg.protocol.FriendGMsg.GResFriendsDelete;
import com.ayjs.mxzg.protocol.FriendGMsg.GResFriendsGift;
import com.ayjs.mxzg.protocol.FriendGMsg.GResFriendsGive;
import com.ayjs.mxzg.protocol.FriendGMsg.GResFriendsGiveAll;
import com.ayjs.mxzg.protocol.FriendGMsg.GResFriendsList;
import com.ayjs.mxzg.protocol.FriendGMsg.GResFriendsRequestList;
import com.ayjs.mxzg.protocol.FriendGMsg.GResFriendsReward;
import com.ayjs.mxzg.protocol.FriendGMsg.GResFriendsRewardAll;
import com.ayjs.mxzg.protocol.FriendGMsg.GResFriendsSearch;
import com.ayjs.mxzg.protocol.FriendGMsg.ResFriendChatData;
import com.ayjs.mxzg.protocol.FriendGMsg.ResFriendData;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * @author YY
 *
 */
@Controller
public class FriendHandler extends ProtocolHandler {

    @Autowired
    private RoleService roleService;
    @Autowired
    private RelationshipService relationshipService;
    @Autowired
    private ClanService clanService;
    @Autowired
    private RelationshipReqService relationshipReqService;
    @Autowired
    private PrivateChatService privateChatService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private FriendShipService friendShipService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private BlackListService blackListService;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private CrossRoleRedisDao crossRoleRedisDao;

    @CMD(id = CmdCode._9001)
    public void friendsList(PlayerContext playerContext, GReqFriendsList msg) {

        FriendShip friendShip = friendShipService.getFriendShip(playerContext.getId());

        Map<Long, Relationship> shipMap = relationshipService.getShipMap(playerContext.getId());

        GResFriendsList.Builder builder = GResFriendsList.newBuilder();
        for (Relationship relationship : shipMap.values()) {
            builder.addList(serialize(relationship));
        }
        builder.setGiveCount(friendShip.getGiveFriends().size());
        playerContext.write(CmdCode._9001, builder.build());
    }

    public ResFriendData serialize(Relationship relationship) {
        Role role = roleService.getOrThrow(relationship.getRelationRid());

        FriendShip friendShip = friendShipService.getFriendShip(relationship.getRid());

        ResFriendData.Builder builder = ResFriendData.newBuilder();
        builder.setRoleId(role.getId());
        builder.setPlayerName(role.getNick());
        builder.setPlayerLevel(role.getLevel());
        builder.setCup(role.getArenaScore());
        builder.setOnlineStatus(role.getOnline());
        builder.setOfflineTime((int) (role.getLastOfflineTime() / 1000));
        builder.setBattle(role.getFighting());
        builder.setHeadId(role.getHeadId());
        builder.setBorderId(role.getBorderId());
        builder.setIsGived(friendShip.getGiveFriends().contains(role.getId()) ? 1 : 0);
        builder.setHasGift(relationship.getHasGift());
        builder.setClanId(role.getClanId());
        if (role.getClanId() > 0) {
            Clan clan = clanService.getOrThrow(role.getClanId());
            if (clan != null) {
                builder.setClanName(clan.getClanName());
                builder.setClanIconId(clan.getClanIcon());
            }
        }
        builder.setBorderId(role.getBorderId());
        return builder.build();
    }


    /**
     * 推荐好友只给在线的玩家
     * @param playerContext
     */
    private void getRecommendFriend(PlayerContext playerContext) {

        Map<Long, Relationship> friendMap = relationshipService.getShipMap(playerContext.getId());

        GResFriendsSearch.Builder builder = GResFriendsSearch.newBuilder();

        List<PlayerContext> list = new ArrayList<>(contextManager.getAllOnline());

        int randIndex = RandomUtil.getRandomInt(0, list.size() - 1);
        BlackList blackList = blackListService.load(playerContext.getId());

        for (int i = 0; i < list.size(); i++) {
            PlayerContext otherContext = list.get((i + randIndex) % list.size());
            if (otherContext.getId() == 0 || otherContext.getId() == playerContext.getId()) {
                continue;
            }
            if (friendMap.containsKey(otherContext.getId())) {
                continue;
            }

            //过滤掉黑名单
            if (blackList.getCrossBlacks().containsKey(otherContext.getId())) {
                continue;
            }

            //过滤掉黑名单
            if (blackListService.inMyBlacklist(otherContext.getId(), playerContext.getId())) {
                continue;
            }

            if (builder.getListCount() >= FriendConst.RECOMMEND_COUNT) {
                break;
            }
            Role other = roleService.getOrThrow(otherContext.getId());
            builder.addList(serializeSimple(other));
        }
        playerContext.write(CmdCode._9003, builder.build());
    }

    /**
     * 获取好友申请列表
     * @param rid
     */
    private void GetFriendReqList(long rid) {
        List<RelationshipReq> reqList = relationshipReqService.getRelationshipReqs(rid);
        GResFriendsRequestList.Builder builder = GResFriendsRequestList.newBuilder();
        for (RelationshipReq req : reqList) {
            Role roleData = roleService.getOrThrow(req.getRequestRid());
            builder.addList(serializeSimple(roleData));
        }
        contextManager.write(rid, CmdCode._9002, builder.build());
    }

    private ResFriendData serializeSimple(Role role) {
        ResFriendData.Builder builder = ResFriendData.newBuilder();
        builder.setRoleId(role.getId());
        builder.setPlayerName(role.getNick());
        builder.setPlayerLevel(role.getLevel());
        builder.setCup(role.getArenaScore());
        builder.setBattle(role.getFighting());
        builder.setHeadId(role.getHeadId());
        builder.setBorderId(role.getBorderId());
        builder.setOnlineStatus(role.getOnline());
        builder.setOfflineTime((int) (role.getLastOfflineTime() / 1000));
        builder.setServerId(role.getServerId());

        builder.setClanId(role.getClanId());
        if (role.getClanId() > 0) {
            Clan clan = clanService.getOrThrow(role.getClanId());
            if (clan != null) {
                builder.setClanName(clan.getClanName());
                builder.setClanIconId(clan.getClanIcon());
            }
        }
        return builder.build();
    }

    private ResFriendData serializeSimple(CrossRole role) {
        ResFriendData.Builder builder = ResFriendData.newBuilder();
        builder.setRoleId(role.getId());
        builder.setPlayerName(role.getNick());
        builder.setPlayerLevel(role.getLevel());
        builder.setCup(role.getArenaScore());
        builder.setBattle(role.getFighting());
        builder.setHeadId(role.getHeadId());
        builder.setBorderId(role.getBorderId());
        builder.setOfflineTime((int) (role.getLastOfflineTime() / 1000));
        builder.setServerId(role.getServerId());

        builder.setClanId(role.getClanId());
//        if (role.getClanId() > 0) {
//            Clan clan = clanService.getOrThrow(role.getClanId());
//            if (clan != null) {
//                builder.setClanName(clan.getClanName());
//                builder.setClanIconId(clan.getClanIcon());
//            }
//        }
        return builder.build();
    }


    @CMD(id = CmdCode._9002)
    public void friendsRequestList(PlayerContext playerContext, GReqFriendsRequestList msg) {
        this.GetFriendReqList(playerContext.getId());
    }

    @CMD(id = CmdCode._9003)
    public void friendsSearch(PlayerContext playerContext, GReqFriendsSearch msg) {
        if (msg.getRName() == null || "".equals(msg.getRName().trim())) {
            getRecommendFriend(playerContext);
            return;
        }
        GResFriendsSearch.Builder builder = GResFriendsSearch.newBuilder();

        List<Role> searchingRoles = roleService.getNameLike(msg.getRName().trim());
        Map<Long, Relationship> map = relationshipService.getShipMap(playerContext.getId());
        for (Role role : searchingRoles) {
            if (map.containsKey(role.getId())) {
                continue;
            }
            builder.addList(serializeSimple(role));
        }
        playerContext.write(CmdCode._9003, builder.build());
    }


    @CMD(id = CmdCode._9004)
    public void friendsAdd(PlayerContext playerContext, GReqFriendsAdd msg) {
        if (msg.getRid() == playerContext.getId()) {
            playerContext.writeError(ErrorCode.FRIEND_NOT_SELF);
            return;
        }

        if (blackListService.inMyBlacklist(playerContext.getId(), msg.getRid()) ||
                blackListService.inMyBlacklist(msg.getRid(), playerContext.getId())) {
            playerContext.writeError(ErrorCode.BLACK_LIST_HAD_ADD);
            return;
        }

        Map<Long, Relationship> shipMap = relationshipService.getShipMap(playerContext.getId());
        // 判断我的好友数量
        if (shipMap.size() >= FriendConst.GLOBAL_FRIEND_MAX) {
            playerContext.writeError(ErrorCode.FRIEND_NUM_LIMIT);
            return;
        }
        Role role = roleService.getOrThrow(playerContext.getId());
        if (shipMap.containsKey(msg.getRid())) {
            //已经是好友
            playerContext.writeError(ErrorCode.FRIEND_ALREADY);
            return;
        }
        Role targetRole = roleService.getOrThrow(msg.getRid());
        if (targetRole == null) {
            playerContext.writeError(ErrorCode.ROLE_NOT_EXIST);
            return;
        }
        Map<Long, Relationship> targetShipMap = relationshipService.getShipMap(targetRole.getId());
        // 判断对方好友数量
        if (targetShipMap.size() >= FriendConst.GLOBAL_FRIEND_MAX) {
            playerContext.writeError(ErrorCode.FRIEND_TARGET_LIMIT);
            return;
        }
        // 对方有没有当前玩家的请求
        List<RelationshipReq> shipReqList = relationshipReqService.getRelationshipReqs(targetRole.getId());
        for (RelationshipReq req : shipReqList) {
            if (req.getRequestRid() == playerContext.getId()) {
                //前端需要飘字提示
                GResFriendsAdd.Builder builder = GResFriendsAdd.newBuilder();
                builder.setTargetNick(targetRole.getNick());
                playerContext.write(CmdCode._9004, builder.build());
                return;
            }
        }

        RelationshipReq req = new RelationshipReq();
        req.setRid(targetRole.getId());
        req.setRequestRid(playerContext.getId());
        req.setReqTime(TimeDateUtil.getCurrentTimeInt());
        relationshipReqService.addRelationshipReq(req);

        GResFriendsAdd.Builder builder = GResFriendsAdd.newBuilder();
        builder.setTargetNick(targetRole.getNick());
        playerContext.write(CmdCode._9004, builder.build());

        GResFriendApplying.Builder builder0 = GResFriendApplying.newBuilder();
        builder0.setResFriendData(serializeSimple(role));
        contextManager.write(targetRole.getId(), CmdCode._9015, builder0.build());
    }

    /**
     * 好友申请通过
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._9005)
    public void friendsAgree(PlayerContext playerContext, GReqFriendsAgree msg) {
        if (msg.getRoleId() == playerContext.getId()) {
            playerContext.writeError(ErrorCode.FRIEND_NOT_SELF);
            return;
        }
        Role targetRole = roleService.getOrThrow(msg.getRoleId());
        if (targetRole == null) {
            playerContext.writeError(ErrorCode.ROLE_NOT_EXIST);
            return;
        }

        List<RelationshipReq> reqList = relationshipReqService.getRelationshipReqs(playerContext.getId());

        RelationshipReq shipReq = null;
        for (RelationshipReq req : reqList) {
            if (req.getRequestRid() == msg.getRoleId()) {
                shipReq = req;
                break;
            }
        }
        if (msg.getAgreeStatus() == 2) {
            if (msg.getRoleId() == 0) {
                relationshipReqService.deleteRelationshipReq(reqList);
            } else {
                if (shipReq != null) {
                    relationshipReqService.deleteRelationshipReq(shipReq);
                }
            }
            //拒绝成为好友
            return;
        }
        if (shipReq == null) {
            playerContext.writeError(ErrorCode.FRIEND_APPLY_MISS);
            return;
        }

        //判断黑名单
        if (blackListService.inMyBlacklist(playerContext.getId(), msg.getRoleId()) ||
                blackListService.inMyBlacklist(playerContext.getId(), msg.getRoleId())) {
            playerContext.writeError(ErrorCode.BLACK_LIST_HAD_ADD);
            return;
        }


        String firstLock = null;
        String secondLock = null;
        if (playerContext.getId() < msg.getRoleId()) {
            firstLock = playerContext.getId() + "";
            secondLock = targetRole.getId() + "";
        } else {
            firstLock = targetRole.getId() + "";
            secondLock = playerContext.getId() + "";
        }

        try {
            synchronized (firstLock.intern()) {
                synchronized (secondLock.intern()) {
                    Map<Long, Relationship> shipMap = relationshipService.getShipMap(playerContext.getId());
                    // 判断我的好友数量
                    if (shipMap.size() >= FriendConst.GLOBAL_FRIEND_MAX) {
                        playerContext.writeError(ErrorCode.FRIEND_NUM_LIMIT);
                        return;
                    }
                    if (shipMap.containsKey(targetRole.getId())) {
                        //已经是好友
                        playerContext.writeError(ErrorCode.FRIEND_ALREADY);
                        return;
                    }
                    Map<Long, Relationship> targetShipMap = relationshipService.getShipMap(targetRole.getId());
                    // 判断对方好友数量
                    if (targetShipMap.size() >= FriendConst.GLOBAL_FRIEND_MAX) {
                        playerContext.writeError(ErrorCode.FRIEND_TARGET_LIMIT);
                        return;
                    }

                    List<Relationship> newList = new ArrayList<>();
                    Relationship thisToThat = new Relationship();
                    thisToThat.setRid(playerContext.getId());
                    thisToThat.setRelationRid(targetRole.getId());
                    thisToThat.setCreateTime(TimeDateUtil.getCurrentTimeInt());
                    newList.add(thisToThat);

                    Relationship thatToThis = new Relationship();
                    thatToThis.setRid(targetRole.getId());
                    thatToThis.setRelationRid(playerContext.getId());
                    thatToThis.setCreateTime(TimeDateUtil.getCurrentTimeInt());
                    newList.add(thatToThis);

                    relationshipService.addRelationships(newList);

                    GResFriendsAgree.Builder thisBuilder = GResFriendsAgree.newBuilder();
                    thisBuilder.setResFriendData(serialize(thisToThat));
                    playerContext.write(CmdCode._9005, thisBuilder.build());

                    GResFriendsAgree.Builder thatBuilder = GResFriendsAgree.newBuilder();
                    thatBuilder.setResFriendData(serialize(thatToThis));
                    contextManager.write(targetRole.getId(), CmdCode._9005, thatBuilder.build());

                    //检验对方是否有我的好友申请，有便删除.
                    RelationshipReq targetReq = relationshipReqService.selectRelationShipReq(msg.getRoleId(), playerContext.getId());
                    if (!Objects.isNull(targetReq)) {
                        relationshipReqService.deleteRelationshipReq(targetReq);
                        this.GetFriendReqList(msg.getRoleId());
                    }
                    eventBus.post(FriendAddEvent.of(playerContext.getId()));
                    eventBus.post(FriendAddEvent.of(targetRole.getId()));
                }
            }
        } finally {
            relationshipReqService.deleteRelationshipReq(shipReq);
        }
    }

    @CMD(id = CmdCode._9006)
    public void friendDel(PlayerContext playerContext, GReqFriendsDelete msg) {
        Map<Long, Relationship> shipMap = relationshipService.getShipMap(playerContext.getId());
        Relationship relationship = shipMap.get(msg.getRid());
        if (relationship == null) {
            playerContext.writeError(ErrorCode.FRIEND_SHIP_MISS);
            return;
        }

        doFriendDel(playerContext, relationship);
    }

    private void doFriendDel(PlayerContext playerContext, Relationship relationship) {
        Map<Long, Relationship> thatShipMap = relationshipService.getShipMap(relationship.getRelationRid());
        Relationship thatRelationship = thatShipMap.get(relationship.getRid());

        List<Relationship> deleteList = new ArrayList<>();
        deleteList.add(relationship);
        if (thatRelationship != null) {
            deleteList.add(thatRelationship);
        }
        relationshipService.deleteRelationships(deleteList);

        GResFriendsDelete.Builder builder = GResFriendsDelete.newBuilder();
        builder.setRid(relationship.getRelationRid());
        playerContext.write(CmdCode._9006, builder.build());

        //发送给对方
        GResFriendsDelete.Builder builder0 = GResFriendsDelete.newBuilder();
        builder0.setRid(playerContext.getId());
        contextManager.write(relationship.getRelationRid(), CmdCode._9006, builder0.build());
    }

    @CMD(id = CmdCode._9007)
    public void friendChatList(PlayerContext playerContext, GReqFriendChatList msg) {
        List<PrivateChat> chatList = privateChatService.getPrivateChats(playerContext.getId());

        GResFriendChatList.Builder builder = GResFriendChatList.newBuilder();

        //TODO 将超过一定时间的聊天记录移到历史库中
        //query.select("private_chat").where("rid").is(player.rid).and("time").gt(DateTime.dayBreak() - 259200)
//		.limit(3000);
        for (PrivateChat chat : chatList) {
            ResFriendChatData.Builder ele = ResFriendChatData.newBuilder();
            ele.setFriendId(chat.getFirendRid());
            Role role = roleService.getOrThrow(chat.getFirendRid());
            ele.setHeadId(role.getHeadId());
            ele.setBorderId(role.getBorderId());
            ele.setTime(chat.getTime());
            ele.setManageId(chat.getManageId());
            ele.setMsg(chat.getChatContent());
            ele.setBorderId(role.getBorderId());
            builder.addList(ele.build());
        }
        playerContext.write(CmdCode._9007, builder.build());
    }


    @CMD(id = CmdCode._9008)
    public void friendsGive(PlayerContext playerContext, GReqFriendsGive msg) {
        FriendShip friendShip = friendShipService.getFriendShip(playerContext.getId());

        Map<Long, Relationship> thisShipMap = relationshipService.getShipMap(playerContext.getId());
        Relationship thisRelationship = thisShipMap.get(msg.getRid());
        if (thisRelationship == null) {
            playerContext.writeError(ErrorCode.FRIEND_SHIP_MISS);
            return;
        }

        Map<Long, Relationship> thatShipMap = relationshipService.getShipMap(thisRelationship.getRelationRid());
        Relationship thatRelationship = thatShipMap.get(playerContext.getId());
        if (thatRelationship == null) {
            playerContext.writeError(ErrorCode.FRIEND_SHIP_MISS);
            return;
        }

        if (friendShip.getGiveFriends().contains(msg.getRid())) {
            playerContext.writeError(ErrorCode.FRIEND_HAD_GIVE);
            return;
        }

        Role role = roleService.getOrThrow(playerContext.getId());

        if (friendShip.getGiveFriends().size() >= FriendConst.REWARD_SEND_LIMIT) {
            //今天已达到赠送次数上限
            playerContext.writeError(ErrorCode.FRIEND_GIVING_FULL);
            return;
        }


        thatRelationship.setHasGift(1);
        relationshipService.updateRelationship(thatRelationship);

        friendShip.getGiveFriends().add(msg.getRid());
        friendShipService.updateFriendShip(friendShip);

        // 检查自身赠送次数。超过20次，赠送友情点自身奖不再奖励道具
        thingService.add(role.getId(), FriendConst.GIFT_SEND_REWARD, GameEvent.FRIEND_REWARD, NoticeType.SLIENT);
        // 向被赠送发送消息：消息体内含赠送者ID
        GResFriendsGive.Builder builder = GResFriendsGive.newBuilder();
        builder.setRid(thisRelationship.getRelationRid());
        Role targetRole = roleService.getOrThrow(thatRelationship.getRid());
        builder.setName(targetRole.getNick());
        builder.addAllRewards(PbUtil.buildReward(FriendConst.GIFT_SEND_REWARD));
        builder.setGiveCount(friendShip.getGiveFriends().size());
        playerContext.write(CmdCode._9008, builder.build());

        // 推送给对方有好友送礼物
        GResFriendsGift.Builder giftBuilder = GResFriendsGift.newBuilder();
        giftBuilder.setRid(playerContext.getId());
        contextManager.write(thisRelationship.getRelationRid(), CmdCode._9013, giftBuilder.build());

        eventBus.post(FriendGiveEvent.of(role.getId(), 1));
        // 更新好友赠送
//		LHAchievement.updateDailyTask(statements, player.rid, AchievementEvent.GIVE_FRIEND, 1);
    }


    @CMD(id = CmdCode._9010)
    public void friendGiveAll(PlayerContext playerContext, GReqFriendsGiveAll msg) {

        Map<Long, Relationship> thisShipMap = relationshipService.getShipMap(playerContext.getId());

        FriendShip friendShip = friendShipService.getFriendShip(playerContext.getId());
        if (friendShip.getGiveFriends().size() >= FriendConst.REWARD_SEND_LIMIT) {
            //今天已达到赠送次数上限
            playerContext.writeError(ErrorCode.FRIEND_GIVING_FULL);
            return;
        }

        List<Relationship> updateShips = new ArrayList<>();

        List<Role> onlineRole = new ArrayList<>();
        List<Role> offlineRole = new ArrayList<>();

        //按在线状态对好友进行分组
        for (Relationship relationship : thisShipMap.values()) {
            if (friendShip.getGiveFriends().contains(relationship.getRelationRid())) {
                continue;
            }
            Role targetRole = roleService.getOrThrow(relationship.getRelationRid());
            if (targetRole.getOnline() == 1) {
                onlineRole.add(targetRole);
            } else {
                offlineRole.add(targetRole);
            }
        }

        //按战力高低给在线玩家送赠礼
        onlineRole.sort(Comparator.comparingInt(Role::getFighting));
        Collections.reverse(onlineRole);
        sendGiftToFriend(friendShip, onlineRole, updateShips);

        //按离线时间长短给离线玩家送赠礼
        offlineRole.sort(Comparator.comparingLong(Role::getLastOfflineTime));
        Collections.reverse(offlineRole);
        sendGiftToFriend(friendShip, offlineRole, updateShips);

        if (updateShips.isEmpty()) {
            playerContext.writeError(ErrorCode.FRIEND_NO_GIVING);
            return;
        }

        relationshipService.updateRelationships(updateShips);
        // 修改赠送次数
        friendShipService.updateFriendShip(friendShip);

        // 若当前赠送好友自身还有奖励道具
        List<ImmutableThing> rewardList = ImmutableThingUtil.multiplyThing(FriendConst.GIFT_SEND_REWARD,
                updateShips.size());
        thingService.add(playerContext.getId(), rewardList, GameEvent.FRIEND_REWARD, NoticeType.SLIENT);

        GResFriendsGiveAll.Builder builder = GResFriendsGiveAll.newBuilder();
        for (Relationship targetShip : updateShips) {
            builder.addRids(targetShip.getRid());
            Role targetRole = roleService.getOrThrow(targetShip.getRid());
            builder.addNames(targetRole.getNick());
        }
        builder.addAllRewards(PbUtil.buildReward(FriendConst.GIFT_SEND_REWARD));
        builder.setGiveCount(friendShip.getGiveFriends().size());
        playerContext.write(CmdCode._9010, builder.build());

        // 推送给对方有好友送礼物
        GResFriendsGift.Builder giftBuilder = GResFriendsGift.newBuilder();
        giftBuilder.setRid(playerContext.getId());
        contextManager.writeSome(builder.getRidsList(), CmdCode._9013, giftBuilder.build());

        // 更新好友赠送
        eventBus.post(FriendGiveEvent.of(friendShip.getRid(), updateShips.size()));
//		LHAchievement.updateDailyTask(statements, player.rid, AchievementEvent.GIVE_FRIEND, list.size());
    }

    /**
     *
     * @param targetRoles 目标玩家列表
     * @param updateShips 需要更新的数据
     */
    private void sendGiftToFriend(FriendShip friendShip, List<Role> targetRoles, List<Relationship> updateShips) {
        if (friendShip.getGiveFriends().size() >= FriendConst.REWARD_SEND_LIMIT) {
            return;
        }
        int deadTime = TimeDateUtil.getCurrentTimeInt() - TimeDateUtil.ONEDAYINT * 7;
        for (Role targetRole : targetRoles) {
            if (deadTime < targetRole.getLastOfflineTime() || deadTime < targetRole.getLastLoginTime()) {
                //不是死号才去修改对方的数据，不然就“当”已经赠送过
                Relationship targetShip = relationshipService.getRelationship(targetRole.getId(), friendShip.getRid());
                if (targetShip == null) {
                    continue;
                }
                // 记录对方已经收到
                targetShip.setHasGift(1);
                updateShips.add(targetShip);
            }
            friendShip.getGiveFriends().add(targetRole.getId());
            if (friendShip.getGiveFriends().size() >= FriendConst.REWARD_SEND_LIMIT) {
                break;
            }
        }
    }

    @CMD(id = CmdCode._9011)
    public void receiveFriendGift(PlayerContext playerContext, GReqFriendsReward msg) {
        Map<Long, Relationship> thisShipMap = relationshipService.getShipMap(playerContext.getId());
        Relationship thisShip = thisShipMap.get(msg.getRid());
        if (thisShip == null) {
            playerContext.writeError(ErrorCode.FRIEND_SHIP_MISS);
            return;
        }
        if (thisShip.getHasGift() != 1) {
            //已领取
            playerContext.writeError(ErrorCode.FRIEND_GOT_GIFT);
            return;
        }
        Role role = roleService.getOrThrow(playerContext.getId());
        FriendShip friendShip = friendShipService.getFriendShip(playerContext.getId());


        List<ImmutableThing> rewardList = null;
        if (friendShip.getReceiveNum() >= FriendConst.REWARD_RECEIVE_LIMIT) {
            //领取次数达到上限则领取另外奖励
            rewardList = FriendConst.GIFT_RECEIVE_OVER_REWARD;
        } else {
            rewardList = FriendConst.GIFT_RECEIVE_REWARD;
        }

        friendShip.setReceiveNum(friendShip.getReceiveNum() + 1);
        friendShipService.updateFriendShip(friendShip);

        thisShip.setHasGift(2);
        relationshipService.updateRelationship(thisShip);

        thingService.add(role.getId(), rewardList, GameEvent.FRIEND_REWARD, NoticeType.SLIENT);

        GResFriendsReward.Builder builder = GResFriendsReward.newBuilder();
        builder.setRid(msg.getRid());
        builder.addAllRewards(PbUtil.buildReward(rewardList));
        playerContext.write(CmdCode._9011, builder.build());
    }

    @CMD(id = CmdCode._9012)
    public void receiveFriendGiftAll(PlayerContext playerContext, GReqFriendsRewardAll msg) {
        FriendShip friendShip = friendShipService.getFriendShip(playerContext.getId());
        Map<Long, Relationship> thisShipMap = relationshipService.getShipMap(playerContext.getId());

        List<Relationship> updateShips = new ArrayList<>();
        List<Long> rids = new ArrayList<>();
        for (Relationship thisShip : thisShipMap.values()) {
            if (thisShip.getHasGift() != 1) {
                //好友没有赠送
                continue;
            }
            thisShip.setHasGift(2);
            updateShips.add(thisShip);
            rids.add(thisShip.getRelationRid());
        }
        if (updateShips.isEmpty()) {
            playerContext.writeError(ErrorCode.FRIEND_NO_GIFT);
            return;
        }
        //剩余的可获取正常奖励的数量
        int receiveNum = FriendConst.REWARD_RECEIVE_LIMIT - friendShip.getReceiveNum();

        relationshipService.updateRelationships(updateShips);
        friendShip.setReceiveNum(friendShip.getReceiveNum() + updateShips.size());
        friendShipService.updateFriendShip(friendShip);

        int rewardNum = 0;
        int overRewardNum = 0;
        List<ImmutableThing> rewardList = new ArrayList<>();
        if (receiveNum > 0) {
            if (updateShips.size() > receiveNum) {
                rewardList.addAll(
                        ImmutableThingUtil.multiplyThing(FriendConst.GIFT_RECEIVE_REWARD, receiveNum));
                rewardList.addAll(ImmutableThingUtil.multiplyThing(FriendConst.GIFT_RECEIVE_OVER_REWARD,
                        updateShips.size() - receiveNum));

                rewardNum = receiveNum;
                overRewardNum = updateShips.size() - receiveNum;
            } else {
                rewardNum = updateShips.size();

                rewardList.addAll(
                        ImmutableThingUtil.multiplyThing(FriendConst.GIFT_RECEIVE_REWARD, rewardNum));
            }
        } else {
            rewardList.addAll(ImmutableThingUtil.multiplyThing(FriendConst.GIFT_RECEIVE_OVER_REWARD,
                    updateShips.size()));

            overRewardNum = updateShips.size();
        }
        rewardList = ImmutableThingUtil.mergeThing(rewardList);
        thingService.add(playerContext.getId(), rewardList, GameEvent.FRIEND_REWARD, NoticeType.SLIENT);

        GResFriendsRewardAll.Builder builder = GResFriendsRewardAll.newBuilder();
        builder.addAllRids(rids);
        builder.setRewardNum(rewardNum);
        builder.addAllRewards(PbUtil.buildReward(FriendConst.GIFT_RECEIVE_REWARD));
        builder.setOverRewardNum(overRewardNum);
        builder.addAllOverRewards(PbUtil.buildReward(FriendConst.GIFT_RECEIVE_OVER_REWARD));
        playerContext.write(CmdCode._9012, builder.build());
    }

    @CMD(id = CmdCode._9016)
    public void getBlackList(PlayerContext playerContext, FriendGMsg.GReqBlackList msg) {
        BlackList blackList = blackListService.load(playerContext.getId());
        FriendGMsg.GResBlackList.Builder builder = FriendGMsg.GResBlackList.newBuilder();
        blackList.getCrossBlacks().forEach((blackId, serverId) -> {
            if (serverId == 0 || serverConfig.matchServerId(serverId)) {
                builder.addBlackList(serializeSimple(roleService.getOrThrow(blackId)));
            } else {
                builder.addBlackList(serializeSimple(crossRoleRedisDao.get(blackId)));
            }
        });
        playerContext.write(CmdCode._9016, builder.build());

    }

    @CMD(id = CmdCode._9017)
    public void addBlackList(PlayerContext playerContext, FriendGMsg.GReqAddBlackList msg) {
        long blackId = msg.getRid();
        BlackList blackList = blackListService.load(playerContext.getId());

        Asserts.isTrue(blackList.getCrossBlacks().size() < systemSysCache.getBlacklistMaxNum(),
                ErrorCode.BLACK_LIST_NUM_LIMIT.getValue(),
                String.format("黑名单数量太多{%s}", blackList.getCrossBlacks().size()));

        Asserts.isTrue(!blackList.getCrossBlacks().containsKey(blackId),
                ErrorCode.BLACK_LIST_HAD_ADD.getValue(), String.format("已经加入黑名单{%s}", blackId));

        int serverId = msg.getServerId() == 0 ? serverConfig.getServerId() : msg.getServerId();
        if (serverConfig.matchServerId(serverId)) {
            Asserts.isTrue(roleService.isRole(blackId), ErrorCode.BLACK_LIST_HAD_ADD.getValue(),
                    String.format("角色id错误{%s}", blackId));
        } else {
            CrossRole crossRole = crossRoleRedisDao.get(msg.getRid());
            Asserts.isTrue(Objects.nonNull(crossRole), ErrorCode.BLACK_LIST_HAD_ADD.getValue(),
                    String.format("角色id错误{%s}", blackId));
        }

        blackList.getCrossBlacks().put(msg.getRid(), serverId);
        blackListService.update(blackList);

        //清除好友关系
        if (serverConfig.matchServerId(serverId)) {
            Map<Long, Relationship> shipMap = relationshipService.getShipMap(playerContext.getId());
            Relationship relationship = shipMap.get(msg.getRid());
            if (relationship != null) {
                doFriendDel(playerContext, relationship);
            }

            //清除好友请求
            RelationshipReq relationshipReq = relationshipReqService.selectRelationShipReq(playerContext.getId(), blackId);
            if (relationshipReq != null) {
                relationshipReqService.deleteRelationshipReq(relationshipReq);
                GetFriendReqList(playerContext.getId());
            }

            //清除好友请求
            RelationshipReq relationshipReq2 = relationshipReqService.selectRelationShipReq(blackId, playerContext.getId());
            if (relationshipReq2 != null) {
                relationshipReqService.deleteRelationshipReq(relationshipReq2);
                GetFriendReqList(blackId);
            }
        }

        FriendGMsg.GResAddBlackList.Builder builder = FriendGMsg.GResAddBlackList.newBuilder();
        if (serverConfig.matchServerId(serverId)) {
            builder.setBlack(serializeSimple(roleService.getOrThrow(blackId)));
        } else {
            builder.setBlack(serializeSimple(crossRoleRedisDao.get(blackId)));
        }

        playerContext.write(CmdCode._9017, builder.build());

    }

    @CMD(id = CmdCode._9018)
    public void removeBlackList(PlayerContext playerContext, FriendGMsg.GReqRemoveBlackList msg) {
        long blackId = msg.getRemoveId();
        BlackList blackList = blackListService.load(playerContext.getId());
        Asserts.isTrue(blackList.getCrossBlacks().containsKey(blackId), ErrorCode.BLACK_LIST_NOT_ADD.getValue(),
                String.format("未加入黑名单{%s}", blackId));

        blackList.getCrossBlacks().remove(blackId);
        blackListService.update(blackList);

        FriendGMsg.GResRemoveBlackList.Builder builder = FriendGMsg.GResRemoveBlackList.newBuilder();
        builder.setRemoveId(blackId);

        playerContext.write(CmdCode._9018, builder.build());

    }
}
