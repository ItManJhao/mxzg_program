package com.ayjs.mxzg.common.util.tuple;

import java.util.Objects;

/**
 * 四个参数
 */
public class Tuple4<T1, T2, T3, T4> extends Tuple3<T1, T2, T3> {
    public final T4 _4;

    public Tuple4(T1 _1, T2 _2, T3 _3, T4 _4) {
        super(_1, _2, _3);
        this._4 = _4;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        if (!super.equals(o)) return false;
        Tuple4<?, ?, ?, ?> tuple4 = (Tuple4<?, ?, ?, ?>) o;
        return Objects.equals(_4, tuple4._4);
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), _4);
    }
}
