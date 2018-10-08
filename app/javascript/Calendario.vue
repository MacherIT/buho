<template lang="pug">
  #calendario
    .cambiar-mes
      .flecha.izquierda(@click="setMesActivo(mesActivo - 1)")
        span.glyphicon.glyphicon-triangle-left
      .flecha.derecha(@click="setMesActivo(mesActivo + 1)")
        span.glyphicon.glyphicon-triangle-right
    .meses
      .mes(
        v-for="(mes, index) in months"
        :key="index"
        v-if="mes && index === mesActivo")
        .titulo
          span {{mes.nombre}}
        .dias
          .dia(
            v-for="(dia, key, index) in mes.dias")
            .numero
              span {{index + 1}}
            .lista-posts
              .post(
                v-for="post in dia.posts"
                :keY="post.id")
                .hora
                  span {{moment(post.hora_pub).format('HH:mm')}}
                .texto
                  span {{post.titulo}}
    .make-new-post(@click="toggleNewPost()")
      span +
    NuevoPost(v-if="showNewPost", :redes="redes", :toggle-new-post="toggleNewPost")
</template>

<script>
import moment from "moment";
import NuevoPost from "./NuevoPost.vue";

export default {
  name: "Calendario",
  props: ["posts", "redes", "meses"],
  components: {
    NuevoPost
  },
  data() {
    return {
      mesActivo: new Date().getMonth(),
      moment,
      showNewPost: true
    };
  },
  computed: {
    months() {
      const mesActivo = this.mesActivo;
      return this.meses.map((mes, index) => {
        if (index === mesActivo) {
          this.posts.map(post => {
            if (mes.dias[moment(post["hora_pub"]).format("YYYY-M-D")]) {
              mes.dias[moment(post["hora_pub"]).format("YYYY-M-D")].posts.push(
                post
              );
            }
          });
        }
        return mes;
      });
    }
  },
  methods: {
    setMesActivo(index) {
      if (this.months[index]) {
        this.mesActivo = index;
      }
    },
    toggleNewPost() {
      this.showNewPost = this.showNewPost ? false : true;
    }
  }
};
// moment(dia.fecha).isSame(mes.dias[index + 1].fecha, 'date')
</script>

<style lang="scss" scoped>
@import "config.scss";

#calendario {
  position: relative;
  .cambiar-mes {
    display: flex;
    justify-content: flex-start;
    align-items: center;
    margin: 15px 0;
    .flecha {
      display: flex;
      justify-content: center;
      align-items: center;
      @include minmaxwh(48px);
      background-color: #eee;
      margin-right: 10px;
      @include ease-transition;
      cursor: pointer;
      &:hover {
        background-color: #ccc;
      }
    }
  }
  .meses {
    width: 100%;
    .mes {
      display: flex;
      flex-direction: column;
      .titulo {
        margin-bottom: 15px;
        span {
          text-transform: uppercase;
          font-size: 130%;
          font-weight: bold;
        }
      }
      .dias {
        width: 100%;
        display: flex;
        justify-content: flex-start;
        align-items: flex-start;
        flex-wrap: wrap;
        .dia {
          display: flex;
          justify-content: center;
          align-items: center;
          width: 13.8vw;
          min-width: 13.8vw;
          height: 18vh;
          position: relative;
          cursor: pointer;
          @include sombra(0 0 1px 0 #666);
          @include ease-transition;
          &:hover {
            @include sombra(0 0 4px 0 #000);
          }
          .numero {
            position: absolute;
            left: 3px;
            top: 3px;
            hora_pub span {
              font-size: 80%;
            }
          }
        }
      }
    }
  }
  .make-new-post {
    position: fixed;
    right: 20px;
    bottom: 20px;
    display: flex;
    justify-content: center;
    align-items: center;
    @include minmaxwh(60px);
    @include sombra(0 0 4px 0 #444);
    cursor: pointer;
    border-radius: 50%;
    background-color: rgb(67, 171, 73);
  }
}
</style>
