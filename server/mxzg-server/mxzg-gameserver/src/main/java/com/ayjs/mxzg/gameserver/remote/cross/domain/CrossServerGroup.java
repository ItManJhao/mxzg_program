package com.ayjs.mxzg.gameserver.remote.cross.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@Entity
@Table(name = "cross_server_group", comment = "跨服分组表")
public class CrossServerGroup extends AbstractEntity {

    @Id
    @Column(name = "id", comment = "主键ID")
    private int id;
    @Column(name = "group_id", comment = "分组")
    private int groupId;
    @Column(name = "ip", comment = "ip")
    private String ip;
    @Column(name = "port", comment = "端口")
    private int port;

    /**
     * 更新信息
     *
     * @param groupId
     * @param ip
     * @param port
     */
    public void update(int groupId, String ip, int port) {
        this.groupId = groupId;
        this.ip = ip;
        this.port = port;
    }
}
