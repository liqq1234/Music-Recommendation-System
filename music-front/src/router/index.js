import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue')
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('../views/Register.vue')
  },
  {
    path: '/',
    component: () => import('../layout/UserLayout.vue'),
    redirect: '/home',
    children: [
      { path: 'home', name: 'Home', component: () => import('../views/user/Home.vue') },
      { path: 'music', name: 'MusicList', component: () => import('../views/user/MusicList.vue') },
      { path: 'music/:id', name: 'MusicDetail', component: () => import('../views/user/MusicDetail.vue') },
      { path: 'playlist', name: 'PlaylistList', component: () => import('../views/user/PlaylistList.vue') },
      { path: 'playlist/:id', name: 'PlaylistDetail', component: () => import('../views/user/PlaylistDetail.vue') },
      { path: 'my/collection', name: 'MyCollection', component: () => import('../views/user/MyCollection.vue'), meta: { requireAuth: true } },
      { path: 'my/playlist', name: 'MyPlaylist', component: () => import('../views/user/MyPlaylist.vue'), meta: { requireAuth: true } },
      { path: 'my/history', name: 'MyHistory', component: () => import('../views/user/MyHistory.vue'), meta: { requireAuth: true } },
      { path: 'recommend', name: 'Recommend', component: () => import('../views/user/Recommend.vue'), meta: { requireAuth: true } },
      { path: 'profile', name: 'Profile', component: () => import('../views/user/Profile.vue'), meta: { requireAuth: true } }
    ]
  },
  {
    path: '/singer',
    component: () => import('../layout/SingerLayout.vue'),
    meta: { requireAuth: true, role: 1 },
    children: [
      { path: '', redirect: 'music' },
      { path: 'music', name: 'SingerMusic', component: () => import('../views/singer/SingerMusic.vue') },
      { path: 'upload', name: 'UploadMusic', component: () => import('../views/singer/UploadMusic.vue') },
      { path: 'profile', name: 'SingerProfile', component: () => import('../views/user/Profile.vue') }
    ]
  },
  {
    path: '/admin',
    component: () => import('../layout/AdminLayout.vue'),
    meta: { requireAuth: true, role: 2 },
    children: [
      { path: '', redirect: 'dashboard' },
      { path: 'dashboard', name: 'Dashboard', component: () => import('../views/admin/Dashboard.vue') },
      { path: 'users', name: 'UserManage', component: () => import('../views/admin/UserManage.vue') },
      { path: 'music', name: 'MusicManage', component: () => import('../views/admin/MusicManage.vue') },
      { path: 'category', name: 'CategoryManage', component: () => import('../views/admin/CategoryManage.vue') }
    ]
  }
]

const router = new VueRouter({
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token')
  const user = JSON.parse(localStorage.getItem('user') || 'null')

  if (to.meta.requireAuth && !token) {
    next('/login')
    return
  }

  if (to.meta.role !== undefined && user && user.role !== to.meta.role) {
    next('/')
    return
  }

  next()
})

export default router
