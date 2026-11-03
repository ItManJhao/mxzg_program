package com.ayjs.mxzg.gameserver.module.headPortrait.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;
import java.util.HashSet;
import java.util.Set;

/**
 * 头像
 * @author hyx
 */
@Data
@Entity
@Table(name = "role_head_portrait",comment = "玩家头像解锁表")
public class RoleHeadPortrait extends AbstractEntity {

    @Id
    @Column(name = "rid",comment = "玩家id")
    private long rid;

    @Column(name = "head_ids",comment = "已解锁的头像列表")
    private Set<Integer> headIds = new HashSet<>();
}
