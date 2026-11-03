/**
 *
 */
package com.ayjs.mxzg.common.excel;

import lombok.extern.slf4j.Slf4j;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author YY
 *
 */
@Slf4j
public class ExcelLoader {

    protected static List<BaseExcelCache<? extends BaseExcelModel>> cacheList = new ArrayList<>();
    protected static Map<String, BaseExcelCache<? extends BaseExcelModel>> cacheNames = new HashMap<>();

    /**
     * 加载全部文件
     *
     * @param excelPath
     */
    public static void load(String excelPath) {
        log.debug("excelPath:{}", excelPath);
        File dirFile = new File(excelPath);
        //加载excel数据到内存中
        Map<String, File> fileMap = new HashMap<>();
        for (File file : dirFile.listFiles()) {
            String fileShortName = file.getName().substring(0, file.getName().lastIndexOf("."));
            fileMap.put(fileShortName, file);
        }
        boolean hasException = false;
        for (BaseExcelCache<?> baseCache : cacheList) {
            try {
                File file = fileMap.get(baseCache.getFileName());
                if (file == null) {
                    throw new RuntimeException("没有找到文件名为[" + baseCache.getFileName() + "]的配置数据");
                }
                loadFile(file, baseCache);
            } catch (Exception e) {
                hasException = true;
                e.printStackTrace();
                log.error("loadFile error:" + baseCache.getFileName(), e);
//                throw e;
            }
        }
        for (BaseExcelCache<?> baseCache : cacheList) {
            try {
                baseCache.loadAfterAllReady();
            } catch (Exception e) {
                hasException = true;
                e.printStackTrace();
                log.error("loadAfterAllReady error:" + baseCache.getFileName(), e);
//                throw e;
            }
        }
        for (BaseExcelCache<?> baseCache : cacheList) {
            try {
                baseCache.check();
            } catch (Exception e) {
                hasException = true;
                e.printStackTrace();
                log.error("check error:" + baseCache.getFileName(), e);
//                throw e;
            }
        }
        if (hasException) {
            throw new RuntimeException("load exception excelPath:" + excelPath);
        }
    }

    private static void loadFile(File file, BaseExcelCache<?> baseCache) {
        if (file.getName().endsWith(".xlsx")) {
            if (file.getName().startsWith("~$")) {
                return;
            }
            List<Map<String, String>> dataList = ExcelExporter.readExcel(file);
            baseCache.loadData(dataList);
        } else if (file.getName().endsWith(".txt")) {
            //补充txt的数据加载方式
        } else {
            log.error("未知的文件处理类型[" + file.getName() + "]");
        }
    }

    /**
     * 加载部分文件
     *
     * @param excelPath
     * @param excelNames
     * @return
     */
    public static boolean loadSome(String excelPath, String[] excelNames) {
        //先检查是否所有文件都存在
        for (String excelName : excelNames) {
            File file = new File(excelPath + File.separator + excelName);
            if (!file.exists()) {
                log.error("未找到文件[" + excelName + "]");
                return false;
            }
        }
        for (String excelName : excelNames) {
            File file = new File(excelPath + File.separator + excelName);
            String fileShortName = file.getName().substring(0, file.getName().lastIndexOf("."));

            BaseExcelCache<?> baseCache = cacheNames.get(fileShortName);
            if (baseCache == null) {
                log.error("没有找到文件[" + file.getName() + "]对应的配置处理类");
                continue;
            }
            loadFile(file, baseCache);
        }
        for (BaseExcelCache<?> baseCache : cacheList) {
            try {
                baseCache.loadAfterAllReady();
            } catch (Exception e) {
                e.printStackTrace();
                throw e;
            }
        }
        for (BaseExcelCache<?> baseCache : cacheList) {
            try {
                baseCache.check();
            } catch (Exception e) {
                e.printStackTrace();
                throw e;
            }
        }
        return true;
    }

    public static void register(BaseExcelCache<?> baseCache) {
        if (baseCache.getFileName() == null) {
            return;
        }
        if (cacheNames.containsKey(baseCache.getFileName())) {
            throw new RuntimeException("重复的Excel缓存[" + baseCache.getFileName() + "]被定义["
                    + baseCache.getClass().getSimpleName() + "]");
        }
        cacheList.add(baseCache);
        cacheNames.put(baseCache.getFileName(), baseCache);
    }
}
