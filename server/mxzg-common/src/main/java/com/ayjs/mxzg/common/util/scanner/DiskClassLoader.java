package com.ayjs.mxzg.common.util.scanner;


import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URL;

/**
 * 从本地加载文件
 */
public class DiskClassLoader extends ClassLoader {
	
	//class文件流
    private byte[] data;

    @Override
    protected Class<?> findClass(String fileName) throws ClassNotFoundException {
    	 String className = getClassName(fileName);

         File file = new File(fileName);

         try {
             FileInputStream is = new FileInputStream(file);

             ByteArrayOutputStream bos = new ByteArrayOutputStream();
             int len = 0;
             try {
                 while ((len = is.read()) != -1) {
                     bos.write(len);
                 }
             } catch (IOException e) {
                 e.printStackTrace();
             }

             this.data = bos.toByteArray();
             is.close();
             bos.close();
            return defineClass(className, data, 0, data.length);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return super.findClass(fileName);
    }

    /**
     * 获取要加载 的class文件名
     * 
     * @param name String
     * @return String
     */
    private String getClassName(String name) {
    	String fileSeparator = System.getProperty("file.separator");
        int index = name.lastIndexOf(fileSeparator);
        if (index == -1) {
            return name;
        } else {
            return name.substring(index + 1, name.lastIndexOf('.')) ;
        }
    }

    @Override
    public URL getResource(String name) {
        return super.getResource(name);
    }
    
    /**
     * 获取类文件
     * @return
     */
    public byte[] getData(){
    	return this.data;
    }
    
}
