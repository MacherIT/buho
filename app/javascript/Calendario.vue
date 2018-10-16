<template lang="pug">
  #calendario
    .cambiar-mes
      .flecha.izquierda(@click="setMesActivo(mesActivo - 1)")
        span.glyphicon.glyphicon-triangle-left
      .flecha.derecha(@click="setMesActivo(mesActivo + 1)")
        span.glyphicon.glyphicon-triangle-right
    .filtrar-red
      select(v-model="filters.red_id.val")
        option(selected, value="") -- Todas las redes --
        option(
          v-for="red in redes"
          :key="red.id"
          :value="red.id") {{red.nombre}} - {{red.tipo === 1 ? 'INSTAGRAM' : 'FACEBOOK'}}
    .meses
      .mes(
        v-for="(mes, index) in months"
        :key="index"
        v-if="mes && index === mesActivo")
        .titulo
          span {{mes.nombre}}
        .dias
          .dia(
            v-for="(dia, key, index) in mes.dias"
            :class="{today: key === today, old: moment(new Date(key)).isBefore(today)}")
            .numero
              span {{index + 1}}
            .lista-posts
              .post(
                v-for="post in dia.posts"
                :key="post.id")
                .info(
                  @click="setPostActivo(post.id)"
                  v-if="visiblePost(post)"
                  :class="{fb: redTipo[post.red_id] === 0, ig: redTipo[post.red_id] === 1}")
                  .hora
                    span {{moment(post.hora_pub).format('HH:mm')}}
                  .texto
                    span {{post.titulo}}
                CardPost(
                  v-if="postActivo === post.id"
                  :post="post"
                  :set-post-activo="setPostActivo"
                  :showme-edit-post="showmeEditPost"
                  :redes="redes"
                  :close-card-post="closeCardPost")
    .make-new-post(@click="showmeNewPost")
      span +
    NuevoPost(v-if="showNewPost", :redes="redes", :close-new-post="closeNewPost")
    EditPost(v-if="showEditPost", :redes="redes", :close-edit-post="closeEditPost", :post="postToEdit")
</template>

<script>
import moment from "moment";
import NuevoPost from "./NuevoPost.vue";
import EditPost from "./EditPost.vue";
import CardPost from "./CardPost.vue";

export default {
  name: "Calendario",
  props: ["posts", "redes", "meses"],
  components: {
    NuevoPost,
    EditPost,
    CardPost
  },
  data() {
    return {
      filters: {
        red_id: {
          fun(item) {
            return item.red_id && item.red_id === this.val;
          },
          val: ""
        }
      },
      postToEdit: false,
      today: moment().format("YYYY-M-D"),
      postActivo: -1,
      mesActivo: new Date().getMonth(),
      moment,
      showNewPost: false,
      showEditPost: false,
      loadedPosts: JSON.parse(JSON.stringify(this.posts))
    };
  },
  computed: {
    months() {
      let loadedMonths = JSON.parse(JSON.stringify(this.meses));
      let mes = loadedMonths[this.mesActivo];
      this.loadedPosts.map(post => {
        if (mes.dias[moment(post["hora_pub"]).format("YYYY-M-D")]) {
          mes.dias[moment(post["hora_pub"]).format("YYYY-M-D")].posts.push(
            post
          );
        }
      });
      return loadedMonths;
    },
    redTipo() {
      let redes = {};
      this.redes.map(red => {
        redes[red.id] = red.tipo;
      });
      return redes;
    }
  },
  methods: {
    visiblePost(post) {
      return Object.keys(this.filters).every(
        k => (this.filters[k].val ? this.filters[k].fun(post) : true)
      );
    },
    setPostActivo(id) {
      this.postActivo = id;
    },
    setMesActivo(index) {
      if (this.months[index]) {
        this.mesActivo = index;
      }
    },
    showmeEditPost(post) {
      this.showEditPost = true;
      this.postToEdit = post;
    },
    showmeNewPost() {
      this.showNewPost = true;
    },
    closeNewPost() {
      this.showNewPost = false;
      this.loadPosts();
    },
    closeEditPost() {
      this.showEditPost = false;
      this.loadPosts();
    },
    closeCardPost() {
      this.setPostActivo(-1);
      this.loadPosts();
    },
    loadPosts() {
      this.$http({
        method: "GET",
        url: "/posts.json"
      }).then(
        ({ data }) => {
          this.loadedPosts = data;
        },
        error => {
          console.error(error);
        }
      );
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
  .filtrar-red {
    position: absolute;
    right: 0;
    top: 0;
    display: flex;
    flex-direction: column;
    select {
      min-width: 350px;
      border: 1px solid #ccc;
      border-radius: 4px;
      padding: 6px;
      margin-bottom: 10px;
      background-color: #fff;
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
          // cursor: pointer;
          @include sombra(0 0 0 1px #ccc);
          @include ease-transition;
          // &:hover {
          //   @include sombra(0 0 2px 1px #999);
          // }
          &.old {
            background-color: #eee;
          }
          &.today {
            background-color: #ffa;
          }
          .numero {
            position: absolute;
            left: 3px;
            top: 3px;
            hora_pub span {
              font-size: 80%;
            }
          }
          .lista-posts {
            width: 100%;
            display: flex;
            justify-content: flex-start;
            align-items: flex-start;
            flex-direction: column;
            .post {
              width: 100%;
              position: relative;
              .info {
                font-size: 90%;
                display: flex;
                justify-content: flex-start;
                align-items: center;
                padding: 1px 3px;
                margin: 1px 0;
                width: 100%;
                color: #fff;
                cursor: pointer;
                @include ease-transition;
                &.fb {
                  background-color: #4267b2;
                }
                &.ig {
                  background-color: #d72b72;
                }
                &:hover {
                  background-color: #279948;
                }
                .hora {
                  margin-right: 5px;
                }
              }
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
