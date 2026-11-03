package com.ayjs.agent;

import java.lang.instrument.ClassDefinition;
import java.lang.instrument.Instrumentation;
import java.util.List;


import com.ayjs.agent.util.FileUtils;
import com.ayjs.agent.util.ScanFolderPath;



/**
 * JavaAgent
 * @author meiyc
 *
 */
public class Agent {

//	private static Logger logger = LoggerFactory.getLogger(Agent.class);
	
	/**
	 * jvm未启动前调用
	 * 
	 * @param agentArgs
	 * @param inst
	 */
	public static void premain(String agentArgs, Instrumentation inst) {
		System.out.println("premain被调用");
//		logger.info("premain被调用");
	}

	
	/**
	 * agent调用
	 * 
	 * @param patchClassPath
	 * @param inst
	 */
	public synchronized static void agentmain(String patchClassPath, Instrumentation inst) {
		List<String> fileNames = ScanFolderPath.scanFilesWithRecursion(patchClassPath, ".class");
		for (String fileName : fileNames) {
			try {
				byte[] data = FileUtils.getBytes(fileName);
				String className = getClassName(fileName);
				Class<?> theClass = Class.forName(className);
				ClassDefinition classDefinition = new ClassDefinition(theClass, data);
				inst.redefineClasses(classDefinition);
				System.out.println(String.format("%s热更新成功", className));
//				logger.info(String.format("%s热更新成功", className));
			} catch (Exception e) {
				System.out.println(String.format("%s热更新失败", fileName));
//				logger.info(String.format("%s热更新失败", fileName));
				e.printStackTrace();
			}
		}
	}

	/**
	 * 获取要加载 的class文件名
	 * 
	 * @param name
	 *            String
	 * @return String
	 */
	private static String getClassName(String name) {
		String fileSeparator = System.getProperty("file.separator");
		int index = name.lastIndexOf(fileSeparator);
		if (index == -1) {
			return name;
		} else {
			return name.substring(index + 1, name.lastIndexOf('.'));
		}
	}

}
