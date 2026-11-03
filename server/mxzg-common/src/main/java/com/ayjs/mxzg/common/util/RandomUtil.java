package com.ayjs.mxzg.common.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Random;
import java.util.TreeMap;
import java.util.concurrent.ThreadLocalRandom;

public class RandomUtil {

    protected static Logger log = LoggerFactory.getLogger(RandomUtil.class);

    public static Random getRandom() {
        return ThreadLocalRandom.current();
    }

    private static char[] numbersAndLetters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ".toCharArray();


    /**
     * 获取随机数[1,2),闭，开区间
     *
     * @throws IllegalArgumentException when max < min
     */
    public static int rand(int min, int max) {
        return rand(getRandom(), min, max);
    }

    public static int rand(Random random, int min, int max) {
        if (min > max) {
            throw new IllegalArgumentException("bound must be greater than origin");
        }
        int differ = max - min;
        return min + random.nextInt(differ);
    }

    /**
     * 制定范围随机
     *
     * @param range
     * @param upperLimit
     * @return
     */
    public static boolean randomUpperLimit(int range, int upperLimit) {
        return randomUpperLimit(getRandom(), range, upperLimit);
    }

    public static boolean randomUpperLimit(Random random, int range, int upperLimit) {
        if (rand(random, 0, upperLimit) > range) {
            return false;
        } else {
            return true;
        }
    }

    /**
     * 制定范围随机多次
     *
     * @param range
     * @param upperLimit
     * @return
     */
    public static int randomUpperLimitMultiple(int range, int upperLimit, int times) {
        int result = 0;
        for (int i = 0; i < times; i++) {
            if (randomUpperLimit(range, upperLimit)) {
                result++;
            }
        }
        return result;
    }

    /**
     * 检查是否命中
     *
     * @param rate 命中率
     * @return 命中返回 true, 不命中返回 false
     */
    public static boolean isHit(double rate) {
        return isHit(getRandom(), rate);
    }

    /**
     * 检查是否命中
     *
     * @param rate   命中率
     * @param random 伪随机序列
     * @return
     */
    public static boolean isHit(Random random, double rate) {
        if (rate <= 0) {
            return false;
        }
        double value = random.nextDouble();
        if (value <= rate) {
            return true;
        }
        return false;
    }

    /**
     * 获取概率事件，几率最多支持3位小数
     *
     * @param map 参数举例: Map(1=>20.1, 2=>29.9, 3=>50), 则20.1%几率返回1, 29.9%返回2, 50%返回3
     * @return 返回键值
     */
    public static <T> T getRand(Map<T, Double> map) {
        int multiple = 1000; // 放大位数

        // 求和
        int sum = 0;
        Iterator<Entry<T, Double>> iterator = map.entrySet().iterator();
        while (iterator.hasNext()) {
            Entry<T, Double> entry = iterator.next();
            Double v = entry.getValue();
            sum += v * multiple;
        }

        if (sum <= 0) {
            return null;
        }

        // 产生0-sum的整数随机
        int luckNum = getRandom().nextInt(sum) + 1;
        int tmp = 0;
        iterator = map.entrySet().iterator();
        while (iterator.hasNext()) {
            Entry<T, Double> entry = iterator.next();
            Double v = entry.getValue();
            tmp += v * multiple;
            if (luckNum <= tmp) {
                return entry.getKey();
            }
        }
        return null;
    }

    /**
     * 适用于概率值不是很大时使用
     */
    public static <T> T getRandInteger(Map<T, Integer> map) {
        int multiple = 10; // 放大位数

        // 求和
        int sum = 0;
        Iterator<Entry<T, Integer>> iterator = map.entrySet().iterator();
        while (iterator.hasNext()) {
            Entry<T, Integer> entry = iterator.next();
            Integer v = entry.getValue();
            sum += v * multiple;
        }

        if (sum <= 0) {
            return null;
        }

        // 产生0-sum的整数随机
        int luckNum = getRandom().nextInt(sum) + 1;
        int tmp = 0;
        iterator = map.entrySet().iterator();
        while (iterator.hasNext()) {
            Entry<T, Integer> entry = iterator.next();
            Integer v = entry.getValue();
            tmp += v * multiple;
            if (luckNum <= tmp) {
                return entry.getKey();
            }
        }
        return null;
    }

    /**
     * 从集合中随机一个元素
     *
     * @date: 2016年4月12日 下午1:18:08
     */
    public static <T> T getRand(List<T> map) {
        return getRand(getRandom(), map);
    }

    public static <T> T getRand(Random random, List<T> map) {
        return randomEle(random, map);
    }

    public static <T> T randomEle(List<T> list) {
        return randomEle(getRandom(), list);
    }

    public static <T> T randomEle(Random random, List<T> list) {
        return randomEle(random, list, list.size());
    }

    public static <T> T randomEle(List<T> list, int limit) {
        return randomEle(getRandom(), list, limit);
    }

    public static <T> T randomEle(Random random, List<T> list, int limit) {
        return list.get(nextInt(random, limit));
    }

    /**
     * 获取概率事件
     *
     * @param wildsArr 字符数组
     * @param num      返回结果个数
     * @return 选中结果（会有重复的）
     */
    public static int[] getRandByStrArray(int[] wildsArr, int num) {
        int[] ret = new int[num];
        int len = wildsArr.length;
        for (int i = 0; i < num; i++) {
            int luckNum = getRandom().nextInt(len);
            System.arraycopy(wildsArr, luckNum, ret, i, 1);
        }
        return ret;
    }

    /**
     * 计算是否中奖
     */
    public static boolean lucky(int base, int rate) {
        return lucky(getRandom(), base, rate);
    }

    public static boolean lucky(Random random, int base, int rate) {
        if (rate < 0 || rate > base || base <= 0) {
            log.warn("lucky illegal param. rate={}, base={}", rate, base);
            return false;
        }

        if (rate == 0) {
            return false;
        }
        if (rate == base) {
            return true;
        }

        int luckyValue = rand(random, 0, base);
        return luckyValue < rate;
    }

    /**
     * 获取两个数之间的随机数，得出的值符合正态分布
     *
     * @param min    最小值
     * @param max    最大值
     * @param factor 调整曲线参数
     */
    public static int gaussianRand(int min, int max, int factor) {
        if (min > max) {
            return 0;
        }
        int middle = (int) Math.ceil((min + max) / 2.0);
        int in = max - middle;
        factor = Math.max(factor, 0);
        LinkedHashMap<Integer, Double> map = new LinkedHashMap<>();
        for (int i = min; i <= max; i++) {
            if (i == middle) {
                map.put(i, (double) in);
            } else {
                double tmp = Math.abs(in - Math.abs(middle - i));
                tmp = tmp <= 0 ? 1 : tmp;
                tmp = factor > 0 ? tmp * (1 + factor / 100.0) : tmp;
                tmp = tmp > in ? in : tmp;
                map.put(i, tmp);
            }
        }
        return getRand(map);
    }

    /**
     * 获取两个数之间的随机数，得出的值符合正态分布
     *
     * @param min 最小值
     * @param max 最大值
     */
    public static int gaussianRand(int min, int max) {
        return gaussianRand(min, max, 0);
    }

    /**
     * 在一个范围内随机一定量的的数值
     *
     * @author tangyangbo 2014-1-21
     */
    public static List<Integer> randomList(int start, int end, int num) {
        List<Integer> result = new ArrayList<>();
        if (start >= end) {
            return result;
        }
        // 包含头尾，返回所有可能，打乱顺序
        if ((end - start + 1) <= num) {
            for (int i = start; i <= end; i++) {
                result.add(i);
            }
            Collections.shuffle(result);
            return result;
        }
        // 列举所有数值
        List<Integer> temp = new ArrayList<>();
        for (int i = start; i <= end; i++) {
            temp.add(i);
        }
        // 取出一个删除一个，然后继续再剩余的列表随机
        for (int i = 0; i < num; i++) {
            int index = rand(0, temp.size());
            Integer value = temp.get(index);
            if (!result.contains(value)) {
                temp.remove(index);
                result.add(value);
            }
        }
        return result;
    }

    /**
     * 在一组数据里面随机几个值
     *
     * @param array 随机的源数据
     * @param num   获取数据个数
     * @author tangyangbo 2015年11月23日
     */
//    public static <T> List<T> getRandByArray(T[] array, int num) {
//        List<T> result = new ArrayList<>();
//        int maxIndex = array.length;
//
//        if (maxIndex <= num) return Arrays.stream(array).collect(Collectors.toList());
//
//        List<Integer> randomIndex = randomList(0, maxIndex - 1, num);
//        for (Integer index : randomIndex) {
//            if (index == null || index < 0 || index > maxIndex - 1) {
//                continue;
//            }
//            if (result.size() >= num) {
//                break;
//            }
//            result.add(array[index]);
//        }
//        return result;
//    }

    /**
     * 在一组数据里面随机几个值
     */
//    public static <T> List<T> getRandByArray(List<T> list, int num) {
//        int maxIndex = list.size();
//        if (maxIndex <= num) return new ArrayList<>(list);
//
//        List<T> result = new ArrayList<>();
//        int[] randomIndex = randomN(0, maxIndex - 1, num);
//        for (int index : randomIndex) {
//            result.add(list.get(index));
//        }
//        return result;
//    }

    /**
     * 从[0-9] 和 [A-Z] 中随机定长的字符串
     *
     * @param length 生成字符串长度
     * @author tangyangbo 2016年1月11日
     */
    public static String randomString(int length) {
        if (length <= 0) {
            return null;
        }
        char[] randBuffer = new char[length];
        for (int i = 0; i < randBuffer.length; i++) {
            randBuffer[i] = numbersAndLetters[getRandom().nextInt(numbersAndLetters.length - 1)];
        }
        return new String(randBuffer);
    }

    /**
     * 通用事件概率
     *
     * @author
     */
    public static class RateObject implements RandomObject {
        /**
         * ID
         */
        private int id;
        /**
         * 权重比例
         */
        private int rate;

        public RateObject(int id, int rate) {
            this.id = id;
            this.rate = rate;
        }

        @Override
        public int getId() {
            return id;
        }

        @Override
        public int getRate() {
            return rate;
        }

        public void setId(int id) {
            this.id = id;
        }

        public void setRate(int rate) {
            this.rate = rate;
        }
    }

    public interface RandomObject {

        int getId();

        int getRate();
    }

    public static <T extends RandomObject> T randomObject(Collection<T> list) {
        return randomObject(list, RandomObject::getRate);
    }

    @FunctionalInterface
    public interface Weight<T> {

        int get(T t);
    }

    public static <T> T randomObject(Collection<T> list, Weight<T> weight) {
        int totalRate = 0;
        for (T temp : list) {
            totalRate += weight.get(temp);
        }
        int randomRate = rand(0, totalRate);
        int currRate = 0;
        T t = null;
        for (T temp : list) {
            currRate += weight.get(temp);
            if (randomRate <= currRate) {
                t = temp;
                break;
            }
        }
        return t;
    }

    /**
     * 储存权重值
     *
     * @param weights 储存进入此List<0=id,1=权重上限值>中
     * @param id      数据id
     * @param weight  数据权重值
     */
    public static void putWeight(List<Object[]> weights, Object id, int weight) {
        int lastWeight = 0;
        if (weights.isEmpty() == false) {
            lastWeight = (int) weights.get(weights.size() - 1)[1];
        }
        weight += lastWeight;
        //0=id,1=权重上限值
        weights.add(new Object[]{id, weight});
    }

    /**
     * 获取权重值
     *
     * @param weights putWeight时储存的List
     * @param clazz   返回的类型
     */
    @SuppressWarnings("unchecked")
    public static <T> T getWeight(List<Object[]> weights, Class<T> clazz) {
        if (weights == null || weights.isEmpty()) {
            return null;
        }
        if (weights.size() == 1) {
            return (T) weights.get(weights.size() - 1)[0];
        }
        int lastWeight = (int) weights.get(weights.size() - 1)[1];
        if (lastWeight <= 0) {
            return null;
        }
        int weight = getRandom().nextInt(lastWeight);
        return search(weights, weight);
    }

    public static <T> T search(List<Object[]> weights, int weight) {
        int min = 0;
        int max = weights.size();
        //2分算法搜索权重范围
        while (min <= max) {
            //获取中间值
            int tmp = min + (max - min) / 2;
            Object[] objs = weights.get(tmp);
            int tmpWeight = (int) objs[1];
            if (weight == tmpWeight) {
                return (T) objs[0]; // 相同
            } else if (weight < tmpWeight && (tmp == 0 || weight > (int) weights.get(tmp - 1)[1])) {
                return (T) objs[0]; // 在范围内
            } else if (weight < tmpWeight) {
                max = tmp;
            } else {
                min = tmp;
            }
        }
        return null;
    }

    /**
     * 在数组r中找k
     *
     * @param r 有序数组
     * @param k
     * @return[0] 找到的下标 -1 找不到  [1][2]是k在数组的区间下标
     */

    public static int[] interSearch(List<Integer> r, int k) {

        int s = 0, e = r.size() - 1;//s和e表示当前查找子表的下限和上限

        if (r.get(s) > k) {
            return new int[]{-1, s, s};
        } else if (r.get(e) < k) {
            return new int[]{-1, e, e};
        }
        int i;
        while (e - s > 1) {
            //k的期望值
            i = (int) (Math.ceil(s + 1.0 * (k - r.get(s)) / (r.get(e) - r.get(s)) * (e - s - 1)));
            if (k < r.get(i)) e = i;
            if (k > r.get(i)) s = i;
            if (k == r.get(i)) return new int[]{i, s, e};
        }
        if (k == r.get(e)) return new int[]{e, e, e};
        if (k == r.get(s)) return new int[]{s, s, s};
        return new int[]{-1, s, e};
    }

    /**
     * 随机指定范围内N个不重复的数
     * 最简单最基本的方法
     *
     * @param min 指定范围最小值
     * @param max 指定范围最大值
     * @param n   随机数个数
     */
    public static int[] randomN(int min, int max, int n) {
        if (max <= min) {
            throw new IllegalArgumentException();
        }

        if (n > max - min + 1) {
            throw new IllegalArgumentException();
        }

        int[] result = new int[n];
        Random random = getRandom();
        int count = 0;
        while (count < n) {
            int num = random.nextInt(max - min + 1) + min;
            boolean flag = true;
            for (int j = 0; j < n; j++) {
                if (num == result[j]) {
                    flag = false;
                    break;
                }
            }
            if (flag) {
                result[count] = num;
                count++;
            }
        }
        return result;
    }

    /**
     * @param middle 中间值
     * @param min    最小值，可包含
     * @param max    最大值，可包含
     * @param period 正态跨度
     * @return
     */
    public static int gaussianRandom(int middle, int min, int max, int period) {

        double g = getRandom().nextGaussian();

        int res = middle;
        res = (int) Math.round(middle + g * period);

        if (res < min) {
            res = min;
        } else if (res > max) {
            res = max;
        }
        return res;
    }

    /**
     * 随机范围值(包括最大值和最小值)
     *
     * @param min
     * @param max
     * @return
     */
    public static int getRandomInt(int min, int max) {
        int abs = Math.abs(max - min) + 1;
        return (min + getRandom().nextInt(abs));
    }

    /**
     * 随机从list中找出x个不相同的数据对象
     *
     * @param list
     * @param x
     * @return
     */
    public static <T> List<T> randomList(List<T> list, int x) {
        return randomList(getRandom(), list, x);
    }

    public static <T> List<T> randomList(Random random, List<T> list, int x) {
        List<T> result = new ArrayList<T>(x);

        if (x <= 0 || CollectionUtils.isEmpty(list))
            return result;

        int size = list.size();
        if (x == 1) {
            result.add(list.get(rand(random, 0, size)));
            return result;
        }
        if (x >= size) {
            result.addAll(list);
            return result;
        }
        List<T> temList = new ArrayList<T>(list);
        for (int i = 0; i < x; i++) {
            result.add(temList.remove(rand(random, 0, temList.size())));
        }
        return result;
    }

    /**
     * @return
     * @see Random#nextBoolean()
     */
    public static boolean nextBoolean() {
        return getRandom().nextBoolean();
    }

    /**
     * @return
     * @see Random#nextBytes(byte[])
     */
    public static void nextBytes(byte[] bytes) {
        getRandom().nextBytes(bytes);
    }

    /**
     * @return
     * @see Random#nextDouble()
     */
    public static double nextDouble() {
        return getRandom().nextDouble();
    }

    /**
     * @return
     * @see Random#nextFloat()
     */
    public static float nextFloat() {
        return getRandom().nextFloat();
    }

    /**
     * @return
     * @see Random#nextInt()
     */
    public static int nextInt() {
        return getRandom().nextInt();
    }

    /**
     * @return
     * @see Random#nextInt(int)
     */
    public static int nextInt(int n) {
        return nextInt(getRandom(), n);
    }

    public static int nextInt(Random random, int n) {
        return random.nextInt(n);
    }

    /**
     * @return
     * @see Random#nextLong()
     */
    public static long nextLong() {
        return getRandom().nextLong();
    }

    public static void main(String[] args) {

        int res;

        Map<Integer, Integer> map = new TreeMap<Integer, Integer>();

        for (int i = 50; i < 76; i++) {
            map.put(i, 0);
        }

        for (int i = 0; i < 1000000; i++) {
            res = RandomUtil.gaussianRandom(66, 50, 75, 5);

            map.put(res, map.get(res) + 1);

        }

        for (Entry<Integer, Integer> entry : map.entrySet()) {
            System.out.println(entry.getKey() + " "
                    + (entry.getValue() / 10000f) + "%");
        }
    }

}
