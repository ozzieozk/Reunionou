import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import axios from 'axios'
import 'bootstrap/dist/css/bootstrap.min.css'
import { library } from '@fortawesome/fontawesome-svg-core'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import VueClipboard from 'vue-clipboard2';

Vue.use(VueClipboard)

library.add(fas);
Vue.component('font-awesome-icon', FontAwesomeIcon)

window.api = axios.create({
  baseURL: 'http://api.local:19080/'
});

Vue.config.productionTip = false

new Vue({
  beforeCreate() {
    api.interceptors.request.use(config => {
        if(this.$store.state.token) {
            config.url+='?token='+this.$store.state.token
        }
        return config;
    })
  },
  router,
  store,
  render: h => h(App)
}).$mount('#app')
