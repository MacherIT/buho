export default {
  FormValidation: {
    computed: {
      dirtyForm() {
        return Object.keys(this.fields).some(field => this.fields[field].dirty);
      },
      validForm() {
        return Object.keys(this.fields).every(
          field => this.fields[field].valid
        );
      }
    }
  }
};
