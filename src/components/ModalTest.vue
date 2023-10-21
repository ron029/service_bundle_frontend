<!-- Modal.vue -->

<template>
  <div>
    <transition name="modal-fade">
      <div class="modal" :id="modalId" tabindex="-1" role="dialog" aria-labelledby="modalTitle" aria-hidden="true">
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="modalTitle">
                <slot name="header">Default Modal Header</slot>
              </h5>
              <button type="button" class="close" @click="closeModal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div class="modal-body">
              <slot name="body">Default Modal Body</slot>
            </div>
            <div class="modal-footer">
              <slot name="footer">
                <button type="button" class="btn btn-secondary">Close</button>
                <button type="button" class="btn btn-primary">Save changes</button>
              </slot>
            </div>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
export default {
  props: {
    modalId: {
      type: String,
      required: true,
    },
  },
  methods: {
    closeModal() {
      const modal = document.getElementById(this.modalId);
      modal.classList.remove('show');
      modal.style.display = 'none';
      modal.setAttribute('aria-hidden', 'true');

      const modalBackdrop = document.querySelector('.modal-backdrop');
      modalBackdrop.remove();
    },
  },
  mounted() {
    // Add the transition CSS classes dynamically
  },
};
</script>

<style>

</style>