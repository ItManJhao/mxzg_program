/**
 * 
 */
package com.ayjs.mxzg.deploy;

import java.io.File;

/**
 * @author YY
 *
 */
public class App {
	public static void main(String[] args) {
		File serverDir = new File("D:\\project\\mxzg\\temp\\mxzg-deploying\\template");
		for(int i = 1; i <= 5; i++) {
			File serviceDir = new File("D:\\project\\mxzg\\temp\\deploy\\service_" + i);
			if(!serviceDir.exists()) {
				serviceDir.mkdirs();
			}
			//复制文件
			Deployer.copyFiles(serverDir, serviceDir.getPath());
		}
	}
}
