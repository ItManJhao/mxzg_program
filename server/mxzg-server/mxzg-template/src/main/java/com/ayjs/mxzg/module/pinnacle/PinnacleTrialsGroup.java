/**
 * 
 */
package com.ayjs.mxzg.module.pinnacle;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

/**
 * @author YY
 *
 */
public class PinnacleTrialsGroup {
	private int id;
	//选拔赛强弱分组
	private final List<IPinnacleCompetitor> before = new ArrayList<>();
	private final List<IPinnacleCompetitor> after = new ArrayList<>();
	//选拔赛乱战分组
	private final List<IPinnacleCompetitor> chaos = new ArrayList<>();
	private int chaosGroup;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public List<IPinnacleCompetitor> getBefore() {
		return before;
	}
	public List<IPinnacleCompetitor> getAfter() {
		return after;
	}
	public List<IPinnacleCompetitor> getChaos() {
		return chaos;
	}
	public int getChaosGroup() {
		return chaosGroup;
	}
	public void setChaosGroup(int chaosGroup) {
		this.chaosGroup = chaosGroup;
	}
	
	public static ConcurrentMap<Integer, PinnacleTrialsGroup> initTrialsGroups(Collection<? extends IPinnacleCompetitor> competitors) {
		ConcurrentMap<Integer, PinnacleTrialsGroup> groupMap = new ConcurrentHashMap<>();
		
		for(IPinnacleCompetitor competitor : competitors) {
			PinnacleTrialsGroup group = groupMap.get(competitor.getTrialsGroup());
			if(group == null) {
				group = new PinnacleTrialsGroup();
				group.setId(competitor.getTrialsGroup());
				group.setChaosGroup(competitor.getChaosGroup());
				groupMap.put(competitor.getTrialsGroup(), group);
			}
			if(competitor.getTrialsPos() == 1) {
				group.getBefore().add(competitor);
			} else {
				group.getAfter().add(competitor);
			}
			group.getChaos().add(competitor);
		}
		
		for(PinnacleTrialsGroup group : groupMap.values()) {
			Collections.sort(group.getBefore(), Comparator.comparingInt(IPinnacleCompetitor::getTrialsIndex));
			Collections.sort(group.getAfter(), Comparator.comparingInt(IPinnacleCompetitor::getTrialsIndex));
			Collections.sort(group.getChaos(), Comparator.comparingInt(IPinnacleCompetitor::getChaosIndex));
		}
		return groupMap;
	}
	
}
