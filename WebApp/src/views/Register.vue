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
                        <div class="card-header"><font-awesome-icon icon="user-plus"></font-awesome-icon> Page d'inscription</div>
                        <div class="card-body">
                            <form @submit.prevent="register()">
                                <div class="form-group row">
                                    <label for="fullname" class="col-md-4 col-form-label text-md-right">Nom complet</label>
                                    <div class="col-md-6">
                                        <input v-model="fullname" type="text" id="fullname" class="form-control" required>
                                    </div>
                                </div>

                                <div class="form-group row mt-3 mb-3">
                                    <label for="email" class="col-md-4 col-form-label text-md-right">Adresse mail</label>
                                    <div class="col-md-6">
                                        <input v-model="email" type="email" id="email" class="form-control" required>
                                    </div>
                                </div>

                                <div class="form-group row mt-3 mb-3">
                                    <label for="password" class="col-md-4 col-form-label text-md-right">Mot de passe</label>
                                    <div class="col-md-6">
                                        <input v-model="password" type="password" id="password" class="form-control" required>
                                    </div>
                                </div>

                                <div class="col-md-6 offset-md-4">
                                    <button class="btn btn-primary">Connexion</button>
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

export default {
  components: {
    Navbar
  },
  data() {
      return {
          error: false,
          fullname: '',
          email: '',
          password: ''
      }
  },
  methods: {
      register() {
          api.post('signup', {
             fullname: this.fullname,
             email: this.email,
             password: this.password 
          }).then(response => {
              if(response.data.post) {
                alert('Votre compte a bien été créé !');
                this.$router.push('/login');
              } else {
                  this.error = response.data.message;
              }
          });
      }
  }
}
</script>