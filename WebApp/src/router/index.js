import Vue from 'vue'
import VueRouter from 'vue-router'
import store from '../store/index.js'
import Home from '../views/Home.vue'
import Login from '../views/Login.vue'
import Register from '../views/Register.vue'
import EditProfile from '../views/EditProfile.vue'
import CreateEvent from '../views/CreateEvent.vue'
import EditEvent from '../views/EditEvent.vue'
import SharedEvents from '../views/SharedEvents.vue'
import SharedEvent from '../views/SharedEvent.vue'
import PublicEvent from '../views/PublicEvent.vue'

Vue.use(VueRouter)

function isLogged() {
  if(!store.state.token) {
    return false;
  } else {
    return true;
  }
}

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  {
    path: '/register',
    name: 'Register',
    component: Register
  },
  {
    path: '/edit/profile',
    name: 'EditProfile',
    component: EditProfile
  },
  {
    path: '/create/event',
    name: 'CreateEvent',
    component: CreateEvent
  },
  {
    path: '/edit/event/:id',
    name: 'EditEvent',
    component: EditEvent
  },
  {
    path: '/shareds',
    name: 'SharedEvents',
    component: SharedEvents
  },
  {
    path: '/shared/:id',
    name: 'SharedEvent',
    component: SharedEvent
  },
  {
    path: '/event/:token',
    name: 'PublicEvent',
    component: PublicEvent
  },
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

router.beforeEach((to, from, next) => {
  if((to.name !== 'Login' && to.name !== 'Register' && to.name !== 'PublicEvent') && !isLogged()) {
    next({name: 'Login'})
  } else if((to.name == 'Login' || to.name == 'Register') && isLogged()) {
    next({name: 'Home'})
  } else {
    next()
  }
})

export default router