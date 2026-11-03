package com.ayjs.mxzg.common.collect;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collector;
import java.util.stream.Collectors;

/**
 * 集合操作
 */
public final class MoreCollectors {

    public static <T, E> Collector<T, ?, List<E>> toImmutableListAndThen(Collector<T, ?, List<E>> collector) {
        return Collectors.collectingAndThen(collector, ImmutableList::copyOf);
    }

    public static <T, E> Collector<T, ?, Set<E>> toImmutableSetAndThen(Collector<T, ?, Set<E>> collector) {
        return Collectors.collectingAndThen(collector, ImmutableSet::copyOf);
    }

    public static <T, K, V> Collector<T, ?, Map<K, V>> toImmutableMapAndThen(Collector<T, ?, Map<K, V>> collector) {
        return Collectors.collectingAndThen(collector, ImmutableMap::copyOf);
    }

    public static <T, K, V> Collector<T, ?, ImmutableMap<K, V>> toImmutableMap(Collector<T, ?, Map<K, V>> collector) {
        return Collectors.collectingAndThen(collector, ImmutableMap::copyOf);
    }
}
