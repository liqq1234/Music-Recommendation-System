<template>
  <div class="register-page">
    <div class="register-card">
      <h2 class="register-title"><i class="el-icon-headset"></i> 注册账号</h2>
      <el-form :model="form" :rules="rules" ref="regForm" label-width="0">
        <el-form-item prop="username">
          <el-input v-model="form.username" prefix-icon="el-icon-user" placeholder="请输入用户名"></el-input>
        </el-form-item>
        <el-form-item prop="password">
          <el-input v-model="form.password" prefix-icon="el-icon-lock" placeholder="请输入密码" type="password" show-password></el-input>
        </el-form-item>
        <el-form-item prop="confirmPwd">
          <el-input v-model="form.confirmPwd" prefix-icon="el-icon-lock" placeholder="请确认密码" type="password" show-password></el-input>
        </el-form-item>
        <el-form-item prop="nickname">
          <el-input v-model="form.nickname" prefix-icon="el-icon-postcard" placeholder="昵称（选填）"></el-input>
        </el-form-item>
        <el-form-item prop="role">
          <el-radio-group v-model="form.role">
            <el-radio :label="0">普通用户</el-radio>
            <el-radio :label="1">歌手</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :loading="loading" style="width:100%" @click="handleRegister">注 册</el-button>
        </el-form-item>
      </el-form>
      <div class="register-footer">
        已有账号？<el-link type="primary" @click="$router.push('/login')">立即登录</el-link>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Register',
  data() {
    const validateConfirm = (rule, value, callback) => {
      if (value !== this.form.password) {
        callback(new Error('两次密码不一致'))
      } else {
        callback()
      }
    }
    return {
      loading: false,
      form: { username: '', password: '', confirmPwd: '', nickname: '', role: 0 },
      rules: {
        username: [{ required: true, message: '请输入用户名', trigger: 'blur' },
                    { min: 3, max: 20, message: '长度3-20个字符', trigger: 'blur' }],
        password: [{ required: true, message: '请输入密码', trigger: 'blur' },
                    { min: 6, message: '密码至少6个字符', trigger: 'blur' }],
        confirmPwd: [{ required: true, message: '请确认密码', trigger: 'blur' },
                      { validator: validateConfirm, trigger: 'blur' }]
      }
    }
  },
  methods: {
    handleRegister() {
      this.$refs.regForm.validate(async valid => {
        if (!valid) return
        this.loading = true
        try {
          await this.$http.post('/api/user/register', {
            username: this.form.username,
            password: this.form.password,
            nickname: this.form.nickname || undefined,
            role: this.form.role
          })
          this.$message.success('注册成功，请登录')
          this.$router.push('/login')
        } catch (e) {
          // handled by interceptor
        } finally {
          this.loading = false
        }
      })
    }
  }
}
</script>

<style scoped>
.register-page {
  min-height: 100vh; display: flex; align-items: center; justify-content: center;
  background: #F5F5F5;
}
.register-card {
  width: 440px; padding: 48px 40px; background: rgba(255,255,255,0.95);
  backdrop-filter: blur(20px); border-radius: 20px;
  box-shadow: 0 25px 60px rgba(0,0,0,0.2); position: relative; z-index: 1;
  animation: slideUp 0.5s ease-out;
}
@keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
.register-title {
  text-align: center; margin-bottom: 36px; color: var(--text-primary); font-size: 26px;
  font-weight: 700; letter-spacing: -0.5px;
}
.register-title i { color: var(--primary); margin-right: 8px; }
.register-footer { text-align: center; color: var(--text-secondary); font-size: 14px; margin-top: 8px; }
</style>
