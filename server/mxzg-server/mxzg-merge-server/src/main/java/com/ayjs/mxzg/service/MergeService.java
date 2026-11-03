package com.ayjs.mxzg.service;

import com.ayjs.mxzg.common.persistence.meta.TableMeta;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.Config;
import com.ayjs.mxzg.processor.DataProcessorProxy;
import com.ayjs.mxzg.processor.ProcessorType;
import com.ayjs.mxzg.repository.manager.MergeRepositoryManager;
import com.ayjs.mxzg.repository.persister.MergeRepository;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/8/20
 **/
@Slf4j
public class MergeService {

    public static void merge() {
        List<String> beforeErrorTable = new ArrayList<>();
        List<String> afterErrorTable = new ArrayList<>();
        DataProcessorMetaManager dataProcessorMetaManager = DataProcessorMetaManager.getInstance();
        dataProcessorMetaManager.getDataProcessorMetas().forEach(processorMeta -> {
            try {
                log.info("合服前处理。。。，当前处理服务器：表{}", processorMeta.getClz());
                DataProcessorProxy.getInstance().getProcessor(processorMeta.getProcessorType()).beforeMerge(processorMeta.getClz(), processorMeta.getSource());
            } catch (Exception e) {
                beforeErrorTable.add(processorMeta.getClz().getSimpleName());
                log.error("{}合服前处理。。。，处理服务器失败", e);
            }
        });

        log.info("开始合服：{}");
        List<String> insertIntoErrorTable = doMerge();

        log.info("合服后处理{}", Config.getInstance().getTarget());
        dataProcessorMetaManager.getDataProcessorMetas().forEach(processor -> {
            try {
                DataProcessorProxy.getInstance().getProcessor(processor.getProcessorType()).afterMerge(processor.getClz(), processor.getSource());
            } catch (Exception e) {
                afterErrorTable.add(processor.getClz().getSimpleName());
                log.error("{}合服后处理，。。失败", Config.getInstance().getTarget(), e);
            }
        });
        if (beforeErrorTable.size() == 0 && afterErrorTable.size() == 0 && insertIntoErrorTable.size() == 0) {
            log.info("合服完成。目标服：{}，源服：{}，。。。。。。。。。。。", Config.getInstance().getTarget(), Config.getInstance().getSource());
        } else {
            log.error("目标服：{}，源服：{}，合服失败，合服前处理失败表列表：{}，合服后处理失败列表:{},合并数据失败：{}", Config.getInstance().getTarget(), Config.getInstance().getSource(),
                    GsonUtils.toJson(beforeErrorTable), GsonUtils.toJson(afterErrorTable), GsonUtils.toJson(insertIntoErrorTable));
        }
        //执行create select语句，不会创建主键


    }

    /***
     * 数据合并失败的表
     */
    private static List<String> doMerge() {
        List<String> result = new ArrayList<>();
        for (int serverId : Config.getInstance().getSource()) {
            if (serverId != Config.getInstance().getTarget()) {
                log.info("当前合并服务器{}。。。。", serverId);
                result.addAll(mergeData(serverId, MergeRepositoryManager.DATA_SIGN));
                result.addAll(mergeData(serverId, MergeRepositoryManager.LOG_SIGN));
            }
        }
        return result;
    }

    private static List<String> mergeData(int serverId, String sign) {
        List<String> result = new ArrayList<>();
        MergeRepository sourceRepository = MergeRepositoryManager.getInstance().get(serverId, sign);
        MergeRepository targetRepository = MergeRepositoryManager.getInstance().get(Config.getInstance().getTarget(), sign);
        List<String> targetSet = targetRepository.queryTableName();
        List<String> sourceSet = sourceRepository.queryTableName();
        sourceSet.forEach(tableName -> {
            ProcessorType processorType = DataProcessorMetaManager.getInstance().getTableName2ProcessType().get(tableName.toLowerCase());
            if (processorType == null || processorType.isMergeToSource()) {
                try {
                    mergeToSource(sourceRepository, targetRepository, targetSet, tableName);
                } catch (Exception e) {
                    log.error(String.format("合并表失败{%s},{%s}", tableName, serverId), e);
                    result.add(tableName + "，server:" + serverId);
                }
            }
        });
        return result;
    }

    private static void mergeToSource(MergeRepository sourceRepository, MergeRepository targetRepository, List<String> targetSet, String tableName) throws Exception {
        String sql = null;

        if (!targetSet.contains(tableName)) {
            sql = String.format("create table %s.%s like %s.%s", targetRepository.getDbName(), tableName, sourceRepository.getDbName(), tableName);
            targetRepository.execute(sql);

            targetSet.add(tableName);
        }
        TableMeta byTableName = TableMeta.getTableFromDB(tableName, targetRepository.getDataBaseAccessor());
//        sql = String.format("insert into %s.%s() select * from %s.%s", targetRepository.getDbName(), tableName, sourceRepository.getDbName(), tableName);
        sql = byTableName.buildSelectInsertInfo(targetRepository.getDbName(), sourceRepository.getDbName());
        log.info("开始合并表:{},sql:{}", tableName, sql);
        targetRepository.execute(sql);

    }


}
