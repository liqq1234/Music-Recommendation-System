<template>
  <div class="category-manage">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
      <h2>分类管理</h2>
      <el-button type="primary" icon="el-icon-plus" size="small" @click="showAdd = true">添加分类</el-button>
    </div>
    <el-table :data="categories" stripe>
      <el-table-column prop="id" label="ID" width="80"></el-table-column>
      <el-table-column prop="name" label="分类名称" min-width="200"></el-table-column>
      <el-table-column prop="sort" label="排序" width="100"></el-table-column>
      <el-table-column label="操作" width="160">
        <template slot-scope="{ row }">
          <el-button type="text" @click="editCategory(row)">编辑</el-button>
          <el-button type="text" style="color:#f56c6c" @click="deleteCategory(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog :title="editForm.id ? '编辑分类' : '添加分类'" :visible.sync="showAdd" width="400px">
      <el-form :model="editForm" label-width="80px">
        <el-form-item label="分类名称">
          <el-input v-model="editForm.name" placeholder="请输入分类名称"></el-input>
        </el-form-item>
        <el-form-item label="排序">
          <el-input-number v-model="editForm.sort" :min="0" :max="999"></el-input-number>
        </el-form-item>
      </el-form>
      <span slot="footer">
        <el-button @click="showAdd = false">取消</el-button>
        <el-button type="primary" @click="submitCategory">确定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'CategoryManage',
  data() {
    return {
      categories: [], showAdd: false,
      editForm: { id: null, name: '', sort: 0 }
    }
  },
  created() { this.loadList() },
  methods: {
    async loadList() {
      try {
        const res = await this.$http.get('/api/category/list')
        this.categories = res.data || []
      } catch (e) { /* ignore */ }
    },
    editCategory(row) {
      this.editForm = { id: row.id, name: row.name, sort: row.sort }
      this.showAdd = true
    },
    async submitCategory() {
      if (!this.editForm.name) {
        this.$message.warning('请输入分类名称')
        return
      }
      try {
        if (this.editForm.id) {
          await this.$http.put('/api/category/update', this.editForm)
        } else {
          await this.$http.post('/api/category/add', this.editForm)
        }
        this.$message.success('操作成功')
        this.showAdd = false
        this.editForm = { id: null, name: '', sort: 0 }
        this.loadList()
      } catch (e) { /* ignore */ }
    },
    async deleteCategory(row) {
      try {
        await this.$confirm(`确认删除分类 "${row.name}" ？`, '提示', { type: 'warning' })
        await this.$http.delete('/api/category/delete/' + row.id)
        this.$message.success('删除成功')
        this.loadList()
      } catch (e) { /* ignore */ }
    }
  }
}
</script>

<style scoped>
.category-manage h2 { color: var(--text-primary); font-size: 24px; font-weight: 700; }
</style>
