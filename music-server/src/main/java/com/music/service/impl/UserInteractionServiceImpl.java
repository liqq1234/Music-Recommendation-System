package com.music.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.music.entity.UserInteraction;
import com.music.mapper.UserInteractionMapper;
import com.music.service.UserInteractionService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class UserInteractionServiceImpl extends ServiceImpl<UserInteractionMapper, UserInteraction> implements UserInteractionService {

    @Override
    public Page<UserInteraction> getUserInteractions(Integer pageNum, Integer pageSize, Long userId, String type) {
        Page<UserInteraction> page = new Page<>(pageNum, pageSize);
        return (Page<UserInteraction>) baseMapper.selectInteractionWithMusic(page, userId, type);
    }
    
    private UserInteraction getOrCreate(Long userId, Long musicId) {
        QueryWrapper<UserInteraction> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("user_id", userId).eq("music_id", musicId);
        UserInteraction ui = getOne(queryWrapper);
        if (ui == null) {
            ui = new UserInteraction();
            ui.setUserId(userId);
            ui.setMusicId(musicId);
            ui.setPlayCount(0);
            ui.setIsFavorite(0);
        }
        return ui;
    }

    @Override
    @Transactional
    public void recordPlay(Long userId, Long musicId) {
        UserInteraction ui = getOrCreate(userId, musicId);
        ui.setPlayCount(ui.getPlayCount() + 1);
        ui.setLastPlayTime(LocalDateTime.now());
        saveOrUpdate(ui);
    }

    @Override
    @Transactional
    public boolean toggleFavorite(Long userId, Long musicId) {
        UserInteraction ui = getOrCreate(userId, musicId);
        int current = ui.getIsFavorite() != null ? ui.getIsFavorite() : 0;
        int next = current == 1 ? 0 : 1;
        ui.setIsFavorite(next);
        saveOrUpdate(ui);
        return next == 1;
    }

    @Override
    @Transactional
    public void rateMusic(Long userId, Long musicId, Integer rating) {
        UserInteraction ui = getOrCreate(userId, musicId);
        ui.setRating(rating);
        saveOrUpdate(ui);
    }

    @Override
    public UserInteraction getInteraction(Long userId, Long musicId) {
        return getOrCreate(userId, musicId);
    }
}
