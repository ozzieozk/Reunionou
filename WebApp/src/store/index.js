import Vue from 'vue'
import Vuex from 'vuex'
import VuexPersistence from 'vuex-persist'

const vuexLocal = new VuexPersistence({
  storage: window.localStorage
})

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    fullname: false,
    email: false,
    token: false
  },
  mutations: {
    setFullname(state, fullname) {
      state.fullname = fullname
    },
    setEmail(state, email) {
      state.email = email
    },
    setToken(state, token) {
      state.token = token
    },
    logout(state) {
      state.fullname = false,
      state.email = false,
      state.token = false
    },
  },
  actions: {
  },
  modules: {
  },
  plugins: [vuexLocal.plugin]
})
