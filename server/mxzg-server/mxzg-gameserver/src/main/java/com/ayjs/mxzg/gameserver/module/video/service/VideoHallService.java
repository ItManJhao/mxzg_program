package com.ayjs.mxzg.gameserver.module.video.service;

import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.annotation.Subscribe.AsyncType;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.constant.VideoConst;
import com.ayjs.mxzg.gameserver.module.ladder.constant.LadderConstant;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.video.constant.PersonVideo;
import com.ayjs.mxzg.gameserver.module.video.constant.VideoType;
import com.ayjs.mxzg.gameserver.module.video.dao.VideoHallDao;
import com.ayjs.mxzg.gameserver.module.video.domain.VideoHall;
import com.ayjs.mxzg.gameserver.module.video.event.VideoRecordEvent;
import com.ayjs.mxzg.module.battle.command.SaveBattleReportCommand;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleReport;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Observer
@Service
public class VideoHallService implements Lifecycle {

    @Autowired
    private VideoHallDao videoHallDao;
    @Autowired
    private VideoRoleService videoRoleService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private CommandBus commandBus;


    private Map<VideoType, List<VideoHall>> videoTypeMap = new HashMap<>();
    private Map<Long, VideoHall> videoIdMap = new ConcurrentHashMap<>();

    public List<VideoHall> getHalls(VideoType videoType) {
        return videoTypeMap.get(videoType);
    }

    public VideoHall getById(long id) {
        return videoIdMap.get(id);
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(VideoRecordEvent event) {
        int nowTime = TimeDateUtil.getCurrentTimeInt();
        try {
            String battleLog = new String(event.getBattleReport().getLog().toByteArray(), VideoConst.ISO);
            long atkRid = event.getBattleReport().getLog().getAttackerLog().getRid();
            long defRid = event.getBattleReport().getLog().getDefenderLog().getRid();

            VideoHall videoHall = new VideoHall();
            videoHall.setType(event.getVideoType().getValue());
            videoHall.setSubType(event.getSubType());
            videoHall.setBattle_log(battleLog);
            videoHall.setTime(nowTime);
            videoHall.setExtra("");
            if (event.getVideoType() == VideoType.PVP || event.getVideoType() == VideoType.STUDY) {
                //竞技场战斗记录连续3条内不可存在同一对玩家的战斗记录
                List<Long> list = new ArrayList<>();
                list.add(atkRid);
                list.add(defRid);
                videoHall.setExtra(JsonUtil.toJson(list));
            } else {
                //TODO 其它类型的特殊处理
            }
            synchronized (event.getVideoType()) {
                if (isAddVideo(event)) {
                    videoHallDao.add(videoHall);
                    List<VideoHall> videoList = this.getHalls(event.getVideoType());
                    videoList.add(0, videoHall);
                    videoIdMap.put(videoHall.getId(), videoHall);

                    while (videoList.size() > VideoConst.MAX_COUNT) {
                        VideoHall delHall = videoList.remove(VideoConst.MAX_COUNT);
                        videoHallDao.remove(delHall);
                        videoIdMap.remove(delHall.getId());
                    }
                }
            }
            //添加个人录像馆
            if (event.getVideoType().getPersonType() == 1) {
                if (roleService.isRole(atkRid)) {
                    videoRoleService.addVideo(atkRid, PersonVideo.RECORD, videoHall);
                }
            } else if (event.getVideoType().getPersonType() == 2) {
                if (roleService.isRole(atkRid)) {
                    videoRoleService.addVideo(atkRid, PersonVideo.RECORD, videoHall);
                }
                if (roleService.isRole(defRid)) {
                    videoRoleService.addVideo(defRid, PersonVideo.RECORD, videoHall);
                }
            }
            commandBus.invoke(SaveBattleReportCommand.of(event.getBattleReport()));
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
    }

    /**
     * 是否添加录像记录
     *
     * @param event
     * @return
     */
    private boolean isAddVideo(VideoRecordEvent event) {
        boolean addVideo = true;
        if (event.getVideoType() == VideoType.PVP) {
            //竞技场战斗记录连续3条内不可存在同一对玩家的战斗记录
            if(isRecentVideo(event.getVideoType(), event.getBattleReport())) {
            	addVideo = false;
            }
        } else if (event.getVideoType() == VideoType.STUDY) {
            //切磋战斗记录连续3条内不可存在同一对玩家的战斗记录
        	if(isRecentVideo(event.getVideoType(), event.getBattleReport())) {
            	addVideo = false;
            }
        } else if (event.getVideoType() == VideoType.LADDER) {
            addVideo = event.getTestValue().equals(LadderConstant.NOT_SYSTEM);
        } else {
            //TODO 其它类型的处理
        }
        return addVideo;
    }
    
    
    private boolean isRecentVideo(VideoType videoType, BattleReport battleReport) {
    	long atkRid = battleReport.getLog().getAttackerLog().getRid();
        long defRid = battleReport.getLog().getDefenderLog().getRid();
        
        boolean isRecent = false;
        
        List<VideoHall> videoList = this.getHalls(videoType);
        for (int i = 0; i < 2 && i < videoList.size(); i++) {
            VideoHall videoHall = videoList.get(i);
            List<Long> pvpRids = JsonUtil.getList(videoHall.getExtra(), Long.class);
            if (pvpRids.contains(atkRid) && pvpRids.contains(defRid)) {
            	isRecent = true;
                break;
            }
        }
        return isRecent;
    }

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf("VideoHallService");
    }

    @Override
    public void start() throws Exception {
        for (VideoType videoType : VideoType.values()) {
            videoTypeMap.put(videoType, new ArrayList<>());
        }
        //服务器启动时加载数据回到内存
        for (VideoHall videoHall : videoHallDao.listAll()) {
            VideoType videoType = VideoType.valueOf(videoHall.getType());
            if (videoType == null) {
                return;
            }
            videoTypeMap.get(videoType).add(0, videoHall);
            videoIdMap.put(videoHall.getId(), videoHall);
        }
    }
}
