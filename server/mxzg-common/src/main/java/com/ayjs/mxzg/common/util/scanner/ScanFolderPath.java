package com.ayjs.mxzg.common.util.scanner;


 
import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;


public class ScanFolderPath {
	
	/**
	 * 递归扫描指定文件夹下面的指定文件
	 * @return ArrayList<Object>
	 * @throws FileNotFoundException 
	 */
	public static List<String> scanFilesWithRecursion(String folderPath) throws FileNotFoundException{
		List<String> fileNames = new ArrayList<>();
		File directory = new File(folderPath);
		if(!directory.isDirectory()){
			throw new FileNotFoundException('"' + folderPath + '"' + " input path is not a Directory , please input the right path of the Directory. ^_^...^_^");
		}
		
		if(directory.isDirectory()){
			File [] filelist = directory.listFiles();
			for(int i = 0; i < filelist.length; i ++){
				if(filelist[i].isDirectory()){
					fileNames.addAll(scanFilesWithRecursion(filelist[i].getAbsolutePath()));
				} else{
					fileNames.add(filelist[i].getAbsolutePath());
				}
			}
		}
		return fileNames;
	}
	
}
