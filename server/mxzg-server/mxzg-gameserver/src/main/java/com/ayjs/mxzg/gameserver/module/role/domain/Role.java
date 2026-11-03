/**
 *
 */
package com.ayjs.mxzg.gameserver.module.role.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.config.struct.LoginMailInfo;
import lombok.Getter;
import lombok.Setter;

import java.util.HashSet;
import java.util.Set;

/**
 * @author YY
 */
@Entity
@Table(name = "role", cache = {@Cache(columns = {"user_id", "server_id"})}, comment = "角色")
@Getter
@Setter
public class Role extends AbstractEntity {
    @Id
    @LongIdGenerate(incrementDigit = 6)
    @Column(name = "id", comment = "角色id")
    private long id;
    @Column(name = "user_id", readOnly = true, comment = "账号id")
    private long userId;
    @Column(name = "server_id", readOnly = true, comment = "服务器id")
    private int serverId;
    @Column(name = "nick", length = 128, comment = "昵称")
    private String nick = "";
    @Column(name = "head_id", comment = "头像ID")
    private int headId;
    @Column(name = "border_id", comment = "头像框ID")
    private int borderId;
    @Column(name = "level", comment = "角色等级")
    private int level;
    @Column(name = "exp", comment = "角色经验")
    private long exp;
    @Column(name = "arena_score", comment = "竞技场积分")
    private int arenaScore;
    @Column(name = "super_gem", comment = "超级钻石数量")
    private long superGem;
    @Column(name = "gem", comment = "钻石数量")
    private long gem;
    @Column(name = "gold", comment = "金币数量")
    private long gold;
    @Column(name = "lang", comment = "语言版本")
    private int lang;
    @Column(name = "is_edit_name", comment = "是否已经修改过昵称，0未修改，1已修改")
    private int isEditName;
    @Column(name = "create_time", comment = "创号时间")
    private long createTime;
    @Column(name = "status", comment = "账号状态，0正常，1封号")
    private int status;
    @Column(name = "online", comment = "在线状态，0离线，1在线")
    private int online;
    @Column(name = "forbid_end_time", comment = "封号结束时间")
    private int forbidEndTime;
    @Column(name = "forbid_words_end_time", comment = "禁言结束时间")
    private int forbidWordsEndTime;
    @Column(name = "last_login_time", comment = "上一次登录的时间")
    private long lastLoginTime;
    @Column(name = "last_offline_time", comment = "最后离线时间")
    private long lastOfflineTime;
    @Column(name = "platform", comment = "客户端类型：1，安卓,2，IOS")
    private int platform;
    @Column(name = "clan_id", comment = "公会id")
    private long clanId;
    @Column(name = "max_cup", comment = "竞技场最大积分")
    private int maxCup;
    @Column(name = "serial", comment = "新手指引，前端新手做了两套")
    private Set<Integer> serial = new HashSet<>();
    @Column(name = "serial_str", comment = "新手指引字符类型，前端新手做了两套")
    private Set<String> serialStr = new HashSet<>();
    @Column(name = "hero_num", comment = "英雄数量上限")
    private int heroNum;
    @Column(name = "image_id", comment = "英雄形象")
    private int imageId;
    @Column(name = "fighting", comment = "布阵英雄当前战力")
    private int fighting;
    @Column(name = "max_fighting", comment = "布阵英雄历史最高战力")
    private int maxFighting;
    @Column(name = "goddess_vip", comment = "VIP等级")
    private int goddessVip;
    @Column(name = "hero_exp", comment = "英雄累积经验")
    private long heroExp;
    @Column(name = "seven_day_login_rewards", comment = "七天奖励")
    private Set<Integer> sevenDayLoginRewards = new HashSet<>();
    @Column(name = "place", comment = "渠道")
    private String place = "";
    @Column(name = "newbie_reward", comment = "新手指引奖励，1为已领取")
    private int newbieReward;
    /**
     * 邀请人rid，可以是其他服人的id
     */
    @Column(name = "invite_rid", comment = "邀请人id，可以是其他服rid")
    private long inviteRid;

    @Column(name = "arena_rank_time", comment = "邀请人id，可以是其他服rid")
    private int arenaRankTime;
    @Column(name = "fight_rank_time", comment = "上榜时间")
    private int fightRankTime;
    @Column(name = "device_id", comment = "设备id", length = 128)
    private String deviceId = "";
    @Column(name = "province", comment = "省名", length = 32)
    private String province = "";
    /**
     * 仅用于聊天同省频道
     */
    @Column(name = "area_id", comment = "区域id,省市对应id")
    private int areaId;
    @Column(name = "clergy_exp", comment = "神职经验")
    private long clergyExp;
    @Column(name = "clergy_level", comment = "解锁的神职特权等级")
    private int clergyLevel;
    @Column(name = "task_count_time", comment = "任务计数值计数时间")
    private int taskCountTime;
    @Column(name = "peerage_chat_status", comment = "尊贵标识聊天展示状态,0.否 1.是")
    private int peerageChatStatus = 1;
    @Column(name = "peerage_status", comment = "尊贵标识属性加成同步状态")
    private int peerageStatus;
    @Column(name = "recharge_popup", comment = "充值弹窗界面(日本版本)")
    private int rechargePopup;
    @Column(name = "login_mail_reward", comment = "新手登陆礼包")
    private LoginMailInfo loginMailInfo;
    @Column(name = "push_token", comment = "推送token")
    private String pushToken = "";
    @Column(name = "push_off_ids", comment = "推送关闭的ids")
    private Set<Integer> pushOffIds = new HashSet<>();
    @Column(name = "assistance_unlock", comment = "援助是否解锁")
    private boolean assistanceUnlock;
    /**
     * 创号时的地区
     */
    @Column(name = "create_area_id", comment = "创号区域id,省市对应id")
    private int createAreaId;

    /**
     * 是否是活跃玩家
     * @param activeThreshold
     * @return
     */
    public boolean isActive(long activeThreshold) {
        return this.lastOfflineTime > activeThreshold;
    }

    /**
     * 本次登录的区域id,省市对应id
     */
    private int loginAreaId;
}
