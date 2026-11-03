package com.ayjs.mxzg.common.config.reader;


import com.ayjs.mxzg.common.util.ExcelUtil;

import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * excel处理方法
 */
public class ExcelReader implements IReader {

    private static final Pattern PATTERN = Pattern.compile("[^~$]\\S*\\.xlsx");

    @Override
    public FileMeta handlerData(File file) {
        Map<String, Object> map = ExcelUtil.readConfigFile(file);
        FileMeta fileMeta = new FileMeta();
        if (map.containsKey("data")) {
            @SuppressWarnings("unchecked")
            List<String[]> data = (List<String[]>) map.get("data");
            if (data.size() > 3) {
                fileMeta.setData(data.subList(3, data.size()));
            }
            if (data.size() > 1) {
                fileMeta.setHead(data.get(2));
            }
            if (data.size() > 0) {
                fileMeta.setReadType(data.get(1));
            }
        }
        fileMeta.setName((String) map.get("name"));
        return fileMeta;
    }

    @Override
    public boolean matchType(String name) {
        return PATTERN.matcher(name).matches();
    }
}
