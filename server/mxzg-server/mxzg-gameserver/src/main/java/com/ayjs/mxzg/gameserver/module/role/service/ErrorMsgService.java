/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.role.service;

import com.ayjs.mxzg.gameserver.module.role.dao.ErrorMsgDao;
import com.ayjs.mxzg.gameserver.module.role.domain.ErrorMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author YY
 *
 */
@Service
public class ErrorMsgService {
	@Autowired
	private ErrorMsgDao errorMsgDao;
	
	public void addErrorMsg(ErrorMsg errorMsg) {
		errorMsgDao.add(errorMsg);
	}
}
