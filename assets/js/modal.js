import $ from "jquery";

// written to open or close the modal
const modal = $('.modal');

$('#modal-btn').on('click', () => {
    modal.show();
})

$('#close-btn').on('click', () => {
    modal.hide();
})

$(window).on('click', event => {
    if (event.target.className === 'modal-background') {
        modal.hide();
    }
})
