USE music_recommendation;

-- ==============================
-- 歌手账号（密码均为 singer123, BCrypt加密）
-- ==============================
INSERT INTO `user` (`username`, `password`, `nickname`, `role`, `status`, `introduction`) VALUES
('jay_chou', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '周杰伦', 1, 1, '华语流行天王，代表作《青花瓷》《稻香》等'),
('eason_chan', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '陈奕迅', 1, 1, '香港歌神，代表作《十年》《浮夸》等'),
('jj_lin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '林俊杰', 1, 1, '新加坡创作歌手，代表作《江南》《修炼爱情》等'),
('mayday', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '五月天', 1, 1, '台湾摇滚乐队，代表作《倔强》《突然好想你》等'),
('li_ronghao', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '李荣浩', 1, 1, '内地创作歌手，代表作《李白》《模特》等'),
('taylor', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', 'Taylor Swift', 1, 1, '美国流行天后'),
('zhao_lei', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '赵雷', 1, 1, '民谣歌手，代表作《成都》《画》等'),
('pu_shu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '朴树', 1, 1, '独立音乐人，代表作《平凡之路》《白桦林》等');

-- ==============================
-- 普通用户（密码均为 user123）
-- ==============================
INSERT INTO `user` (`username`, `password`, `nickname`, `role`, `status`) VALUES
('user01', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '音乐爱好者小明', 0, 1),
('user02', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '文艺青年小红', 0, 1),
('user03', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '摇滚少年小强', 0, 1),
('user04', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '古典迷小美', 0, 1),
('user05', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '嘻哈玩家小帅', 0, 1);

-- ==============================
-- 音乐数据（关联歌手userId，分类categoryId）
-- ==============================
INSERT INTO `music` (`title`, `singer_name`, `singer_id`, `album`, `category_id`, `duration`, `file_url`, `status`, `play_count`) VALUES
-- 周杰伦 (singer_id=2)
('青花瓷', '周杰伦', 2, '我很忙', 1, 239, '/uploads/music/qinghuaci.mp3', 1, 58320),
('稻香', '周杰伦', 2, '魔杰座', 1, 223, '/uploads/music/daoxiang.mp3', 1, 72150),
('七里香', '周杰伦', 2, '七里香', 1, 296, '/uploads/music/qilixiang.mp3', 1, 65430),
('晴天', '周杰伦', 2, '叶惠美', 1, 269, '/uploads/music/qingtian.mp3', 1, 89200),
('双截棍', '周杰伦', 2, '范特西', 8, 193, '/uploads/music/shuangjiegun.mp3', 1, 43210),
('简单爱', '周杰伦', 2, '范特西', 1, 270, '/uploads/music/jiandanai.mp3', 1, 56780),
('夜曲', '周杰伦', 2, '十一月的萧邦', 1, 225, '/uploads/music/yequ.mp3', 1, 47890),
('反方向的钟', '周杰伦', 2, 'Jay', 1, 262, '/uploads/music/fanfangxiang.mp3', 1, 38900),
-- 陈奕迅 (singer_id=3)
('十年', '陈奕迅', 3, '黑白灰', 1, 206, '/uploads/music/shinian.mp3', 1, 91000),
('浮夸', '陈奕迅', 3, 'U87', 1, 283, '/uploads/music/fukua.mp3', 1, 78500),
('富士山下', '陈奕迅', 3, 'What\'s Going On...?', 1, 264, '/uploads/music/fushishanxia.mp3', 1, 61200),
('孤勇者', '陈奕迅', 3, '孤勇者', 1, 262, '/uploads/music/guyongzhe.mp3', 1, 120000),
('淘汰', '陈奕迅', 3, '认了吧', 1, 276, '/uploads/music/taotai.mp3', 1, 55000),
('好久不见', '陈奕迅', 3, '认了吧', 1, 251, '/uploads/music/haojiubujian.mp3', 1, 68700),
-- 林俊杰 (singer_id=4)
('江南', '林俊杰', 4, '第二天堂', 1, 284, '/uploads/music/jiangnan.mp3', 1, 85600),
('修炼爱情', '林俊杰', 4, '因你而在', 1, 276, '/uploads/music/xiulian.mp3', 1, 72300),
('她说', '林俊杰', 4, '她说', 1, 295, '/uploads/music/tashuo.mp3', 1, 63200),
('可惜没如果', '林俊杰', 4, '新地球', 1, 309, '/uploads/music/keximeir.mp3', 1, 54000),
('不为谁而作的歌', '林俊杰', 4, '和自己对话', 1, 286, '/uploads/music/buweishui.mp3', 1, 41200),
-- 五月天 (singer_id=5)
('倔强', '五月天', 5, '神的孩子都在跳舞', 2, 294, '/uploads/music/juejiang.mp3', 1, 67500),
('突然好想你', '五月天', 5, '后青春期的诗', 2, 295, '/uploads/music/turanhaoxiangni.mp3', 1, 82100),
('知足', '五月天', 5, '知足 Just My Pride', 2, 308, '/uploads/music/zhizu.mp3', 1, 56300),
('温柔', '五月天', 5, '爱情万岁', 2, 269, '/uploads/music/wenrou.mp3', 1, 48000),
('干杯', '五月天', 5, '第二人生', 2, 299, '/uploads/music/ganbei.mp3', 1, 39800),
-- 李荣浩 (singer_id=6)
('李白', '李荣浩', 6, '模特', 1, 262, '/uploads/music/libai.mp3', 1, 76200),
('模特', '李荣浩', 6, '模特', 1, 311, '/uploads/music/mote.mp3', 1, 51400),
('年少有为', '李荣浩', 6, '耳朵', 1, 234, '/uploads/music/nianshaoyouwei.mp3', 1, 93500),
('戒烟', '李荣浩', 6, '有理想', 1, 297, '/uploads/music/jieyan.mp3', 1, 41200),
-- Taylor Swift (singer_id=7)
('Love Story', 'Taylor Swift', 7, 'Fearless', 1, 235, '/uploads/music/lovestory.mp3', 1, 68200),
('Shake It Off', 'Taylor Swift', 7, '1989', 1, 219, '/uploads/music/shakeitoff.mp3', 1, 105000),
('Blank Space', 'Taylor Swift', 7, '1989', 1, 231, '/uploads/music/blankspace.mp3', 1, 89700),
('Anti-Hero', 'Taylor Swift', 7, 'Midnights', 1, 200, '/uploads/music/antihero.mp3', 1, 76500),
-- 赵雷 (singer_id=8)
('成都', '赵雷', 8, '无法长大', 3, 328, '/uploads/music/chengdu.mp3', 1, 110000),
('画', '赵雷', 8, '赵小雷', 3, 251, '/uploads/music/hua.mp3', 1, 45600),
('南方姑娘', '赵雷', 8, '赵小雷', 3, 302, '/uploads/music/nanfangg.mp3', 1, 38700),
('鼓楼', '赵雷', 8, '无法长大', 3, 276, '/uploads/music/gulou.mp3', 1, 32100),
-- 朴树 (singer_id=9)
('平凡之路', '朴树', 9, '猎户星座', 3, 281, '/uploads/music/pingfanzhilu.mp3', 1, 130000),
('白桦林', '朴树', 9, '我去2000年', 3, 316, '/uploads/music/baihualin.mp3', 1, 52300),
('那些花儿', '朴树', 9, '我去2000年', 3, 307, '/uploads/music/naxiehuaer.mp3', 1, 61200),
('生如夏花', '朴树', 9, '生如夏花', 3, 265, '/uploads/music/shengruxiahua.mp3', 1, 47800),
-- 额外经典曲目（轻音乐/古典/电子/爵士等分类）
('克罗地亚狂想曲', '马克西姆', 2, '钢琴名曲', 5, 218, '/uploads/music/croatia.mp3', 1, 34500),
('卡农', '帕赫贝尔', 2, '古典精选', 5, 328, '/uploads/music/canon.mp3', 1, 42100),
('River Flows in You', 'Yiruma', 4, '钢琴合集', 10, 183, '/uploads/music/riverflows.mp3', 1, 55800),
('夜的钢琴曲五', '石进', 4, '夜的钢琴曲', 10, 198, '/uploads/music/yedegangqin.mp3', 1, 38200),
('Faded', 'Alan Walker', 7, 'Different World', 4, 212, '/uploads/music/faded.mp3', 1, 115000),
('Alone', 'Alan Walker', 7, 'Different World', 4, 157, '/uploads/music/alone.mp3', 1, 72100),
('See You Again', 'Wiz Khalifa', 7, 'Furious 7', 8, 237, '/uploads/music/seeyouagain.mp3', 1, 98000),
('Shape of You', 'Ed Sheeran', 7, '÷ (Divide)', 1, 234, '/uploads/music/shapeofyou.mp3', 1, 140000);

-- ==============================
-- 评分数据（让推荐算法有数据可用）
-- ==============================
INSERT INTO `rating` (`user_id`, `music_id`, `score`) VALUES
-- user01 喜欢周杰伦和林俊杰
(10, 1, 5), (10, 2, 5), (10, 3, 4), (10, 4, 5), (10, 16, 5), (10, 17, 4), (10, 18, 5),
-- user02 喜欢陈奕迅和民谣
(11, 9, 5), (11, 10, 5), (11, 11, 4), (11, 12, 5), (11, 33, 5), (11, 34, 4), (11, 35, 5),
-- user03 喜欢摇滚
(12, 21, 5), (12, 22, 5), (12, 23, 4), (12, 24, 5), (12, 5, 4), (12, 25, 4),
-- user04 喜欢轻音乐古典
(13, 39, 5), (13, 40, 5), (13, 41, 4), (13, 42, 5), (13, 37, 4), (13, 38, 4),
-- user05 喜欢嘻哈电子
(14, 5, 5), (14, 43, 5), (14, 44, 4), (14, 45, 5), (14, 46, 5),
-- 交叉评分（让协同过滤能找到相似用户）
(10, 33, 3), (10, 9, 4), (11, 1, 3), (11, 2, 4), (12, 4, 4), (12, 37, 3),
(13, 33, 4), (13, 9, 3), (14, 4, 3), (14, 22, 4);

-- ==============================
-- 收藏数据
-- ==============================
INSERT INTO `collection` (`user_id`, `music_id`) VALUES
(10, 1), (10, 2), (10, 4), (10, 16), (10, 17),
(11, 9), (11, 10), (11, 12), (11, 33), (11, 35),
(12, 21), (12, 22), (12, 23), (12, 5),
(13, 39), (13, 40), (13, 41), (13, 42),
(14, 43), (14, 44), (14, 45), (14, 46);

-- ==============================
-- 播放记录
-- ==============================
INSERT INTO `play_history` (`user_id`, `music_id`, `play_time`) VALUES
(10, 1, '2026-03-01 10:00:00'), (10, 2, '2026-03-01 10:05:00'), (10, 4, '2026-03-02 14:00:00'),
(10, 16, '2026-03-03 08:30:00'), (10, 17, '2026-03-04 20:00:00'),
(11, 9, '2026-03-01 09:00:00'), (11, 10, '2026-03-02 15:00:00'), (11, 12, '2026-03-03 11:00:00'),
(11, 33, '2026-03-04 16:00:00'), (11, 35, '2026-03-05 09:30:00'),
(12, 21, '2026-03-01 22:00:00'), (12, 22, '2026-03-02 21:00:00'), (12, 5, '2026-03-03 23:00:00'),
(13, 39, '2026-03-01 19:00:00'), (13, 40, '2026-03-02 18:00:00'), (13, 41, '2026-03-03 20:00:00'),
(14, 43, '2026-03-01 12:00:00'), (14, 44, '2026-03-02 13:00:00'), (14, 45, '2026-03-04 14:00:00');

-- ==============================
-- 公开歌单
-- ==============================
INSERT INTO `playlist` (`name`, `description`, `user_id`, `is_public`, `play_count`) VALUES
('华语经典情歌', '收录华语乐坛最动人的情歌', 10, 1, 1520),
('周杰伦精选', '杰伦最好听的歌曲合集', 10, 1, 3200),
('民谣时光', '静下来，听一首民谣', 11, 1, 890),
('摇滚不死', '热血摇滚歌曲精选', 12, 1, 760),
('深夜轻音乐', '助眠减压的轻音乐合集', 13, 1, 1100),
('欧美热歌榜', '最新欧美流行歌曲', 14, 1, 2100);

INSERT INTO `playlist_music` (`playlist_id`, `music_id`) VALUES
-- 华语经典情歌
(1, 9), (1, 13), (1, 14), (1, 4), (1, 17), (1, 18),
-- 周杰伦精选
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 6), (2, 7), (2, 8),
-- 民谣时光
(3, 33), (3, 34), (3, 35), (3, 36), (3, 37), (3, 38),
-- 摇滚不死
(4, 21), (4, 22), (4, 23), (4, 24), (4, 25),
-- 深夜轻音乐
(5, 39), (5, 40), (5, 41), (5, 42),
-- 欧美热歌榜
(6, 29), (6, 30), (6, 31), (6, 32), (6, 43), (6, 44), (6, 45), (6, 46);
