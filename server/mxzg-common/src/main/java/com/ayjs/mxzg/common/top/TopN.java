package com.ayjs.mxzg.common.top;

import com.google.common.collect.ImmutableList;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

/**
 * 排行榜
 */
public class TopN<K, E extends ITop<K>> {

    /**
     * 读写锁
     */
    private final ReadWriteLock lock = new ReentrantReadWriteLock();
    /**
     * 比较器
     */
    private final Comparator<? super E> comparator;
    /**
     * 排行榜最大数量
     */
    private final int maximumSize;
    /**
     * 排行榜元素
     */
    private final List<E> elements = new ArrayList<>();
    /**
     * 排行榜元素id索引map
     */
    private final Map<K, Integer> id_index = new HashMap<>();
    /**
     * 入榜门槛
     */
    private final E threshold;

    private TopN(Comparator<? super E> comparator, int maximumSize, E threshold) {
        this.comparator = comparator;
        this.maximumSize = maximumSize;
        this.threshold = threshold;
    }

    public static <K, E extends ITop<K>> Builder<K, E> orderedBy(Comparator<? super E> comparator) {
        return new Builder<>(comparator);
    }

    @Override
    public int hashCode() {
        return super.hashCode();
    }

    public static class Builder<K, E extends ITop<K>> {
        private final Comparator<? super E> comparator;
        private int maximumSize = Integer.MAX_VALUE;
        private E threshold;

        private Builder(Comparator<? super E> comparator) {
            this.comparator = comparator;
        }

        public Builder<K, E> maximumSize(int maximumSize) {
            this.maximumSize = maximumSize;
            return this;
        }

        public Builder<K, E> threshold(E threshold) {
            this.threshold = threshold;
            return this;
        }

        public TopN<K, E> build() {
            if (comparator == null) {
                throw new IllegalArgumentException("comparator cannot be null");
            }
            if (maximumSize < 0) {
                throw new IllegalArgumentException("maximumSize cannot be negative");
            }
            return new TopN<>(comparator, maximumSize, threshold);
        }
    }

    private boolean rankCheck(int rank) {
        return rank >= 1 && rank <= elements.size();
    }

    private E elementData(int rank) {
        return rankCheck(rank) ? elements.get(rank - 1) : null;
    }

    /**
     * 根据排名获得元素
     *
     * @param rank
     * @return
     */
    public E get(int rank) {
        final ReadWriteLock lock = this.lock;
        lock.readLock().lock();
        try {
            return elementData(rank);
        } finally {
            lock.readLock().unlock();
        }
    }

    /**
     * 根据id获得元素
     *
     * @param id
     * @return
     */
    public E get(K id) {
        final ReadWriteLock lock = this.lock;
        lock.readLock().lock();
        try {
            Integer index = id_index.get(id);
            int rank = asRank(index);
            return elementData(rank);
        } finally {
            lock.readLock().unlock();
        }
    }

    /**
     * 根据id获取排名
     *
     * @param id
     * @return 如果没有排名则返回 0
     */
    public int getRank(K id) {
        final ReadWriteLock lock = this.lock;
        lock.readLock().lock();
        try {
            Integer index = id_index.get(id);
            return asRank(index);
        } finally {
            lock.readLock().unlock();
        }
    }

    /**
     * 索引转换排名
     *
     * @param index
     * @return 如果index为null, 则排名为 0
     */
    private int asRank(Integer index) {
        return index == null || index < 0 ? 0 : index + 1;
    }

    /**
     * 添加
     *
     * @param e
     */
    public TopResult add(E e) {
        final ReadWriteLock lock = this.lock;
        lock.writeLock().lock();
        try {
            Integer index = id_index.get(e.getRankId());
            if (index == null) {
                if (lowerThreshold(e)) {
                    return TopResult.CANNOT_IN_TOP_N_RESULT;
                }

                int position = SortedLists.binarySearch(
                        elements,
                        e,
                        comparator,
                        SortedLists.KeyPresentBehavior.FIRST_AFTER,
                        SortedLists.KeyAbsentBehavior.NEXT_HIGHER);
                elements.add(position, e);

                updateIndexRangeClosed(position, size() - 1);
            } else {
                E old = elements.get(index);

                if (lowerThreshold(e)) {
                    remove(old);
                } else {
                    int res = comparator.compare(e, old);
                    if (res < 0) {
                        rise(e, index);
                    } else if (res > 0) {
                        fall(e, index);
                    } else {
                        silent(e, index);
                    }
                }
            }

            removeLastIfOverMaximumSize();

            Integer newIndex = id_index.get(e.getRankId());
            return TopResult.builder()
                    .status(makeTopNStatus(index, newIndex))
                    .oldRank(asRank(index))
                    .newRank(asRank(newIndex))
                    .build();
        } finally {
            lock.writeLock().unlock();
        }
    }

    private void removeLastIfOverMaximumSize() {
        int size = size();
        if (size > maximumSize) {
            remove(elements.get(size - 1));
        }
    }

    /**
     * 低于门槛
     *
     * @param e
     * @return
     */
    private boolean lowerThreshold(E e) {
        return threshold != null && comparator.compare(e, threshold) > 0;
    }

    private TopResult.TopNStatus makeTopNStatus(Integer oldIndex, Integer newIndex) {
        if (oldIndex == null && newIndex == null) {
            return TopResult.TopNStatus.CANNOT_IN_TOP_N;
        } else if (oldIndex == null) {
            return TopResult.TopNStatus.IN_TOP_N;
        } else if (newIndex == null) {
            return TopResult.TopNStatus.OUT_TOP_N;
        } else {
            return TopResult.TopNStatus.CHANGE_IN_TOP_N;
        }
    }

    /**
     * 上升
     *
     * @param e     元素
     * @param index 元素所在位置
     */
    private void rise(E e, int index) {
        // 如果已经在首位
        if (index == 0) {
            silent(e, index);
        } else {
            int foundIndex = forwardSearch(elements, e, comparator, index - 1);
            int position = foundIndex < 0 ? 0 : foundIndex + 1;

            // 上升 先删后插
            elements.remove(index);
            elements.add(position, e);

            updateIndexRangeClosed(position, index);
        }
    }

    /**
     * 下降
     *
     * @param e     元素
     * @param index 元素所在位置
     */
    private void fall(E e, int index) {
        // 如果已经在末尾
        if (index == size() - 1) {
            silent(e, index);
        } else {
            int foundIndex = backwardSearch(elements, e, comparator, index + 1);
            int position = foundIndex < 0 ? size() : foundIndex;

            // 下降 先插后删
            elements.add(position, e);
            elements.remove(index);

            updateIndexRangeClosed(index, foundIndex < 0 ? size() - 1 : position);
        }
    }

    /**
     * 不动, {@code e}替换原来位置的元素
     *
     * @param e     元素
     * @param index 元素所在位置
     */
    private void silent(E e, int index) {
        elements.set(index, e);
    }

    /**
     * 更新闭区间{@code from}到{@code to}位置的索引
     *
     * @param from
     * @param to
     */
    private void updateIndexRangeClosed(int from, int to) {
        for (int i = from; i <= to; ++i) {
            id_index.put(elements.get(i).getRankId(), i);
        }
    }

    /**
     * 从{@code start}位置向前查找{@code list}中元素直到{@code comparator}比较{@code e}与{@code list}中元素 >= 0
     * <p>
     * 向前 <-
     *
     * @param list       列表
     * @param e          被比较的元素
     * @param comparator 比较器
     * @param start      开始查找位置
     * @param <E>
     * @return 返回被找到元素位置, 如果未找到返回 -1
     */
    private static <E> int forwardSearch(List<? extends E> list, E e, Comparator<? super E> comparator, int start) {
        int end = 0;
        for (int i = start; i >= end; --i) {
            if (comparator.compare(e, list.get(i)) >= 0) {
                return i;
            }
        }
        return -1;
    }

    /**
     * 从{@code start}位置向后查找{@code list}中元素直到{@code comparator}比较{@code e}与{@code list}中元素 < 0
     * <p>
     * 向后 ->
     *
     * @param list
     * @param e
     * @param comparator
     * @param start
     * @param <E>
     * @return 返回被找到元素位置, 如果未找到返回 -1
     */
    private static <E> int backwardSearch(List<? extends E> list, E e, Comparator<? super E> comparator, int start) {
        int end = list.size() - 1;
        for (int i = start; i <= end; ++i) {
            if (comparator.compare(e, list.get(i)) < 0) {
                return i;
            }
        }
        return -1;
    }

    /**
     * 移除
     *
     * @param e
     */
    public void remove(E e) {
        remove(e.getRankId());
    }

    /**
     * 移除
     *
     * @param id
     */
    public E remove(K id) {
        final ReadWriteLock lock = this.lock;
        lock.writeLock().lock();
        try {
            E old = null;
            Integer index = id_index.remove(id);
            if (index != null) {
                old = elements.remove(index.intValue());
                updateIndexRangeClosed(index, size() - 1);
            }
            return old;
        } finally {
            lock.writeLock().unlock();
        }
    }

    /**
     * 前{@code n}名
     *
     * @param n
     * @return
     */
    public List<E> top(int n) {
        final ReadWriteLock lock = this.lock;
        lock.readLock().lock();
        try {
            return ImmutableList.copyOf(sublist(0, rangeCheck(n)));
        } finally {
            lock.readLock().unlock();
        }
    }

    /**
     * 第{@code from}到{@code to}名
     *
     * @param from
     * @param to
     * @return
     */
    public List<E> rangeClosed(int from, int to) {
        final ReadWriteLock lock = this.lock;
        lock.readLock().lock();
        try {
            return ImmutableList.copyOf(sublist(rangeCheck(from - 1), rangeCheck(to)));
        } finally {
            lock.readLock().unlock();
        }
    }

    private List<E> sublist(int fromIndex, int toIndex) {
        return elements.subList(fromIndex, toIndex);
    }

    private int rangeCheck(int index) {
        int size = size();
        return Math.min(index, size);
    }

    public int size() {
        lock.readLock().lock();
        try {
            return elements.size();
        } finally {
            lock.readLock().unlock();
        }
    }

    public void clear(){
        final ReadWriteLock lock = this.lock;
        lock.readLock().lock();
        try {
            elements.clear();
            id_index.clear();
        } finally {
            lock.readLock().unlock();
        }

    }
}
