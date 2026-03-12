package com.music.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.music.entity.Playlist;

public interface PlaylistService extends IService<Playlist> {

    void createPlaylist(Playlist playlist);

    void updatePlaylist(Playlist playlist);

    void deletePlaylist(Long id, Long userId);

    Playlist getDetail(Long id);

    IPage<Playlist> getPublicList(int pageNum, int pageSize);

    IPage<Playlist> getUserPlaylists(Long userId, int pageNum, int pageSize);

    void addMusic(Long playlistId, Long musicId, Long userId);

    void removeMusic(Long playlistId, Long musicId, Long userId);
}
