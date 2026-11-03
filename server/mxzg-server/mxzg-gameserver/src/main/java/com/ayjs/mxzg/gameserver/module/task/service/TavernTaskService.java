/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.task.service;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.config.excel.cache.TavernSysCache;
import com.ayjs.mxzg.config.excel.entity.CTavern;
import com.ayjs.mxzg.gameserver.module.task.dao.TavernTaskDao;
import com.ayjs.mxzg.gameserver.module.task.domain.TavernTask;
import com.ayjs.mxzg.protocol.PubTaskGMsg.ResPubTaskData;

/**
 * @author YY
 *
 */
@Service
public class TavernTaskService {
	@Autowired
	private TavernTaskDao tavernTaskDao;
	@Autowired
	private TavernSysCache tavernSysCache;
	
	public List<TavernTask> getTavernTasks(long rid) {
		return tavernTaskDao.list("rid", rid);
	}
	
	public TavernTask getTavernTask(long rid, long taskId) {
		for(TavernTask tavernTask : getTavernTasks(rid)) {
			if(tavernTask.getId() == taskId) {
				return tavernTask;
			}
		}
		return null;
	}
	
	/**
	 * 获取当前正在任务状态中的英雄ID集合
	 * @param rid
	 * @return
	 */
	public Set<Long> getTaskingHeroIds(long rid) {
		Set<Long> heroIds = new HashSet<>();
		for(TavernTask tavernTask : getTavernTasks(rid)) {
			heroIds.addAll(tavernTask.getHeros());
		}
		return heroIds;
	}
	
	
	public void addTavernTask(TavernTask task) {
		tavernTaskDao.add(task);
	}
	
	public void addTavernTasks(List<TavernTask> list) {
		tavernTaskDao.add(list);
	}
	
	public void updateTavernTask(TavernTask task) {
		tavernTaskDao.update(task);
	}
	
	public void deleteTavernTask(TavernTask task) {
		tavernTaskDao.remove(task);
	}

	public void deleteTavernTasks(List<TavernTask> list) {
		tavernTaskDao.remove(list);
	}

	public ResPubTaskData serialize(TavernTask tavern) {
		CTavern cTavern = tavernSysCache.getOrThrow(tavern.getType());
	
		ResPubTaskData.Builder builder = ResPubTaskData.newBuilder();
		if (tavern.getStatus() == 0) {
			builder.setUsedTime(0);
		} else {
			builder.setUsedTime(tavern.getStartTime() + cTavern.getTime());
		}
		builder.setTaskId(tavern.getId());
		builder.setTaskType(tavern.getType());
		builder.setTaskLock(tavern.getTaskLock());
		builder.addAllHeroIds(tavern.getHeros());
		return builder.build();
	}
}
