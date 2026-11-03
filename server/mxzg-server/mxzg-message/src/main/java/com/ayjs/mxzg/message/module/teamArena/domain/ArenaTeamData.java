package com.ayjs.mxzg.message.module.teamArena.domain;

import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.Map;

/**
 * 组队竞技场队伍数据
 *
 * @Author: CWJ
 * @Date: 2020/4/14
 **/
@Setter
@Getter
public class ArenaTeamData {

    /***
     * 队伍名
     */
    private String teamName;

    /***
     * 队长id
     */
    private long captainId;

    /***
     * 队伍id
     *
     */
    private long teamId;

    /***
     * 服务器
     */
    private int serverId;

    /***
     * 所以成员
     */
    private List<ArenaTeamMember> members;

    /***
     * 成员形象信息
     */
    private Map<Long, RoleSimpleMessage> simpleMap;

    /***
     * 创建时间
     */
    private int createTime;


}
