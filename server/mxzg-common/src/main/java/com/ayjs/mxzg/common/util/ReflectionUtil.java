/**
 * 
 */
package com.ayjs.mxzg.common.util;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.commons.lang3.StringUtils;

import com.google.common.reflect.TypeToken;
import com.googlecode.concurrentlinkedhashmap.ConcurrentLinkedHashMap;

/**
 * 反射工具类
 */
public abstract class ReflectionUtil extends org.springframework.util.ReflectionUtils {
	
	/**
	 * 类反射属性缓存
	 */
	private static final Map<Class<?>, Map<String, Field>> field_cache = new ConcurrentHashMap<Class<?>, Map<String, Field>>();
	
	/**
	 * 类反射方法缓存
	 */
	private static final Map<Class<?>, Map<String, Method>> method_cache = new ConcurrentHashMap<Class<?>, Map<String, Method>>();

	/**
	 * 获取类所有的属性(包括从父类继承的)
	 * @param clazz
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public static Field[] getAllDeclareFields(Class clazz){	
		
		if(clazz.getSuperclass() == Object.class){//父类就是顶级类
			return clazz.getDeclaredFields();
		}
		
		Set<String> names = new HashSet<String>();
		List<Field> list = new ArrayList<Field>();
		Class<?> searchType = clazz;
		while (!Object.class.equals(searchType) && searchType != null) {
			Field[] fields = searchType.getDeclaredFields();
			for (Field field : fields) {
				if(names.contains(field.getName())){
					continue;
				}
				list.add(field);
			}
			searchType = searchType.getSuperclass();
		}
		
		Field[] fields = new Field[list.size()];
		return list.toArray(fields);
	}
	
	/**
	 * 直接通过反射获取对象属性的值
	 * @param target
	 * @param fieldName
	 * @return
	 */
	public static Object getFieldValue(Object target, String fieldName){
		
		if(target == null){
			return null;
		}
		
		if(StringUtils.isBlank(fieldName)){
			return null;
		}
		
		//map直接返回
		if(target instanceof Map){
			return ((Map<?, ?>)target).get(fieldName);
		}
		
		Class<?> clazz = null;
		if(target instanceof Class){
			clazz = (Class<?>)target;
		} else {
			clazz = target.getClass();
		}
		
		Map<String, Field> filedMap = field_cache.get(clazz);
		//没有属性
		if(filedMap == null || !filedMap.containsKey(fieldName)){
			
			synchronized (clazz) {
				filedMap = field_cache.get(clazz);
				if(filedMap == null || !filedMap.containsKey(fieldName)){
					Field field = findField(clazz, fieldName);
					if(field != null){
						field.setAccessible(true);
						if(filedMap == null){
							filedMap = new ConcurrentLinkedHashMap.Builder<String, Field>().maximumWeightedCapacity(300).build();//做个长度缓存
							field_cache.put(clazz, filedMap);
						} 
						filedMap.put(fieldName, field);
					} 
				}
			}
			
		}
		
		if(filedMap == null || !filedMap.containsKey(fieldName)){
			throw new RuntimeException(String.format("类 [%s] 不存在属性 [%s]", clazz.getCanonicalName(), fieldName));
		}
		
		Field filed = filedMap.get(fieldName);
		
		try {
			return filed.get(target); 
		} catch (Exception e) {
			String message = String.format("类 [%s] 反射访问属性 [%s] 异常!", clazz.getCanonicalName(), fieldName);
			throw new RuntimeException(message, e);
		}
		
	}
	
	/**
	 * 直接通过反射设置对象属性的值
	 * @param target
	 * @param fieldName
	 * @param fieldValue
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static void setFieldValue(Object target, String fieldName, Object fieldValue){
		
		if(target == null){
			return;
		}
		
		if(StringUtils.isBlank(fieldName)){
			return;
		}
		
		//map直接返回
		if(target instanceof Map){
			((Map)target).put(fieldName, fieldValue);
			return;
		}
		
		Class<?> clazz = null;
		if(target instanceof Class){
			clazz = (Class<?>)target;
		} else {
			clazz = target.getClass();
		}
		
		Map<String, Field> filedMap = field_cache.get(clazz);
		//没有属性
		if(filedMap == null || !filedMap.containsKey(fieldName)){
			
			synchronized (clazz) {
				filedMap = field_cache.get(clazz);
				if(filedMap == null || !filedMap.containsKey(fieldName)){
					Field field = findField(clazz, fieldName);
					if(field != null){
						field.setAccessible(true);
						if(filedMap == null){
							filedMap = new ConcurrentLinkedHashMap.Builder<String, Field>().maximumWeightedCapacity(300).build();//做个长度缓存
							field_cache.put(clazz, filedMap);
						} 
						filedMap.put(fieldName, field);
					} 
				}
			}
			
		}
		
		if(filedMap == null || !filedMap.containsKey(fieldName)){
			throw new RuntimeException(String.format("类 [%s] 不存在属性 [%s]", clazz.getCanonicalName(), fieldName));
		}
		
		Field filed = filedMap.get(fieldName);
		
		try {
			filed.set(target, fieldValue); 
		} catch (Exception e) {
			String message = String.format("类 [%s] 反射访问属性 [%s] 异常!", clazz.getCanonicalName(), fieldName);
			throw new RuntimeException(message, e);
		}
		
	}
	
	
	/**
	 * 反射调用类的静态方法(注意本方法不支持重载方法的反射调用)
	 * @param clazz
	 * @param methodName
	 * @param args
	 * @return
	 */
	public static Object invokeStaticMethod(Class<?> clazz, String methodName, Object...args){
		return invokeMethod(clazz, methodName, args);
	}
	
	/**
	 * 反射调用方法(注意本方法不支持重载方法的反射调用)
	 * @param target  
	 * @param methodName
	 * @param args
	 * @return
	 */
	public static Object invokeMethod(Object target, String methodName, Object...args){
		
		if(target == null){
			return null;
		}
		
		if(StringUtils.isBlank(methodName)){
			return null;
		}
		
		Class<?> clazz = null;
		if(target instanceof Class){//本身就是class类 可能是调用静态方法
			clazz = (Class<?>)target;
		} else {
			clazz = target.getClass();
		}
			
		
		Map<String, Method> methodMap = method_cache.get(clazz);
		//没有属性
		if(methodMap == null || !methodMap.containsKey(methodName)){
			
			synchronized (clazz) {
				methodMap = method_cache.get(clazz);
				if(methodMap == null || !methodMap.containsKey(methodName)){
					Method method = findMethod(clazz, methodName, new Class<?>[]{});
					if(method != null){
						method.setAccessible(true);
						if(methodMap == null){
							methodMap = new ConcurrentLinkedHashMap.Builder<String, Method>().maximumWeightedCapacity(300).build();//做个长度缓存
							method_cache.put(clazz, methodMap);
						} 
						methodMap.put(methodName, method);
					} 
				}
			}
			
		}
		
		if(methodMap == null || !methodMap.containsKey(methodName)){
			throw new RuntimeException(String.format("类 [%s] 不存在方法 [%s]", clazz.getCanonicalName(), methodName));
		}
		
		Method method = methodMap.get(methodName);
		
		try {
			return method.invoke(target, args);
		} catch (Exception e) {
			String message = String.format("类 [%s] 反射访问方法 [%s] 异常!", clazz.getCanonicalName(), methodName);
			throw new RuntimeException(message, e);
		}
		
	}
	
	
	/**
	 * 查找唯一被指定注释声明的域
	 * @param <A> 注释类型
	 * @param clz 被查找的类
	 * @param type 指定的注释
	 * @return 不存在会返回 null
	 */
	public static <A extends Annotation> Field findUniqueFieldWithAnnotation(Class<?> clz, final Class<A> type) {
		final List<Field> fields = new ArrayList<Field>();
		doWithFields(clz, new FieldCallback() {
			@Override
			public void doWith(Field field) throws IllegalArgumentException, IllegalAccessException {
				fields.add(field);
			}
		}, new FieldFilter() {
			@Override
			public boolean matches(Field field) {
				return field.isAnnotationPresent(type);
			}
		});
		
		if (fields.size() > 1) {
			throw new IllegalStateException("被注释" + type.getSimpleName() + "声明的域不唯一");
		} else if (fields.size() == 1) {
			return fields.get(0);
		}
		return null;
	}

	/**
	 * 类似{@link org.springframework.util.ReflectionUtils#doWithFields(Class, FieldCallback, FieldFilter)}
	 * 的方法，只是该方法不会递归检查父类上的域
	 * @see org.springframework.util.ReflectionUtils#doWithFields(Class, FieldCallback, FieldFilter)
	 * @param clazz
	 * @param fc
	 * @param ff
	 * @throws IllegalArgumentException
	 */
	public static void doWithDeclaredFields(Class<?> clazz, FieldCallback fc, FieldFilter ff) throws IllegalArgumentException {
		if (clazz == null || clazz == Object.class) {
			return;
		}
		Field[] fields = clazz.getDeclaredFields();
		for (Field field : fields) {
			if (ff != null && !ff.matches(field)) {
				continue;
			}
			try {
				fc.doWith(field);
			} catch (IllegalAccessException ex) {
				throw new IllegalStateException("非法访问属性 '" + field.getName() + "': " + ex);
			}
		}
	}
	
	/**
	 * 获得第一个使用指定注释声明的属性
	 * @param clz 属性所在类
	 * @param annotationClass 注释类型
	 * @return 不存在则返回 null
	 */
	public static Field getFirstDeclaredFieldWith(Class<?> clz, Class<? extends Annotation> annotationClass) {
		for (Field field : clz.getDeclaredFields()) {
			if (field.isAnnotationPresent(annotationClass)) {
				return field;
			}
		}
		return null;
	}
	
	/**
	 * 获得全部使用指定注释声明的属性
	 * @param clz 属性所在类
	 * @param annotationClass 注释类型
	 * @return 不会返回 null
	 */
	public static Field[] getDeclaredFieldsWith(Class<?> clz, final Class<? extends Annotation> annotationClass) {
		final List<Field> fields = new ArrayList<Field>();
		ReflectionUtil.doWithFields(clz, new FieldCallback() {
			
			@Override
			public void doWith(Field field) throws IllegalArgumentException,
					IllegalAccessException {
				if (field.isAnnotationPresent(annotationClass)) {
					fields.add(field);
				}
			}
		});
		
		return fields.toArray(new Field[0]);
	}

	/**
	 * 获得第一个使用指定注释声明的方法
	 * @param clz 属性所在类
	 * @param annotationClass 注释类型
	 * @return 不存在则返回 null
	 */
	public static Method getFirstDeclaredMethodWith(Class<?> clz, Class<? extends Annotation> annotationClass) {
		for (Method method : clz.getDeclaredMethods()) {
			if (method.isAnnotationPresent(annotationClass)) {
				return method;
			}
		}
		return null;
	}

	/**
	 * 获得全部使用指定注释声明的方法
	 * @param clz 属性所在类
	 * @param annotationClass 注释类型
	 * @return 不会返回 null
	 */
	public static Method[] getDeclaredMethodsWith(Class<?> clz, Class<? extends Annotation> annotationClass) {
		List<Method> methods = new ArrayList<Method>();
		for (Method method : clz.getDeclaredMethods()) {
			if (method.isAnnotationPresent(annotationClass)) {
				methods.add(method);
			}
		}
		return methods.toArray(new Method[0]);
	}

	/**
	 * 获得全部使用指定注释声明的 get 方法
	 * @param clz 属性所在类
	 * @param annotationClass 注释类型	
	 */
	public static Method[] getDeclaredGetMethodsWith(Class<?> clz, Class<? extends Annotation> annotationClass) {
		List<Method> methods = new ArrayList<Method>();
		for (Method method : clz.getDeclaredMethods()) {
			if (method.getAnnotation(annotationClass) == null) {
				continue;
			}
			if (method.getReturnType().equals(void.class)) {
				continue;
			}
			if (method.getParameterTypes().length > 0) {
				continue;
			}
			methods.add(method);
		}
		return methods.toArray(new Method[0]);
	}
	
	/**
	 * 获取clazz的超类，但不包括Object.class
	 * @param clazz
	 * @return
	 */
	public static Set<Class<?>> getSupperClass(Class<?> clazz){
		Set<Class<?>> set = new HashSet<>(TypeToken.of(clazz).getTypes().rawTypes());
		set.remove(Object.class);
		return set;
	}
	
}
