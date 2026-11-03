/**
 * 
 */
package com.ayjs.mxzg.common.util;

import java.math.BigDecimal;

/**
 * @author YY
 *
 */
public class Calculator {
	/**
	 * 精度
	 */
	private int scale = 2;
	/**
	 * 取舍模式
	 */
	private int roundingMode = BigDecimal.ROUND_HALF_UP;
	/**
	 * 计算值
	 */
	private BigDecimal value = BigDecimal.ZERO;
	
	private Calculator() {}
	
	public static Calculator build() {
		return new Calculator();
	}
	
	public static Calculator build(int scale, int roundingMode) {
		Calculator calculator = new Calculator();
		calculator.scale = scale;
		calculator.roundingMode = roundingMode;
		return calculator;
	}
	/**
	 * 加
	 * @param add
	 * @return
	 */
	public Calculator add(int add) {
		value = value.add(new BigDecimal(add)).setScale(scale, roundingMode);
		return this;
	}
	/**
	 * 减
	 * @param subtract
	 * @return
	 */
	public Calculator subtract(int subtract) {
		value = value.subtract(new BigDecimal(subtract)).setScale(scale, roundingMode);
		return this;
	}
	/**
	 * 乘
	 * @param multiply
	 * @return
	 */
	public Calculator multiply(int multiply) {
		value = value.multiply(new BigDecimal(multiply)).setScale(scale, roundingMode);
		return this;
	}
	/**
	 * 除
	 * @param divide
	 * @return
	 */
	public Calculator divide(int divide) {
		value = value.divide(new BigDecimal(divide), scale, roundingMode);
		return this;
	}
	/**
	 * 加
	 * @param add
	 * @return
	 */
	public Calculator add(String add) {
		value = value.add(new BigDecimal(add)).setScale(scale, roundingMode);
		return this;
	}
	/**
	 * 减
	 * @param subtract
	 * @return
	 */
	public Calculator subtract(String subtract) {
		value = value.subtract(new BigDecimal(subtract)).setScale(scale, roundingMode);
		return this;
	}
	/**
	 * 乘
	 * @param multiply
	 * @return
	 */
	public Calculator multiply(String multiply) {
		value = value.multiply(new BigDecimal(multiply)).setScale(scale, roundingMode);
		return this;
	}
	/**
	 * 除
	 * @param divide
	 * @return
	 */
	public Calculator divide(String divide) {
		value = value.divide(new BigDecimal(divide), scale, roundingMode);
		return this;
	}
	/**
	 * 加
	 * @param add
	 * @return
	 */
	public Calculator add(BigDecimal add) {
		value = value.add(add).setScale(scale, roundingMode);
		return this;
	}
	/**
	 * 减
	 * @param subtract
	 * @return
	 */
	public Calculator subtract(BigDecimal subtract) {
		value = value.subtract(subtract).setScale(scale, roundingMode);
		return this;
	}
	/**
	 * 乘
	 * @param multiply
	 * @return
	 */
	public Calculator multiply(BigDecimal multiply) {
		value = value.multiply(multiply).setScale(scale, roundingMode);
		return this;
	}
	/**
	 * 除
	 * @param divide
	 * @return
	 */
	public Calculator divide(BigDecimal divide) {
		value = value.divide(divide, scale, roundingMode);
		return this;
	}
	/**
	 * 加
	 * @param add
	 * @return
	 */
	public Calculator add(long add) {
		value = value.add(new BigDecimal(add)).setScale(scale, roundingMode);
		return this;
	}
	/**
	 * 减
	 * @param subtract
	 * @return
	 */
	public Calculator subtract(long subtract) {
		value = value.subtract(new BigDecimal(subtract)).setScale(scale, roundingMode);
		return this;
	}
	/**
	 * 乘
	 * @param multiply
	 * @return
	 */
	public Calculator multiply(long multiply) {
		value = value.multiply(new BigDecimal(multiply)).setScale(scale, roundingMode);
		return this;
	}
	/**
	 * 除
	 * @param divide
	 * @return
	 */
	public Calculator divide(long divide) {
		value = value.divide(new BigDecimal(divide), scale, roundingMode);
		return this;
	}
	
	
	
	/**
	 * 计算结果
	 * @return
	 */
	public BigDecimal result() {
		return value;
	}
	/**
	 * 重置
	 * @return
	 */
	public Calculator reset() {
		value = BigDecimal.ZERO;
		return this;
	}
	
	public static void main(String[] args) {
		Calculator calculator = Calculator.build(8, BigDecimal.ROUND_FLOOR);
		calculator.add(1000).divide(90 * 24 * 60 * 60).multiply(2 * 24 * 60 * 60);
		System.out.println(calculator.result());
	}
}
