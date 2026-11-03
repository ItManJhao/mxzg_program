package com.ayjs.mxzg.gameserver.module.backpack.service;

import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.ToString;

import java.util.Collection;
import java.util.List;

/**
 * ThingSet
 */
@ToString
public class ThingSet {

    /**
     * 空集
     */
    private static final ThingSet EMPTY_SET = new ThingSet(ImmutableList.of());

    /**
     * 物品集
     */
    private final ImmutableList<ImmutableThing> collection;

    public ThingSet(ImmutableList<ImmutableThing> list) {
        this.collection = list;
    }

    public List<ImmutableThing> asList() {
        return collection;
    }

    public static ThingSet of(Collection<ImmutableThing> elements) {
        return new ThingSet(ImmutableList.copyOf(elements));
    }

    public static ThingSet of() {
        return EMPTY_SET;
    }

    public static ThingSet of(ImmutableThing values) {
        return new ThingSet(ImmutableList.of(values));
    }

    public static ThingSet of(ImmutableThing v1, ImmutableThing v2) {
        return new ThingSet(ImmutableList.of(v1, v2));
    }

    public static ThingSet of(ImmutableThing v1, ImmutableThing v2, ImmutableThing v3) {
        return new ThingSet(ImmutableList.of(v1, v2, v3));
    }

    public static Builder builder() {
        return new Builder();
    }

    @ToString
    public static class Builder {

        private final ImmutableList.Builder<ImmutableThing> builder = ImmutableList.builder();

        private Builder() {
        }

        public Builder add(ImmutableThing values) {
            builder.add(values);
            return this;
        }

        public Builder addAll(Iterable<? extends ImmutableThing> elements) {
            builder.addAll(elements);
            return this;
        }

        public Builder combine(Builder other) {
            builder.addAll(other.builder.build());
            return this;
        }

        public ThingSet build() {
            return new ThingSet(builder.build());
        }
    }
}
