/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.task.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.SignSysCache;
import com.ayjs.mxzg.config.excel.entity.CSign;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.module.task.domain.Signday;
import com.ayjs.mxzg.gameserver.module.task.service.SigndayService;
import com.ayjs.mxzg.protocol.SignInGMsg.GReqSignInAward;
import com.ayjs.mxzg.protocol.SignInGMsg.GReqSignInList;
import com.ayjs.mxzg.protocol.SignInGMsg.GResSignInAward;
import com.ayjs.mxzg.protocol.SignInGMsg.GResSignInList;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.List;

/**
 * @author YY
 * 签到
 */
@Controller
public class SignInHandler extends ProtocolHandler {
	
	@Autowired
	private SigndayService signdayService;
	@Autowired
	private ServerParamService serverParamService;
	@Autowired
    private ThingService thingService;
	@Autowired
	private RoleService roleService;
	@Autowired
	private SignSysCache signSysCache;
	
	/**
	 * 获取签到信息
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._13010)
	public void getSignInList(PlayerContext playerContext, GReqSignInList msg) {
		Signday signday = signdayService.getSignday(playerContext.getId());
		
		int currMonth = TimeDateUtil.getMonthOfYear(TimeDateUtil.getCurrentTime());
		
		GResSignInList.Builder builder = GResSignInList.newBuilder();
		builder.setDays(signday.getDay());
		builder.setIsSignIn(signday.getTodaySign());
		builder.setMonth(currMonth);
		builder.setCharged(signday.getTodayCharge());
		builder.setNewServer(serverParamService.isNewServer() ? 1 : 0);
		playerContext.write(CmdCode._13010, builder.build());
	}
	
	/**
	 * 获取签到奖励
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._13011)
	public void getSignInReward(PlayerContext playerContext, GReqSignInAward msg) {
		Role role = roleService.getOrThrow(playerContext.getId());
		
		Signday signday = signdayService.getSignday(playerContext.getId());
		
		//一签和二签
		boolean canSign = false;
		if(signday.getTodaySign() == 0 || (signday.getTodaySign() == 1 && signday.getTodayCharge() == 1)) {
			canSign = true;
		}
		if(!canSign) {
			//今天已经签到过
			playerContext.writeError(ErrorCode.SIGNIN_TODAY);
			return;
		}
		int currMonth = TimeDateUtil.getMonthOfYear(TimeDateUtil.getCurrentTime());
		//按当前的已经签到的天数来签
		int currDay = 0;
		
		if(signday.getTodaySign() == 0) {
			currDay = signday.getDay() + 1;
		} else {
			currDay = signday.getDay();
		}
		
		CSign cSign = signSysCache.getByMonthDay(currMonth, currDay);
		if(cSign == null) {
			//没有找到配置
			playerContext.writeError(ErrorCode.CONFIG_NOT_EXIST);
			return;
		}
		
		if(signday.getTodaySign() == 0) {
			signday.setDay(signday.getDay() + 1);
		}
		signday.setTodaySign(signday.getTodaySign() + 1);
		signdayService.updateSignday(signday);
		
		List<ImmutableThing> rewardList = null;
		if(serverParamService.isNewServer()) {
			rewardList = cSign.getNew_server_reward();
		} else {
			rewardList = cSign.getReward();
		}
        thingService.add(role.getId(), rewardList, GameEvent.SIGN_GET);
		
		GResSignInAward.Builder builder = GResSignInAward.newBuilder();
		builder.setDays(signday.getDay());
		builder.setIsSignIn(signday.getTodaySign());
		playerContext.write(CmdCode._13011, builder.build());
	}
}
