package com.ayjs.mxzg.center.module.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.*;
import lombok.Getter;

@Getter
@Entity

@Table(name = "cross_config", comment = "跨服配置表", indexes = {@Index(name = "cross_server_id", columnList = {"cross_server_id"})}, cache = {@Cache(columns = "cross_server_id")})
public class CrossConfig extends AbstractEntity {

    @Id
    @Column(name = "id", comment = "主键ID")
    private int id;
    @Column(name = "cross_server_id", comment = "跨服id", readOnly = true)
    private int crossServerId;
    @Column(name = "ip", comment = "ip")
    private String ip;
    @Column(name = "port", comment = "端口")
    private int port;
}
