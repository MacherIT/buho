import Vue from "vue";
import VueResource from "vue-resource";
import VeeValidate from "vee-validate";
import TurbolinksAdapter from "vue-turbolinks";
import App from "../Calendario.vue";

Vue.use(VueResource);
Vue.use(VeeValidate);

document.addEventListener("turbolinks:load", () => {
  const el = document.querySelector("#contenedor-calendario");
  const props = JSON.parse(el.getAttribute("data"));
  const app = new Vue({
    el,
    render: h => h(App, { props }),
  });
});
