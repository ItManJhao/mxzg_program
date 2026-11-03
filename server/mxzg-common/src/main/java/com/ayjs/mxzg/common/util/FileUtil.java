/**
 * 
 */
package com.ayjs.mxzg.common.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * @author YY
 *
 */
public class FileUtil {
	
	public static void writeFile(String fileName, String content) {
		try {
			FileWriter fw = new FileWriter(fileName);
			fw.write(content);
			fw.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public static List<String> readTxtLines(File file) {
		List<String> list = new ArrayList<>();
		try {
			BufferedReader br = new BufferedReader(new FileReader(file));
			String line = br.readLine();
			while(line != null) {
				list.add(line);
				line = br.readLine();
			}
			br.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public static String readTxtFile(File file) {
		StringBuilder builder = new StringBuilder();
		try {
			BufferedReader br = new BufferedReader(new FileReader(file));
			String line = br.readLine();
			while(line != null) {
				builder.append(line);
				line = br.readLine();
			}
			br.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return builder.toString();
	}
	
	public static String txtFileMD5(File file) {
		String fileContext = readTxtFile(file);
		return MD5Util.getMD5(fileContext);
	}
}
