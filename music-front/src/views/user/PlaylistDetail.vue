<template>
  <div class="playlist-detail" v-if="playlist">
    <el-card>
      <div class="detail-header">
        <img :src="playlist.coverUrl || defaultCover" class="detail-cover" />
        <div class="detail-info">
          <h2>{{ playlist.name }}</h2>
          <p class="info-row">创建者：{{ playlist.creatorName }}</p>
          <p class="info-row" v-if="playlist.description">{{ playlist.description }}</p>
          <p class="info-row">共 {{ playlist.musicCount || 0 }} 首 · 播放 {{ playlist.playCount || 0 }} 次</p>
        </div>
      </div>
    </el-card>
    <el-card style="margin-top: 16px;">
      <h3 style="margin-bottom: 12px;">歌曲列表</h3>
      <el-table :data="playlist.musicList || []" stripe>
        <el-table-column type="index" width="50"></el-table-column>
        <el-table-column prop="title" label="歌曲" min-width="200">
          <template slot-scope="{ row }">
            <el-link @click="$router.push('/music/' + row.id)">{{ row.title }}</el-link>
          </template>
        </el-table-column>
        <el-table-column prop="singerName" label="歌手" width="150"></el-table-column>
        <el-table-column prop="album" label="专辑" width="150"></el-table-column>
        <el-table-column label="操作" width="100">
          <template slot-scope="{ row }">
            <el-button type="text" icon="el-icon-video-play" @click="playMusic(row)">播放</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'PlaylistDetail',
  data() {
    return {
      playlist: null,
      defaultCover: 'https://via.placeholder.com/200x200?text=Playlist'
    }
  },
  created() { this.loadDetail() },
  methods: {
    async loadDetail() {
      try {
        const res = await this.$http.get('/api/playlist/detail/' + this.$route.params.id)
        this.playlist = res.data
      } catch (e) { /* ignore */ }
    },
    playMusic(music) {
      this.$store.dispatch('playMusic', music)
      if (this.$store.getters.isLoggedIn) {
        this.$http.post('/api/music/play/' + music.id).catch(() => {})
      }
    }
  }
}
</script>

<style scoped>
.detail-header { display: flex; gap: 32px; }
.detail-cover {
  width: 220px; height: 220px; border-radius: 20px; object-fit: cover; flex-shrink: 0;
  box-shadow: 0 12px 40px rgba(0,0,0,0.12); transition: var(--transition);
}
.detail-cover:hover { transform: scale(1.03); }
.detail-info { flex: 1; padding-top: 8px; }
.detail-info h2 { font-size: 26px; margin-bottom: 16px; color: var(--text-primary); font-weight: 700; }
.info-row { color: var(--text-secondary); margin-bottom: 8px; font-size: 15px; }
</style>
