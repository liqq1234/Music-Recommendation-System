package com.music.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.music.common.Constants;
import com.music.entity.Music;
import com.music.entity.UserInteraction;
import com.music.mapper.MusicMapper;
import com.music.mapper.UserInteractionMapper;
import com.music.service.RecommendService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * 推荐服务实现 - 基于用户的协同过滤算法
 */
@Service
public class RecommendServiceImpl implements RecommendService {

    @Autowired
    private UserInteractionMapper userInteractionMapper;

    @Autowired
    private MusicMapper musicMapper;

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    @Override
    @SuppressWarnings("unchecked")
    public List<Music> recommendForUser(Long userId, int limit) {
        // 先查Redis缓存
        String cacheKey = Constants.REDIS_RECOMMEND_PREFIX + userId;
        List<Music> cached = (List<Music>) redisTemplate.opsForValue().get(cacheKey);
        if (cached != null && !cached.isEmpty()) {
            return cached;
        }

        // ========== 基于用户的协同过滤 ==========
        // 1. 构建用户-音乐评分矩阵
        List<UserInteraction> allInteractions = userInteractionMapper.selectList(null);
        Map<Long, Map<Long, Integer>> userRatingMap = new HashMap<>();
        Set<Long> playedMusicIds = new HashSet<>();
        for (UserInteraction ui : allInteractions) {
            if (ui.getRating() != null && ui.getRating() > 0) {
                userRatingMap.computeIfAbsent(ui.getUserId(), k -> new HashMap<>())
                        .put(ui.getMusicId(), ui.getRating());
            }
            if (ui.getUserId().equals(userId) && (ui.getPlayCount() != null && ui.getPlayCount() > 0)) {
                playedMusicIds.add(ui.getMusicId());
            }
        }

        Map<Long, Integer> targetUserRatings = userRatingMap.getOrDefault(userId, new HashMap<>());

        // 如果用户没有评分记录，返回热门推荐
        if (targetUserRatings.isEmpty()) {
            List<Music> top = musicMapper.selectTop100();
            return top.size() > limit ? top.subList(0, limit) : top;
        }

        // 2. 计算当前用户与其他用户的相似度（余弦相似度）
        Map<Long, Double> similarityMap = new HashMap<>();
        for (Map.Entry<Long, Map<Long, Integer>> entry : userRatingMap.entrySet()) {
            Long otherUserId = entry.getKey();
            if (otherUserId.equals(userId)) continue;

            Map<Long, Integer> otherRatings = entry.getValue();
            double similarity = cosineSimilarity(targetUserRatings, otherRatings);
            if (similarity > 0) {
                similarityMap.put(otherUserId, similarity);
            }
        }

        // 3. 取相似度最高的K个用户
        int K = 20;
        List<Map.Entry<Long, Double>> topKUsers = similarityMap.entrySet().stream()
                .sorted(Map.Entry.<Long, Double>comparingByValue().reversed())
                .limit(K)
                .collect(Collectors.toList());

        // 4. 根据相似用户的评分加权计算推荐分数
        Set<Long> ratedMusicIds = targetUserRatings.keySet();
        // 同时排除已播放的
        Set<Long> excludeIds = new HashSet<>(ratedMusicIds);
        excludeIds.addAll(playedMusicIds);

        Map<Long, Double> recommendScores = new HashMap<>();
        Map<Long, Double> similaritySum = new HashMap<>();

        for (Map.Entry<Long, Double> userSim : topKUsers) {
            Long simUserId = userSim.getKey();
            Double sim = userSim.getValue();
            Map<Long, Integer> simUserRatings = userRatingMap.get(simUserId);

            for (Map.Entry<Long, Integer> ratingEntry : simUserRatings.entrySet()) {
                Long musicId = ratingEntry.getKey();
                if (excludeIds.contains(musicId)) continue;

                recommendScores.merge(musicId, sim * ratingEntry.getValue(), Double::sum);
                similaritySum.merge(musicId, sim, Double::sum);
            }
        }

        // 5. 归一化分数并排序
        List<Long> recommendMusicIds = recommendScores.entrySet().stream()
                .map(e -> {
                    double normalized = e.getValue() / similaritySum.getOrDefault(e.getKey(), 1.0);
                    return new AbstractMap.SimpleEntry<>(e.getKey(), normalized);
                })
                .sorted(Map.Entry.<Long, Double>comparingByValue().reversed())
                .limit(limit)
                .map(Map.Entry::getKey)
                .collect(Collectors.toList());

        // 如果推荐结果不足，补充热门音乐
        if (recommendMusicIds.size() < limit) {
            List<Music> top = musicMapper.selectTop100();
            for (Music m : top) {
                if (recommendMusicIds.size() >= limit) break;
                if (!excludeIds.contains(m.getId()) && !recommendMusicIds.contains(m.getId())) {
                    recommendMusicIds.add(m.getId());
                }
            }
        }

        if (recommendMusicIds.isEmpty()) {
            return new ArrayList<>();
        }

        // 6. 查询音乐详情
        List<Music> result = musicMapper.selectBatchIds(recommendMusicIds);

        // 缓存推荐结果
        if (!result.isEmpty()) {
            redisTemplate.opsForValue().set(cacheKey, result, Constants.REDIS_EXPIRE_SECONDS, TimeUnit.SECONDS);
        }

        return result;
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Music> getTop100() {
        List<Music> list = (List<Music>) redisTemplate.opsForValue().get(Constants.REDIS_TOP100);
        if (list != null && !list.isEmpty()) {
            return list;
        }
        list = musicMapper.selectTop100();
        if (list != null && !list.isEmpty()) {
            redisTemplate.opsForValue().set(Constants.REDIS_TOP100, list, Constants.REDIS_EXPIRE_SECONDS, TimeUnit.SECONDS);
        }
        return list;
    }

    /**
     * 计算余弦相似度
     */
    private double cosineSimilarity(Map<Long, Integer> ratings1, Map<Long, Integer> ratings2) {
        Set<Long> commonKeys = new HashSet<>(ratings1.keySet());
        commonKeys.retainAll(ratings2.keySet());

        if (commonKeys.isEmpty()) return 0.0;

        double dotProduct = 0.0;
        double norm1 = 0.0;
        double norm2 = 0.0;

        for (Long key : commonKeys) {
            dotProduct += ratings1.get(key) * ratings2.get(key);
        }
        for (Integer v : ratings1.values()) {
            norm1 += v * v;
        }
        for (Integer v : ratings2.values()) {
            norm2 += v * v;
        }

        double denominator = Math.sqrt(norm1) * Math.sqrt(norm2);
        return denominator == 0 ? 0.0 : dotProduct / denominator;
    }
}
