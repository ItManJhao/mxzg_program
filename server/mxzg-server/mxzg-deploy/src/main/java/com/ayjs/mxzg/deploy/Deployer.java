/**
 * 
 */
package com.ayjs.mxzg.deploy;

import com.alibaba.fastjson.JSONObject;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.reflect.Field;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.regex.Matcher;

/**
 * @author YY
 *
 */
public class Deployer {
	
	// F:\deploy\servicehahah_ F:\WorkSpace\mxzg-deploy\template F:\WorkSpace\mxzg-deploy\serverconfig.txt \resources\application-release.properties,\resources\database-game.properties,\resources\database-log.properties 1 10
	
	
	public static void main(String[] args) {

//		args = new String[] {"D:\\project\\mxzg\\temp\\deploy\\service",
//				"D:\\project\\mxzg\\temp\\mxzg-deploying\\template",
//				"D:\\project\\mxzg\\temp\\mxzg-deploying\\serverconfig.txt",
//				"\\resources\\application-release.properties,\\resources\\database-game.properties,\\resources\\database-log.properties",
//				"1", "10"};
		
		String servicePattern = args[0];
		String templatePath = args[1];
		String configPath = args[2];
		String[] checkFiles = args[3].split(",");
		int start = Integer.valueOf(args[4]);
		int end = Integer.valueOf(args[5]);
		
		System.out.println("模板目录：" + templatePath);
		System.out.println("服务器文件目录：" + configPath);
		System.out.println("需要进行内容替换的文件：" + Arrays.toString(checkFiles));
		System.out.println("服务器起始ID：" + start);
		System.out.println("服务器终止ID：" + end);

		try {
			File file = new File(configPath);
			FileReader fr = new FileReader(file);
			BufferedReader br = new BufferedReader(fr);
			
			List<ServerConfig> configList = new ArrayList<>();
			String line = br.readLine();
			while(line != null) {
				line = line.trim();
				if(!"".equals(line)) {
					ServerConfig config = JSONObject.parseObject(line, ServerConfig.class);
					configList.add(config);
				}
				line = br.readLine();
			}
			br.close();
			fr.close();
			
			//1、复制目录
			System.out.println("正在拷贝目录");
			copyDeployDir(servicePattern, templatePath, configList, start, end);
			//2、更新配置
			System.out.println("正在更新文件内容");
			updateConfigFiles(servicePattern, configList, checkFiles, start, end);
			System.out.println("构建完成");
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		}
	}
	
	
	public static void updateConfigFiles(String servicePattern, List<ServerConfig> configList, String[] checkFiles, int start, int end) {
		Map<String, Field> fieldMap = new HashMap<>();
		
		try {
			//组装配置值
			for(Field field : ServerConfig.class.getDeclaredFields()) {
				field.setAccessible(true);
				DeployValue deployValue = field.getAnnotation(DeployValue.class);
				fieldMap.put(deployValue.value(), field);
			}
			for(ServerConfig serverConfig : configList) {
				if(serverConfig.getId() < start || end < serverConfig.getId()) {
					continue;
				}
				for(String checkFile : checkFiles) {
					File file = new File(servicePattern + "" + serverConfig.getId() + File.separator + checkFile);
					String fileContent = readFile(file);
					//替换检测文件中的配置内容
					for(Entry<String, Field> entry : fieldMap.entrySet()) {
						String regex = "##" + entry.getKey() + "##";
						String tempValue = entry.getValue().get(serverConfig).toString();
						String replaceValue = Matcher.quoteReplacement(tempValue);
						fileContent = fileContent.replaceAll(regex, replaceValue);
					}
					writeToFile(file, fileContent);
				}
			}
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}
	}
	
	public static String readFile(File file) {
		StringBuilder builder = new StringBuilder();
		try {
			FileReader fr = new FileReader(file);
			BufferedReader br = new BufferedReader(fr);
			String line = br.readLine();
			while(line != null) {
				builder.append(line).append("\n");
				line = br.readLine();
			}
			br.close();
			fr.close();
			return builder.toString();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public static void writeToFile(File file, String content) {
		try {
			FileWriter fw = new FileWriter(file);
			fw.write(content);
			fw.flush();
			fw.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public static void copyDeployDir(String servicePattern, String templatePath, List<ServerConfig> configList, int start, int end) {
		File serverDir = new File(templatePath);
		for(ServerConfig config : configList) {
			if(config.getId() < start || end < config.getId()) {
				continue;
			}
			File serviceDir = new File(servicePattern + config.getId());
			if(!serviceDir.exists()) {
				serviceDir.mkdirs();
			}
			//复制文件
			copyFiles(serverDir, serviceDir.getPath());
		}
	}
	
	
	public static void copyFiles(File dirFile, String destPath) {
		//复制文件
		for(File childFile : dirFile.listFiles()) {
			//需要复制的文件
			File copyFile = new File(destPath + File.separator + childFile.getName());
			if(childFile.isDirectory()) {
				if(!copyFile.exists()) {
					copyFile.mkdirs();
				}
				copyFiles(childFile, copyFile.getPath());
			} else {
				try {
					FileOutputStream fos = new FileOutputStream(copyFile);
					Files.copy(childFile.toPath(), fos);
					fos.flush();
					fos.close();
				} catch (FileNotFoundException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
}
