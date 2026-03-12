import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    user: JSON.parse(localStorage.getItem('user') || 'null'),
    token: localStorage.getItem('token') || '',
    currentMusic: null,
    isPlaying: false,
    playlist: []
  },
  getters: {
    isLoggedIn: state => !!state.token,
    userRole: state => state.user ? state.user.role : -1,
    isAdmin: state => state.user && state.user.role === 2,
    isSinger: state => state.user && state.user.role === 1,
    isUser: state => state.user && state.user.role === 0
  },
  mutations: {
    SET_USER(state, user) {
      state.user = user
      localStorage.setItem('user', JSON.stringify(user))
    },
    SET_TOKEN(state, token) {
      state.token = token
      localStorage.setItem('token', token)
    },
    LOGOUT(state) {
      state.user = null
      state.token = ''
      state.currentMusic = null
      state.isPlaying = false
      localStorage.removeItem('user')
      localStorage.removeItem('token')
    },
    SET_CURRENT_MUSIC(state, music) {
      state.currentMusic = music
    },
    SET_PLAYING(state, status) {
      state.isPlaying = status
    },
    SET_PLAYLIST(state, list) {
      state.playlist = list
    }
  },
  actions: {
    login({ commit }, data) {
      commit('SET_TOKEN', data.token)
      commit('SET_USER', data.user)
    },
    logout({ commit }) {
      commit('LOGOUT')
    },
    playMusic({ commit }, music) {
      commit('SET_CURRENT_MUSIC', music)
      commit('SET_PLAYING', true)
    }
  }
})
