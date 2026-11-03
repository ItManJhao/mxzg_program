/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.video.service;

import com.ayjs.mxzg.config.excel.constant.VideoConst;
import com.ayjs.mxzg.gameserver.module.video.constant.PersonVideo;
import com.ayjs.mxzg.gameserver.module.video.dao.VideoRoleDao;
import com.ayjs.mxzg.gameserver.module.video.domain.VideoHall;
import com.ayjs.mxzg.gameserver.module.video.domain.VideoRole;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author YY
 *
 */
@Service
public class VideoRoleService {
	
	@Autowired
	private VideoRoleDao videoRoleDao;
	
	public List<VideoRole> getVideos(long rid, PersonVideo personVideo) {
		Map<String, Object> options = new HashMap<>();
		options.put("rid", rid);
		options.put("kind", personVideo.getValue());
		List<VideoRole> videos = videoRoleDao.list(options);
		while(videos.size() > VideoConst.MAX_COUNT) {
			deleteVideo(videos.remove(0));
		}
		return videos;
	}
	
	public VideoRole getById(long id) {
		return videoRoleDao.get(id);
	}
	
	public VideoRole addKeepVideo(long rid, VideoHall video) {
		return addVideo(rid, PersonVideo.KEEP, video);
	}
	public VideoRole addKeepVideo(long rid, VideoRole video) {
		return addVideo(rid, PersonVideo.KEEP, video);
	}
	
	
	/**
	 * 添加个人录像馆数据
	 * @param rid
	 * @param video
	 */
	protected VideoRole addVideo(long rid, PersonVideo personVideo, VideoHall video) {
		VideoRole videoRole = new VideoRole();
		videoRole.setRid(rid);
		videoRole.setKind(personVideo.getValue());
		videoRole.setType(video.getType());
		videoRole.setSubType(video.getSubType());
		videoRole.setTime(video.getTime());
		videoRole.setBattle_log(video.getBattle_log());
		videoRole.setHallId(video.getId());
		videoRoleDao.add(videoRole);
		return videoRole;
	}
	
	private VideoRole addVideo(long rid, PersonVideo personVideo, VideoRole video) {
		VideoRole videoRole = new VideoRole();
		videoRole.setRid(rid);
		videoRole.setKind(personVideo.getValue());
		videoRole.setType(video.getType());
		videoRole.setSubType(video.getSubType());
		videoRole.setTime(video.getTime());
		videoRole.setBattle_log(video.getBattle_log());
		videoRole.setHallId(video.getHallId());
		videoRole.setPersonId(video.getId());
		videoRoleDao.add(videoRole);
		return videoRole;
	}
	
	public void deleteVideo(VideoRole videoRole) {
		videoRoleDao.remove(videoRole);
	}
}
