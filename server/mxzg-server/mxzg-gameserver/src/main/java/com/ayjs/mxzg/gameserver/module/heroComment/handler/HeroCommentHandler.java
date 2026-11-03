package com.ayjs.mxzg.gameserver.module.heroComment.handler;

import com.ayjs.mxzg.common.exception.ErrorCodeException;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.OpenConditionSysCache;
import com.ayjs.mxzg.config.excel.cache.heroComment.HeroCommentConst;
import com.ayjs.mxzg.config.excel.entity.COpenCondition;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.heroComment.domain.HeroComment;
import com.ayjs.mxzg.gameserver.module.heroComment.service.HeroCommentService;
import com.ayjs.mxzg.gameserver.module.role.constant.EntryType;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.sensitive.service.SensitiveWordService;
import com.ayjs.mxzg.message.module.heroComment.domain.CrossHeroComment;
import com.ayjs.mxzg.message.module.heroComment.message.HeroCommentCommentReqMessage;
import com.ayjs.mxzg.message.module.heroComment.message.HeroCommentCommentResMessage;
import com.ayjs.mxzg.message.module.heroComment.message.HeroCommentLikeCommentReqMessage;
import com.ayjs.mxzg.message.module.heroComment.message.HeroCommentLikeCommentResMessage;
import com.ayjs.mxzg.message.module.heroComment.message.HeroCommentLikeHeroReqMessage;
import com.ayjs.mxzg.message.module.heroComment.message.HeroCommentLikeHeroResMessage;
import com.ayjs.mxzg.message.module.heroComment.message.HeroCommentOperatorCode;
import com.ayjs.mxzg.message.module.role.dao.CrossRoleRedisDao;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.protocol.HeroCommentGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Iterator;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/6/11
 **/
@Component
public class HeroCommentHandler extends ProtocolHandler {

    @Autowired
    private HeroCommentService heroCommentService;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private CrossRoleRedisDao crossRoleRedisDao;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private HeroCommentConst heroCommentConst;
    @Autowired
    private SensitiveWordService sensitiveWordService;
    @Autowired
    private OpenConditionSysCache openConditionSysCache;
    @Autowired
    private RoleService roleService;


    @CMD(id = CmdCode._71101)
    public void getHeroCommentData(PlayerContext playerContext, HeroCommentGMsg.GReqGetData req) {
        heroTypeSysCache.getOrThrow(req.getHeroType());
        HeroCommentGMsg.GResGetData.Builder builder = HeroCommentGMsg.GResGetData.newBuilder();
        builder.setHeroCommentData(getBuilder(playerContext.getId(), req.getHeroType()));
        playerContext.write(CmdCode._71101, builder.build());
    }

    @NotNull
    private HeroCommentGMsg.PBHeroCommentData.Builder getBuilder(long rid, int heroType) {
        HeroComment myHeroComment = heroCommentService.load(rid);
        CrossHeroComment crossHeroComment = heroCommentService.getCrossHeroComment(heroType);
        HeroCommentGMsg.PBHeroCommentData.Builder commentDataBuilder = HeroCommentGMsg.PBHeroCommentData.newBuilder();
        commentDataBuilder.setHeroType(heroType);
        commentDataBuilder.setCommentCount(myHeroComment.getCommentHeroCount().getOrDefault(heroType, 0));
        commentDataBuilder.setHadLike(myHeroComment.getLikeHero().contains(heroType));

        if (crossHeroComment != null) {
            commentDataBuilder.setLikeCount(crossHeroComment.getLikeCount());
            crossHeroComment.getCommentDetailMap().values().forEach(detail -> {
                CrossRole crossRole = crossRoleRedisDao.get(detail.getRid());
                HeroCommentGMsg.PBHeroDetailComment.Builder detailBuilder = HeroCommentGMsg.PBHeroDetailComment.newBuilder();
                detailBuilder.setCommentId(detail.getId());
                detailBuilder.setContext(detail.getContext());
                detailBuilder.setLikeCount(detail.getLikeCount());
                detailBuilder.setHateCount(detail.getHateCount());
                detailBuilder.setRid(detail.getRid());
                detailBuilder.setServerId(crossRole.getServerId());
                detailBuilder.setName(crossRole.getNick());
                detailBuilder.setLikeState(myHeroComment.getCommentsLike().getOrDefault(detail.getId(), 0));
                detailBuilder.setCommentTime(LocalDateTimeUtil.toEpochSecond(detail.getLocalDateTime()));

                commentDataBuilder.addComments(detailBuilder);
            });

            Iterator<Map.Entry<String, Integer>> iterator = myHeroComment.getCommentsLike().entrySet().iterator();
            while (iterator.hasNext()) {
                Map.Entry<String, Integer> entry = iterator.next();
                if (!crossHeroComment.getCommentDetailMap().containsKey(entry.getKey())
                        && entry.getKey().startsWith(String.valueOf(heroType))) {
                    iterator.remove();
                    heroCommentService.update(myHeroComment);
                }
            }

        } else {
            commentDataBuilder.setCommentCount(0);
        }
        return commentDataBuilder;
    }

    @CMD(id = CmdCode._71102)
    public void likeHero(PlayerContext playerContext, HeroCommentGMsg.GReqLikeHero req) {

        COpenCondition condition = openConditionSysCache.getCondition(EntryType.MAIN_CHAT_CROSS_SHARE);
        Role role = roleService.getOrThrow(playerContext.getId());
        Asserts.isTrue(role.getLevel() >= condition.getCondition_value(),
                ErrorCode.ROLE_LEVEL_LACK.getValue(),
                () -> String.format("hero comment role level:%s need:%s", role.getLevel(), condition.getCondition_value()));

        heroTypeSysCache.getOrThrow(req.getHeroType());

        HeroComment myHeroComment = heroCommentService.load(playerContext.getId());

        Asserts.isTrue(!myHeroComment.getLikeHero().contains(req.getHeroType()),
                ErrorCode.HERO_COMMENT_HAD_LIKE_HERO.getValue(),
                String.format("已经点赞{%s}", myHeroComment.getLikeHero().contains(req.getHeroType())));

        messageDispatcher.dispatch(HeroCommentLikeHeroReqMessage.of(req.getHeroType()), response -> {
            HeroCommentLikeHeroResMessage res = (HeroCommentLikeHeroResMessage) response;
            if (res.getCode() == HeroCommentOperatorCode.SUCCESS) {

                myHeroComment.getLikeHero().add(req.getHeroType());
                heroCommentService.update(myHeroComment);

                HeroCommentGMsg.GResLikeHero.Builder builder = HeroCommentGMsg.GResLikeHero.newBuilder();
                builder.setComments(getBuilder(playerContext.getId(), req.getHeroType()));
                playerContext.write(CmdCode._71102, builder.build());
            } else {
                throw new ErrorCodeException(ErrorCode.HERO_COMMENT_HAD_LIKE_HERO.getValue(),
                        String.format("已经点赞{%s}", myHeroComment.getLikeHero().contains(req.getHeroType())));
            }
        });
    }

    @CMD(id = CmdCode._71103)
    public void comment(PlayerContext playerContext, HeroCommentGMsg.GReqComment req) {

        COpenCondition condition = openConditionSysCache.getCondition(EntryType.MAIN_CHAT_CROSS_SHARE);
        Role role = roleService.getOrThrow(playerContext.getId());
        Asserts.isTrue(role.getLevel() >= condition.getCondition_value(),
                ErrorCode.CHAT_LEVEL_NOT_ENOUGH.getValue(),
                () -> String.format("hero comment role level:%s need:%s", role.getLevel(), condition.getCondition_value()));

        heroTypeSysCache.getOrThrow(req.getHeroType());

        HeroComment myHeroComment = heroCommentService.load(playerContext.getId());

        String msg = req.getContext().trim();
        msg = msg.replaceAll("\r|\n", "");

        Asserts.isTrue(sensitiveWordService.wordCanUse(msg, role), ErrorCode.HERO_COMMENT_CONTEXT_NOT_ILLEGALITY.getValue(),
                String.format("包含敏感字{%s}", msg));

        int length = StringUtil.getShowLength(msg);
        Asserts.isTrue(length > 0 && length <= heroCommentConst.getHeroCommentContextLength(),
                ErrorCode.HERO_COMMENT_CONTEXT_LONG.getValue(), String.format("聊天内容{%s}长度过长：字符长度：{%s}，限制长度{%s}",
                        msg, length, heroCommentConst.getHeroCommentContextLength()));

        Asserts.isTrue(myHeroComment.getCommentHeroCount().getOrDefault(req.getHeroType(), 0) <
                        heroCommentConst.getHeroCommentCount(), ErrorCode.HERO_COMMENT_LIKE_HERO_COUNT_OVER.getValue(),
                String.format("当前点赞次数{%s}", myHeroComment.getCommentHeroCount().getOrDefault(req.getHeroType(), 0)));

        messageDispatcher.dispatch(HeroCommentCommentReqMessage.of(req.getHeroType(), msg, playerContext.getId()), response -> {
            HeroCommentCommentResMessage res = (HeroCommentCommentResMessage) response;
            if (res.getCode() == HeroCommentOperatorCode.SUCCESS) {

                myHeroComment.getCommentHeroCount().put(req.getHeroType(),
                        myHeroComment.getCommentHeroCount().getOrDefault(req.getHeroType(), 0) + 1);
                heroCommentService.update(myHeroComment);

                HeroCommentGMsg.GResComment.Builder builder = HeroCommentGMsg.GResComment.newBuilder();
                builder.setComments(getBuilder(playerContext.getId(), req.getHeroType()));
                playerContext.write(CmdCode._71103, builder.build());
            } else {
                throw new ErrorCodeException(ErrorCode.CONFIG_NOT_EXIST.getValue(),
                        String.format("英雄不存在{%s},{%s}", req.getHeroType(), req.getContext()));
            }
        });
    }

    @CMD(id = CmdCode._71104)
    public void likeComment(PlayerContext playerContext, HeroCommentGMsg.GReqLikeComment req) {

        COpenCondition condition = openConditionSysCache.getCondition(EntryType.MAIN_CHAT_CROSS_SHARE);
        Role role = roleService.getOrThrow(playerContext.getId());
        Asserts.isTrue(role.getLevel() >= condition.getCondition_value(),
                ErrorCode.CHAT_LEVEL_NOT_ENOUGH.getValue(),
                () -> String.format("hero comment role level:%s need:%s", role.getLevel(), condition.getCondition_value()));

        heroTypeSysCache.getOrThrow(req.getHeroType());

        CrossHeroComment crossHeroComment = heroCommentService.getCrossHeroComment(req.getHeroType());

        Asserts.isTrue(crossHeroComment != null && crossHeroComment.getCommentDetailMap().containsKey(req.getCommentId()),
                ErrorCode.HERO_COMMENT_COMMENT_NOT_EXIT.getValue(),
                String.format("评论不存在{%s},{%s}", req.getHeroType(), req.getCommentId()));

        HeroComment heroComment = heroCommentService.load(playerContext.getId());

        Asserts.isTrue(heroComment.getCommentsLike().getOrDefault(req.getCommentId(), 0) == 0,
                ErrorCode.HERO_COMMENT_COMMENT_HAD_LIKE.getValue(),
                String.format("已经评论过{%s},{%s}", req.getCommentId(), heroComment.getCommentsLike().containsKey(req.getCommentId())));

        messageDispatcher.dispatch(HeroCommentLikeCommentReqMessage.of(req.getHeroType(), req.getCommentId(), req.getLikeState()), response -> {
            HeroCommentLikeCommentResMessage res = (HeroCommentLikeCommentResMessage) response;
            if (res.getCode() == HeroCommentOperatorCode.SUCCESS) {

                heroComment.getCommentsLike().put(req.getCommentId(), req.getLikeState());
                heroCommentService.update(heroComment);

                HeroCommentGMsg.GResLikeComment.Builder builder = HeroCommentGMsg.GResLikeComment.newBuilder();
                builder.setComments(getBuilder(playerContext.getId(), req.getHeroType()));
                playerContext.write(CmdCode._71104, builder.build());
            } else {
                throw new ErrorCodeException(ErrorCode.HERO_COMMENT_COMMENT_NOT_EXIT.getValue(),
                        String.format("评论不存在{%s},{%s}", req.getHeroType(), req.getCommentId()));
            }
        });
    }
}
