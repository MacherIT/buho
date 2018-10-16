<template lang="pug">
  .card-post
    .contenido
      .cerrar-popup(@click="setPostActivo(-1)")
        font-awesome-icon(icon="times")
      .pubdate
        span {{moment(post.hora_pub).format("DD/MM/YYYY HH:mm")}}
      .titulo
        h3 {{post.titulo}}
      .texto
        p {{post.texto}}
      .imagen
        img(
          :src="post.img")
      .botonera
        button.editar-post(@click="editarPost", type="button")
          font-awesome-icon(icon="pencil-alt")
        button.eliminar-post(@click="muestraPopupEliminar", type="button")
          font-awesome-icon(icon="trash")
    .popup-eliminar(v-if="popupEliminar")
      .pregunta
        p ¿Realmente querés eliminar el post?
      .botonera
        button.cancelar(type="button", @click="escondePopupEliminar") CANCELAR
        button.aceptar(type="button", @click="eliminarPost", :disabled="sent") ACEPTAR
      .loading(v-if="sent")
        font-awesome-icon(icon="circle-notch", spin)
</template>

<script>
import moment from "moment";

export default {
  name: "CardPost",
  props: ["post", "setPostActivo", "showmeEditPost", "redes", "closeCardPost"],
  data() {
    return {
      sent: false,
      redActual: "",
      popupEliminar: false,
      moment
    };
  },
  mounted() {
    this.redActual = this.redes.find(red => red.id === this.post.red_id);
  },
  methods: {
    editarPost() {
      this.setPostActivo(-1);
      this.showmeEditPost(this.post);
    },
    muestraPopupEliminar() {
      this.popupEliminar = true;
    },
    escondePopupEliminar() {
      this.popupEliminar = false;
    },
    eliminarPost() {
      this.sent = true;

      let urlDelete =
        this.redActual.tipo === 0
          ? `/posts/${this.post.id}`
          : `/posts/${this.post.id}/delete/ig`;

      this.$http({
        method: "DELETE",
        url: urlDelete
      }).then(
        ({ status }) => {
          this.closeCardPost();
        },
        error => {
          // console.error(error);
          this.closeCardPost();
        }
      );
    }
  }
};
</script>

<style lang="scss" scoped>
@import "config.scss";
.card-post {
  position: fixed;
  left: 0;
  top: 0;
  width: 100vw;
  height: 100vh;
  z-index: 1000;
  background-color: rgba(0, 0, 0, 0.4);
  .contenido {
    position: fixed;
    left: 25vw;
    top: 5vh;
    z-index: 1100;
    width: 50vw;
    height: 90vh;
    overflow: auto;
    background-color: #fff;
    @include sombra(0 0 3px 0 #444);
    padding: 15px;
    display: flex;
    flex-direction: column;
    cursor: auto;
    .cerrar-popup {
      position: absolute;
      right: 15px;
      top: 15px;
      cursor: pointer;
    }
    .pubdate {
      span {
        color: #666;
        font-size: 90%;
      }
    }
    .titulo {
      h3 {
      }
    }
    .texto {
      max-height: 200px;
      overflow: auto;
    }
    .imagen {
      width: 100%;
      height: 300px;
      img {
        width: 100%;
        height: 100%;
        object-fit: contain;
      }
    }
    .botonera {
      display: flex;
      justify-content: flex-end;
      align-items: center;
      margin: 25px 5px;
      button {
        display: flex;
        justify-content: center;
        align-items: center;
        cursor: pointer;
        @include ease-transition;
        min-width: 65px;
        padding: 5px 0;
        border-radius: 5px;
        margin-left: 10px;
        * {
          color: #fff;
        }
        &.editar-post {
          border: 1px solid #3f879f;
          background-color: #34a9cf;
          &:hover {
            background-color: #53b1d0;
          }
        }
        &.eliminar-post {
          border: 1px solid #9f3f3f;
          background-color: #cf3434;
          &:hover {
            background-color: #d05353;
          }
        }
      }
    }
  }
  .popup-eliminar {
    position: fixed;
    width: 30vw;
    height: 30vh;
    left: 35vw;
    top: 35vh;
    z-index: 1200;
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    text-align: center;
    background-color: #fff;
    @include sombra(0 0 4px 0 #000);
    .botonera {
      display: flex;
      justify-content: flex-end;
      align-items: center;
      margin: 25px 5px;
      button {
        display: flex;
        justify-content: center;
        align-items: center;
        cursor: pointer;
        @include ease-transition;
        min-width: 65px;
        border-radius: 5px;
        margin-left: 10px;
        padding: 5px 7px;
        color: #fff;
        &.cancelar {
          border: 1px solid #9f3f3f;
          background-color: #cf3434;
          &:hover {
            background-color: #d05353;
          }
        }
        &.aceptar {
          border: 1px solid #3f9f40;
          background-color: #34cf3e;
          &:hover {
            background-color: #6cd053;
          }
        }
      }
    }
  }
}
</style>
