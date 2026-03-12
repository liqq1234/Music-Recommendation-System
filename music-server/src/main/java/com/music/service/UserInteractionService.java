package com.music.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.music.entity.UserInteraction;

public interface UserInteractionService extends IService<UserInteraction> {
    
    // 获取用户交互记录及音乐信息（分页）
    Page<UserInteraction> getUserInteractions(Integer pageNum, Integer pageSize, Long userId, String type);
    
    // 增加或更新播放记录
    void recordPlay(Long userId, Long musicId);
    
    // 收藏/取消收藏
    boolean toggleFavorite(Long userId, Long musicId);
    
    // 打分
    void rateMusic(Long userId, Long musicId, Integer rating);
    
    // 获取用户的某首音乐的交互详情
    UserInteraction getInteraction(Long userId, Long musicId);
}
