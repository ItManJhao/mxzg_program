package com.ayjs.mxzg;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.CRepository;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.TypeUtil;
import lombok.extern.slf4j.Slf4j;
import org.reflections.Reflections;

import java.lang.reflect.Modifier;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/8/19
 **/
@Slf4j
public class ReflectionUtil {

    /***
     * 扫描所有表
     * @param packageName
     * @return
     */
    public static Set<Class<? extends AbstractEntity>> scanner(String packageName) {
        Set<Class<? extends AbstractEntity>> set = new HashSet<>();
        Reflections reflections = new Reflections(packageName);
        Set<Class<?>> classSet = reflections.getTypesAnnotatedWith(Table.class);
        classSet = classSet.stream().filter(clz -> !Modifier.isAbstract(clz.getModifiers())).collect(Collectors.toSet());

        classSet.forEach(clz -> {
            if (AbstractEntity.class.isAssignableFrom(clz)) {
                set.add((Class<? extends AbstractEntity>) clz);
            }
        });
        return set;
    }

    public static Map<String, Set<Class<? extends AbstractEntity>>> scannerRepository(String packageName) {
        Reflections reflections = new Reflections(packageName);
        Set<Class<?>> classSet = reflections.getTypesAnnotatedWith(CRepository.class);
        classSet = classSet.stream().filter(clz -> !Modifier.isAbstract(clz.getModifiers())).collect(Collectors.toSet());

        Map<String, Set<Class<? extends AbstractEntity>>> result = new HashMap<>();
        classSet.forEach(clz -> {
            CRepository annotation = getCRepository(clz);
            Class<?> paramClz = TypeUtil.resolveClassArguments(clz, IRepository.class)[0];
            if (TypeUtil.resolveAnnotation(Table.class, paramClz) != null) {
                log.info("{},{}", clz, paramClz);
                result.computeIfAbsent(annotation.source(), key -> new HashSet<>()).add((Class<? extends AbstractEntity>) paramClz);
            }
        });
        return result;
    }

    private static CRepository getCRepository(Class<?> clz) {
        CRepository result = null;
        while (clz != Object.class && result == null) {
            result = clz.getAnnotation(CRepository.class);
            clz = clz.getSuperclass();
        }
        return result;
    }

    public static void main(String[] args) {
//        ReflectionUtil.scanner("com.ayjs");
        ReflectionUtil.scannerRepository("com.ayjs");
        System.out.println("00000000000000000000000");
    }

}
