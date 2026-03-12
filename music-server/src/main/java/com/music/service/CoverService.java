package com.music.service;

import cn.hutool.http.HttpUtil;
import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.music.entity.Music;
import com.music.mapper.MusicMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Service
public class CoverService {

    private static final Logger log = LoggerFactory.getLogger(CoverService.class);

    @Value("${yaohud.api-key}")
    private String apiKey;

    @Value("${yaohud.base-url}")
    private String baseUrl;

    @Autowired
    private MusicMapper musicMapper;

    /**
     * 通过QQ音乐API搜索歌曲封面
     */
    public String fetchCoverUrl(String title, String singer) {
        try {
            String word = title + " " + singer;
            String encodedWord = URLEncoder.encode(word, StandardCharsets.UTF_8.toString());
            String url = baseUrl + "?type=so&word=" + encodedWord + "&key=" + apiKey + "&format=json&per_page=1";

            String result = HttpUtil.get(url, 10000);
            JSONObject json = JSONUtil.parseObj(result);

            if (json.getInt("code") == 200) {
                JSONObject data = json.getJSONObject("data");
                JSONArray list = data.getJSONArray("list");
                if (list != null && !list.isEmpty()) {
                    JSONObject song = list.getJSONObject(0);
                    String pic = song.getStr("pic");
                    if (pic != null && !pic.isEmpty()) {
                        return pic;
                    }
                }
            }
        } catch (Exception e) {
            log.warn("获取封面失败: {} - {}", title, e.getMessage());
        }
        return null;
    }

    /**
     * 批量更新所有缺少封面的音乐
     */
    public int batchUpdateCovers() {
        List<Music> musicList = musicMapper.selectList(
                new LambdaQueryWrapper<Music>()
                        .and(w -> w.isNull(Music::getCoverUrl).or().eq(Music::getCoverUrl, ""))
                        .or()
                        .likeRight(Music::getCoverUrl, "https://picsum")
        );

        int updated = 0;
        for (Music music : musicList) {
            String coverUrl = fetchCoverUrl(music.getTitle(), music.getSingerName());
            if (coverUrl != null) {
                music.setCoverUrl(coverUrl);
                musicMapper.updateById(music);
                updated++;
                log.info("封面更新成功: {} -> {}", music.getTitle(), coverUrl);
            }
            // 遵守API频率限制
            try {
                Thread.sleep(1500);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                break;
            }
        }
        return updated;
    }

    /**
     * 批量更新所有音乐封面（包括已有封面的）
     */
    public int batchUpdateAllCovers() {
        List<Music> musicList = musicMapper.selectList(null);

        int updated = 0;
        for (Music music : musicList) {
            String coverUrl = fetchCoverUrl(music.getTitle(), music.getSingerName());
            if (coverUrl != null) {
                music.setCoverUrl(coverUrl);
                musicMapper.updateById(music);
                updated++;
                log.info("封面更新成功: {} -> {}", music.getTitle(), coverUrl);
            }
            // 遵守API频率限制
            try {
                Thread.sleep(1500);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                break;
            }
        }
        return updated;
    }
}
