<template>
  <div>
    <Navbar />
    <div class="container mt-5">

      <h1 class="text-center">Mes évènements partagés</h1>
      <div class="text-center mb-3">
        <router-link to="/">
            <a href="#">Mes évènements</a>
        </router-link>
        -
        <router-link to="/shareds">
            <a href="#">Mes évènements partagés</a>
        </router-link>
      </div>

      <div v-if="events.length > 0" class="row mb-5">
        <div class="col-12 col-sm-7">
          <div class="card mb-3">
            <l-map v-if="showMap" :zoom="zoom" :center="center" :options="mapOptions" style="height: 350px; width: 100%;"
              @update:center="centerUpdate" @update:zoom="zoomUpdate">
              <l-tile-layer :url="url" :attribution="attribution" />
              <l-marker :lat-lng="withTooltip">
                <l-tooltip :options="{ permanent: true, interactive: true }">
                  {{ location.name }}
                </l-tooltip>
              </l-marker>
            </l-map>
            <div class="card-body">
              <h5 class="card-title">{{ title }}</h5>
              <p class="card-text">{{ description }}</p>
              <p class="card-text button-display"><small class="text-muted"><font-awesome-icon icon="calendar-alt"></font-awesome-icon> Prévu le {{ date }} par {{ author }}</small></p>
            </div>
          </div>

          <div class="row mb-3">
              <div class="col-10">
                <input v-model="input_comment" type="text" class="form-control" placeholder="Entrez votre commentaire...">
              </div>
              <div class="col-2">
                <button @click="postComment(id)" type="button" class="btn btn-primary">Envoyer</button>
              </div>
          </div>
          
          <div class="btn-group mb-3 w-100" role="group">
            <button @click="postAvailable(id)" type="button" class="btn btn-primary">Je serais présent</button>
            <button @click="postAbsent(id)" type="button" class="btn btn-danger">Je serais absent</button>
          </div>

          <div class="card">
              <div class="card-body text-center">
                  <h4 class="card-title">Liste des commentaires</h4>
                  <hr>
              </div>
              <div class="comment-widgets">
                  <div :key="index" v-for="(comment, index) in comments" class="d-flex flex-row mb-3">
                      <div class="p-2"><font-awesome-icon icon="user" style="width: 50px;"></font-awesome-icon></div>
                      <div class="w-100">
                          <h6>{{ comment.user.fullname }}</h6> <span class="m-b-15 d-block">{{ comment.content }}</span>
                      </div>
                  </div>
              </div>
          </div>
    
          
        </div>
        <div class="col-12 col-sm-5">
          <div :key="index" v-for="(event, index) in events" class="list-group">
            <a @click="selectEvent(event.id, event.title, event.description, event.date, event.author, event.location, index)" href="#" class="list-group-item list-group-item-action">
              <div class="d-flex w-100 justify-content-between">
                <h5 class="mb-1">{{ event.title }}</h5>
                <small><font-awesome-icon icon="map-marker-alt"></font-awesome-icon> {{ event.location.name }}</small>
              </div>
              <p class="mb-1">{{ event.description }}</p>
              <small><font-awesome-icon icon="calendar-alt"></font-awesome-icon> Prévu le {{ event.date }}</small>
            </a>
          </div>
        </div>
      </div>
      <div v-else class="row mb-5">
        <h3 class="text-center">Vous n'avez aucun évènement partagés !</h3>
      </div>
    </div>
  </div>
</template>

<style lang="scss">
.button-display {
  display: inline;
}

.deleteBtn {
  width: 20%;
  float: right; 
}

.editBtn {
  width: 20%;
  float: right;
  margin-right: 1em;
}
</style>

<script>
import Navbar from '@/components/Navbar.vue';
import { latLng } from "leaflet";
import { LMap, LTileLayer, LMarker, LTooltip } from "vue2-leaflet";
import { Icon } from 'leaflet';
import 'leaflet/dist/leaflet.css';
import moment from 'moment';

moment.locale('fr');

delete Icon.Default.prototype._getIconUrl;
Icon.Default.mergeOptions({
  iconRetinaUrl: require('leaflet/dist/images/marker-icon-2x.png'),
  iconUrl: require('leaflet/dist/images/marker-icon.png'),
  shadowUrl: require('leaflet/dist/images/marker-shadow.png'),
});


export default {
  components: {
    Navbar,
    LMap,
    LTileLayer,
    LMarker,
    LTooltip
  },

  data() {
    return {
      events: [],
      comments: [],
      index: false,
      id: false,
      title: false,
      description: false,
      date: false,
      author: false,
      location: false,
      comment_content: false,
      comment_user: false,
      input_comment: '',

      zoom: 15,
      center: latLng(location.x, location.y),
      url: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
      withTooltip: latLng(47.41422, -1.250482),
      currentZoom: 15,
      currentCenter: latLng(location.x, location.y),
      mapOptions: {
        zoomSnap: 0.5
      },
      showMap: true
    }
  },
  methods: {
    selectEvent(id, title, description, date, author, location, index) {
      this.index = index;
      this.id = id;
      this.title = title;
      this.description = description;
      this.date = date;
      this.author = author.fullname;
      this.location = location;
      this.center = latLng(location.x, location.y);
      this.currentCenter = latLng(location.x, location.y);
      this.withTooltip = latLng(location.x, location.y);

      api.get('comments/' + this.id).then(response => {
          this.comments = [];
          response.data.forEach(element => {
            this.comments.push(element);
          });
      });
    },

    postAvailable(id) {
      let content = "Je serais présent.";
      api.post('comment/' + id, {
        content: content,
        event_id: id
      }).then(response => {
        this.getComments();
      });
    },

    postAbsent(id) {
      let content = "Je serais absent.";
      api.post('comment/' + id, {
        content: content,
        event_id: id
      }).then(response => {
        this.getComments();
      });
    },

    postComment(id) {
      let content = this.input_comment;
      api.post('comment/' + id, {
        content: content,
        event_id: id
      }).then(response => {
        this.input_comment = '';
        this.getComments();
      });
    },

    getComments() {
      this.comments = [];
      api.get('comments/' + this.id).then(response => {
          response.data.forEach(element => {
            this.comments.push(element);
          });
      });
    },

    deleteEvent(id) {
      if(confirm("Êtes vous sûr de vouloir supprimer cet évènement ?")) {
        api.post('delete/event/' + id).then(response => {
          document.location.reload();
        });
      }
    },

    zoomUpdate(zoom) {
      this.currentZoom = zoom;
    },

    centerUpdate(center) {
      this.currentCenter = center;
    },

    showLongText() {
      this.showParagraph = !this.showParagraph;
    }
  },
  mounted() {
    api.get('events').then(response => {
      if (response.data.shared.length > 0) {
        this.id = response.data.shared[0].id;
        this.title = response.data.shared[0].title;
        this.description = response.data.shared[0].description;
        this.date = moment(response.data.shared[0].date).format('L à LT');
        this.author = response.data.shared[0].author.fullname;
        this.location = response.data.shared[0].location;
        this.center = latLng(response.data.shared[0].location.x, response.data.shared[0].location.y);
        this.currentCenter = latLng(response.data.shared[0].location.x, response.data.shared[0].location.y);
        this.withTooltip = latLng(response.data.shared[0].location.x, response.data.shared[0].location.y);

        response.data.shared.forEach(element => {
          this.events.push(element);
        });

        this.events.forEach(element => {
          element.date = moment(element.date).format('L à LT');
        });

        this.getComments();
      }
    });
  }
}
</script>
