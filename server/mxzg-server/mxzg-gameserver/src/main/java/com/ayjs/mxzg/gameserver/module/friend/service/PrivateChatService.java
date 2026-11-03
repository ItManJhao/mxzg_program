/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.friend.service;

import com.ayjs.mxzg.gameserver.module.friend.dao.PrivateChatDao;
import com.ayjs.mxzg.gameserver.module.friend.domain.PrivateChat;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author YY
 *
 */
@Service
public class PrivateChatService {

	@Autowired
	private PrivateChatDao privateChatDao;
	
	public List<PrivateChat> getPrivateChats(long rid) {
		return privateChatDao.list("rid", rid);
	}
}
