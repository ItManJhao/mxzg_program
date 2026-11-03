package com.ayjs.mxzg.gameserver.module.role.domain;

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
import com.ayjs.mxzg.gameserver.module.role.constant.RoleParamType;
import com.google.common.reflect.TypeToken;

import java.util.Objects;

@Entity
@Table(name = "role_param", comment = "角色参数字典表",
        indexes = {@Index(name = "idx_rid", columnList = {"rid"})},
        cache = {@Cache(columns = {"rid"})})
public class RoleParam extends AbstractEntity {

    @Id
    @LongIdGenerate
    @Column(name = "id", comment = "主键id")
    private long id;

    @Column(name = "rid", readOnly = true, comment = "角色id")
    private long rid;

    @Column(name = "rp_key", readOnly = true, comment = "玩家参数key值，在RoleParamEvent中定义")
    private int rpKey;

    /***
     * 不支持map，list结构
     */
    @Column(name = "rp_value", comment = "参数value值，自定义", length = 512)
    private String rpValue;
    /**
     * rpValue具体对象
     */
    private Object value;

    public RoleParam() {
    }

    private RoleParam(long rid, int rpKey) {
        this(rid, rpKey, "");
    }

    private RoleParam(long rid, int rpKey, String rpValue) {
        this.rid = rid;
        this.rpKey = rpKey;
        this.rpValue = rpValue;
        this.value = rpValue;
    }

    public static RoleParam of(long rid, RoleParamType roleParamType) {
        return new RoleParam(rid, roleParamType.getValue());
    }

    public static <V> RoleParam of(long rid, RoleParamType roleParamType, V value) {
        RoleParam roleParam = new RoleParam(rid, roleParamType.getValue(), toJSONString(value));
        roleParam.value = value;
        return roleParam;
    }

    private static <V> String toJSONString(V data) {
        return JSON.toJSONString(data);
    }

    public <V> void saveJson(V data) {
        this.value = data;
        this.rpValue = toJSONString(data);
    }

    public <T> T parseJson(Class<T> clazz) {
        if (Objects.isNull(value)) {
            value = GsonUtils.fromJson(rpValue, clazz);
        }
        return (T) value;
    }

    public <T> T parseJson(TypeToken<T> type) {
        if (Objects.isNull(value)) {
            value = GsonUtils.fromJson(rpValue, type);
        }
        return (T) value;
    }

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

    public int getRpKey() {
        return rpKey;
    }

    public void setRpKey(int rpKey) {
        this.rpKey = rpKey;
    }

    public String getRpValue() {
        return rpValue;
    }

    public void setRpValue(String rpValue) {
        this.rpValue = rpValue;
        this.value = rpValue;
    }

}
