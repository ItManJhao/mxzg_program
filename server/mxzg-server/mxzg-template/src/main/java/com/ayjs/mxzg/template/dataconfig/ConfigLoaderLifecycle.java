package com.ayjs.mxzg.template.dataconfig;

import com.ayjs.mxzg.common.excel.ExcelLoader;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;

/**
 * 加载excel数据
 */
@Slf4j
@Component
@Configuration
public class ConfigLoaderLifecycle implements Lifecycle {

    @Value("${config.path:}")
    private String configPath;

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.SYSTEM, Ordinal._3, "DATA CONFIG");
    }

    @Override
    public void start() throws Exception {
        if (StringUtils.isNotBlank(configPath)){
            ExcelLoader.load(configPath);
        } else {
            log.error("configPath is null:{}", configPath);
        }
    }
}
