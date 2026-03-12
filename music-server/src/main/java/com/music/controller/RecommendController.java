package com.music.controller;

import com.music.common.Result;
import com.music.entity.Music;
import com.music.service.RecommendService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@RestController
@RequestMapping("/api/recommend")
public class RecommendController {

    @Autowired
    private RecommendService recommendService;

    @GetMapping("/personal")
    public Result<List<Music>> personal(
            HttpServletRequest request,
            @RequestParam(defaultValue = "20") int limit) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(recommendService.recommendForUser(userId, limit));
    }

    @GetMapping("/top100")
    public Result<List<Music>> top100() {
        return Result.success(recommendService.getTop100());
    }
}
