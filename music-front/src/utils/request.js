import axios from 'axios'
import { Message } from 'element-ui'
import router from '../router'

const service = axios.create({
  baseURL: '',
  timeout: 30000
})

// 请求拦截器
service.interceptors.request.use(
  config => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers['Authorization'] = 'Bearer ' + token
    }
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// 响应拦截器
service.interceptors.response.use(
  response => {
    const res = response.data
    if (res.code === 401) {
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      Message.error(res.message || '登录已过期')
      router.push('/login')
      return Promise.reject(new Error(res.message))
    }
    if (res.code !== 200) {
      Message.error(res.message || '操作失败')
      return Promise.reject(new Error(res.message))
    }
    return res
  },
  error => {
    Message.error('网络错误，请稍后重试')
    return Promise.reject(error)
  }
)

export default service
