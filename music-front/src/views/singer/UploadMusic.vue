<template>
  <div class="upload-music">
    <h2>上传音乐</h2>
    <el-card style="max-width: 700px; margin-top: 16px;">
      <el-form :model="form" :rules="rules" ref="uploadForm" label-width="100px">
        <el-form-item label="歌曲名称" prop="title">
          <el-input v-model="form.title" placeholder="请输入歌曲名称"></el-input>
        </el-form-item>
        <el-form-item label="歌手名称" prop="singerName">
          <el-input v-model="form.singerName" placeholder="歌手名称"></el-input>
        </el-form-item>
        <el-form-item label="所属专辑">
          <el-input v-model="form.album" placeholder="专辑名称（选填）"></el-input>
        </el-form-item>
        <el-form-item label="音乐分类">
          <el-select v-model="form.categoryId" placeholder="请选择分类" clearable style="width: 100%;">
            <el-option v-for="c in categories" :key="c.id" :label="c.name" :value="c.id"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="时长（秒）">
          <el-input-number v-model="form.duration" :min="0" :max="9999"></el-input-number>
        </el-form-item>
        <el-form-item label="音频文件" prop="fileUrl">
          <el-upload action="/api/file/upload" :data="{ type: 'music' }"
                     :headers="uploadHeaders" :show-file-list="true"
                     :on-success="handleMusicSuccess" :limit="1" accept="audio/*">
            <el-button size="small" type="primary" icon="el-icon-upload">选择音频文件</el-button>
            <div slot="tip" class="el-upload__tip">支持mp3、wav、flac等格式，最大50MB</div>
          </el-upload>
          <span v-if="form.fileUrl" style="color:#67c23a;font-size:12px;">已上传</span>
        </el-form-item>
        <el-form-item label="封面图片">
          <el-upload action="/api/file/upload" :data="{ type: 'cover' }"
                     :headers="uploadHeaders" :show-file-list="false"
                     :on-success="handleCoverSuccess" accept="image/*">
            <img v-if="form.coverUrl" :src="form.coverUrl" style="width:120px;height:120px;border-radius:8px;object-fit:cover;" />
            <el-button v-else size="small" type="success" icon="el-icon-picture">选择封面</el-button>
          </el-upload>
        </el-form-item>
        <el-form-item label="歌词">
          <el-input v-model="form.lyric" type="textarea" rows="6" placeholder="请输入歌词（选填）"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :loading="loading" @click="submitUpload">上传音乐</el-button>
          <el-button @click="resetForm">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'UploadMusic',
  data() {
    return {
      loading: false,
      categories: [],
      form: {
        title: '', singerName: '', album: '', categoryId: null,
        duration: 0, fileUrl: '', coverUrl: '', lyric: ''
      },
      rules: {
        title: [{ required: true, message: '请输入歌曲名称', trigger: 'blur' }],
        singerName: [{ required: true, message: '请输入歌手名称', trigger: 'blur' }],
        fileUrl: [{ required: true, message: '请上传音频文件', trigger: 'change' }]
      }
    }
  },
  computed: {
    uploadHeaders() {
      return { Authorization: 'Bearer ' + localStorage.getItem('token') }
    }
  },
  created() { this.loadCategories() },
  methods: {
    async loadCategories() {
      try {
        const res = await this.$http.get('/api/category/list')
        this.categories = res.data || []
      } catch (e) { /* ignore */ }
    },
    handleMusicSuccess(res) {
      if (res.code === 200) {
        this.form.fileUrl = res.data.url
        this.$message.success('音频上传成功')
      }
    },
    handleCoverSuccess(res) {
      if (res.code === 200) {
        this.form.coverUrl = res.data.url
      }
    },
    submitUpload() {
      this.$refs.uploadForm.validate(async valid => {
        if (!valid) return
        this.loading = true
        try {
          await this.$http.post('/api/music/upload', this.form)
          this.$message.success('上传成功')
          this.resetForm()
        } catch (e) { /* ignore */ }
        this.loading = false
      })
    },
    resetForm() {
      this.form = {
        title: '', singerName: '', album: '', categoryId: null,
        duration: 0, fileUrl: '', coverUrl: '', lyric: ''
      }
    }
  }
}
</script>

<style scoped>
.upload-music h2 { margin-bottom: 20px; color: var(--text-primary); font-size: 24px; font-weight: 700; }
</style>
