-- ============================================
-- 基于Spring Boot的定制音乐推荐系统 - 数据库初始化脚本
-- ============================================

CREATE DATABASE IF NOT EXISTS music_recommendation DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE music_recommendation;

-- ----------------------------
-- 1. 用户表
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户ID',
    `username` VARCHAR(50) NOT NULL COMMENT '用户名',
    `password` VARCHAR(255) NOT NULL COMMENT '密码（BCrypt加密）',
    `nickname` VARCHAR(50) DEFAULT NULL COMMENT '昵称',
    `avatar` VARCHAR(255) DEFAULT NULL COMMENT '头像URL',
    `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    `role` TINYINT NOT NULL DEFAULT 0 COMMENT '角色：0-普通用户 1-歌手 2-管理员',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-禁用 1-正常',
    `introduction` VARCHAR(500) DEFAULT NULL COMMENT '个人简介',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`),
    KEY `idx_role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ----------------------------
-- 2. 音乐分类表
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '分类ID',
    `name` VARCHAR(50) NOT NULL COMMENT '分类名称',
    `sort` INT DEFAULT 0 COMMENT '排序',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='音乐分类表';

-- ----------------------------
-- 3. 音乐表
-- ----------------------------
DROP TABLE IF EXISTS `music`;
CREATE TABLE `music` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '音乐ID',
    `title` VARCHAR(200) NOT NULL COMMENT '歌曲名称',
    `singer_id` BIGINT NOT NULL COMMENT '歌手ID（关联user表）',
    `singer_name` VARCHAR(50) DEFAULT NULL COMMENT '歌手名称',
    `category_id` BIGINT DEFAULT NULL COMMENT '分类ID',
    `album` VARCHAR(200) DEFAULT NULL COMMENT '所属专辑',
    `duration` INT DEFAULT 0 COMMENT '时长（秒）',
    `cover_url` VARCHAR(255) DEFAULT NULL COMMENT '封面图URL',
    `file_url` VARCHAR(255) NOT NULL COMMENT '音频文件URL',
    `lyric` TEXT COMMENT '歌词',
    `audio_fingerprint` VARCHAR(255) DEFAULT NULL COMMENT '音频指纹（去重用）',
    `play_count` BIGINT DEFAULT 0 COMMENT '播放次数',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-下架 1-正常 2-审核中',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_singer_id` (`singer_id`),
    KEY `idx_category_id` (`category_id`),
    KEY `idx_title` (`title`),
    KEY `idx_audio_fingerprint` (`audio_fingerprint`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='音乐表';

-- ----------------------------
-- 4. 评分表
-- ----------------------------
DROP TABLE IF EXISTS `rating`;
CREATE TABLE `rating` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '评分ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `music_id` BIGINT NOT NULL COMMENT '音乐ID',
    `score` TINYINT NOT NULL COMMENT '评分（1-5）',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_music` (`user_id`, `music_id`),
    KEY `idx_music_id` (`music_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评分表';

-- ----------------------------
-- 5. 收藏表
-- ----------------------------
DROP TABLE IF EXISTS `collection`;
CREATE TABLE `collection` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `music_id` BIGINT NOT NULL COMMENT '音乐ID',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_music` (`user_id`, `music_id`),
    KEY `idx_music_id` (`music_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='收藏表';

-- ----------------------------
-- 6. 歌单表
-- ----------------------------
DROP TABLE IF EXISTS `playlist`;
CREATE TABLE `playlist` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '歌单ID',
    `name` VARCHAR(200) NOT NULL COMMENT '歌单名称',
    `description` VARCHAR(500) DEFAULT NULL COMMENT '歌单描述',
    `cover_url` VARCHAR(255) DEFAULT NULL COMMENT '封面URL',
    `user_id` BIGINT NOT NULL COMMENT '创建者ID',
    `is_public` TINYINT NOT NULL DEFAULT 1 COMMENT '是否公开：0-私有 1-公开',
    `play_count` BIGINT DEFAULT 0 COMMENT '播放次数',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='歌单表';

-- ----------------------------
-- 7. 歌单-音乐关联表
-- ----------------------------
DROP TABLE IF EXISTS `playlist_music`;
CREATE TABLE `playlist_music` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `playlist_id` BIGINT NOT NULL COMMENT '歌单ID',
    `music_id` BIGINT NOT NULL COMMENT '音乐ID',
    `sort` INT DEFAULT 0 COMMENT '排序',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_playlist_music` (`playlist_id`, `music_id`),
    KEY `idx_music_id` (`music_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='歌单-音乐关联表';

-- ----------------------------
-- 8. 播放记录表
-- ----------------------------
DROP TABLE IF EXISTS `play_history`;
CREATE TABLE `play_history` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `music_id` BIGINT NOT NULL COMMENT '音乐ID',
    `play_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '播放时间',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_music_id` (`music_id`),
    KEY `idx_play_time` (`play_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='播放记录表';

-- ----------------------------
-- 初始数据：管理员账号（密码: admin123，BCrypt加密）
-- ----------------------------
INSERT INTO `user` (`username`, `password`, `nickname`, `role`, `status`) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', '系统管理员', 2, 1);

-- ----------------------------
-- 初始数据：音乐分类
-- ----------------------------
INSERT INTO `category` (`name`, `sort`) VALUES
('流行', 1),
('摇滚', 2),
('民谣', 3),
('电子', 4),
('古典', 5),
('爵士', 6),
('R&B', 7),
('嘻哈', 8),
('乡村', 9),
('轻音乐', 10);
