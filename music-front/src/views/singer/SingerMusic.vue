<template>
  <div class="singer-music">
    <h2>我的音乐</h2>
    <el-table :data="musicList" stripe style="width: 100%; margin-top: 16px;">
      <el-table-column type="index" width="50"></el-table-column>
      <el-table-column label="封面" width="60">
        <template slot-scope="{ row }">
          <img :src="row.coverUrl || defaultCover" style="width:40px;height:40px;border-radius:4px;object-fit:cover;" />
        </template>
      </el-table-column>
      <el-table-column prop="title" label="歌曲名称" min-width="180"></el-table-column>
      <el-table-column prop="album" label="专辑" width="150"></el-table-column>
      <el-table-column label="状态" width="80">
        <template slot-scope="{ row }">
          <el-tag :type="row.status === 1 ? 'success' : row.status === 0 ? 'danger' : 'warning'" size="small">
            {{ row.status === 1 ? '正常' : row.status === 0 ? '下架' : '审核中' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="playCount" label="播放量" width="90"></el-table-column>
      <el-table-column label="操作" width="160">
        <template slot-scope="{ row }">
          <el-button type="text" @click="editMusic(row)">编辑</el-button>
          <el-button type="text" style="color:#f56c6c" @click="deleteMusic(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination background layout="prev, pager, next, total"
                   :total="total" :page-size="pageSize" :current-page.sync="pageNum"
                   @current-change="loadList" style="margin-top: 16px; text-align: center;"></el-pagination>

    <!-- 编辑对话框 -->
    <el-dialog title="编辑音乐" :visible.sync="showEdit" width="500px">
      <el-form :model="editForm" label-width="80px">
        <el-form-item label="歌曲名称"><el-input v-model="editForm.title"></el-input></el-form-item>
        <el-form-item label="专辑"><el-input v-model="editForm.album"></el-input></el-form-item>
        <el-form-item label="歌词"><el-input v-model="editForm.lyric" type="textarea" rows="5"></el-input></el-form-item>
      </el-form>
      <span slot="footer">
        <el-button @click="showEdit = false">取消</el-button>
        <el-button type="primary" @click="submitEdit">保存</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'SingerMusic',
  data() {
    return {
      musicList: [], pageNum: 1, pageSize: 15, total: 0, showEdit: false,
      editForm: { id: null, title: '', album: '', lyric: '' },
      defaultCover: 'https://via.placeholder.com/40x40?text=%E2%99%AA'
    }
  },
  created() { this.loadList() },
  methods: {
    async loadList() {
      try {
        const res = await this.$http.get('/api/music/singer/list', {
          params: { pageNum: this.pageNum, pageSize: this.pageSize }
        })
        this.musicList = res.data.records || []
        this.total = res.data.total || 0
      } catch (e) { /* ignore */ }
    },
    editMusic(row) {
      this.editForm = { id: row.id, title: row.title, album: row.album, lyric: row.lyric }
      this.showEdit = true
    },
    async submitEdit() {
      try {
        await this.$http.put('/api/music/update', this.editForm)
        this.$message.success('修改成功')
        this.showEdit = false
        this.loadList()
      } catch (e) { /* ignore */ }
    },
    async deleteMusic(row) {
      try {
        await this.$confirm('确认删除该音乐？', '提示', { type: 'warning' })
        await this.$http.delete('/api/music/delete/' + row.id)
        this.$message.success('删除成功')
        this.loadList()
      } catch (e) { /* ignore */ }
    }
  }
}
</script>

<style scoped>
.singer-music h2 { margin-bottom: 20px; color: var(--text-primary); font-size: 24px; font-weight: 700; }
</style>
