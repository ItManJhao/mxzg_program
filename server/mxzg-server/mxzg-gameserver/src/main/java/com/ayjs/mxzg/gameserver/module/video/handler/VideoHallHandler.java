package com.ayjs.mxzg.gameserver.module.video.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.config.excel.cache.NoticeSysCache;
import com.ayjs.mxzg.config.excel.constant.VideoConst;
import com.ayjs.mxzg.config.excel.entity.CNotice;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.chat.constant.ChatType;
import com.ayjs.mxzg.gameserver.module.chat.service.ChatService;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.marquee.constant.NoticeIdx;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.video.constant.BattleShareType;
import com.ayjs.mxzg.gameserver.module.video.constant.PersonVideo;
import com.ayjs.mxzg.gameserver.module.video.constant.VideoType;
import com.ayjs.mxzg.gameserver.module.video.domain.BattleShareInfo;
import com.ayjs.mxzg.gameserver.module.video.domain.VideoHall;
import com.ayjs.mxzg.gameserver.module.video.domain.VideoRole;
import com.ayjs.mxzg.gameserver.module.video.service.BattleShareInfoService;
import com.ayjs.mxzg.gameserver.module.video.service.VideoHallService;
import com.ayjs.mxzg.gameserver.module.video.service.VideoRoleService;
import com.ayjs.mxzg.module.battle.BattleReportManager;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleReport;
import com.ayjs.mxzg.protocol.VideoGMsg.GReqBattleShare;
import com.ayjs.mxzg.protocol.VideoGMsg.GReqDeleteFavorite;
import com.ayjs.mxzg.protocol.VideoGMsg.GReqKeepFavorite;
import com.ayjs.mxzg.protocol.VideoGMsg.GReqMyVideos;
import com.ayjs.mxzg.protocol.VideoGMsg.GReqScanShare;
import com.ayjs.mxzg.protocol.VideoGMsg.GReqVideoShare;
import com.ayjs.mxzg.protocol.VideoGMsg.GReqVideos;
import com.ayjs.mxzg.protocol.VideoGMsg.GResBattleShare;
import com.ayjs.mxzg.protocol.VideoGMsg.GResDeleteFavorite;
import com.ayjs.mxzg.protocol.VideoGMsg.GResKeepFavorite;
import com.ayjs.mxzg.protocol.VideoGMsg.GResMyVideos;
import com.ayjs.mxzg.protocol.VideoGMsg.GResScanShare;
import com.ayjs.mxzg.protocol.VideoGMsg.GResVideoShare;
import com.ayjs.mxzg.protocol.VideoGMsg.GResVideos;
import com.ayjs.mxzg.protocol.VideoGMsg.PSVideo;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.protobuf.InvalidProtocolBufferException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 录像馆
 */
@Component
public class VideoHallHandler extends ProtocolHandler {

	@Autowired
	private VideoHallService videoHallService;
	@Autowired
	private VideoRoleService videoRoleService;
	@Autowired
	private RoleService roleService;
	@Autowired
	private NoticeSysCache noticeSysCache;
	@Autowired
	private BattleReportManager battleReportManager;
	@Autowired
	private BattleShareInfoService battleShareInfoService;
	@Autowired
	private ChatService chatService;
	@Autowired
	private MailService mailService;

	@CMD(id = CmdCode._42001)
	public void scanSystemVideo(PlayerContext playerContext, GReqVideos msg) {
		VideoType videoType = VideoType.valueOf(msg.getType());
		Asserts.notNull(videoType, ErrorCode.VIDEO_TYPE_ERROR.getValue(), "错误的系统类型：" + msg.getType());

		//系统录像最新的在列表的“头”位置
		List<VideoHall> videoHalls = videoHallService.getHalls(videoType);
		
		List<VideoRole> videos = videoRoleService.getVideos(playerContext.getId(), PersonVideo.KEEP);
		Map<Long, VideoRole> myVideoMap = ListMapUtil.listToMap(videos, VideoRole::getHallId);

		GResVideos.Builder builder = GResVideos.newBuilder();
		builder.setType(videoType.getValue());
		for (VideoHall videoHall : videoHalls) {
			PSVideo.Builder model = PSVideo.newBuilder();
			model.setId(videoHall.getId());
			model.setHallId(videoHall.getId());
			model.setType(videoHall.getType());
			model.setSubtype(videoHall.getSubType());
			model.setTime(videoHall.getTime());
			model.setBattleLog(videoHall.getBattleImage());
			VideoRole keepVideo = myVideoMap.get(videoHall.getId());
			if(keepVideo != null) {
				model.setKeepId(keepVideo.getId());
			}
			builder.addVideos(model.build());
		}
		playerContext.write(CmdCode._42001, builder.build());
	}

	@CMD(id = CmdCode._42002)
	public void scanPersonVideo(PlayerContext playerContext, GReqMyVideos msg) {
		PersonVideo personVideo = PersonVideo.valueOf(msg.getKind());
		Asserts.notNull(personVideo, ErrorCode.VIDEO_TYPE_ERROR.getValue(), "错误的个人类型：" + msg.getKind());
		
		List<VideoRole> keepVideos = videoRoleService.getVideos(playerContext.getId(), PersonVideo.KEEP);
		Map<Long, VideoRole> myVideoMap = ListMapUtil.listToMap(keepVideos, VideoRole::getPersonId);
		
		
		//个人录像最新的在列表的“尾”位置
		List<VideoRole> videos = videoRoleService.getVideos(playerContext.getId(), personVideo);
		
		GResMyVideos.Builder builder = GResMyVideos.newBuilder();
		for(int i = videos.size() - 1; i >= 0; i--) {
			VideoRole videoRole = videos.get(i);
			if(personVideo == PersonVideo.KEEP) {
				builder.addVideos(serialVideoRole(videoRole, videoRole));
			} else {
				builder.addVideos(serialVideoRole(videoRole, myVideoMap.get(videoRole.getId())));
			}
		}
		builder.setKind(msg.getKind());
		playerContext.write(CmdCode._42002, builder.build());
	}
	
	private PSVideo serialVideoRole(VideoRole videoRole, VideoRole keepVideo) {
		PSVideo.Builder builder = PSVideo.newBuilder();
		builder.setId(videoRole.getId());
		builder.setType(videoRole.getType());
		builder.setSubtype(videoRole.getSubType());
		builder.setTime(videoRole.getTime());
		builder.setHallId(videoRole.getHallId());
		builder.setPersonId(videoRole.getPersonId());
		builder.setBattleLog(videoRole.getBattleImage());
		if(keepVideo != null) {
			builder.setKeepId(keepVideo.getId());
		}
		return builder.build();
	}

	@CMD(id = CmdCode._42003)
	public void keepFavorite(PlayerContext playerContext, GReqKeepFavorite msg) {
		
		List<VideoRole> keepVideos = videoRoleService.getVideos(playerContext.getId(), PersonVideo.KEEP);
		
		VideoRole keepVideo = null;
		
		if(msg.getKeepType() == 1) {
			
			//系统录像
			VideoHall videoHall = videoHallService.getById(msg.getId());
			Asserts.notNull(videoHall, ErrorCode.VIDEO_NOT_EXIST.getValue(), "系统录像馆不存在：" + msg.getKeepType() + " - " + msg.getId());
			
			for(int i = 0; i < keepVideos.size(); i++) {
				VideoRole video = keepVideos.get(i);
				if(video.getHallId() == videoHall.getId()) {
					Asserts.isTrue(false, ErrorCode.VIDEO_HAD_KEEP.getValue(), "已经收藏了该录像：" + msg.getKeepType() + " - " + msg.getId());
					return;
				}
			}
			
			//有个人记录的录像是来源于系统录像，如果是这种情况，为了让收藏数据关联到系统录像跟个人记录里面的数据，则需要用个人记录来生成收藏数据
			List<VideoRole> personVideos = videoRoleService.getVideos(playerContext.getId(), PersonVideo.RECORD);
			VideoRole videoRole = null;
			for(int i = 0; i < personVideos.size(); i++) {
				VideoRole video = personVideos.get(i);
				if(video.getHallId() == msg.getId()) {
					videoRole = video;
					break;
				}
			}
			if(videoRole != null) {
				keepVideo = videoRoleService.addKeepVideo(playerContext.getId(), videoRole);
			} else {
				keepVideo = videoRoleService.addKeepVideo(playerContext.getId(), videoHall);
			}
		} else {
			//个人录像
			List<VideoRole> videoList = videoRoleService.getVideos(playerContext.getId(), PersonVideo.RECORD);
			VideoRole videoRole = null;
			for(VideoRole temp : videoList) {
				if(temp.getId() == msg.getId()) {
					videoRole = temp;
					break;
				}
			}
			Asserts.notNull(videoRole, ErrorCode.VIDEO_NOT_EXIST.getValue(), "个人录像馆不存在：" + msg.getKeepType() + " - " + msg.getId());
			//是下标进行循环，避免遍历中修改列表的异常
			for(int i = 0; i < keepVideos.size(); i++) {
				VideoRole video = keepVideos.get(i);
				if(video.getPersonId() == videoRole.getId()) {
					Asserts.isTrue(false, ErrorCode.VIDEO_HAD_KEEP.getValue(), "已经收藏了该录像：" + msg.getKeepType() + " - " + msg.getId());
					return;
				}
				if(video.getHallId() != 0 && video.getHallId() == videoRole.getHallId()) {
					Asserts.isTrue(false, ErrorCode.VIDEO_HAD_KEEP.getValue(), "已经收藏了该录像：" + msg.getKeepType() + " - " + msg.getId());
					return;
				}
			}
			keepVideo = videoRoleService.addKeepVideo(playerContext.getId(), videoRole);
		}
		
		GResKeepFavorite.Builder builder = GResKeepFavorite.newBuilder();
		builder.setVideo(serialVideoRole(keepVideo, keepVideo));
		playerContext.write(CmdCode._42003, builder.build());
	}

	@CMD(id = CmdCode._42004)
	public void deleteFavorite(PlayerContext playerContext, GReqDeleteFavorite msg) {
		List<VideoRole> videos = videoRoleService.getVideos(playerContext.getId(), PersonVideo.KEEP);
		VideoRole videoRole = null;
		for(int i = 0; i < videos.size(); i++) {
			VideoRole video = videos.get(i);
			if(video.getId() == msg.getKeepId()) {
				videoRole = video;
				break;
			}
		}
		if(videoRole != null) {
			videoRoleService.deleteVideo(videoRole);
		}
		
		GResDeleteFavorite.Builder builder = GResDeleteFavorite.newBuilder();
		builder.setKeepId(msg.getKeepId());
		playerContext.write(CmdCode._42004, builder.build());
	}

	@CMD(id = CmdCode._42005)
	public void shareBattle(PlayerContext playerContext, GReqBattleShare msg) {
		Role role = roleService.getOrThrow(playerContext.getId());

		//前端不肯改，只能后端做匹配
		int channel = msg.getChannel();
		if(channel == 1) {
			channel = ChatType.CROSS_CHAT.getValue();
		}
		
		ChatType chatType = ChatType.valueOf(channel);
		Asserts.notNull(chatType, ErrorCode.CHAT_TYPE_NOT_EXIST.getValue(), "chat type is null: " + channel);

        Asserts.isTrue(chatType.isShareBattle(), ErrorCode.BATTLE_SHARE_NOT_CHAT_TYPE.getValue(), "战斗不允许分享在此频道");

        //TODO 修改战斗分享的公告ID
        CNotice cNotice = null;
        long receiveId = 0;
        if (chatType == ChatType.CLAN) {
            Asserts.isTrue(role.getClanId() != 0, ErrorCode.CLAN_NOT_EXIST.getValue(), "未加入任何公会，不可分享战斗在公会频道。");
            cNotice = noticeSysCache.getOrThrow(NoticeIdx.BATTLE_SHARE_CLAN);
            receiveId = role.getClanId();
        } else if (chatType == ChatType.WORLD) {
            cNotice = noticeSysCache.getOrThrow(NoticeIdx.BATTLE_SHARE_WORLD);
        } else if(chatType == ChatType.CROSS_CHAT) {
            cNotice = noticeSysCache.getOrThrow(NoticeIdx.BATTLE_SHARE_KF);
        }

        BattleReport report = battleReportManager.getReport(msg.getBattleId());
        Asserts.notNull(report, ErrorCode.BATTLE_REPORT_TIMEOUT.getValue(), () -> String.format("战报已过期：%s", msg.getBattleId()));
        
		ErrorCode errorCode = shareBattle(role, BattleShareType.BATTLE, chatType, receiveId,
				cNotice, report);
        if (errorCode != ErrorCode.NO_ERROR) {
            playerContext.writeError(errorCode);
            return;
        }
        playerContext.write(CmdCode._42005, GResBattleShare.getDefaultInstance());
	}
	
	private ErrorCode shareBattle(Role role, BattleShareType battleShareType, ChatType chatType,
			long targetId, CNotice cNotice, BattleReport report) {
		//保存分享英雄镜像
        BattleShareInfo battleShareInfo = battleShareInfoService.addBattle(battleShareType, report);
        
        //编缉参数
        List<String> paramList = new ArrayList<>();
        paramList.add(report.getAttacker().getName());
        paramList.add(report.getDefender().getName());
        paramList.add(role.getServerId() + "");
        paramList.add(battleShareInfo.getId());
        
        //发送聊天信息
        String finalChat = mailService.formatParamStr(cNotice.getChat_lang(), cNotice.getParam(), paramList);
        return chatService.send(chatType, finalChat, role.getId(), targetId, true, cNotice.getIdx(), paramList);
	}
	
	@CMD(id = CmdCode._42006)
	public void videoShare(PlayerContext playerContext, GReqVideoShare msg) {
		Role role = roleService.getOrThrow(playerContext.getId());
		
		//前端不肯改，只能后端做匹配
		int channel = msg.getChannel();
		if(channel == 1) {
			channel = ChatType.CROSS_CHAT.getValue();
		}
		
		ChatType chatType = ChatType.valueOf(channel);
		Asserts.notNull(chatType, ErrorCode.CHAT_TYPE_NOT_EXIST.getValue(), "chat type is null: " + channel);
		
		Asserts.isTrue(chatType.isShareBattle(), ErrorCode.BATTLE_SHARE_NOT_CHAT_TYPE.getValue(), "战斗不允许分享在此频道" + chatType);
		
		CNotice cNotice = null;
        long receiveId = 0;
        if (chatType == ChatType.CLAN) {
            Asserts.isTrue(role.getClanId() != 0, ErrorCode.CLAN_NOT_EXIST.getValue(), "未加入任何公会，不可分享战斗在公会频道。");
            cNotice = noticeSysCache.getOrThrow(NoticeIdx.BATTLE_SHARE_CLAN);
            receiveId = role.getClanId();
        } else if (chatType == ChatType.WORLD) {
            cNotice = noticeSysCache.getOrThrow(NoticeIdx.BATTLE_SHARE_WORLD);
        } else if(chatType == ChatType.CROSS_CHAT) {
            cNotice = noticeSysCache.getOrThrow(NoticeIdx.BATTLE_SHARE_KF);
        }
		
		BattleReport report = null;
        
		BattleShareType battleShareType = null;
		
		if(msg.getType() == 1) {
			//系统录像
			battleShareType = BattleShareType.SYS_VIDEO;
			VideoHall videoHall = videoHallService.getById(msg.getId());
			if(videoHall != null) {
				report = battleReportManager.getReport(videoHall.getBattleImage().getBattleId());
			}
		} else {
			//个人录像
			battleShareType = BattleShareType.ROLE_VIDEO;
			VideoRole videoRole = videoRoleService.getById(msg.getId());
			if(videoRole != null) {
				report = battleReportManager.getReport(videoRole.getBattleImage().getBattleId());
			}
		}
		Asserts.notNull(report, ErrorCode.VIDEO_EXPIRE.getValue(), () -> String.format("录像已过期：%s", msg.getId()));
		
		ErrorCode errorCode = shareBattle(role, battleShareType, chatType, receiveId, cNotice, report);
        if (errorCode != ErrorCode.NO_ERROR) {
            playerContext.writeError(errorCode);
            return;
        }
        playerContext.write(CmdCode._42006, GResVideoShare.getDefaultInstance());
	}
	
	@CMD(id = CmdCode._42007)
	public void scanBattleShare(PlayerContext playerContext, GReqScanShare msg) {
		BattleShareInfo battleShareInfo = battleShareInfoService.get(msg.getShareId());
		Asserts.notNull(battleShareInfo, ErrorCode.BATTLE_SHARE_MISS.getValue(), () -> String.format("战斗分享不存在：%s", msg.getShareId()));
		
		try {
			GResScanShare.Builder builder = GResScanShare.newBuilder();
			BattleReport battleReport = BattleReport.parseFrom(battleShareInfo.getBattleReport().getBytes(VideoConst.ISO));
			builder.setReport(battleReport);
			playerContext.write(CmdCode._42007, builder.build());
		} catch (InvalidProtocolBufferException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
	}
}
