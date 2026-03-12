<template>
  <div class="music-manage">
    <h2>音乐管理</h2>
    <div class="filter-bar" style="margin: 16px 0;">
      <el-input v-model="keyword" placeholder="搜索歌曲/歌手" prefix-icon="el-icon-search"
                clearable style="width:220px;" @keyup.enter.native="loadList" @clear="loadList"></el-input>
      <el-select v-model="statusFilter" placeholder="全部状态" clearable @change="loadList" style="width:130px;margin-left:12px;">
        <el-option label="正常" :value="1"></el-option>
        <el-option label="下架" :value="0"></el-option>
        <el-option label="审核中" :value="2"></el-option>
      </el-select>
    </div>
    <el-table :data="musicList" stripe>
      <el-table-column prop="id" label="ID" width="70"></el-table-column>
      <el-table-column label="封面" width="60">
        <template slot-scope="{ row }">
          <img :src="row.coverUrl || defaultCover" style="width:40px;height:40px;border-radius:4px;object-fit:cover;" />
        </template>
      </el-table-column>
      <el-table-column prop="title" label="歌曲名称" min-width="180"></el-table-column>
      <el-table-column prop="singerName" label="歌手" width="120"></el-table-column>
      <el-table-column prop="album" label="专辑" width="120"></el-table-column>
      <el-table-column label="状态" width="80">
        <template slot-scope="{ row }">
          <el-tag :type="row.status === 1 ? 'success' : row.status === 0 ? 'danger' : 'warning'" size="small">
            {{ row.status === 1 ? '正常' : row.status === 0 ? '下架' : '审核中' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="playCount" label="播放量" width="90"></el-table-column>
      <el-table-column prop="createTime" label="上传时间" width="170"></el-table-column>
      <el-table-column label="操作" width="200" fixed="right">
        <template slot-scope="{ row }">
          <el-button type="text" v-if="row.status !== 1" style="color:#67c23a" @click="changeStatus(row, 1)">上架</el-button>
          <el-button type="text" v-if="row.status === 1" style="color:#e6a23c" @click="changeStatus(row, 0)">下架</el-button>
          <el-button type="text" style="color:#f56c6c" @click="deleteMusic(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination background layout="prev, pager, next, total"
                   :total="total" :page-size="pageSize" :current-page.sync="pageNum"
                   @current-change="loadList" style="margin-top:16px;text-align:center;"></el-pagination>
  </div>
</template>

<script>
export default {
  name: 'MusicManage',
  data() {
    return {
      musicList: [], pageNum: 1, pageSize: 15, total: 0, keyword: '', statusFilter: null,
      defaultCover: 'https://via.placeholder.com/40x40?text=%E2%99%AA'
    }
  },
  created() { this.loadList() },
  methods: {
    async loadList() {
      try {
        const res = await this.$http.get('/api/music/all', {
          params: { pageNum: this.pageNum, pageSize: this.pageSize, keyword: this.keyword || undefined, status: this.statusFilter }
        })
        this.musicList = res.data.records || []
        this.total = res.data.total || 0
      } catch (e) { /* ignore */ }
    },
    async changeStatus(row, status) {
      const action = status === 1 ? '上架' : '下架'
      try {
        await this.$confirm(`确认${action}歌曲 "${row.title}" ？`, '提示', { type: 'warning' })
        await this.$http.put('/api/music/status/' + row.id, null, { params: { status } })
        this.$message.success(`${action}成功`)
        this.loadList()
      } catch (e) { /* ignore */ }
    },
    async deleteMusic(row) {
      try {
        await this.$confirm(`确认删除歌曲 "${row.title}" ？此操作不可恢复。`, '警告', { type: 'error' })
        await this.$http.delete('/api/music/delete/' + row.id)
        this.$message.success('删除成功')
        this.loadList()
      } catch (e) { /* ignore */ }
    }
  }
}
</script>

<style scoped>
.music-manage h2 { color: var(--text-primary); font-size: 24px; font-weight: 700; }
.filter-bar {
  display: flex; align-items: center; gap: 12px;
  padding: 16px 20px; background: var(--bg-card); border-radius: var(--radius);
  border: 1px solid var(--border); box-shadow: var(--shadow-sm);
}
</style>
