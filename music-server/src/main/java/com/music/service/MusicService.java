package com.music.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.music.entity.Music;

import java.util.List;
import java.util.Map;

public interface MusicService extends IService<Music> {

    IPage<Music> pageList(int pageNum, int pageSize, String keyword, String category, Long singerId);

    Music getDetail(Long id);

    void uploadMusic(Music music);

    void updateMusic(Music music);

    void deleteMusic(Long id);

    void updateStatus(Long id, Integer status);

    List<Music> getTop100();

    void incrementPlayCount(Long id);

    Map<String, Object> getStatistics();
}
