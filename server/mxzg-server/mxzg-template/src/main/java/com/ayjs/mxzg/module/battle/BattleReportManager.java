package com.ayjs.mxzg.module.battle;

import cn.hutool.core.util.ZipUtil;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.util.DateFormatConstants;
import com.ayjs.mxzg.common.util.FileUtils;
import com.ayjs.mxzg.common.util.NamesThreadFactory;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleReport;
import com.google.protobuf.InvalidProtocolBufferException;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.File;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * 战报帮助类
 * @author meiyc
 *
 */
@Slf4j
@Component
public class BattleReportManager implements Lifecycle {
	/**
	 * 默认存到当前目录的report里面
	 */
	@Value("${battle.report.path:}")
	private String battleReportPath;
	@Value("${battle.report.thread.num:1}")
	private int battleReportThreadNum;

	/** 线程池 */
	private ExecutorService executorService;
	/** 默认的战报填充 */
	private BattleReport defaultReport = BattleReport.getDefaultInstance();
	
	@Override
	public LifecycleInfo getInfo() {		
		return LifecycleInfo.valueOf("BATTLE_REPORT_MANAGER");
	}
	
	@Override
	public void start() throws Exception {
		this.executorService = Executors.newFixedThreadPool(battleReportThreadNum, new NamesThreadFactory("BATTLE_REPORT_MANAGER"));
	}
	
	@Override
	public void stop() throws Exception {		
		this.executorService.shutdown();
	}
	
	/**
	 * 获取战报
	 * @param battleId
	 * @return
	 */
	public BattleReport getReport(String battleId){
		BattleReport battleReport = loadReport(battleId);
		return battleReport == defaultReport ? null : battleReport;
	}
	
	/**
	 * 根据战报id获取战报
	 * @param battleId
	 * @return
	 */
	private BattleReport loadReport(String battleId){
		try {
			long startTime = DateTimeUtil.millisTime();
			byte[] bytes = FileUtils.getBytes(buildFullPath(battleId));
			if(bytes != null){
				try {
					BattleReport report = BattleReport.parseFrom(ZipUtil.unZlib(bytes));
					long endTime = DateTimeUtil.millisTime();
					long time = endTime - startTime;
					if(time > 20){
						log.info(String.format("战报:%s加载时间过长%sms", battleId, time));
					}
					return report;
				} catch (InvalidProtocolBufferException e) {
					e.printStackTrace();
				}
			}
		} catch (Exception e){
			
		}
		return defaultReport;
	}
	
	/**
	 * 保存战报
	 * @param report
	 */
	public void save(BattleReport report){
		this.executorService.submit(()->{
			String battleId = report.getBattleId();
			byte[] byteArray = report.toByteArray();
			long start = System.currentTimeMillis();
			byte[] bytes = ZipUtil.zlib(byteArray, 9);
			long end = System.currentTimeMillis();
			log.debug("战报{}压缩前{}字节压缩后{}字节耗时:{}ms", battleId, byteArray.length, bytes.length, end - start);
			FileUtils.writeFile(bytes, buildFilePath(battleId), buildFileName(battleId));
		});
	}
	
	/**
	 * 根据战报id生成路径
	 * @param battleId
	 * @return
	 */
	private String buildFilePath(String battleId){
		String[] battleArray = battleId.split("_");
		String serverId = battleArray[BattleConstant.BATTLE_SERVERID_INDEX];
		String battleType = battleArray[BattleConstant.BATTLE_TYPE_INDEX];
		String reportDateTime = battleArray[BattleConstant.BATTLE_DATE_INDEX];
		if (StringUtils.isBlank(battleReportPath)){
			battleReportPath = "report";
		}
		StringBuilder builder = new StringBuilder(battleReportPath).append(File.separator);
		builder.append(serverId).append(File.separator);
		builder.append(battleType).append(File.separator);
		builder.append(getReportDateStr(reportDateTime));
		return builder.toString();
	}
	
	/**
	 * 根据战报时间获取日期
	 * @param reportDateTime
	 * @return
	 */
	private String getReportDateStr(String reportDateTime){
		return reportDateTime.substring(0, DateFormatConstants.FORMAT_YYYYMMDD.length());		
	}
	
	/**
	 * 构建战报文件名
	 * @param battleId
	 * @return
	 */
	private String buildFileName(String battleId){
		return battleId.concat(".bin");
	}
	
	/**
	 * 构建全路径
	 * @param battleId
	 * @return
	 */
	private String buildFullPath(String battleId){
		StringBuilder builder = new StringBuilder();
		builder.append(buildFilePath(battleId));
		builder.append(File.separator);
		builder.append(buildFileName(battleId));
		return builder.toString();
	}
	
	/**
	 * 根据id删除战报
	 * @param battleId
	 */
	public void delete(String battleId){
		this.executorService.submit(()->{ 
			FileUtils.deleteFile(buildFullPath(battleId));
		});
	}
}
