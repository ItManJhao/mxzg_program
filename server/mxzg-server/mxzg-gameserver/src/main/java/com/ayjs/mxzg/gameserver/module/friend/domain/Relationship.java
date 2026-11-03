/**
 *
 */
package com.ayjs.mxzg.gameserver.module.friend.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;

import java.util.HashMap;
import java.util.Map;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "relationship", comment = "好友关系表", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
public class Relationship extends AbstractEntity {
    @Id
    @LongIdGenerate
    @Column(name = "id", comment = "")
    private long id;
    @Column(name = "rid", comment = "玩家ID", readOnly = true)
    private long rid;
    @Column(name = "relation_rid", comment = "好友ID")
    private long relationRid;
    @Column(name = "create_time", comment = "玩家关系建立时间")
    private int createTime;
    @Column(name = "has_gift", comment = "是否有友情点可以领取，0没有，1有，2已领取")
    private int hasGift;
    @Column(name = "chat_ing", comment = "正在聊天")
    private boolean chatIng;
    @Column(name = "red_status", comment = "是否有小红点")
    private boolean redStatus = false;
    @Column(name = "read_time", comment = "阅读时间")
    private int readTime;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getRid() {
        return rid;
    }

    public void setRid(long rid) {
        this.rid = rid;
    }

    public long getRelationRid() {
        return relationRid;
    }

    public void setRelationRid(long relationRid) {
        this.relationRid = relationRid;
    }

    public int getCreateTime() {
        return createTime;
    }

    public void setCreateTime(int createTime) {
        this.createTime = createTime;
    }

    public int getHasGift() {
        return hasGift;
    }

    public void setHasGift(int hasGift) {
        this.hasGift = hasGift;
    }

    public boolean isChatIng() {
        return chatIng;
    }

    public void setChatIng(boolean chatIng) {
        this.chatIng = chatIng;
    }

    public boolean isRedStatus() {
        return redStatus;
    }

    public void setRedStatus(boolean redStatus) {
        this.redStatus = redStatus;
    }

    public int getReadTime() {
        return readTime;
    }

    public void setReadTime(int readTime) {
        this.readTime = readTime;
    }
}
