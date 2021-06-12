<template>
  <div>
    <div class="container mt-5">

      <div class="row mb-5">
        <div class="col-12">
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
              <h5 class="card-title">
                {{ title }}
              </h5>
              <p class="card-text">{{ description }}</p>
              <p class="card-text button-display"><small class="text-muted"><font-awesome-icon icon="calendar-alt"></font-awesome-icon> Prévu le {{ date }} par {{ author }}</small></p>
            </div>
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
      </div>
    </div>
  </div>
</template>

<style lang="scss">
</style>

<script>
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
    getComments() {
      this.comments = [];
      api.get('public_comments/' + this.$route.params.token).then(response => {
          response.data.forEach(element => {
            this.comments.push(element);
          });
      });
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
    api.get('public_event/' + this.$route.params.token).then(response => {
        this.id = response.data.id;
        this.title = response.data.title;
        this.description = response.data.description;
        this.date = moment(response.data.date).format('L à LT');
        this.author = response.data.author.fullname;
        this.location = response.data.location;
        this.center = latLng(response.data.location.x, response.data.location.y);
        this.currentCenter = latLng(response.data.location.x, response.data.location.y);
        this.withTooltip = latLng(response.data.location.x, response.data.location.y);

        this.getComments();
    });
  }
}
</script>
