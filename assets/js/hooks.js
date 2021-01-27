import $ from 'jquery';

let Hooks = {};

Hooks.PendingModal = {
  mounted() {
    const modal = $('.pending-modal');

    $('.open-pending-modal').on('click', event => {
      const transaction_id = event.currentTarget.dataset.id;
      modal.data('transaction-id', transaction_id);
      modal.show();
    });

    $('#close-btn').on('click', () => {
      modal.hide();
    });

    $(window).on('click', event => {
      if (event.target.className === 'modal-background') {
        modal.hide();
      }
    });

     $('.select-pending').on('click', event => {
      const transaction_id = modal.data('transaction-id');
      const invoice_id = event.currentTarget.dataset.id;
      this.pushEvent(
        "register-invoice-transaction",
        { transaction_id, invoice_id }
      );
    });
  }
};

export default Hooks;
