/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.title.service;

import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.gameserver.module.title.dao.TitleDao;
import com.ayjs.mxzg.gameserver.module.title.domain.Title;

/**
 * @author YY
 *
 */
@Service
public class TitleService {
	
	@Autowired
	private TitleDao titleDao;
	
	public Title getTitle(long rid) {
		Title title = titleDao.get(rid);
		if(title == null) {
			title = new Title();
			title.setRid(rid);
			title.setTitles(new ConcurrentHashMap<>());
			titleDao.add(title);
		}
		return title;
	}
	
	public void update(Title title) {
		titleDao.update(title);
	}
}
