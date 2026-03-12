-- ============================================
-- 基于Spring Boot的定制音乐推荐系统 - 数据库结构
-- ============================================

CREATE DATABASE IF NOT EXISTS music_recommendation DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE music_recommendation;

-- ----------------------------
-- 1. 用户表 (包含管理员、歌手、普通用户)
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户ID',
    `username` VARCHAR(50) NOT NULL COMMENT '用户名',
    `password` VARCHAR(255) NOT NULL COMMENT '密码',
    `nickname` VARCHAR(50) DEFAULT NULL COMMENT '昵称',
    `avatar` VARCHAR(255) DEFAULT NULL COMMENT '头像',
    `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    `role` TINYINT NOT NULL DEFAULT 0 COMMENT '角色：0-普通用户 1-歌手 2-管理员',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-禁用 1-正常',
    `introduction` VARCHAR(500) DEFAULT NULL COMMENT '简介',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ----------------------------
-- 2. 音乐表
-- ----------------------------
DROP TABLE IF EXISTS `music`;
CREATE TABLE `music` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '音乐ID',
    `title` VARCHAR(200) NOT NULL COMMENT '歌曲名称',
    `singer_id` BIGINT NOT NULL COMMENT '歌手ID',
    `singer_name` VARCHAR(50) DEFAULT NULL COMMENT '歌手名称',
    `category` VARCHAR(50) DEFAULT NULL COMMENT '风格分类',
    `album` VARCHAR(200) DEFAULT NULL COMMENT '专辑名',
    `duration` INT DEFAULT 0 COMMENT '时长(秒)',
    `cover_url` VARCHAR(500) DEFAULT NULL COMMENT '封面URL',
    `file_url` VARCHAR(500) NOT NULL COMMENT '文件URL',
    `play_count` BIGINT DEFAULT 0 COMMENT '总播放量',
    `lyric` TEXT COMMENT '歌词',
    `audio_fingerprint` VARCHAR(255) DEFAULT NULL COMMENT '音频指纹',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_singer` (`singer_id`),
    KEY `idx_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='音乐表';

-- ----------------------------
-- 3. 用户交互表 (整合了评分、收藏、播放记录)
-- ----------------------------
DROP TABLE IF EXISTS `user_interaction`;
CREATE TABLE `user_interaction` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `music_id` BIGINT NOT NULL,
    `rating` TINYINT DEFAULT NULL COMMENT '评分(1-5)',
    `is_favorite` TINYINT DEFAULT 0 COMMENT '是否收藏：0-否 1-是',
    `play_count` INT DEFAULT 0 COMMENT '播放次数',
    `last_play_time` DATETIME DEFAULT NULL COMMENT '最后播放时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_music` (`user_id`, `music_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户交互行为表';

-- ----------------------------
-- 4. 歌单表
-- ----------------------------
DROP TABLE IF EXISTS `playlist`;
CREATE TABLE `playlist` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(200) NOT NULL,
    `description` VARCHAR(500) DEFAULT NULL,
    `cover_url` VARCHAR(500) DEFAULT NULL,
    `user_id` BIGINT NOT NULL,
    `is_public` TINYINT DEFAULT 1,
    `play_count` BIGINT DEFAULT 0 COMMENT '播放次数',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='歌单表';

-- ----------------------------
-- 5. 歌单音乐关联表
-- ----------------------------
DROP TABLE IF EXISTS `playlist_music`;
CREATE TABLE `playlist_music` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `playlist_id` BIGINT NOT NULL,
    `music_id` BIGINT NOT NULL,
    `sort` INT DEFAULT 0 COMMENT '排序',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_playlist_music` (`playlist_id`, `music_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='歌单关联表';
