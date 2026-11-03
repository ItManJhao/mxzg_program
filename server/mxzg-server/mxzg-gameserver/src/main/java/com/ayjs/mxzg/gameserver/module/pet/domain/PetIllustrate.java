package com.ayjs.mxzg.gameserver.module.pet.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * @author hyx
 */
@Entity
@Table(name = "pet_illustrate", comment = "宠物图鉴表")
@Getter
@Setter
public class PetIllustrate extends AbstractEntity {

    @Id
    @Column(name = "rid",comment = "玩家id")
    private long rid;

    @Column(name = "unlock_list",comment = "解锁的图鉴")
    private List<Integer> unlockList = new ArrayList<>();
}
