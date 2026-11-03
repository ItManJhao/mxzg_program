package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.struct.FleetBoxInfo;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.struct.FleetEnemyInfo;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * 时空冒险
 *
 * @author hyx
 */
@Entity
@Table(name = "space_time_info", comment = "时空冒险")
@Getter
@Setter
public class SpaceTimeInfo extends AbstractEntity {

    @Id
    @Column(name = "rid", readOnly = true, comment = "角色id")
    private long rid;

    @Column(name = "fleet_name", comment = "航队名称")
    private String fleetName = "";

    @Column(name = "unlock_routes", comment = "解锁的隐藏航线", length = 100)
    private List<Integer> unlockRoutes = new ArrayList<>();

    @Column(name = "route_id", comment = "当前选择的运行航线")
    private int routeId;

    @Column(name = "start_time", comment = "启航时间")
    private int startTime;

    @Column(name = "remake_time", comment = "以当前速度加成开始航行时间，用于计算进度")
    private int remakeTime;

    @Column(name = "speed_buff", comment = "此次航行速度加成")
    private int speedBuff;

    @Column(name = "not_progress", comment = "已航行里程")
    private long notProgress;

    @Column(name = "event_id", comment = "当前记录事件")
    private int eventId;

    @Column(name = "unlock_event", comment = "已解锁事件，用于图鉴展示")
    private List<Integer> unlockEvent = new ArrayList<>();

    @Column(name = "enemy_info", comment = "其他舰队敌人信息")
    private FleetEnemyInfo enemyInfo = new FleetEnemyInfo();

    @Column(name = "fleet_level", comment = "航队等级")
    private int fleetLevel;

    @Column(name = "fleet_exp", comment = "航队经验")
    private long fleetExp;

    @Column(name = "durability", comment = "耐久度")
    private int durability;

    @Column(name = "energy", comment = "体力值")
    private int energy;

    @Column(name = "energy_time", comment = "上一次体力扣除时间,用于体力恢复")
    private int energyTime;

    @Column(name = "cargo_hold_item", comment = "船舱材料")
    private List<ImmutableThing> cargoHoldItem = new ArrayList<>();

    @Column(name = "cargo_hold_box", comment = "船舱物资")
    private List<FleetBoxInfo> cargoHoldBox = new ArrayList<>();

    @Column(name = "skill_num", comment = "剩余科技点")
    private int skillNum;

    /**
     * {@link com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.constant.FleetSkillEnum}
     */
    @Column(name = "skill", comment = "航队科技")
    private Map<Integer, Integer> skillMap = new HashMap<>();

    @Column(name = "shop_end_time", comment = "土著商店结束时间")
    private int shopEndTime;

    @Column(name = "shop", comment = "商品数据")
    private Map<Integer, Integer> shopItems = new HashMap<>();

    @Column(name = "last_enemy", comment = "上一个敌人")
    private String lastEnemy = "";

    @Column(name = "next_event", comment = "GM,指定下一次事件")
    private int nextEvent;

    @Column(name = "product_end_time", comment = "超值礼包结束时间")
    private int productEndTime;

    @Column(name = "product_idx", comment = "超值礼包idx")
    private int productIdx;

    @Column(name = "product_buy", comment = "超值礼包购买次数")
    private int productBuy;

    @Column(name = "event_ids", comment = "此次航行遇到事件集")
    private List<Integer> eventIds = new ArrayList<>();
}





















