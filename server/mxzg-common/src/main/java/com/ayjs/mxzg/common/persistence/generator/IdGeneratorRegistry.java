package com.ayjs.mxzg.common.persistence.generator;

import com.ayjs.mxzg.common.persistence.DatabaseHelper;
import com.ayjs.mxzg.common.persistence.TableRegistry;
import com.ayjs.mxzg.common.persistence.annotation.FixedDigitIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.UUIDGenerate;
import com.ayjs.mxzg.common.persistence.meta.MetaData;
import com.ayjs.mxzg.common.persistence.meta.TableMeta;
import com.ayjs.mxzg.common.persistence.repository.DataBaseAccessor;
import com.google.common.base.Preconditions;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;

/**
 * ID生成器注册器
 */
@Component
public class IdGeneratorRegistry {

    @Autowired
    private TableRegistry tableRegistry;

    private final Map<Class<?>, IdGenerator> idGenerators = new HashMap<>();
    @Setter
    private int serverId;

    /**
     * 获取id增长器
     *
     * @param entityType
     * @return
     */
    public IdGenerator getIdGenerator(Class<?> entityType) {
        return idGenerators.get(entityType);
    }

    /**
     * 初始化id增长器
     *
     * @param dataBaseAccessor
     * @param metaData
     */
    public void initIdGenerator(int serverId, DataBaseAccessor dataBaseAccessor, MetaData metaData, String tableName) {
        this.serverId = serverId;
        IdGenerator idGenerator = buildIdGenerator(metaData.getEntityType(), dataBaseAccessor, metaData.getTableMeta(), this.serverId, tableName);
        if (idGenerator != null) {
            idGenerators.put(metaData.getEntityType(), idGenerator);
        }
    }

    private IdGenerator buildIdGenerator(Class<?> entityType, DataBaseAccessor dataBaseAccessor, TableMeta meta, int serverId, String tableName) {
        Preconditions.checkArgument(!meta.getPk().isAuto(), "主键自增长由IdGenerator维护，请将表{} Pk auto 设置为false",
                meta.getName());

        Field pkField = meta.getPk().getField();
        LongIdGenerate longIdGenerate = pkField.getAnnotation(LongIdGenerate.class);
        if (longIdGenerate != null) {
//            if (pkField.getType() != Long.class && pkField.getType() != long.class) {
//                throw new RuntimeException(String.format("表[%s] 主键类型不匹配", meta.getName()));
//            }
//            Collection<String> tableNames = tableRegistry.get(entityType);
//            Long maxId = tableNames.stream()
//                    .map(tableName -> DatabaseHelper.queryMaxId(dataBaseAccessor, tableName, meta.getPk().getName(), serverId))
//                    .filter(Objects::nonNull)
//                    .max(Long::compareTo)
//                    .orElse(null);
            Long maxId = DatabaseHelper.queryMaxId(dataBaseAccessor, tableName, meta.getPk().getName(), serverId);
            if (maxId == null || maxId <= 0) {
                return LongIdGenerator.of(serverId, longIdGenerate.incrementDigit());
            } else {
                return LongIdGenerator.of(maxId, serverId, longIdGenerate.incrementDigit());
            }
        }

        UUIDGenerate uuidGenerate = pkField.getAnnotation(UUIDGenerate.class);
        if (uuidGenerate != null) {
            if (pkField.getType() != String.class) {
                throw new RuntimeException(String.format("表[%s] 主键类型不匹配", meta.getName()));
            }
            return UUIDGenerator.INSTANCE;
        }

        FixedDigitIdGenerate fixedDigitIdGenerate = pkField.getAnnotation(FixedDigitIdGenerate.class);
        if (fixedDigitIdGenerate != null) {
            if (pkField.getType() != Integer.class && pkField.getType() != int.class) {
                throw new RuntimeException(String.format("表[%s] 主键类型不匹配", meta.getName()));
            }
//            Collection<String> tableNames = tableRegistry.get(entityType);
//            Long maxId = tableNames.stream()
//                    .map(tableName -> DatabaseHelper.queryMaxId(dataBaseAccessor, tableName, meta.getPk().getName()))
//                    .filter(Objects::nonNull)
//                    .max(Long::compareTo)
//                    .orElse(null);
            Long maxId = DatabaseHelper.queryMaxId(dataBaseAccessor, tableName, meta.getPk().getName());
            if (maxId == null || maxId <= 0) {
                return FixedDigitIdGenerator.of(fixedDigitIdGenerate.initialValue(), fixedDigitIdGenerate.digit());
            } else {
                return FixedDigitIdGenerator.of(maxId.intValue(), fixedDigitIdGenerate.digit());
            }
        }

        return null;
    }
}
