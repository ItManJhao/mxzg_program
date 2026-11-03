package com.ayjs.mxzg.gameserver.module.dungeon.domain;

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.*;
import lombok.Getter;
import lombok.Setter;

/**
 * dungeon
 *
 * @author mxzg
 * @version 1.0.0 2019-10-01
 */
@Entity
@Table(name = "dungeon", comment = "地牢网格数据表，用于记录25个网格信息", indexes = {@Index(name = "rid", columnList = {"rid"})},
        cache = {@Cache(columns = "rid")})
@Getter
@Setter
public class Dungeon extends AbstractEntity {
    @Id
    @Column(name = "id")
    @LongIdGenerate
    private long id;

    @Column(name = "rid", readOnly = true)
    private long rid;

    @Column(name = "grid_x", comment = "X轴坐标")
    private int gridX;

    @Column(name = "grid_y", comment = "Y轴坐标")
    private int gridY;

    @Column(name = "is_open", comment = "该网格是否找开")
    private int isOpen;

    /***
     * {@link com.ayjs.mxzg.gameserver.module.dungeon.constant.DungeonEvent}
     */
    @Column(name = "event_type", comment = "网格事件类型")
    private int eventType;

    @Column(name = "event_detail", comment = "事件内容。例：商店id、怪物level、药剂类型、事件奖励内容")
    private long eventDetail;

    /***
     * {@link com.ayjs.mxzg.gameserver.module.dungeon.constant.DungeonEnum}
     */
    @Column(name = "grid_type", comment = "网格类型2 与 网格类型1 给成网格表现形式")
    private int gridType;

    @Column(name = "monster", comment = "怪物战斗数据,只有怪物事件才会有实际怪物数据")
    private BattlerVo battlerVo = new BattlerVo();
}
