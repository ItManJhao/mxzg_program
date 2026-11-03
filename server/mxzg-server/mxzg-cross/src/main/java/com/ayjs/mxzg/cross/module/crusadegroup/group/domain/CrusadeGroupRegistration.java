package com.ayjs.mxzg.cross.module.crusadegroup.group.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;

@Entity
@Table(name = "crusade_group_registration", comment = "跨服讨伐团报名表")
@Getter
@Setter
public class CrusadeGroupRegistration extends AbstractEntity {

    @Id
    @Column(name = "id", comment = "服务器id")
    private int id;

    @Column(name = "members", comment = "报名玩家id")
    private Map<Long, Integer> members = new HashMap<>();


    /**
     * 报名
     * @param rid
     * @param emblem
     */
    public void signUp(long rid, int emblem){
        this.members.put(rid, emblem);
    }

    /**
     * 获取团徽
     * @param rid
     * @return
     */
    public int getEmblem(long rid){
        return this.members.get(rid);
    }

    /**
     * 是否报名
     * @param rid
     * @return
     */
    public boolean isSignUp(long rid){
        return members.containsKey(rid);
    }
}
