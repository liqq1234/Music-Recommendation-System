-- ============================================
-- 基于Spring Boot的定制音乐推荐系统 - 完整初始化数据
-- ============================================

USE music_recommendation;

-- ----------------------------
-- 1. 用户数据
-- ----------------------------
INSERT INTO `user` (`username`, `password`, `nickname`, `role`, `status`, `introduction`) VALUES
-- 管理员（密码: admin123）
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', '系统管理员', 2, 1, NULL),
-- 歌手（密码: singer123）
('jay_chou', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '周杰伦', 1, 1, '华语流行天王，代表作《青花瓷》《稻香》等'),
('eason_chan', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '陈奕迅', 1, 1, '香港歌神，代表作《十年》《浮夸》等'),
('jj_lin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '林俊杰', 1, 1, '新加坡创作歌手，代表作《江南》《修炼爱情》等'),
('mayday', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '五月天', 1, 1, '台湾摇滚乐队，代表作《倔强》《突然好想你》等'),
('li_ronghao', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '李荣浩', 1, 1, '内地创作歌手，代表作《李白》《模特》等'),
('taylor', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', 'Taylor Swift', 1, 1, '美国流行天后'),
('zhao_lei', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '赵雷', 1, 1, '民谣歌手，代表作《成都》《画》等'),
('pu_shu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '朴树', 1, 1, '独立音乐人，代表作《平凡之路》《白桦林》等'),
-- 普通用户（密码: user123）
('user01', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '音乐爱好者小明', 0, 1, NULL),
('user02', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '文艺青年小红', 0, 1, NULL),
('user03', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '摇滚少年小强', 0, 1, NULL),
('user04', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '古典迷小美', 0, 1, NULL),
('user05', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKt6Z5EH', '嘻哈玩家小帅', 0, 1, NULL);

-- 说明：user表中 id 自增，顺序为：
-- 1=admin, 2=jay_chou, 3=eason_chan, 4=jj_lin, 5=mayday
-- 6=li_ronghao, 7=taylor, 8=zhao_lei, 9=pu_shu
-- 10=user01, 11=user02, 12=user03, 13=user04, 14=user05

-- ----------------------------
-- 2. 音乐数据（category 直接存字符串，已带封面URL）
-- ----------------------------
INSERT INTO `music` (`id`, `title`, `singer_name`, `singer_id`, `album`, `category`, `duration`, `file_url`, `cover_url`, `status`, `play_count`) VALUES
-- 周杰伦 (singer_id=2)
(1,  '青花瓷',     '周杰伦', 2, '我很忙',              '流行', 239, '/uploads/music/qinghuaci.mp3',     'https://y.gtimg.cn/music/photo_new/T002R300x300M000002eFUFm2XYZ7z.jpg?max_age=2592000', 1, 58320),
(2,  '稻香',       '周杰伦', 2, '魔杰座',              '流行', 223, '/uploads/music/daoxiang.mp3',      'https://y.gtimg.cn/music/photo_new/T002R300x300M000002Neh8l0uciQZ.jpg?max_age=2592000', 1, 72150),
(3,  '七里香',     '周杰伦', 2, '七里香',              '流行', 296, '/uploads/music/qilixiang.mp3',     'https://y.gtimg.cn/music/photo_new/T002R300x300M000003DFRzD192KKD.jpg?max_age=2592000', 1, 65430),
(4,  '晴天',       '周杰伦', 2, '叶惠美',              '流行', 269, '/uploads/music/qingtian.mp3',      'https://y.gtimg.cn/music/photo_new/T002R300x300M000000MkMni19ClKG.jpg?max_age=2592000', 1, 89200),
(5,  '双截棍',     '周杰伦', 2, '范特西',              '嘻哈', 193, '/uploads/music/shuangjiegun.mp3',  'https://y.gtimg.cn/music/photo_new/T002R300x300M000000I5jJB3blWeN.jpg?max_age=2592000', 1, 43210),
(6,  '简单爱',     '周杰伦', 2, '范特西',              '流行', 270, '/uploads/music/jiandanai.mp3',     'https://y.gtimg.cn/music/photo_new/T002R300x300M000000I5jJB3blWeN.jpg?max_age=2592000', 1, 56780),
(7,  '夜曲',       '周杰伦', 2, '十一月的萧邦',        '流行', 225, '/uploads/music/yequ.mp3',          'https://y.gtimg.cn/music/photo_new/T002R300x300M0000024bjiL2aocxT.jpg?max_age=2592000', 1, 47890),
(8,  '反方向的钟', '周杰伦', 2, 'Jay',                 '流行', 262, '/uploads/music/fanfangxiang.mp3',  'https://y.gtimg.cn/music/photo_new/T002R300x300M000000f01724fd7TH.jpg?max_age=2592000', 1, 38900),
-- 陈奕迅 (singer_id=3)
(9,  '十年',       '陈奕迅', 3, '黑白灰',              '流行', 206, '/uploads/music/shinian.mp3',       'https://y.gtimg.cn/music/photo_new/T002R300x300M000000GDz8k03UOaI.jpg?max_age=2592000', 1, 91000),
(10, '浮夸',       '陈奕迅', 3, 'U87',                 '流行', 283, '/uploads/music/fukua.mp3',         'https://y.gtimg.cn/music/photo_new/T002R300x300M000003J6fvc0bVJon.jpg?max_age=2592000', 1, 78500),
(11, '富士山下',   '陈奕迅', 3, 'What\'s Going On...?','流行', 264, '/uploads/music/fushishanxia.mp3',  'https://y.gtimg.cn/music/photo_new/T002R300x300M000004Z85XP1c25b7.jpg?max_age=2592000', 1, 61200),
(12, '孤勇者',     '陈奕迅', 3, '孤勇者',              '流行', 262, '/uploads/music/guyongzhe.mp3',     'https://y.gtimg.cn/music/photo_new/T002R300x300M000001uaPM93kxk1R.jpg?max_age=2592000', 1, 120000),
(13, '淘汰',       '陈奕迅', 3, '认了吧',              '流行', 276, '/uploads/music/taotai.mp3',        'https://y.gtimg.cn/music/photo_new/T002R300x300M000003yQidc3s7P65.jpg?max_age=2592000', 1, 55000),
(14, '好久不见',   '陈奕迅', 3, '认了吧',              '流行', 251, '/uploads/music/haojiubujian.mp3',  'https://y.gtimg.cn/music/photo_new/T002R300x300M000003yQidc3s7P65.jpg?max_age=2592000', 1, 68700),
-- 林俊杰 (singer_id=4)
(15, '江南',       '林俊杰', 4, '第二天堂',            '流行', 284, '/uploads/music/jiangnan.mp3',      'https://y.gtimg.cn/music/photo_new/T002R300x300M000000y5gq7449K9I.jpg?max_age=2592000', 1, 85600),
(16, '修炼爱情',   '林俊杰', 4, '因你而在',            '流行', 276, '/uploads/music/xiulian.mp3',       'https://y.gtimg.cn/music/photo_new/T002R300x300M000001gqOnU3DTg2S.jpg?max_age=2592000', 1, 72300),
(17, '她说',       '林俊杰', 4, '她说',                '流行', 295, '/uploads/music/tashuo.mp3',        'https://y.gtimg.cn/music/photo_new/T002R300x300M000000TuW8h0AH2n4.jpg?max_age=2592000', 1, 63200),
(18, '可惜没如果', '林俊杰', 4, '新地球',              '流行', 309, '/uploads/music/keximeir.mp3',      'https://y.gtimg.cn/music/photo_new/T002R300x300M0000033R2xQ2I0Uyf.jpg?max_age=2592000', 1, 54000),
(19, '不为谁而作的歌','林俊杰',4,'和自己对话',         '流行', 286, '/uploads/music/buweishui.mp3',     'https://y.gtimg.cn/music/photo_new/T002R300x300M000003nbc0602Tgfx.jpg?max_age=2592000', 1, 41200),
-- 五月天 (singer_id=5)
(20, '倔强',       '五月天', 5, '神的孩子都在跳舞',    '摇滚', 294, '/uploads/music/juejiang.mp3',      'https://y.gtimg.cn/music/photo_new/T002R300x300M000002plCgA0zOyYF.jpg?max_age=2592000', 1, 67500),
(21, '突然好想你', '五月天', 5, '后青春期的诗',        '摇滚', 295, '/uploads/music/turanhaoxiangni.mp3','https://y.gtimg.cn/music/photo_new/T002R300x300M0000020I7sO0ayXhN.jpg?max_age=2592000', 1, 82100),
(22, '知足',       '五月天', 5, 'Just My Pride',       '摇滚', 308, '/uploads/music/zhizu.mp3',         'https://y.gtimg.cn/music/photo_new/T002R300x300M000003PIMo40rxcAn.jpg?max_age=2592000', 1, 56300),
(23, '温柔',       '五月天', 5, '爱情万岁',            '摇滚', 269, '/uploads/music/wenrou.mp3',        'https://y.gtimg.cn/music/photo_new/T002R300x300M0000042miPf28nzum.jpg?max_age=2592000', 1, 48000),
(24, '干杯',       '五月天', 5, '第二人生',            '摇滚', 299, '/uploads/music/ganbei.mp3',        'https://y.gtimg.cn/music/photo_new/T002R300x300M000001fbipy4azgKM.jpg?max_age=2592000', 1, 39800),
-- 李荣浩 (singer_id=6)
(25, '李白',       '李荣浩', 6, '模特',                '流行', 262, '/uploads/music/libai.mp3',         'https://y.gtimg.cn/music/photo_new/T002R300x300M000004AhJHV3slLjN.jpg?max_age=2592000', 1, 76200),
(26, '模特',       '李荣浩', 6, '模特',                '流行', 311, '/uploads/music/mote.mp3',          'https://y.gtimg.cn/music/photo_new/T002R300x300M000004AhJHV3slLjN.jpg?max_age=2592000', 1, 51400),
(27, '年少有为',   '李荣浩', 6, '耳朵',                '流行', 234, '/uploads/music/nianshaoyouwei.mp3','https://y.gtimg.cn/music/photo_new/T002R300x300M000004QnEHc3zjC7J.jpg?max_age=2592000', 1, 93500),
(28, '戒烟',       '李荣浩', 6, '有理想',              '流行', 297, '/uploads/music/jieyan.mp3',        'https://y.gtimg.cn/music/photo_new/T002R300x300M000003EenCA2q0MWF.jpg?max_age=2592000', 1, 41200),
-- Taylor Swift (singer_id=7)
(29, 'Love Story',  'Taylor Swift', 7, 'Fearless',     '流行', 235, '/uploads/music/lovestory.mp3',     'https://y.gtimg.cn/music/photo_new/T002R300x300M000002Q1XUj3HBAzw.jpg?max_age=2592000', 1, 68200),
(30, 'Shake It Off','Taylor Swift', 7, '1989',         '流行', 219, '/uploads/music/shakeitoff.mp3',    'https://y.gtimg.cn/music/photo_new/T002R300x300M000003GEK3g1jAzq3.jpg?max_age=2592000', 1, 105000),
(31, 'Blank Space', 'Taylor Swift', 7, '1989',         '流行', 231, '/uploads/music/blankspace.mp3',    'https://y.gtimg.cn/music/photo_new/T002R300x300M000002Kz5Jo1uzHjz.jpg?max_age=2592000', 1, 89700),
(32, 'Anti-Hero',   'Taylor Swift', 7, 'Midnights',   '流行', 200, '/uploads/music/antihero.mp3',      'https://y.gtimg.cn/music/photo_new/T002R300x300M000004duMMb29d9fe.jpg?max_age=2592000', 1, 76500),
-- 赵雷 (singer_id=8)
(33, '成都',       '赵雷', 8, '无法长大',              '民谣', 328, '/uploads/music/chengdu.mp3',       'https://y.gtimg.cn/music/photo_new/T002R300x300M000003ltiMR4RSrgo.jpg?max_age=2592000', 1, 110000),
(34, '画',         '赵雷', 8, '赵小雷',                '民谣', 251, '/uploads/music/hua.mp3',           'https://y.gtimg.cn/music/photo_new/T002R300x300M000001sKd2l0dVkXa.jpg?max_age=2592000', 1, 45600),
(35, '南方姑娘',   '赵雷', 8, '赵小雷',                '民谣', 302, '/uploads/music/nanfangg.mp3',      'https://y.gtimg.cn/music/photo_new/T002R300x300M000001sKd2l0dVkXa.jpg?max_age=2592000', 1, 38700),
(36, '鼓楼',       '赵雷', 8, '无法长大',              '民谣', 276, '/uploads/music/gulou.mp3',         'https://y.gtimg.cn/music/photo_new/T002R300x300M000000jE4g74VS43p.jpg?max_age=2592000', 1, 32100),
-- 朴树 (singer_id=9)
(37, '平凡之路',   '朴树', 9, '猎户星座',              '民谣', 281, '/uploads/music/pingfanzhilu.mp3',  'https://y.gtimg.cn/music/photo_new/T002R300x300M000002aRnZM0garaC.jpg?max_age=2592000', 1, 130000),
(38, '白桦林',     '朴树', 9, '我去2000年',            '民谣', 316, '/uploads/music/baihualin.mp3',     'https://y.gtimg.cn/music/photo_new/T002R300x300M000001n8QT30kOhTD.jpg?max_age=2592000', 1, 52300),
(39, '那些花儿',   '朴树', 9, '我去2000年',            '民谣', 307, '/uploads/music/naxiehuaer.mp3',    'https://y.gtimg.cn/music/photo_new/T002R300x300M000001n8QT30kOhTD.jpg?max_age=2592000', 1, 61200),
(40, '生如夏花',   '朴树', 9, '生如夏花',              '民谣', 265, '/uploads/music/shengruxiahua.mp3', 'https://y.gtimg.cn/music/photo_new/T002R300x300M000004dFbDj2kl3Pn.jpg?max_age=2592000', 1, 47800),
-- 额外经典曲目
(41, '克罗地亚狂想曲','马克西姆',2,'钢琴名曲',         '古典', 218, '/uploads/music/croatia.mp3',       'https://y.gtimg.cn/music/photo_new/T002R300x300M000001eVPmX2UfhDo.jpg?max_age=2592000', 1, 34500),
(42, '卡农',       '帕赫贝尔', 2, '古典精选',          '古典', 328, '/uploads/music/canon.mp3',         'https://y.gtimg.cn/music/photo_new/T002R300x300M000002dtATI3zZzqF.jpg?max_age=2592000', 1, 42100),
(43, 'Faded',      'Alan Walker', 7, 'Different World','电子', 212, '/uploads/music/faded.mp3',         'https://y.gtimg.cn/music/photo_new/T002R300x300M00000080XXJ0KLwW1.jpg?max_age=2592000', 1, 115000),
(44, 'Alone',      'Alan Walker', 7, 'Different World','电子', 157, '/uploads/music/alone.mp3',         'https://y.gtimg.cn/music/photo_new/T002R300x300M000001H7FNw0sI1IH.jpg?max_age=2592000', 1, 72100),
(45, 'See You Again','Wiz Khalifa',7,'Furious 7',      '嘻哈', 237, '/uploads/music/seeyouagain.mp3',   'https://y.gtimg.cn/music/photo_new/T002R300x300M000002Nt51E0q8Zoo.jpg?max_age=2592000', 1, 98000),
(46, 'Shape of You','Ed Sheeran', 7, '÷ (Divide)',     '流行', 234, '/uploads/music/shapeofyou.mp3',    'https://y.gtimg.cn/music/photo_new/T002R300x300M000001uSQEE2WdFLN.jpg?max_age=2592000', 1, 140000),
(47, 'River Flows in You','Yiruma',4,'钢琴合集',       '轻音乐',183,'/uploads/music/riverflows.mp3',   'https://y.gtimg.cn/music/photo_new/T002R300x300M000003ltiMR4RSrgo.jpg?max_age=2592000', 1, 55800),
(48, '夜的钢琴曲五','石进',     4, '夜的钢琴曲',       '轻音乐',198,'/uploads/music/yedegangqin.mp3',  'https://y.gtimg.cn/music/photo_new/T002R300x300M000001eVPmX2UfhDo.jpg?max_age=2592000', 1, 38200);

-- ----------------------------
-- 3. 用户交互数据（整合评分+收藏+播放，映射自旧的 rating/collection/play_history 表）
-- ----------------------------
-- user01(id=10) 喜欢周杰伦和林俊杰
INSERT INTO `user_interaction` (`user_id`, `music_id`, `rating`, `is_favorite`, `play_count`, `last_play_time`) VALUES
(10, 1,  5, 1, 12, '2026-03-04 20:00:00'),
(10, 2,  5, 1, 8,  '2026-03-01 10:05:00'),
(10, 3,  4, 0, 5,  '2026-03-02 09:00:00'),
(10, 4,  5, 1, 10, '2026-03-02 14:00:00'),
(10, 9,  4, 0, 3,  '2026-03-05 11:00:00'),
(10, 15, 5, 1, 7,  '2026-03-03 08:30:00'),
(10, 16, 4, 1, 6,  '2026-03-04 20:00:00'),
(10, 17, 5, 0, 4,  '2026-03-05 09:00:00'),
(10, 33, 3, 0, 2,  '2026-03-01 15:00:00'),
-- user02(id=11) 喜欢陈奕迅和民谣
(11, 1,  3, 0, 3,  '2026-03-03 10:00:00'),
(11, 2,  4, 0, 2,  '2026-03-04 11:00:00'),
(11, 9,  5, 1, 15, '2026-03-01 09:00:00'),
(11, 10, 5, 1, 10, '2026-03-02 15:00:00'),
(11, 11, 4, 0, 6,  '2026-03-03 12:00:00'),
(11, 12, 5, 1, 8,  '2026-03-03 11:00:00'),
(11, 33, 5, 1, 12, '2026-03-04 16:00:00'),
(11, 34, 4, 0, 5,  '2026-03-05 09:30:00'),
(11, 35, 5, 1, 9,  '2026-03-05 09:30:00'),
-- user03(id=12) 喜欢摇滚
(12, 4,  4, 0, 3,  '2026-03-04 22:00:00'),
(12, 5,  4, 1, 7,  '2026-03-03 23:00:00'),
(12, 20, 5, 1, 18, '2026-03-01 22:00:00'),
(12, 21, 5, 1, 14, '2026-03-02 21:00:00'),
(12, 22, 4, 1, 9,  '2026-03-03 20:00:00'),
(12, 23, 5, 1, 11, '2026-03-04 22:30:00'),
(12, 24, 4, 0, 5,  '2026-03-05 22:00:00'),
(12, 37, 3, 0, 2,  '2026-03-04 20:00:00'),
-- user04(id=13) 喜欢轻音乐古典
(13, 33, 4, 0, 3,  '2026-03-04 10:00:00'),
(13, 9,  3, 0, 2,  '2026-03-03 09:00:00'),
(13, 37, 4, 0, 4,  '2026-03-02 20:00:00'),
(13, 38, 4, 0, 3,  '2026-03-03 21:00:00'),
(13, 39, 4, 0, 5,  '2026-03-03 20:00:00'),
(13, 40, 4, 1, 6,  '2026-03-02 18:00:00'),
(13, 41, 5, 1, 10, '2026-03-01 19:00:00'),
(13, 42, 5, 1, 8,  '2026-03-01 19:30:00'),
(13, 47, 4, 0, 4,  '2026-03-04 22:00:00'),
(13, 48, 5, 1, 7,  '2026-03-03 22:00:00'),
-- user05(id=14) 喜欢嘻哈电子
(14, 4,  3, 0, 2,  '2026-03-03 13:00:00'),
(14, 22, 4, 0, 3,  '2026-03-04 14:00:00'),
(14, 5,  5, 0, 8,  '2026-03-05 15:00:00'),
(14, 43, 5, 1, 12, '2026-03-01 12:00:00'),
(14, 44, 4, 1, 9,  '2026-03-02 13:00:00'),
(14, 45, 5, 1, 15, '2026-03-04 14:00:00'),
(14, 46, 5, 1, 11, '2026-03-05 10:00:00');

-- ----------------------------
-- 4. 歌单数据
-- ----------------------------
INSERT INTO `playlist` (`name`, `description`, `user_id`, `is_public`, `play_count`) VALUES
('华语经典情歌', '收录华语乐坛最动人的情歌', 10, 1, 1520),
('周杰伦精选',   '杰伦最好听的歌曲合集',     10, 1, 3200),
('民谣时光',     '静下来，听一首民谣',       11, 1, 890),
('摇滚不死',     '热血摇滚歌曲精选',         12, 1, 760),
('深夜轻音乐',   '助眠减压的轻音乐合集',     13, 1, 1100),
('欧美热歌榜',   '最新欧美流行歌曲',         14, 1, 2100);

INSERT INTO `playlist_music` (`playlist_id`, `music_id`) VALUES
-- 1. 华语经典情歌
(1, 9), (1, 13), (1, 14), (1, 4), (1, 16), (1, 17),
-- 2. 周杰伦精选
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 6), (2, 7), (2, 8),
-- 3. 民谣时光
(3, 33), (3, 34), (3, 35), (3, 36), (3, 37), (3, 38),
-- 4. 摇滚不死
(4, 20), (4, 21), (4, 22), (4, 23), (4, 24),
-- 5. 深夜轻音乐
(5, 41), (5, 42), (5, 47), (5, 48),
-- 6. 欧美热歌榜
(6, 29), (6, 30), (6, 31), (6, 32), (6, 43), (6, 44), (6, 45), (6, 46);
