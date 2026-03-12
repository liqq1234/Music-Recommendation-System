package com.music.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.music.common.Constants;
import com.music.entity.Music;
import com.music.mapper.MusicMapper;
import com.music.service.MusicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Service
public class MusicServiceImpl extends ServiceImpl<MusicMapper, Music> implements MusicService {

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    @Override
    public IPage<Music> pageList(int pageNum, int pageSize, String keyword, String category, Long singerId) {
        LambdaQueryWrapper<Music> wrapper = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.and(w -> w.like(Music::getTitle, keyword).or().like(Music::getSingerName, keyword));
        }
        if (category != null && !category.isEmpty()) {
            wrapper.eq(Music::getCategory, category);
        }
        if (singerId != null) {
            wrapper.eq(Music::getSingerId, singerId);
        }
        wrapper.eq(Music::getStatus, Constants.MUSIC_STATUS_NORMAL);
        wrapper.orderByDesc(Music::getCreateTime);
        return this.page(new Page<>(pageNum, pageSize), wrapper);
    }

    @Override
    public Music getDetail(Long id) {
        return baseMapper.selectDetailById(id);
    }

    @Override
    public void uploadMusic(Music music) {
        // 音频指纹去重
        if (music.getAudioFingerprint() != null && !music.getAudioFingerprint().isEmpty()) {
            long count = this.count(new LambdaQueryWrapper<Music>()
                    .eq(Music::getAudioFingerprint, music.getAudioFingerprint()));
            if (count > 0) {
                throw new RuntimeException("该音乐已存在（音频指纹重复）");
            }
        }
        music.setStatus(Constants.MUSIC_STATUS_NORMAL);
        music.setPlayCount(0L);
        this.save(music);
        // 清除TOP100缓存
        redisTemplate.delete(Constants.REDIS_TOP100);
    }

    @Override
    public void updateMusic(Music music) {
        this.updateById(music);
        redisTemplate.delete(Constants.REDIS_TOP100);
    }

    @Override
    public void deleteMusic(Long id) {
        this.removeById(id);
        redisTemplate.delete(Constants.REDIS_TOP100);
    }

    @Override
    public void updateStatus(Long id, Integer status) {
        Music music = new Music();
        music.setId(id);
        music.setStatus(status);
        this.updateById(music);
        redisTemplate.delete(Constants.REDIS_TOP100);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Music> getTop100() {
        // 先查Redis缓存
        List<Music> list = (List<Music>) redisTemplate.opsForValue().get(Constants.REDIS_TOP100);
        if (list != null && !list.isEmpty()) {
            return list;
        }
        // 查数据库
        list = baseMapper.selectTop100();
        // 存入Redis
        if (list != null && !list.isEmpty()) {
            redisTemplate.opsForValue().set(Constants.REDIS_TOP100, list, Constants.REDIS_EXPIRE_SECONDS, TimeUnit.SECONDS);
        }
        return list;
    }

    @Override
    public void incrementPlayCount(Long id) {
        Music music = this.getById(id);
        if (music != null) {
            Music update = new Music();
            update.setId(id);
            update.setPlayCount(music.getPlayCount() + 1);
            this.updateById(update);
        }
    }

    @Override
    public Map<String, Object> getStatistics() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("total", this.count());
        stats.put("normal", this.count(new LambdaQueryWrapper<Music>().eq(Music::getStatus, Constants.MUSIC_STATUS_NORMAL)));
        stats.put("offline", this.count(new LambdaQueryWrapper<Music>().eq(Music::getStatus, Constants.MUSIC_STATUS_OFF)));
        stats.put("review", this.count(new LambdaQueryWrapper<Music>().eq(Music::getStatus, Constants.MUSIC_STATUS_REVIEW)));
        return stats;
    }
}
