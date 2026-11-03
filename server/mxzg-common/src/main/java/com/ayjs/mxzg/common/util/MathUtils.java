package com.ayjs.mxzg.common.util;

/**
 * 数字工具类
 */
public class MathUtils {

    /**
     * 获取比例
     *
     * @return
     */
    public static int getRate(long numerator, long denominator, int rate) {
        return (int) ((numerator / denominator) * rate);
    }

    /**
     * 获取百分比
     *
     * @param numerator
     * @param denominator
     * @return
     */
    public static int getPercent(long numerator, long denominator) {
        return (int) Math.ceil((numerator / (double) denominator) * 100);
    }

    /**
     * 获取数字的长度
     *
     * @param number
     * @return
     */
    public static int length(long number) {
        return (int) Math.log10(number) + 1;
    }

    /**
     * 获取给定数字指定位数的头位数 例如：number = 10010000001, bits = 4, return = 1001
     *
     * @param number
     * @param bits
     * @return
     */
    public static int getHeadNum(long number, int bits) {
        if (bits <= 0) {
            throw new IllegalArgumentException();
        }
        int totalLength = length(number);
        if (totalLength < bits) {
            throw new IllegalArgumentException();
        }
        long divisor = (long) Math.pow(10, totalLength - bits);
        return (int) (number / divisor);
    }

    /**
     * 获取给定数字指定位数的头位数后的数 例如：number = 10010000001, bits = 4, return = 0000001
     *
     * @param number
     * @param bits
     * @return
     */
    public static long getBodyNum(long number, int bits) {
        if (bits <= 0) {
            throw new IllegalArgumentException();
        }
        int totalLength = length(number);
        if (totalLength < bits) {
            throw new IllegalArgumentException();
        }
        long divisor = (long) Math.pow(10, totalLength - bits);
        long headNum = (int) (number / divisor);
        return number % (headNum * divisor);
    }

    /**
     * 获取给定数字指定位数的头位数 例如：number = 10010000001, referNum = 1002, return = 1001 ,取referNum的长度来截取number的头几位数
     *
     * @param number
     * @param referNum 参考数字
     * @return
     */
    public static int getHeadNumBy(long number, int referNum) {
        return getHeadNum(number, length(referNum));
    }

    /**
     * 扩大数字 例如: number = 10011000001, beginIndex = 4, bits = 1, return = 100101000001
     *
     * @param number
     * @param beginIndex 开始位置
     * @param bits       扩大位数
     * @return
     */
    public static long expand(long number, int beginIndex, int bits) {
        if (bits <= 0 || number <= 0) {
            throw new IllegalArgumentException();
        }
        int headNum = MathUtils.getHeadNum(number, beginIndex);
        int exponent = MathUtils.length(number) - beginIndex;
        if (exponent < 0) {
            throw new IllegalArgumentException();
        }
        long divisor = (long) Math.pow(10, exponent) * headNum;
        long result = number % divisor;
        return (long) Math.pow(10, exponent + bits) * headNum + result;
    }

    /**
     * 保留几位小数，默认四舍五入
     *
     * @param value
     * @param scale
     * @return
     */
    public static double getScaleDecimals(double value, int scale) {
        long temp = (long) Math.pow(10, scale);
        return ((double) Math.round(value * temp) / temp);
    }

    /**
     * 溢出判断
     *
     * @param upperLimit 上限
     * @param count      拥有数量
     * @param value      增加数量
     * @return true 如果溢出
     */
    public static boolean overflow(long upperLimit, long count, long value) {
        return (upperLimit - count) < value;
    }

    /**
     * 区间是否有交集
     *
     * @param a1
     * @param a2
     * @param b1
     * @param b2
     * @return
     */
    public static boolean isIntersection(int a1, int a2, int b1, int b2) {
        if (a2 > b2) {
            if (a1 < b2) {
                return true;
            }
        } else {
            if (b1 < a2) {
                return true;
            }
        }
        return false;
    }
}
