<template>
  <div class="playlist-list">
    <h2>歌单广场</h2>
    <div class="playlist-grid">
      <div class="playlist-card" v-for="item in playlists" :key="item.id"
           @click="$router.push('/playlist/' + item.id)">
        <div class="card-cover">
          <img :src="item.coverUrl || defaultCover" />
          <span class="play-count"><i class="el-icon-headset"></i> {{ item.playCount || 0 }}</span>
        </div>
        <div class="card-info">
          <span class="card-title">{{ item.name }}</span>
          <span class="card-desc">{{ item.musicCount || 0 }} 首</span>
        </div>
      </div>
    </div>
    <el-pagination background layout="prev, pager, next, total"
                   :total="total" :page-size="pageSize" :current-page.sync="pageNum"
                   @current-change="loadList" style="margin-top: 24px; text-align: center;"></el-pagination>
  </div>
</template>

<script>
export default {
  name: 'PlaylistList',
  data() {
    return {
      playlists: [], pageNum: 1, pageSize: 12, total: 0,
      defaultCover: 'https://via.placeholder.com/200x200?text=Playlist'
    }
  },
  created() { this.loadList() },
  methods: {
    async loadList() {
      try {
        const res = await this.$http.get('/api/playlist/public', {
          params: { pageNum: this.pageNum, pageSize: this.pageSize }
        })
        this.playlists = res.data.records || []
        this.total = res.data.total || 0
      } catch (e) { /* ignore */ }
    }
  }
}
</script>

<style scoped>
.playlist-list h2 { margin-bottom: 24px; color: var(--text-primary); font-size: 24px; font-weight: 700; }
.playlist-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 24px; }
.playlist-card {
  background: #fff; border-radius: 12px; overflow: hidden; cursor: pointer;
  transition: var(--transition); border: 1px solid var(--border);
}
.playlist-card:hover {
  transform: translateY(-4px); box-shadow: 0 8px 24px rgba(0,0,0,0.1);
  border-color: var(--primary-light);
}
.card-cover { position: relative; padding-top: 100%; overflow: hidden; }
.card-cover img {
  position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover;
  transition: transform 0.4s ease;
}
.playlist-card:hover .card-cover img { transform: scale(1.08); }
.play-count {
  position: absolute; top: 10px; right: 10px; background: rgba(0,0,0,0.55);
  backdrop-filter: blur(8px); color: #fff; font-size: 12px; padding: 3px 10px;
  border-radius: 20px; font-weight: 500;
}
.card-info { padding: 14px; }
.card-title { display: block; font-size: 14px; color: var(--text-primary); font-weight: 600; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.card-desc { display: block; font-size: 12px; color: var(--text-muted); margin-top: 4px; }
</style>
