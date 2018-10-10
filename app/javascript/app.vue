<template lang="pug">
  //- <div id="app">
  //-   <p>{{ message }}</p>
  //- </div>
  #main
    span {{message}} 123
</template>

<script>
export default {
  data: function() {
    return {
      message: "Hello Vue!"
    };
  }
};
</script>

<style lang="scss" scoped>
#main {
  background-color: red;
  span {
    display: block;
    background-color: red;
  }
}
</style>
