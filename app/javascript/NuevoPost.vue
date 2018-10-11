<template lang="pug">
  .contenedor-new-post
    .cerrar-popup(@click="closeNewPost")
      font-awesome-icon(icon="times")
    form(@submit.prevent="crearPost", novalidate)
      select(
        v-model="post.red"
        v-validate="'required'"
        name="red")
        option(selected, disabled, value="") -- Seleccionar red --
        option(
          v-for="red in redes"
          :key="red.id"
          :value="red") {{red.nombre}} - {{red.tipo === 1 ? 'INSTAGRAM' : 'FACEBOOK'}}
      .fecha
        input(
          type="date"
          v-model="fecha_pub"
          :disabled="!post.red"
          placeholder="Fecha")
        select(
          v-model="hour_pub"
          :disabled="!post.red")
          option(selected, disabled, value="") -- Hora --
          option(value="0") 00
          option(
            v-for="hora in 23"
            :key="hora"
            :value="hora") {{hora > 9 ? hora : '0' + hora}}
        select(
          v-model="minute_pub"
          :disabled="!post.red")
          option(selected, disabled, value="") -- Minuto --
          option(value="0") 00
          option(value="15") 15
          option(value="30") 30
          option(value="45") 45
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
      .adjuntos(:class="{disabled: !post.red, focus: adjuntosFocus}")
        .explicacion(v-if="!post.adjunto")
          span ADJUNTAR IMAGEN
        img#tmpimage(v-if="post.adjunto")
        .quitar-adjunto(v-if="post.adjunto", @click="quitarAdjunto")
          font-awesome-icon(icon="times")
        input#adjuntar-archivo(
          type="file"
          accept="image/*"
          @change="setAdjunto"
          @focus="adjuntosFocus = true"
          @blur="adjuntosFocus = false")
      input(
        type="submit"
        value="Postear!"
        :disabled="!validForm || sent")
      .loading(v-if="sent")
        font-awesome-icon(icon="circle-notch", spin)
</template>

<script>
import moment from "moment";
import mixins from "./mixins";

export default {
  name: "NuevoPost",
  props: ["closeNewPost", "redes", "finishPost"],
  mixins: [mixins.FormValidation],
  data() {
    return {
      adjuntosFocus: false,
      sent: false,
      fecha_pub: moment(new Date()).format("YYYY-MM-DD"),
      hour_pub: "0",
      minute_pub: "0",
      post: {
        adjunto: "",
        hora_pub: "",
        red: "",
        titulo: "",
        texto: ""
      }
    };
  },
  methods: {
    setAdjunto(event) {
      if (event.target.files && event.target.files[0]) {
        this.post.adjunto = event.target.files[0];
        setTimeout(() => {
          if (FileReader) {
            var fr = new FileReader();
            fr.onload = function() {
              document.querySelector("#tmpimage").src = fr.result;
            };
            fr.readAsDataURL(event.target.files[0]);
          }
        }, 1000);
      }
    },
    quitarAdjunto() {
      this.post.adjunto = "";
    },
    crearPost() {
      if (this.dirtyForm && this.validForm) {
        this.sent = true;
        let data = new FormData();
        data.append("post[red_id]", this.post.red.id);
        data.append(
          "post[hora_pub]",
          new Date(`${this.fecha_pub} ${this.hour_pub}:${this.minute_pub}`)
        );
        data.append("post[titulo]", this.post.titulo);
        data.append("post[texto]", this.post.texto);
        data.append("post[imagen]", this.post.adjunto);

        let urlPost =
          this.post.red.tipo === 0 ? "/posts.json" : "/posts/create/ig";

        this.finishPost(
          this.$http({
            method: "POST",
            url: urlPost,
            body: data
          })
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
  left: 25vw;
  height: 90vh;
  overflow: auto;
  top: 5vh;
  @include sombra(0 0 5px 0 #222);
  z-index: 1000;
  @include default-form;
  padding-top: 30px;
  .cerrar-popup {
    position: absolute;
    right: 10px;
    top: 15px;
    cursor: pointer;
  }
  form {
    padding: 15px;
    .fecha {
      width: 100%;
      display: flex;
    }
    textarea {
      min-height: 180px;
    }
    .adjuntos {
      display: flex;
      justify-content: center;
      align-items: center;
      flex-direction: column;
      position: relative;
      height: 314px;
      width: 100%;
      border: 1px solid #ccc;
      margin: 15px 0;
      @include ease-transition;
      border-radius: 4px;
      overflow: hidden;
      &.focus {
        border: 1px solid #dab73d;
      }
      &.disabled {
        &::before {
          position: absolute;
          width: 100%;
          height: 100%;
          background-color: rgba(0, 0, 0, 0.3);
          left: 0;
          top: 0;
          content: "";
          z-index: 50;
        }
      }
      .explicacion {
        position: absolute;
        span {
          color: #ccc;
        }
      }
      #adjuntar-archivo {
        height: 100%;
        width: 100%;
        cursor: pointer;
        opacity: 0;
        position: absolute;
      }
      #tmpimage {
        display: block;
        object-fit: contain;
        height: 314px;
        width: 100%;
      }
      .quitar-adjunto {
        position: absolute;
        top: 15px;
        right: 15px;
        cursor: pointer;
        z-index: 5;
      }
    }
  }
}
</style>
