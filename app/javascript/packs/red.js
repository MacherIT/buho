let evL = "";

setTimeout(() => {
  document.querySelector("#red_tipo").removeEventListener("change", () => {});
  document.querySelector("#red_tipo").addEventListener("change", ev => {
    if (ev.target.value == 1) {
      document.querySelector("#p_red_fb").style.display = "none";
      document.querySelector("#p_red_ig").style.display = "block";
    }
    if (ev.target.value == 0) {
      document.querySelector("#p_red_fb").style.display = "block";
      document.querySelector("#p_red_ig").style.display = "none";
    }
  });
}, 2000);
