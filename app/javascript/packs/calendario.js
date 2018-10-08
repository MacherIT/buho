import Vue from "vue";
import VueResource from "vue-resource";
import VeeValidate from "vee-validate";
import TurbolinksAdapter from "vue-turbolinks";
import { library } from "@fortawesome/fontawesome-svg-core";
import { faCoffee } from "@fortawesome/free-solid-svg-icons";
import faSolid from "@fortawesome/fontawesome-free-solid";
import faBrands from "@fortawesome/fontawesome-free-brands";
import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome";
import App from "../Calendario.vue";

library.add(faCoffee, faSolid, faBrands);

Vue.component("font-awesome-icon", FontAwesomeIcon);

Vue.use(VueResource);
Vue.use(VeeValidate);

document.addEventListener("turbolinks:load", () => {
  const el = document.querySelector("#contenedor-calendario");
  const props = JSON.parse(el.getAttribute("data"));
  const app = new Vue({
    el,
    render: h => h(App, { props })
  });
});
