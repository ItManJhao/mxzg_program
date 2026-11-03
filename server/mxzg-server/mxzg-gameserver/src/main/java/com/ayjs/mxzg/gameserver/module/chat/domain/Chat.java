package com.ayjs.mxzg.gameserver.module.chat.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/13 16:21
 */
@Table(name = "chat", indexes = {@Index(name = "receiver", columnList = {"receiver"}), @Index(name = "sender", columnList = {"sender"})},
        cache = {@Cache(columns = "sender"), @Cache(columns = "receiver")}, charset = "utf8mb4", comment = "私聊记录")
@Data
@Entity
public class Chat extends AbstractEntity {
    @Id
    @Column(name = "id", comment = "唯一主键")
    @LongIdGenerate
    private long id;
    @Column(name = "content", comment = "聊天内容")
    private String content;
    @Column(name = "chat_type", comment = "聊天频道类型")
    private int chatType;
    @Column(name = "create_time", comment = "聊天发送时间")
    private int createTime;
    @Column(name = "sender", readOnly = true, comment = "发送者")
    private long sender;
    @Column(name = "receiver", readOnly = true, comment = "接收者")
    private long receiver;

}
