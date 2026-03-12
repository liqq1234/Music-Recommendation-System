<template>
  <div class="music-list">
    <h2>音乐库</h2>
    <!-- 筛选 -->
    <div class="filter-bar">
      <el-input v-model="keyword" placeholder="搜索音乐/歌手" prefix-icon="el-icon-search"
                clearable style="width: 250px;" @keyup.enter.native="loadList" @clear="loadList"></el-input>
      <el-select v-model="category" placeholder="全部分类" clearable @change="loadList" style="width: 150px; margin-left: 12px;">
        <el-option v-for="c in categories" :key="c" :label="c" :value="c"></el-option>
      </el-select>
    </div>
    <!-- 列表 -->
    <el-table :data="musicList" stripe style="width: 100%; margin-top: 16px;">
      <el-table-column width="60">
        <template slot-scope="{ row }">
          <img :src="row.coverUrl || defaultCover" style="width:40px;height:40px;border-radius:4px;object-fit:cover;" referrerpolicy="no-referrer" />
        </template>
      </el-table-column>
      <el-table-column prop="title" label="歌曲名称" min-width="200">
        <template slot-scope="{ row }">
          <el-link @click="$router.push('/music/' + row.id)">{{ row.title }}</el-link>
        </template>
      </el-table-column>
      <el-table-column prop="singerName" label="歌手" width="150"></el-table-column>
      <el-table-column prop="category" label="分类" width="100"></el-table-column>
      <el-table-column prop="album" label="专辑" width="150"></el-table-column>
      <el-table-column label="时长" width="80">
        <template slot-scope="{ row }">{{ formatDuration(row.duration) }}</template>
      </el-table-column>
      <el-table-column label="播放量" width="100" prop="playCount"></el-table-column>
      <el-table-column label="操作" width="120" fixed="right">
        <template slot-scope="{ row }">
          <el-button type="text" icon="el-icon-video-play" @click="playMusic(row)">播放</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination background layout="prev, pager, next, total"
                   :total="total" :page-size="pageSize" :current-page.sync="pageNum"
                   @current-change="loadList" style="margin-top: 16px; text-align: center;"></el-pagination>
  </div>
</template>

<script>
export default {
  name: 'MusicList',
  data() {
    return {
      musicList: [],
      categories: ['流行', '摇滚', '民谣', '电子', '古典', 'R&B', '嘻哈', '爵士', '古风', '其他'],
      keyword: '',
      category: null,
      pageNum: 1,
      pageSize: 15,
      total: 0,
      defaultCover: 'https://via.placeholder.com/40x40?text=%E2%99%AA'
    }
  },
  created() {
    if (this.$route.query.keyword) {
      this.keyword = this.$route.query.keyword
    }
    this.loadList()
  },
  watch: {
    '$route.query.keyword'(val) {
      this.keyword = val || ''
      this.pageNum = 1
      this.loadList()
    }
  },
  methods: {
    async loadList() {
      try {
        const params = { pageNum: this.pageNum, pageSize: this.pageSize }
        if (this.keyword) params.keyword = this.keyword
        if (this.category) params.category = this.category
        const res = await this.$http.get('/api/music/list', { params })
        this.musicList = res.data.records || []
        this.total = res.data.total || 0
      } catch (e) { /* ignore */ }
    },
    playMusic(music) {
      this.$store.dispatch('playMusic', music)
      if (this.$store.getters.isLoggedIn) {
        this.$http.post('/api/music/play/' + music.id).catch(() => {})
      }
    },
    formatDuration(s) {
      if (!s) return '--'
      const m = Math.floor(s / 60)
      const sec = s % 60
      return `${m}:${sec.toString().padStart(2, '0')}`
    }
  }
}
</script>

<style scoped>
.music-list h2 { margin-bottom: 20px; color: var(--text-primary); font-size: 24px; font-weight: 700; }
.filter-bar {
  display: flex; align-items: center; gap: 12px;
  padding: 16px 20px; background: var(--bg-card); border-radius: var(--radius);
  border: 1px solid var(--border); box-shadow: var(--shadow-sm);
}
</style>
