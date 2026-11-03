package com.ayjs.mxzg.common.util.tuple;

import java.util.Objects;

/**
 * 两个参数
 */
public class Tuple2<T1, T2> {
    public final T1 _1;
    public final T2 _2;

    public Tuple2(T1 _1, T2 _2) {
        this._1 = _1;
        this._2 = _2;
    }

    public Object[] toArray() {
        return new Object[]{_1, _2};
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Tuple2<?, ?> tuple2 = (Tuple2<?, ?>) o;
        return Objects.equals(_1, tuple2._1) &&
                Objects.equals(_2, tuple2._2);
    }

    @Override
    public int hashCode() {
        return Objects.hash(_1, _2);
    }

    @Override
    public String toString() {
        return Tuples.tupleStringRepresentation(toArray()).insert(0, '[').append(']').toString();
    }

	public T1 get_1() {
		return _1;
	}

	public T2 get_2() {
		return _2;
	}
}
