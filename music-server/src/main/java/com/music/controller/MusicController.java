package com.music.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.music.common.Result;
import com.music.entity.Music;
import com.music.service.CoverService;
import com.music.service.MusicService;
import com.music.service.UserInteractionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/music")
public class MusicController {

    @Autowired
    private MusicService musicService;

    @Autowired
    private UserInteractionService userInteractionService;

    @Autowired
    private CoverService coverService;

    @GetMapping("/list")
    public Result<IPage<Music>> list(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) Long singerId) {
        return Result.success(musicService.pageList(pageNum, pageSize, keyword, category, singerId));
    }

    @GetMapping("/detail/{id}")
    public Result<Map<String, Object>> detail(@PathVariable Long id) {
        Music music = musicService.getDetail(id);
        if (music == null) {
            return Result.error("音乐不存在");
        }
        Map<String, Object> data = new HashMap<>();
        data.put("music", music);
        data.put("avgScore", 0.0); // 暂不提供平均分计算，如有需要可以去user_interaction表里算
        return Result.success(data);
    }

    @GetMapping("/search")
    public Result<IPage<Music>> search(
            @RequestParam String keyword,
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {
        return Result.success(musicService.pageList(pageNum, pageSize, keyword, null, null));
    }

    @PostMapping("/upload")
    public Result<?> upload(@RequestBody Music music, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        music.setSingerId(userId);
        musicService.uploadMusic(music);
        return Result.success("上传成功", null);
    }

    @PutMapping("/update")
    public Result<?> update(@RequestBody Music music) {
        musicService.updateMusic(music);
        return Result.success("修改成功", null);
    }

    @DeleteMapping("/delete/{id}")
    public Result<?> delete(@PathVariable Long id) {
        musicService.deleteMusic(id);
        return Result.success("删除成功", null);
    }

    @PutMapping("/status/{id}")
    public Result<?> updateStatus(@PathVariable Long id, @RequestParam Integer status) {
        musicService.updateStatus(id, status);
        return Result.success();
    }

    @PostMapping("/play/{id}")
    public Result<?> play(@PathVariable Long id, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        musicService.incrementPlayCount(id);
        if (userId != null) {
            userInteractionService.recordPlay(userId, id);
        }
        return Result.success();
    }

    @GetMapping("/top100")
    public Result<List<Music>> top100() {
        return Result.success(musicService.getTop100());
    }

    @GetMapping("/singer/list")
    public Result<IPage<Music>> singerMusicList(
            HttpServletRequest request,
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(musicService.pageList(pageNum, pageSize, null, null, userId));
    }

    @GetMapping("/statistics")
    public Result<Map<String, Object>> getStatistics() {
        return Result.success(musicService.getStatistics());
    }

    @GetMapping("/all")
    public Result<IPage<Music>> allList(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer status) {
        // 管理员查看所有音乐（包含不同状态）
        com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<Music> wrapper =
                new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.and(w -> w.like(Music::getTitle, keyword).or().like(Music::getSingerName, keyword));
        }
        if (status != null) {
            wrapper.eq(Music::getStatus, status);
        }
        wrapper.orderByDesc(Music::getCreateTime);
        com.baomidou.mybatisplus.extension.plugins.pagination.Page<Music> page =
                new com.baomidou.mybatisplus.extension.plugins.pagination.Page<>(pageNum, pageSize);
        return Result.success(musicService.page(page, wrapper));
    }

    @PostMapping("/cover/batch")
    public Result<Map<String, Object>> batchUpdateCovers(@RequestParam(defaultValue = "false") boolean all) {
        int count;
        if (all) {
            count = coverService.batchUpdateAllCovers();
        } else {
            count = coverService.batchUpdateCovers();
        }
        Map<String, Object> data = new HashMap<>();
        data.put("updated", count);
        return Result.success("封面更新完成", data);
    }

    @GetMapping("/cover/fetch")
    public Result<String> fetchCover(@RequestParam String title, @RequestParam(required = false) String singer) {
        String coverUrl = coverService.fetchCoverUrl(title, singer != null ? singer : "");
        if (coverUrl != null) {
            return Result.success(coverUrl);
        }
        return Result.error("未找到封面");
    }
}
