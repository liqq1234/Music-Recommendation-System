<template>
  <div class="music-detail" v-if="music">
    <el-card>
      <div class="detail-header">
        <img :src="music.coverUrl || defaultCover" class="detail-cover" referrerpolicy="no-referrer" />
        <div class="detail-info">
          <h2>{{ music.title }}</h2>
          <p class="info-row"><span>歌手：</span>{{ music.singerName }}</p>
          <p class="info-row" v-if="music.album"><span>专辑：</span>{{ music.album }}</p>
          <p class="info-row" v-if="music.category"><span>分类：</span>{{ music.category }}</p>
          <p class="info-row"><span>播放量：</span>{{ music.playCount }}</p>
          <p class="info-row"><span>平均评分：</span>
            <el-rate :value="avgScore" disabled show-score text-color="#ff9900"></el-rate>
          </p>
          <div class="detail-actions">
            <el-button type="primary" icon="el-icon-video-play" @click="playMusic">播放</el-button>
            <el-button :type="isFavorite ? 'danger' : 'default'" :icon="isFavorite ? 'el-icon-star-on' : 'el-icon-star-off'"
                       @click="toggleFavorite" v-if="isLoggedIn">{{ isFavorite ? '取消收藏' : '收藏' }}</el-button>
            <el-dropdown trigger="click" @command="addToPlaylist" v-if="isLoggedIn">
              <el-button icon="el-icon-plus">加入歌单</el-button>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item v-for="pl in myPlaylists" :key="pl.id" :command="pl.id">{{ pl.name }}</el-dropdown-item>
                <el-dropdown-item v-if="myPlaylists.length === 0" disabled>暂无歌单</el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
          </div>
          <!-- 评分 -->
          <div class="rating-section" v-if="isLoggedIn">
            <span>我的评分：</span>
            <el-rate v-model="userScore" @change="submitRating"></el-rate>
          </div>
        </div>
      </div>
    </el-card>

    <!-- 歌词 -->
    <el-card style="margin-top: 16px;" v-if="music.lyric">
      <h3 style="margin-bottom: 12px;">歌词</h3>
      <pre class="lyric-text">{{ music.lyric }}</pre>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'MusicDetail',
  data() {
    return {
      music: null, avgScore: 0, userScore: 0, isFavorite: false, myPlaylists: [],
      defaultCover: 'https://via.placeholder.com/300x300?text=Music'
    }
  },
  computed: {
    isLoggedIn() { return this.$store.getters.isLoggedIn }
  },
  created() { this.loadDetail() },
  watch: { '$route.params.id'() { this.loadDetail() } },
  methods: {
    async loadDetail() {
      const id = this.$route.params.id
      try {
        const res = await this.$http.get('/api/music/detail/' + id)
        this.music = res.data.music
        this.avgScore = res.data.avgScore || 0
      } catch (e) { return }
      if (this.isLoggedIn) {
        this.loadUserData(id)
      }
    },
    async loadUserData(musicId) {
      try {
        const [statusRes, plRes] = await Promise.all([
          this.$http.get('/api/interaction/status/' + musicId),
          this.$http.get('/api/playlist/my', { params: { pageNum: 1, pageSize: 100 } })
        ])
        if (statusRes.data) {
          this.isFavorite = statusRes.data.isFavorite === 1
          this.userScore = statusRes.data.rating || 0
        }
        this.myPlaylists = plRes.data.records || []
      } catch (e) { /* ignore */ }
    },
    playMusic() {
      this.$store.dispatch('playMusic', this.music)
      if (this.isLoggedIn) {
        this.$http.post('/api/music/play/' + this.music.id).catch(() => {})
      }
    },
    async toggleFavorite() {
      try {
        const res = await this.$http.post('/api/interaction/favorite/' + this.music.id)
        this.isFavorite = res.data === true
        this.$message.success(this.isFavorite ? '收藏成功' : '已取消收藏')
      } catch (e) { /* ignore */ }
    },
    async submitRating(val) {
      try {
        await this.$http.post(`/api/interaction/rate/${this.music.id}/${val}`)
        this.$message.success('评分成功')
        // 刷新平均分
        const res = await this.$http.get('/api/music/detail/' + this.music.id)
        this.avgScore = res.data.avgScore || 0
      } catch (e) { /* ignore */ }
    },
    async addToPlaylist(playlistId) {
      try {
        await this.$http.post('/api/playlist/addMusic', { playlistId, musicId: this.music.id })
        this.$message.success('已添加到歌单')
      } catch (e) { /* ignore */ }
    }
  }
}
</script>

<style scoped>
.detail-header { display: flex; gap: 32px; }
.detail-cover {
  width: 280px; height: 280px; border-radius: 20px; object-fit: cover; flex-shrink: 0;
  box-shadow: 0 12px 40px rgba(0,0,0,0.12); transition: var(--transition);
}
.detail-cover:hover { transform: scale(1.03); }
.detail-info { flex: 1; padding-top: 8px; }
.detail-info h2 { font-size: 28px; margin-bottom: 16px; color: var(--text-primary); font-weight: 700; }
.info-row { color: var(--text-secondary); margin-bottom: 10px; font-size: 15px; }
.info-row span { color: var(--text-muted); min-width: 60px; display: inline-block; }
.detail-actions { display: flex; gap: 10px; margin: 20px 0; flex-wrap: wrap; }
.rating-section {
  display: flex; align-items: center; gap: 10px; margin-top: 12px;
  color: var(--text-secondary); font-weight: 500;
  padding: 12px 16px; background: #f8fafc; border-radius: var(--radius-sm);
}
.lyric-text {
  white-space: pre-wrap; color: var(--text-secondary); line-height: 2.2;
  font-size: 15px; padding: 8px 0;
}
</style>
