package com.ayjs.mxzg.common.excel;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ExcelExporter {

//	private static Logger logger = LoggerFactory.getLogger(ExcelExporter.class);
	
	//表头所在的行
	private static int FIELD_ROW = 2;
	//实际数据开始的行
	private static int DATA_START_ROW = 3;
	
	private static List<Map<String, String>> getData(File file) {
		return getWorkbookData(file);
	}

	private static List<Map<String, String>> getWorkbookData(File file) {
		XSSFWorkbook xwb = null;
		try {
			InputStream inputFile = new FileInputStream(file);
			xwb = new XSSFWorkbook(OPCPackage.open(inputFile));
			return getSheetData(xwb.getSheetAt(0));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (InvalidFormatException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if(xwb != null) {
				try {
					xwb.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return null;
	}

	private static List<Map<String, String>> getSheetData(XSSFSheet sheet) {
		List<Map<String, String>> result = new ArrayList<>();
		
		// 根据字段定义行确定数据的列数
		int maxColumn = sheet.getRow(FIELD_ROW).getLastCellNum();
		// 字段名的定义行
		String[] fields = readOneRow(sheet.getRow(FIELD_ROW), maxColumn);
		// 行号从0开始
		for (int rowIndex = DATA_START_ROW; rowIndex <= sheet.getLastRowNum(); rowIndex++) {
			XSSFRow row = sheet.getRow(rowIndex);
			if (row == null || row.getLastCellNum() == -1) {
				continue;
			}
			// 一条数据 [格1.格2.格3...]
			String[] values = readOneRow(row, maxColumn);
			if(values == null) {
				continue;
			}
			Map<String, String> data = new LinkedHashMap<>(fields.length);
			for (int i = 0; i < fields.length; i++) {
				data.put(fields[i], values[i]);
			}
			result.add(data);
		}
		return result;
	}
	
	private static String[] readOneRow(XSSFRow row, int columnSize) {
		// 一条数据 [格1.格2.格3...]
		String[] values = new String[columnSize];
		// 赋值前，全部填充为""
		Arrays.fill(values, "");
		// 格
		boolean hasValue = false;
		for (int columnIndex = row.getFirstCellNum(); columnIndex < columnSize; columnIndex++) {
			XSSFCell cell = row.getCell(columnIndex);
			if (cell == null) {
				continue;
			}
			String cellValue = getCellValue(cell);
			String value = cellValue.trim();
			values[columnIndex] = value;
			
			if (value != null && !value.equals("")) {
				hasValue = true;
			}
		}
		if(hasValue) {
			return values;
		} else {
			return null;
		}
	}

	/**
	 * 获取单元格里的值
	 * @param cell
	 * @return
	 */
	private static String getCellValue(XSSFCell cell) {
		String value = "";
		if (cell != null) {
			if (cell.getCellTypeEnum() == CellType.FORMULA) {
				try {
					value = String.valueOf(cell.getNumericCellValue());
				} catch (IllegalStateException e) {
					cell.setCellType(CellType.STRING);
					value = cell.getStringCellValue();
				}
			} else if (cell.getCellTypeEnum() == CellType.NUMERIC) {
				//获取数字类型的值有两种方式，一种是getRawValue，一种是getNumericCellValue
				//getRawValue是获取到原始的数字，即在excel中输入的值
				//getNumericCellValue是获取经过excel处理后的数字，像比较大的数字，excel会使用科学计数法的方式来记录，
				//通过这个方法就是获取到使用了科学计数法表示的数字，也就是说有可能会丢失部分的精度
				value = cell.getRawValue();
			} else if (cell.getCellTypeEnum() == CellType.STRING) {
				value = cell.getStringCellValue();
			}
		}
		return value;
	}
	
	
	/**
	 * 读取excel内容
	 * @param file
	 * @return
	 */
	public static List<Map<String, String>> readExcel(File file) {
		List<Map<String, String>> dataList = null;
		try {
			dataList = ExcelExporter.getData(file);
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("无法处理的文件:" + file.getName());
		}
		return dataList;
	}
//	/**
//	 * 获取Excel的版本信息
//	 * @param file
//	 * @return
//	 */
//	private static int getExcelVersion(File file) {
//		InputStream inputFile = null;
//		try {
//			inputFile = new BufferedInputStream(new FileInputStream(file));
//			if (POIXMLDocument..hasOOXMLHeader(inputFile)) {
//				return 2007;
//			} else {
//				throw new RuntimeException("无法解释的Excel版本");
//			}
//		} catch (Exception e) {
//			throw new RuntimeException("无法解释的Excel版本");
//		} finally {
//			if(inputFile != null) {
//				try {
//					inputFile.close();
//				} catch (IOException e) {
//					e.printStackTrace();
//				}
//			}
//		}
//	}
}

// 如对cell格式要求严格，可参考
// http://wenku.baidu.com/view/aeb79eddd15abe23482f4d39.html
// http://blog.csdn.net/hsunday0915/article/details/6035083
// http://sarin.iteye.com/blog/845035