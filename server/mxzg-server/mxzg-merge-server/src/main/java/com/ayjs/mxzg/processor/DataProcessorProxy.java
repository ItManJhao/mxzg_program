package com.ayjs.mxzg.processor;

import lombok.extern.slf4j.Slf4j;
import org.reflections.Reflections;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

/**
 * @Author: CWJ
 * @Date: 2020/8/20
 **/
@Slf4j
public class DataProcessorProxy {

    private static DataProcessorProxy instance;

    public static DataProcessorProxy getInstance() {
        if (instance == null) {
            instance = new DataProcessorProxy();
            instance.init();
        }
        return instance;
    }

    Map<ProcessorType, DataProcessor> map = new HashMap<>();

    public void init() {
        Reflections reflections = new Reflections("com.ayjs.mxzg");
        Set<Class<? extends DataProcessor>> subTypesOf = reflections.getSubTypesOf(DataProcessor.class);
        subTypesOf.forEach(clz -> {
            try {
                DataProcessor dataProcessor = clz.newInstance();
                DataProcessor old = map.put(dataProcessor.getType(), dataProcessor);
                if (Objects.nonNull(old)) {
                    log.error("合表处理类型重复{}", dataProcessor.getType());
                }
            } catch (Exception e) {
                log.error("初始化MergeHandler异常{}", clz);
            }
        });
    }

    public DataProcessor getProcessor(ProcessorType processorType) {
        return map.get(processorType);
    }


}
