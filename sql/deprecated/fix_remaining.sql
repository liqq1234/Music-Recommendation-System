USE music_recommendation;

-- 为歌单设置封面：选用歌单主题对应的专辑封面
-- 华语经典情歌 -> 修炼爱情(林俊杰)
UPDATE playlist SET cover_url = (SELECT cover_url FROM music WHERE id = 64) WHERE id = 7;
-- 周杰伦精选 -> 青花瓷(周杰伦)
UPDATE playlist SET cover_url = (SELECT cover_url FROM music WHERE id = 49) WHERE id = 8;
-- 民谣时光 -> 成都(赵雷)
UPDATE playlist SET cover_url = (SELECT cover_url FROM music WHERE id = 81) WHERE id = 9;
-- 摇滚不死 -> 倔强(五月天)
UPDATE playlist SET cover_url = (SELECT cover_url FROM music WHERE id = 68) WHERE id = 10;
-- 深夜轻音乐 -> River Flows in You(Yiruma)
UPDATE playlist SET cover_url = (SELECT cover_url FROM music WHERE id = 91) WHERE id = 11;
-- 欧美热歌榜 -> Shape of You(Ed Sheeran)
UPDATE playlist SET cover_url = (SELECT cover_url FROM music WHERE id = 96) WHERE id = 12;
