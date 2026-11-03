/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.mail.dao;

import org.springframework.stereotype.Repository;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.gameserver.module.mail.domain.MailSome;

/**
 * @author YY
 *
 */
@Repository
public class MailSomeDao extends CacheAllDelayedJDBCRepository<MailSome> {

}
