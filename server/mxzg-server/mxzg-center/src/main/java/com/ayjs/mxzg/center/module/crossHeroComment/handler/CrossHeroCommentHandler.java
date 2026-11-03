package com.ayjs.mxzg.center.module.crossHeroComment.handler;

import com.ayjs.mxzg.center.module.crossHeroComment.domain.CrossHeroTypeComment;
import com.ayjs.mxzg.center.module.crossHeroComment.service.CrossHeroCommentService;
import com.ayjs.mxzg.common.util.InternerPool;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.heroComment.HeroCommentConst;
import com.ayjs.mxzg.message.module.heroComment.message.HeroCommentCommentReqMessage;
import com.ayjs.mxzg.message.module.heroComment.message.HeroCommentCommentResMessage;
import com.ayjs.mxzg.message.module.heroComment.message.HeroCommentLikeCommentReqMessage;
import com.ayjs.mxzg.message.module.heroComment.message.HeroCommentLikeCommentResMessage;
import com.ayjs.mxzg.message.module.heroComment.message.HeroCommentLikeHeroReqMessage;
import com.ayjs.mxzg.message.module.heroComment.message.HeroCommentLikeHeroResMessage;
import com.ayjs.mxzg.message.module.heroComment.message.HeroCommentOperatorCode;
import com.ayjs.mxzg.message.module.heroComment.struct.HeroCommentDetailData;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/6/11
 **/
@Component
public class CrossHeroCommentHandler implements MessageHandler {

    @Autowired
    private CrossHeroCommentService crossHeroCommentService;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private HeroCommentConst heroCommentConst;

    private Comparator<HeroCommentDetailData> comparator = new Comparator<HeroCommentDetailData>() {
        @Override
        public int compare(HeroCommentDetailData o1, HeroCommentDetailData o2) {
            //点赞数倒序，时间顺序
            int res = Long.compare(o1.getLikeCount() + o1.getHateCount(), o2.getLikeCount() + o2.getHateCount());
            if (res != 0) {
                return res;
            }
            return Integer.compare(LocalDateTimeUtil.toEpochSecond(o1.getLocalDateTime()),
                    LocalDateTimeUtil.toEpochSecond(o2.getLocalDateTime()));
        }
    };

    @RemoteMethod
    public HeroCommentLikeHeroResMessage like(HeroCommentLikeHeroReqMessage message) {
        try {
            heroTypeSysCache.getOrThrow(message.getHeroType());
            synchronized (InternerPool.intern(CrossHeroCommentService.HERO_LIKE_LOCK, message.getHeroType())) {
                CrossHeroTypeComment entity = crossHeroCommentService.load(message.getHeroType());
                entity.setLikeCount(entity.getLikeCount() + 1);
                crossHeroCommentService.update(entity);
                return HeroCommentLikeHeroResMessage.of(message.getHeroType(), HeroCommentOperatorCode.SUCCESS);
            }

        } catch (Exception e) {
            return HeroCommentLikeHeroResMessage.of(message.getHeroType(), HeroCommentOperatorCode.FAIL);
        }
    }

    @RemoteMethod
    public HeroCommentCommentResMessage comment(HeroCommentCommentReqMessage message) {
        try {
            heroTypeSysCache.getOrThrow(message.getHeroType());

            HeroCommentDetailData data = new HeroCommentDetailData();
            data.setRid(message.getRid());
            data.setContext(message.getComment());

            synchronized (InternerPool.intern(CrossHeroCommentService.HERO_LIKE_LOCK, message.getHeroType())) {
                CrossHeroTypeComment entity = crossHeroCommentService.load(message.getHeroType());
                long newId = entity.getIdCount() + 1;
                if (entity.getIdCount() >= Long.MAX_VALUE) {
                    newId = 1;
                }
                entity.setIdCount(newId);

                data.setId(message.getHeroType() + "_" + newId);
                data.setLocalDateTime(LocalDateTime.now());
                entity.getCommentDetailMap().put(data.getId(), data);

                if (entity.getCommentDetailMap().size() > heroCommentConst.getHeroCommentMaxCount()) {
                    Collection<HeroCommentDetailData> allComments = new ArrayList<>(entity.getCommentDetailMap().values());
                    List<HeroCommentDetailData> expire = allComments.stream().sorted(comparator).collect(Collectors.toList());
                    if (expire.size() > heroCommentConst.getHeroCommentMaxCount()) {
                        entity.getCommentDetailMap().remove(expire.get(0).getId());
                    }
                }

                crossHeroCommentService.update(entity);
                return HeroCommentCommentResMessage.of(message.getHeroType(), HeroCommentOperatorCode.SUCCESS);
            }

        } catch (Exception e) {
            return HeroCommentCommentResMessage.of(message.getHeroType(), HeroCommentOperatorCode.FAIL);
        }
    }

    @RemoteMethod
    public HeroCommentLikeCommentResMessage likeComment(HeroCommentLikeCommentReqMessage message) {
        try {
            heroTypeSysCache.getOrThrow(message.getHeroType());
            synchronized (InternerPool.intern(CrossHeroCommentService.HERO_LIKE_LOCK, message.getHeroType())) {
                CrossHeroTypeComment entity = crossHeroCommentService.load(message.getHeroType());

                HeroCommentDetailData data = entity.getCommentDetailMap().get(message.getCommentId());
                if (message.getLikeState() == 2) {
                    data.setHateCount(data.getHateCount() + 1);
                } else {
                    data.setLikeCount(data.getLikeCount() + 1);
                }

                crossHeroCommentService.update(entity);
                return HeroCommentLikeCommentResMessage.of(message.getHeroType(), HeroCommentOperatorCode.SUCCESS);
            }

        } catch (Exception e) {
            return HeroCommentLikeCommentResMessage.of(message.getHeroType(), HeroCommentOperatorCode.FAIL);
        }
    }
}
