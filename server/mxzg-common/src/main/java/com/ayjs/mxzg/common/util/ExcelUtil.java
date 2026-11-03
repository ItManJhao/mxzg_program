package com.ayjs.mxzg.common.util;

import com.google.common.base.Throwables;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.xssf.usermodel.XSSFFormulaEvaluator;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.File;
import java.io.FileInputStream;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * excel工具类
 */
@Slf4j
public class ExcelUtil {

    private static final NumberFormat NUMBER_FORMAT;

    static {
        NUMBER_FORMAT = NumberFormat.getInstance();
        NUMBER_FORMAT.setGroupingUsed(false);
    }

    /**
     * 读取配置文件
     *
     * @param file 文件
     */
    public static Map<String, Object> readConfigFile(File file) {
        Map<String, Object> map = new LinkedHashMap<>();
        List<String[]> data = null;
        try (XSSFWorkbook workbook = new XSSFWorkbook(new FileInputStream(file))) {
            XSSFSheet sheet = workbook.getSheetAt(0);// 只获取每个Sheet表
            //表达式
            XSSFFormulaEvaluator evaluator = new XSSFFormulaEvaluator(workbook);
            if (sheet != null) {
                map.put("name", sheet.getSheetName());
                // getLastRowNum，获取最后一行的行标
                data = new ArrayList<>(sheet.getLastRowNum() + 1);
                for (int j = 0; j < sheet.getLastRowNum() + 1; j++) {
                    XSSFRow row = sheet.getRow(j);
                    if (row != null) {
                        String[] strArr = new String[row.getLastCellNum() > 0 ? row.getLastCellNum() : 0];
                        data.add(j, strArr);
                        // getLastCellNum，是获取最后一个不为空的列是第几个
                        for (int k = 0; k < row.getLastCellNum(); k++) {
                            if (row.getCell(k) != null) { // getCell 获取单元格数据
                                switch (row.getCell(k).getCellTypeEnum()) {
                                    case FORMULA:
                                        strArr[k] = evaluator.evaluate(row.getCell(k)).formatAsString();
                                        break;
                                    case NUMERIC:
                                        strArr[k] = NUMBER_FORMAT.format(row.getCell(k).getNumericCellValue());
                                        break;
                                    case STRING:
                                        strArr[k] = row.getCell(k).getStringCellValue();
                                        break;
                                    case BOOLEAN:
                                        strArr[k] = String.valueOf(row.getCell(k).getBooleanCellValue());
                                        break;
                                    default:
                                        break;
                                }
                            }
                        }
                    } else {
                        data.add(j, null);
                    }
                }
            }
            map.put("data", data);
        } catch (Exception e) {
            log.error(String.format("{%s} loading error!", file.getName()), e);
            Throwables.throwIfUnchecked(e);
            throw new RuntimeException(e);
        }
        return map;
    }
}
