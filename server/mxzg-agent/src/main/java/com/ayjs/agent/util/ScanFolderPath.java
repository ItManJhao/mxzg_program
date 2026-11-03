package com.ayjs.agent.util;


 
import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;


public class ScanFolderPath {
	
	/**
	 * TODO:递归扫描指定文件夹下面的指定文件
	 * @return ArrayList<Object>
	 * @throws FileNotFoundException 
	 */
	public static List<String> scanFilesWithRecursion(String folderPath, String suffix){
		List<String> fileNames = new ArrayList<>();
		File directory = new File(folderPath);
		if(!directory.isDirectory()){
			try {
				throw new FileNotFoundException('"' + folderPath + '"' + " input path is not a Directory , please input the right path of the Directory. ^_^...^_^");
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}
		}
		
		if(directory.isDirectory()){
			File [] filelist = directory.listFiles();
			for(int i = 0; i < filelist.length; i ++){
				if(filelist[i].isDirectory()){
					fileNames.addAll(scanFilesWithRecursion(filelist[i].getAbsolutePath(), suffix));
				} else {
					String fileName = filelist[i].getAbsolutePath();
					if(suffix == null || "".equals(suffix) || fileName.endsWith(suffix)){
						fileNames.add(fileName);
					}
				}
			}
		}
		return fileNames;
	}
	
}
