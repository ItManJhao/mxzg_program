package com.ayjs.mxzg.gameserver.module.sensitive.dao;

import com.ayjs.mxzg.common.persistence.SqlBuilder;
import com.ayjs.mxzg.common.persistence.repository.JDBCRepository;
import com.ayjs.mxzg.gameserver.module.sensitive.domain.SensitiveWord;
import com.google.common.base.Throwables;
import org.springframework.stereotype.Repository;

@Repository
public class SensitiveWordDao extends JDBCRepository<SensitiveWord> {

    public void deleteAll() {
        try {
            dataBaseAccessor.update(SqlBuilder.deleteAll(meta.getName()));
        } catch (Exception e) {
            Throwables.throwIfUnchecked(e);
            throw new RuntimeException(e);
        }
    }
}
