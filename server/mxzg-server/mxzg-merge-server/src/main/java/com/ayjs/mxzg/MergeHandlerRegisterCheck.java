package com.ayjs.mxzg;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.config.Config;
import com.ayjs.mxzg.repository.manager.TableMetaManager;
import com.ayjs.mxzg.service.DataProcessorMetaManager;

import java.util.Map;
import java.util.Set;

/**
 * @Author: CWJ
 * @Date: 2020/11/10
 **/
public class MergeHandlerRegisterCheck {

    public static void main(String[] args) {
        if (args == null || args.length == 0) {
            Config.getInstance().setResourcePath(MergeServerStartUp.class.getResource("/").getPath());
        }

        Map<String, Set<Class<? extends AbstractEntity>>> allTables = ReflectionUtil.scannerRepository("com.ayjs.mxzg");
        TableMetaManager.getInstance().init(allTables);
        //初始化TableMerge
        DataProcessorMetaManager.getInstance().registerMeta(allTables);
        //MergeHandler初始化处理类
//        DataProcessorProxy.getInstance();
    }
}
