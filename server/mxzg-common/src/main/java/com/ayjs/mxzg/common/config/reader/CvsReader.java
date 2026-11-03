package com.ayjs.mxzg.common.config.reader;

import au.com.bytecode.opencsv.CSVReader;
import lombok.extern.slf4j.Slf4j;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.regex.Pattern;

/**
 * csv处理方法
 */
@Slf4j
public class CvsReader implements IReader {

    private static final Pattern PATTERN = Pattern.compile("\\S{1,}.csv");

    @Override
    public FileMeta handlerData(File file) {
        try (CSVReader csvReader = new CSVReader(new InputStreamReader(new FileInputStream(file), StandardCharsets.UTF_8))) {
            //  指定编码,防止编码问题
            List<String[]> rowDataList = csvReader.readAll();
            //前5行不需要解析
            FileMeta fileMeta = new FileMeta();
            fileMeta.setData(rowDataList.subList(5, rowDataList.size()));
            fileMeta.setHead(rowDataList.get(0));
            return fileMeta;
        } catch (Exception e) {
            log.error(String.format("%s loading config error! ", file.getName()), e);
            return null;
        }
    }

    @Override
    public boolean matchType(String name) {
        return PATTERN.matcher(name).matches();
    }
}
