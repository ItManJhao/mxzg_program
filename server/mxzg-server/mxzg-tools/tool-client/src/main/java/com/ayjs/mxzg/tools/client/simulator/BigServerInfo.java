package com.ayjs.mxzg.tools.client.simulator;

import lombok.Data;

/**
 * 大区信息
 *
 * @Author: CWJ
 * @Date: 2019/12/14
 **/
@Data
public class BigServerInfo {

    private int id;
    private String name;
    private int sort;
    private int c_id;
    private int c_son_id;
    private int created_at;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getSort() {
        return sort;
    }

    public void setSort(int sort) {
        this.sort = sort;
    }

    public int getC_id() {
        return c_id;
    }

    public void setC_id(int c_id) {
        this.c_id = c_id;
    }

    public int getC_son_id() {
        return c_son_id;
    }

    public void setC_son_id(int c_son_id) {
        this.c_son_id = c_son_id;
    }

    public int getCreated_at() {
        return created_at;
    }

    public void setCreated_at(int created_at) {
        this.created_at = created_at;
    }

    @Override
    public String toString() {
        return id + "-" + name + "-" + c_id;
    }
}
