package com.music.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.music.entity.Music;
import com.music.entity.Playlist;
import com.music.entity.PlaylistMusic;
import com.music.entity.User;
import com.music.mapper.MusicMapper;
import com.music.mapper.PlaylistMapper;
import com.music.mapper.PlaylistMusicMapper;
import com.music.mapper.UserMapper;
import com.music.service.PlaylistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class PlaylistServiceImpl extends ServiceImpl<PlaylistMapper, Playlist> implements PlaylistService {

    @Autowired
    private PlaylistMusicMapper playlistMusicMapper;

    @Autowired
    private MusicMapper musicMapper;

    @Autowired
    private UserMapper userMapper;

    @Override
    public void createPlaylist(Playlist playlist) {
        playlist.setPlayCount(0L);
        this.save(playlist);
    }

    @Override
    public void updatePlaylist(Playlist playlist) {
        this.updateById(playlist);
    }

    @Override
    public void deletePlaylist(Long id, Long userId) {
        Playlist playlist = this.getById(id);
        if (playlist == null) {
            throw new RuntimeException("歌单不存在");
        }
        if (!playlist.getUserId().equals(userId)) {
            throw new RuntimeException("无权删除该歌单");
        }
        // 删除歌单和关联数据
        this.removeById(id);
        playlistMusicMapper.delete(new LambdaQueryWrapper<PlaylistMusic>()
                .eq(PlaylistMusic::getPlaylistId, id));
    }

    @Override
    public Playlist getDetail(Long id) {
        Playlist playlist = this.getById(id);
        if (playlist == null) {
            return null;
        }
        // 获取创建者信息
        User creator = userMapper.selectById(playlist.getUserId());
        if (creator != null) {
            playlist.setCreatorName(creator.getNickname());
        }
        // 获取歌单内的音乐
        List<PlaylistMusic> pmList = playlistMusicMapper.selectList(
                new LambdaQueryWrapper<PlaylistMusic>()
                        .eq(PlaylistMusic::getPlaylistId, id)
                        .orderByAsc(PlaylistMusic::getSort));
        List<Long> musicIds = pmList.stream().map(PlaylistMusic::getMusicId).collect(Collectors.toList());
        if (!musicIds.isEmpty()) {
            List<Music> musicList = musicMapper.selectBatchIds(musicIds);
            playlist.setMusicList(musicList);
            playlist.setMusicCount(musicList.size());
        } else {
            playlist.setMusicCount(0);
        }
        return playlist;
    }

    @Override
    public IPage<Playlist> getPublicList(int pageNum, int pageSize) {
        LambdaQueryWrapper<Playlist> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Playlist::getIsPublic, 1);
        wrapper.orderByDesc(Playlist::getCreateTime);
        IPage<Playlist> page = this.page(new Page<>(pageNum, pageSize), wrapper);
        // 补充音乐数量
        page.getRecords().forEach(p -> {
            long count = playlistMusicMapper.selectCount(
                    new LambdaQueryWrapper<PlaylistMusic>().eq(PlaylistMusic::getPlaylistId, p.getId()));
            p.setMusicCount((int) count);
        });
        return page;
    }

    @Override
    public IPage<Playlist> getUserPlaylists(Long userId, int pageNum, int pageSize) {
        LambdaQueryWrapper<Playlist> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Playlist::getUserId, userId);
        wrapper.orderByDesc(Playlist::getCreateTime);
        IPage<Playlist> page = this.page(new Page<>(pageNum, pageSize), wrapper);
        page.getRecords().forEach(p -> {
            long count = playlistMusicMapper.selectCount(
                    new LambdaQueryWrapper<PlaylistMusic>().eq(PlaylistMusic::getPlaylistId, p.getId()));
            p.setMusicCount((int) count);
        });
        return page;
    }

    @Override
    public void addMusic(Long playlistId, Long musicId, Long userId) {
        Playlist playlist = this.getById(playlistId);
        if (playlist == null) {
            throw new RuntimeException("歌单不存在");
        }
        if (!playlist.getUserId().equals(userId)) {
            throw new RuntimeException("无权操作该歌单");
        }
        // 检查是否已添加
        long count = playlistMusicMapper.selectCount(new LambdaQueryWrapper<PlaylistMusic>()
                .eq(PlaylistMusic::getPlaylistId, playlistId)
                .eq(PlaylistMusic::getMusicId, musicId));
        if (count > 0) {
            throw new RuntimeException("该音乐已在歌单中");
        }
        PlaylistMusic pm = new PlaylistMusic();
        pm.setPlaylistId(playlistId);
        pm.setMusicId(musicId);
        pm.setSort(0);
        playlistMusicMapper.insert(pm);
    }

    @Override
    public void removeMusic(Long playlistId, Long musicId, Long userId) {
        Playlist playlist = this.getById(playlistId);
        if (playlist == null) {
            throw new RuntimeException("歌单不存在");
        }
        if (!playlist.getUserId().equals(userId)) {
            throw new RuntimeException("无权操作该歌单");
        }
        playlistMusicMapper.delete(new LambdaQueryWrapper<PlaylistMusic>()
                .eq(PlaylistMusic::getPlaylistId, playlistId)
                .eq(PlaylistMusic::getMusicId, musicId));
    }
}
