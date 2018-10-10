<template lang="pug">
  .card-post
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
</template>

<script>
import moment from "moment";

export default {
  name: "CardPost",
  props: ["post", "setPostActivo"],
  data() {
    return {
      moment
    };
  }
};
</script>

<style lang="scss" scoped>
@import "config.scss";
.card-post {
  position: absolute;
  left: 100%;
  top: 100%;
  background-color: #fff;
  @include sombra(0 0 3px 0 #444);
  z-index: 100;
  padding: 15px;
  display: flex;
  flex-direction: column;
  min-width: 40vw;
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
}
</style>
