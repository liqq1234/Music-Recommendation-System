package com.music.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.music.common.Result;
import com.music.entity.Playlist;
import com.music.service.PlaylistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

@RestController
@RequestMapping("/api/playlist")
public class PlaylistController {

    @Autowired
    private PlaylistService playlistService;

    @PostMapping("/create")
    public Result<?> create(@RequestBody Playlist playlist, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        playlist.setUserId(userId);
        playlistService.createPlaylist(playlist);
        return Result.success("创建成功", null);
    }

    @PutMapping("/update")
    public Result<?> update(@RequestBody Playlist playlist) {
        playlistService.updatePlaylist(playlist);
        return Result.success("修改成功", null);
    }

    @DeleteMapping("/delete/{id}")
    public Result<?> delete(@PathVariable Long id, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        playlistService.deletePlaylist(id, userId);
        return Result.success("删除成功", null);
    }

    @GetMapping("/detail/{id}")
    public Result<Playlist> detail(@PathVariable Long id) {
        Playlist playlist = playlistService.getDetail(id);
        if (playlist == null) {
            return Result.error("歌单不存在");
        }
        return Result.success(playlist);
    }

    @GetMapping("/public")
    public Result<IPage<Playlist>> publicList(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {
        return Result.success(playlistService.getPublicList(pageNum, pageSize));
    }

    @GetMapping("/my")
    public Result<IPage<Playlist>> myPlaylists(
            HttpServletRequest request,
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(playlistService.getUserPlaylists(userId, pageNum, pageSize));
    }

    @PostMapping("/addMusic")
    public Result<?> addMusic(@RequestBody Map<String, Long> params, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        playlistService.addMusic(params.get("playlistId"), params.get("musicId"), userId);
        return Result.success("添加成功", null);
    }

    @PostMapping("/removeMusic")
    public Result<?> removeMusic(@RequestBody Map<String, Long> params, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        playlistService.removeMusic(params.get("playlistId"), params.get("musicId"), userId);
        return Result.success("移除成功", null);
    }
}
