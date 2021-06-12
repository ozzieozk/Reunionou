<template>
    <div>
        <Navbar />
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div v-if="error" class="alert alert-danger" role="alert">
                        <font-awesome-icon icon="exclamation-circle"></font-awesome-icon> {{ error }}
                    </div>
                    <div class="card">
                        <div class="card-header"><font-awesome-icon icon="plus"></font-awesome-icon> Page de modification d'un évènement</div>
                        <div class="card-body">
                            <form @submit.prevent="editEvent()">
                                <div class="mb-3">
                                    <label for="title" class="form-label">Intitulé de l'évènement :</label>
                                    <input v-model="title" type="text" class="form-control" id="title">
                                </div>
                                <div class="mb-3">
                                    <label for="description" class="form-label">Description :</label>
                                    <input v-model="description" type="text" class="form-control" id="description">
                                </div>
                                <div class="row">
                                    <div class="col-6">
                                        <div class="mb-3">
                                            <label for="date" class="form-label">Date :</label>
                                            <input v-model="date" type="date" class="form-control" id="date">
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <div class="mb-3">
                                            <label for="time" class="form-label">Heure :</label>
                                            <input v-model="time" type="time" class="form-control" id="time">
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label for="location" class="form-label">Intitulé du lieu :</label>
                                        <input v-model="location" type="text" class="form-control" id="location">
                                    </div>
                                </div>

                                <l-map v-if="showMap" :zoom="zoom" :center="initialLocation" :options="mapOptions"
                                    style="height: 350px; width: 100%;" @update:center="centerUpdate"
                                    @update:zoom="zoomUpdate" @click="handleMapClick">
                                    <l-tile-layer :url="url" :attribution="attribution" />
                                    <l-marker :key="index" v-for="(m, index) in markers" :lat-lng="m.pos">
                                        <l-tooltip :options="{ permanent: true, interactive: true }">{{ location }}</l-tooltip>
                                    </l-marker>
                                </l-map>

                                <div class="d-grid gap-2 mt-3">
                                    <button @click="editEvent()" class="btn btn-primary" type="button">Modifier l'évènement</button>
                                </div>
                            </form>
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
import Navbar from '@/components/Navbar.vue';
import { latLng } from "leaflet";
import { LMap, LTileLayer, LMarker, LPopup, LTooltip } from "vue2-leaflet";
import { Icon } from 'leaflet';
import 'leaflet/dist/leaflet.css';

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
    LPopup,
    LTooltip
  },
  data() {
      return {
        error: false,
        success: false,
        title: '',
        description: '',
        date: '',
        time: '',
        location: '',
        initialLocation: [46.227638, 2.213749],
        markers: [],
        x: false,
        y: false,

        zoom: 15,
        center: latLng(location.x, location.y),
        url: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
        attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
        withPopup: latLng(47.41322, -1.219482),
        showParagraph: false,
        withTooltip: latLng(47.41422, -1.250482),
        currentZoom: 15,
        currentCenter: latLng(location.x, location.y),
        mapOptions: {
            zoomSnap: 0.5
        },
        showMap: true,
      }
  },
  methods: {
    editEvent() {
        api.post('edit/event/' + this.$route.params.id, {
             title: this.title,
             description: this.description,
             date: this.date + ' ' + this.time,
             location: this.location,
             x: this.x,
             y: this.y
          }).then(response => {
              if(response.data.post) {
                alert("L'évènement a bien été modifié !");
                this.$router.push('/');
              } else {
                  this.error = response.data.message;
              }
          });
    },

    zoomUpdate(zoom) {
    this.currentZoom = zoom;
    },

    centerUpdate(center) {
      this.currentCenter = center;
    },

    handleMapClick(event) {
        const pos = L.latLng(event.latlng.lat, event.latlng.lng);
        this.markers = [];
        this.markers.push({ pos: pos });
        this.x = event.latlng.lat;
        this.y = event.latlng.lng;
    }
  },

  mounted() {
      api.get('event/' + this.$route.params.id).then(response => {
          let data = response.data[0];
          this.title = data.title;
          this.description = data.description;
          this.location = data.location.name;
          this.initialLocation = [data.location.x, data.location.y];
          this.x = data.location.x;
          this.y = data.location.y;
          
          const pos = L.latLng(this.x, this.y);
          this.markers.push({ pos: pos });

          let datetime = data.date.split(' ');
          this.date = datetime[0];
          this.time = datetime[1];
      });
  }
}
</script>