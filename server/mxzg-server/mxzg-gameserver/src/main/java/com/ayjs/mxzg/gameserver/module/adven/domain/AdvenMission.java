/**
 *
 */
package com.ayjs.mxzg.gameserver.module.adven.domain;

import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.adven.struct.AdvenSelectAssist;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * 勇者试炼
 * @author YY
 */
@Getter
@Setter
@Entity
@Table(name = "adven_mission", comment = "勇者试炼")
public class AdvenMission extends AbstractEntity {
    @Id
    @Column(name = "rid", comment = "角色id")
    private long rid;

    @Column(name = "mission_id", comment = "当前关卡（不计算宝箱关卡）")
    private int missionId;

    @Column(name = "mission_data", comment = "关卡详细数据", longtext = true)
    private Map<Integer, AdvenMissionData> missionData;

    @Column(name = "hero_hp_record", comment = "英雄血量记录", length = 5000)
    private Map<Long, Long> heroHpRecord;

    @Column(name = "next_reset_time", comment = "下一次重置时间")
    private int nextResetTime;
    @Column(name = "received_mission_id", comment = "已领取的关卡")
    private Set<Integer> receivedMissionId;

    @Column(name = "assist_hero", comment = "支援英雄,非镜像数据", length = 5000)
    private List<HeroVo> assistHeros = new ArrayList<>();
    @Column(name = "select_assist", comment = "选择助战数据", length = 5000)
    private List<AdvenSelectAssist> selectAssists = new ArrayList<>();
    @Column(name = "assist_expire_time", comment = "助战有效时间")
    private int assistExpireTime;

    @Column(name = "lv_time", comment = "关卡难度有效时间")
    private int lvTime;
    @Column(name = "lv", comment = "关卡难度")
    private int lv;
    @Column(name = "last_lv", comment = "上一次关卡难度")
    private int lastLv;
    @Column(name = "last_lv_time", comment = "上一次关卡难度选择时间")
    private int lastLvTime;
    @Column(name = "be_elect_num", comment = "被选择并出战的次数")
    private int beSelectNum;
    @Column(name = "rewards", comment = "累计奖励")
    private List<ImmutableThing> rewards = new ArrayList<>();
    @Column(name = "pass_lv", comment = "通关难度")
    private int passLv;
}
