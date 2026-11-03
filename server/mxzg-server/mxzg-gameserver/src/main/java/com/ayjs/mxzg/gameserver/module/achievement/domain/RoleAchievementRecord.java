package com.ayjs.mxzg.gameserver.module.achievement.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.util.HashSet;
import java.util.Set;

/**
 * @Author: CWJ
 * @Date: 2019/11/14
 **/

@Table(name = "role_achievement_record", comment = "成就记录表")
@Data
@Entity
public class RoleAchievementRecord extends AbstractEntity {

    @Id
    @Column(name = "rid", comment = "角色id")
    private long rid;
    @Column(name = "complete_list", comment = "完成列表")
    private Set<Integer> completeList = new HashSet<>();

    @Column(name = "first_task", comment = "已接取的任务链第一个任务")
    private Set<Integer> acceptFirsts = new HashSet<>();

    @Column(name = "complete_tips_idx", comment = "完成提示列表")
    private Set<Integer> completeTipsIdx = new HashSet<>();
}
