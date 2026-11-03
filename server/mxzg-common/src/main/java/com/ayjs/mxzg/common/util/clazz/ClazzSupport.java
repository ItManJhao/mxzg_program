package com.ayjs.mxzg.common.util.clazz;

import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.util.ReflectionUtil;
import com.ayjs.mxzg.common.util.TypeUtils;
import com.ayjs.mxzg.common.util.scanner.PackageScanner;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.lang.annotation.Annotation;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;


/**
 * class支持
 *
 * @author meiyc
 */
@SuppressWarnings("unchecked")
@Component
public class ClazzSupport implements Lifecycle {

    @Value("${base.package.path:com.ayjs}")
    private String basePackagePath;

    private List<Class<?>> allClazz = new ArrayList<>();

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.INITIALIZATION, 0, "CLAZZ_SUPPORT");
    }

    @Override
    public void start() throws RuntimeException {
        allClazz.addAll(PackageScanner.scanPackages(basePackagePath));
    }

    /**
     * 增加单个Class
     *
     * @param clazz
     * @return
     */
    public List<Class<?>> putClazz(Class<?> clazz) {
        if (allClazz.indexOf(clazz) > -1) {
            allClazz.remove(clazz);
        }
        allClazz.add(clazz);
        return allClazz;
    }

    public <P, C extends P> List<Class<C>> getLowSubclassOfType(Class<P> clazzType) {
        List<Class<C>> typeClasses = getSubclassOfType(clazzType);
        List<Class<C>> impClasses = typeClasses.stream().filter(this::isLowSubclassOfType).collect(Collectors.toList());
        impClasses.forEach(clazz -> typeClasses.remove(clazz.getSuperclass()));
        return typeClasses;
    }

    private boolean isLowSubclassOfType(Class<?> subclass) {
        Class<?> superclass = subclass.getSuperclass();
        return superclass != Object.class;
    }

    public <P, C extends P> List<Class<C>> getSubclassAndNotImpOfType(Class<P> clazzType) {
        return getClazzsOfType(clazzType).stream()
                .filter(type -> !isImplementationClass(clazzType, type))
                .map(pclass -> (Class<C>) cast(pclass))
                .collect(Collectors.toList());
    }


    public <P, C extends P> List<Class<C>> getSubclassOfType(Class<P> clazzType) {
        return getClazzsOfType(clazzType).stream().map(pclass -> (Class<C>) cast(pclass)).collect(Collectors.toList());
    }

    public <P, C extends P> List<Class<C>> getImpClassOfType(Class<P> clazzType) {
        return getImpClassesOfType(clazzType).stream().map(pclass -> (Class<C>) cast(pclass)).collect(Collectors.toList());
    }

    public <P, C extends P> Class<C> cast(Class<P> pClass) {
        return (Class<C>) pClass;
    }

    public List<Class<?>> getClazzsWithAnnotation(Class<? extends Annotation> annatationClazz) {
        return allClazz.stream().filter(clazz -> clazz.isAnnotationPresent(annatationClazz)).collect(Collectors.toList());
    }

    public List<Class<?>> getClazzsWithAnnotation2(Class<? extends Annotation> annatationClazz) {
        return allClazz.stream().filter(clazz -> isAnnotationPresent(annatationClazz, clazz)).collect(Collectors.toList());
    }

    private boolean isAnnotationPresent(Class<? extends Annotation> annatationClazz, Class<?> type) {
        return TypeUtils.resolveAnnotation(annatationClazz, type) != null;
    }

    public Map<Class<?>, List<Method>> getMethodMapWithAnnotation(Class<? extends Annotation> methodAnnatation) {
        return allClazz.stream().collect(Collectors.toMap(clazz -> clazz, clazz -> getMethodsWith(clazz, methodAnnatation)));
    }

    private List<Method> getMethodsWith(Class<?> clazz, Class<? extends Annotation> methodAnnatation) {
        return Arrays.asList(ReflectionUtil.getDeclaredMethodsWith(clazz, methodAnnatation));
    }

    public List<Class<?>> getClazzsOfType(Class<?> clazzType) {
        return allClazz.stream().filter(clazz -> isClazzOfType(clazzType, clazz)).collect(Collectors.toList());
    }

    private List<Class<?>> getImpClassesOfType(Class<?> clazzType) {
        return allClazz.stream().filter(clazz -> isImplementationClass(clazzType, clazz)).collect(Collectors.toList());
    }

    private <T> boolean isClazzOfType(Class<T> clazzType, Class<?> clazz) {
        return !clazz.isInterface() && (clazz == clazzType || isSubclass(clazz, clazzType) || isImplementationClass(clazz, clazzType));
    }

    private boolean isSubclass(Class<?> subclass, Class<?> superclass) {
        return ReflectionUtil.getSupperClass(subclass).stream().anyMatch(clazz -> clazz == superclass);
    }

    private boolean isImplementationClass(Class<?> interfaceClass, Class<?> implementationClass) {
        return Arrays.asList(implementationClass.getInterfaces()).stream().anyMatch(clazz -> clazz == interfaceClass);
    }

}
