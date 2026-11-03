package com.ayjs.mxzg.gameserver.module.backpack.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.godequip.domain.GodEquip;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroMagicWand;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import lombok.ToString;

import java.util.Collection;
import java.util.Collections;
import java.util.Objects;

/**
 *
 */
@Getter
public class Rewards {

    private static final Rewards EMPTY = new Rewards(ThingSet.of());
    /**
     * 英雄
     */
    private final Collection<Hero> heroes;
    /**
     * 神装
     */
    private final Collection<GodEquip> godEquips;
    /**
     * 魔杖
     */
    private final Collection<HeroMagicWand> heroMagicWands;

    /**
     * 物品
     */
    private final ThingSet thingSet;

    private Rewards(ThingSet thingSet) {
        this(thingSet, Collections.emptyList(), Collections.emptyList(), Collections.emptyList());
    }

    private Rewards(ThingSet thingSet, Collection<Hero> heroes, Collection<GodEquip> godEquips, Collection<HeroMagicWand> heroMagicWands) {
        this.thingSet = thingSet;
        this.heroes = heroes;
        this.godEquips = godEquips;
        this.heroMagicWands = heroMagicWands;
    }

    public static Rewards of() {
        return EMPTY;
    }

    public static Rewards of(ThingSet thingSet) {
        return new Rewards(thingSet);
    }

    public static Rewards ofHeros(ThingSet thingSet, Collection<Hero> heroes) {
        return new Rewards(thingSet, heroes, Collections.emptyList(), Collections.emptyList());
    }
    
    public static Rewards ofGodEquips(ThingSet thingSet, Collection<GodEquip> godEquips) {
        return new Rewards(thingSet, Collections.emptyList(), godEquips, Collections.emptyList());
    }

    public static Rewards ofHeroMagicWands(ThingSet thingSet, Collection<HeroMagicWand> heroMagicWands) {
        return new Rewards(thingSet, Collections.emptyList(), Collections.emptyList(), heroMagicWands);
    }

    public boolean isEmpty() {
        return CollectionUtil.isEmpty(heroes) && CollectionUtil.isEmpty(godEquips)
                && CollectionUtil.isEmpty(getThingSet().asList()) && CollectionUtil.isEmpty(heroMagicWands);
    }

    public static Builder builder() {
        return new Builder();
    }

    @ToString
    public static class Builder {
        private final ImmutableList.Builder<ImmutableThing> thingList = ImmutableList.builder();
        private final ImmutableList.Builder<Hero> heroList = ImmutableList.builder();
        private final ImmutableList.Builder<GodEquip> godEquipList = ImmutableList.builder();
        private final ImmutableList.Builder<HeroMagicWand> heroMagicWandList = ImmutableList.builder();

        private Builder() {
        }

        public Builder addValues(ImmutableThing thing) {
            thingList.add(thing);
            return this;
        }

        public Builder addAllValues(Iterable<? extends ImmutableThing> things) {
            thingList.addAll(things);
            return this;
        }


        public Builder addRewards(Rewards rewards) {
            if (Objects.nonNull(rewards)) {
                thingList.addAll(rewards.getThingSet().asList());
                heroList.addAll(rewards.getHeroes());
                godEquipList.addAll(rewards.getGodEquips());
                heroMagicWandList.addAll(rewards.getHeroMagicWands());
            }
            return this;
        }

        public Rewards build() {
            return new Rewards(ThingSet.of(thingList.build()), heroList.build(), godEquipList.build(), heroMagicWandList.build());
        }
    }
}