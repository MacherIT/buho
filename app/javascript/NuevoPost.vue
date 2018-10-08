<template lang="pug">
  .contenedor-new-post
    form(@submit.prevent="crearPost", novalidate)
      select(
        v-model="post.red"
        v-validate="'required'"
        name="red")
        option(selected, disabled, value="") -- Seleccionar red --
        option(
          v-for="red in redes"
          :key="red.id"
          :value="red.id") {{red.nombre}}
      input(
        type="text"
        :disabled="!post.red"
        placeholder="Título"
        v-validate="'required'"
        name="titulo"
        v-model="post.titulo")
      textarea(
        :disabled="!post.red"
        placeholder="Cuerpo"
        v-validate="'required'"
        name="texto"
        v-model="post.texto")
      input(
        type="submit"
        value="Postear!"
        :disabled="!validForm || sent")
</template>

<script>
import mixins from "./mixins";

export default {
  name: "NuevoPost",
  props: ["toggleNewPost", "redes"],
  mixins: [mixins.FormValidation],
  data() {
    return {
      post: {
        red: "",
        titulo: ""
      }
    };
  },
  methods: {
    crearPost() {
      if (this.dirtyForm && this.validForm) {
        this.$http({
          method: "POST",
          url: "/api/proyectos",
          body: {
            post: {
              red_id: this.post.red,
              texto: this.post.texto
            }
          },
          headers: {
            Authorization: `Bearer ${this.token}`
          }
        }).then(
          ({ status }) => {
            this.sent = false;
            console.log(status);
          },
          error => {
            this.sent = false;
            console.error(error);
          }
        );
      } else {
        this.$validator.validateAll();
      }
    }
  }
};
</script>

<style lang="scss" scoped>
@import "config.scss";

.contenedor-new-post {
  position: fixed;
  background-color: #fff;
  width: 50vw;
  height: 90vh;
  left: 25vw;
  top: 5vh;
  @include sombra(0 0 5px 0 #222);
  z-index: 1000;
  @include default-form;
  form {
    padding: 15px;
  }
}
</style>
