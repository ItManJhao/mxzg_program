package com.ayjs.mxzg.gameserver;

import java.util.function.Function;

public class TestRandom {

    public static void main(String[] args) {
        Function<Integer, String> u1 = (i) -> i + 2 + "";
        System.out.println(u1.apply(1));
    }
}
