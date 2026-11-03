package com.ayjs.mxzg.gameserver.remote.large.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/6/20
 **/
@Entity
@Table(name = "stage_cross_group", comment = "超凡段位赛跨服组")
@Setter
@Getter
public class LargeServerGroup extends AbstractEntity {

    @Id
    @Column(name = "id", comment = "主键ID")
    private int id;
    @Column(name = "group_id", comment = "分组")
    private int groupId;

}
