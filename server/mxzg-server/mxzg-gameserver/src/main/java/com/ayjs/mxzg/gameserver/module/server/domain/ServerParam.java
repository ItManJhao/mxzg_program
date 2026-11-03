package com.ayjs.mxzg.gameserver.module.server.domain;

import com.alibaba.fastjson.JSON;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.gameserver.module.server.constant.ServerParamType;
import com.google.common.reflect.TypeToken;

import java.util.Objects;

@Entity
@Table(name = "server_param", comment = "服务器参数字典表",
        indexes = {@Index(name = "idx_sp_key", columnList = {"sp_key"})},
        cache = {@Cache(columns = "sp_key")})
public class ServerParam extends AbstractEntity {

    @Id
    @LongIdGenerate
    @Column(name = "id", comment = "主键id")
    private long id;

    @Column(name = "sp_key", readOnly = true, comment = "服务器参数key值，在ServerParamEvent中定义")
    private int spKey;

    @Column(name = "sp_value", comment = "服务器参数value值，自定义", length = 512)
    private String spValue;

    /**
     * spValue具体对象
     */
    private Object value;

    public ServerParam() {

    }

    public ServerParam(ServerParamType serverParamEvent, String spValue) {
        this.spKey = serverParamEvent.getValue();
        this.spValue = spValue;
        this.value = spValue;
    }

    public static ServerParam of(ServerParamType type) {
        ServerParam entity = new ServerParam();
        entity.setSpKey(type.getValue());
        return entity;
    }

    public <T> void saveJson(T data) {
        this.value = data;
        this.spValue = JSON.toJSONString(data);
    }

    public <T> T parseJson(Class<T> clazz) {
        if (Objects.isNull(value)) {
            value = GsonUtils.fromJson(spValue, clazz);
        }
        return (T) value;
    }

    public <T> T parseJson(TypeToken<T> type) {
        if (Objects.isNull(value)) {
            value = GsonUtils.fromJson(spValue, type);
        }
        return (T) value;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public int getSpKey() {
        return spKey;
    }

    public void setSpKey(int spKey) {
        this.spKey = spKey;
    }

    public String getSpValue() {
        return spValue;
    }

    public void setSpValue(String spValue) {
        this.spValue = spValue;
        this.value = spValue;
    }
}
