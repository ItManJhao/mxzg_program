package com.ayjs.mxzg.largecross.module.robot.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "cross_ladder_robot", comment = "跨服天梯机器人")
@Getter
@Setter
public class LargeCrossRobot extends AbstractEntity {
    /**
     * 机器人id
     */
    @Id
    @Column(name = "id", comment = "主键ID")
    private long rid;
    /**
     * 等级
     */
    @Column(name = "level", comment = "等级")
    private int level;
    /**
     * 头像
     */
    @Column(name = "head_id", comment = "头像id")
    private int headId;
    /**
     * 头像框
     */
    @Column(name = "border_id", comment = "头像框id")
    private int borderId;
    /**
     * 形象
     */
    @Column(name = "image_id", comment = "形象id")
    private int imageId;
    /**
     * 昵称
     */
    @Column(name = "nick", length = 128, comment = "昵称")
    private String nick;
    /**
     * 战力
     */
    @Column(name = "fighting", comment = "战力")
    private int fighting;
}
