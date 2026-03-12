package com.music.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.music.common.Result;
import com.music.service.UserInteractionService;
import com.music.entity.UserInteraction;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/interaction")
public class UserInteractionController {

    @Autowired
    private UserInteractionService userInteractionService;

    // 分页获取用户交互记录（支持 type: favorite, history, rating）
    @GetMapping("/page")
    public Result<?> findPage(@RequestParam(defaultValue = "1") Integer pageNum,
                              @RequestParam(defaultValue = "10") Integer pageSize,
                              @RequestParam String type,
                              HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        Page<UserInteraction> page = userInteractionService.getUserInteractions(pageNum, pageSize, userId, type);
        return Result.success(page);
    }

    // 记录播放
    @PostMapping("/play/{musicId}")
    public Result<?> recordPlay(@PathVariable Long musicId, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        userInteractionService.recordPlay(userId, musicId);
        return Result.success();
    }

    // 切换收藏状态
    @PostMapping("/favorite/{musicId}")
    public Result<?> toggleFavorite(@PathVariable Long musicId, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        boolean isFavorite = userInteractionService.toggleFavorite(userId, musicId);
        return Result.success(isFavorite);
    }

    // 评分
    @PostMapping("/rate/{musicId}/{score}")
    public Result<?> rateMusic(@PathVariable Long musicId, @PathVariable Integer score, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        userInteractionService.rateMusic(userId, musicId, score);
        return Result.success();
    }
    
    // 获取单首歌曲的交互状态
    @GetMapping("/status/{musicId}")
    public Result<?> getStatus(@PathVariable Long musicId, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        UserInteraction ui = userInteractionService.getInteraction(userId, musicId);
        return Result.success(ui);
    }
}
