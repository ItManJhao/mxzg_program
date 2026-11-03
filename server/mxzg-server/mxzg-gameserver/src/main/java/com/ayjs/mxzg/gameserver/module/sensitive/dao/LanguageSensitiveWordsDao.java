package com.ayjs.mxzg.gameserver.module.sensitive.dao;

import com.ayjs.mxzg.common.persistence.repository.DelayedJDBCRepository;
import com.ayjs.mxzg.gameserver.module.sensitive.domain.LanguageSensitiveWords;
import org.springframework.stereotype.Repository;

/**
 * @Author CJX
 * @Date 2021/6/7
 */

@Repository
public class LanguageSensitiveWordsDao extends DelayedJDBCRepository<LanguageSensitiveWords> {

}
