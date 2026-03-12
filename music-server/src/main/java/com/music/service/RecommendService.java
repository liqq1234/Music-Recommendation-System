package com.music.service;

import com.music.entity.Music;

import java.util.List;

/**
 * 推荐服务接口
 */
public interface RecommendService {

    /**
     * 基于协同过滤的个性化推荐
     */
    List<Music> recommendForUser(Long userId, int limit);

    /**
     * 获取热门推荐 TOP-100
     */
    List<Music> getTop100();
}
