<template>
  <div class="home">
    <!-- 顶部横幅 -->
    <div class="banner">
      <h2>发现好音乐</h2>
      <p>基于协同过滤算法，为你精准推荐</p>
    </div>

    <!-- TOP100 热门音乐 -->
    <div class="section">
      <div class="section-header">
        <h3><i class="el-icon-trophy"></i> 热门 TOP 100</h3>
        <el-button type="text" @click="$router.push('/music')">查看更多 ></el-button>
      </div>
      <div class="music-grid">
        <div class="music-card" v-for="item in top100List.slice(0, 10)" :key="item.id"
             @click="$router.push('/music/' + item.id)">
          <div class="card-cover">
            <img :src="item.coverUrl || defaultCover" referrerpolicy="no-referrer" />
            <div class="play-overlay" @click.stop="playMusic(item)">
              <i class="el-icon-video-play"></i>
            </div>
          </div>
          <div class="card-info">
            <span class="card-title">{{ item.title }}</span>
            <span class="card-singer">{{ item.singerName }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 公开歌单 -->
    <div class="section">
      <div class="section-header">
        <h3><i class="el-icon-files"></i> 推荐歌单</h3>
        <el-button type="text" @click="$router.push('/playlist')">查看更多 ></el-button>
      </div>
      <div class="playlist-grid">
        <div class="playlist-card" v-for="item in playlists" :key="item.id"
             @click="$router.push('/playlist/' + item.id)">
          <div class="card-cover">
            <img :src="item.coverUrl || defaultPlaylistCover" referrerpolicy="no-referrer" />
            <span class="play-count"><i class="el-icon-headset"></i> {{ item.playCount || 0 }}</span>
          </div>
          <div class="card-info">
            <span class="card-title">{{ item.name }}</span>
            <span class="card-singer">{{ item.musicCount || 0 }} 首</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Home',
  data() {
    return {
      top100List: [],
      playlists: [],
      defaultCover: 'https://via.placeholder.com/200x200?text=Music',
      defaultPlaylistCover: 'https://via.placeholder.com/200x200?text=Playlist'
    }
  },
  created() {
    this.loadTop100()
    this.loadPlaylists()
  },
  methods: {
    async loadTop100() {
      try {
        const res = await this.$http.get('/api/music/top100')
        this.top100List = res.data || []
      } catch (e) { /* ignore */ }
    },
    async loadPlaylists() {
      try {
        const res = await this.$http.get('/api/playlist/public', { params: { pageNum: 1, pageSize: 5 } })
        this.playlists = res.data.records || []
      } catch (e) { /* ignore */ }
    },
    playMusic(music) {
      this.$store.dispatch('playMusic', music)
      // 记录播放
      if (this.$store.getters.isLoggedIn) {
        this.$http.post('/api/music/play/' + music.id).catch(() => {})
      }
    }
  }
}
</script>

<style scoped>
.banner {
  background: linear-gradient(135deg, rgba(49,194,124,0.25) 0%, rgba(76,217,100,0.2) 50%, rgba(40,167,69,0.18) 100%);
  backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(49,194,124,0.2);
  border-radius: 20px; padding: 48px 40px; color: #1e293b; margin-bottom: 40px;
  position: relative; overflow: hidden;
}
.banner::after {
  content: ''; position: absolute; width: 200px; height: 200px; border-radius: 50%;
  background: rgba(49,194,124,0.1); top: -40px; right: -20px;
}
.banner h2 { font-size: 32px; margin-bottom: 10px; font-family: 'Righteous', sans-serif; letter-spacing: 1px; }
.banner p { font-size: 16px; opacity: 0.8; font-weight: 300; }
.section { margin-bottom: 48px; }
.section-header {
  display: flex; align-items: center; justify-content: space-between;
  margin-bottom: 20px; padding-bottom: 12px;
  border-bottom: 2px solid var(--border);
}
.section-header h3 { font-size: 20px; color: var(--text-primary); font-weight: 700; }
.section-header h3 i { color: var(--primary); margin-right: 8px; }
.music-grid, .playlist-grid {
  display: grid; grid-template-columns: repeat(5, 1fr); gap: 20px;
}
.music-card, .playlist-card {
  background: #fff; border-radius: 12px; overflow: hidden; cursor: pointer;
  transition: var(--transition); border: 1px solid var(--border);
}
.music-card:hover, .playlist-card:hover {
  transform: translateY(-4px); box-shadow: 0 8px 24px rgba(0,0,0,0.1);
  border-color: var(--primary-light);
}
.card-cover { position: relative; padding-top: 100%; overflow: hidden; border-radius: 16px 16px 0 0; }
.card-cover img {
  position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover;
  transition: transform 0.4s ease;
}
.music-card:hover .card-cover img, .playlist-card:hover .card-cover img { transform: scale(1.08); }
.play-overlay {
  position: absolute; top: 0; left: 0; right: 0; bottom: 0;
  display: flex; align-items: center; justify-content: center;
  background: rgba(0,0,0,0.35); opacity: 0; transition: opacity 0.25s;
}
.card-cover:hover .play-overlay { opacity: 1; }
.play-overlay i { font-size: 44px; color: #fff; filter: drop-shadow(0 2px 8px rgba(0,0,0,0.3)); }
.play-count {
  position: absolute; top: 10px; right: 10px; background: rgba(0,0,0,0.55);
  backdrop-filter: blur(8px); color: #fff; font-size: 12px; padding: 3px 10px;
  border-radius: 20px; font-weight: 500;
}
.card-info { padding: 14px; }
.card-title {
  display: block; font-size: 14px; color: var(--text-primary); font-weight: 600;
  overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
}
.card-singer { display: block; font-size: 12px; color: var(--text-muted); margin-top: 4px; }
</style>
