package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CInitUser;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;
import org.springframework.stereotype.Component;

@Component
public class InitUserSysCache extends BaseExcelCache<CInitUser> {


	private int level;
	private int cup;
	private long gem;
	private long exp;
	private long gold;

	private ImmutableList<ImmutableThing> initReward;
	
	@Override
	public String getFileName() {
		return "inituser";
	}

	@Override
	protected void loadAfterReady() {
		this.gem = Long.parseLong(this.getOrThrow(1).getValue());
		this.gold = Long.parseLong(this.getOrThrow(2).getValue());
		this.exp = Long.parseLong(this.getOrThrow(3).getValue());
		this.level = Integer.parseInt(this.getOrThrow(4).getValue());
		this.cup = Integer.parseInt(this.getOrThrow(5).getValue());
		CInitUser initReward = this.getById(6);
		if (initReward != null) {
			this.initReward = ImmutableThingUtil.fromJson(initReward.getValue());
		}
	}

	public int getLevel() {
		return level;
	}

	public int getCup() {
		return cup;
	}

	public long getGem() {
		return gem;
	}

	public long getExp() {
		return exp;
	}

	public long getGold() {
		return gold;
	}

	public ImmutableList<ImmutableThing> getInitReward() {
		return initReward;
	}
}