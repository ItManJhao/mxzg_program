/**
 * 
 */
package com.ayjs.mxzg.module.champion;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import com.ayjs.mxzg.module.champion.IChampionCompetitor;

/**
 * @author YY
 *
 */
public class ChampionTrialsGroup {
	private int id;
	//选拔赛强弱分组
	private final List<IChampionCompetitor> before = new ArrayList<>();
	private final List<IChampionCompetitor> after = new ArrayList<>();
	//选拔赛乱战分组
	private final List<IChampionCompetitor> chaos = new ArrayList<>();
	private int chaosGroup;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public List<IChampionCompetitor> getBefore() {
		return before;
	}
	public List<IChampionCompetitor> getAfter() {
		return after;
	}
	public List<IChampionCompetitor> getChaos() {
		return chaos;
	}
	public int getChaosGroup() {
		return chaosGroup;
	}
	public void setChaosGroup(int chaosGroup) {
		this.chaosGroup = chaosGroup;
	}
	
	public static ConcurrentMap<Integer, ChampionTrialsGroup> initTrialsGroups(Collection<? extends IChampionCompetitor> competitors) {
		ConcurrentMap<Integer, ChampionTrialsGroup> groupMap = new ConcurrentHashMap<>();
		
		for(IChampionCompetitor competitor : competitors) {
			ChampionTrialsGroup group = groupMap.get(competitor.getTrialsGroup());
			if(group == null) {
				group = new ChampionTrialsGroup();
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
		
		for(ChampionTrialsGroup group : groupMap.values()) {
			Collections.sort(group.getBefore(), Comparator.comparingInt(IChampionCompetitor::getTrialsIndex));
			Collections.sort(group.getAfter(), Comparator.comparingInt(IChampionCompetitor::getTrialsIndex));
			Collections.sort(group.getChaos(), Comparator.comparingInt(IChampionCompetitor::getChaosIndex));
		}
		return groupMap;
	}
	
}
