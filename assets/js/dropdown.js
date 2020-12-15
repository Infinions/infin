import $ from "jquery";

const dropdown =
    document.querySelector('.dropdown');
const active =
    document.querySelector('.is-active')
document.body.addEventListener('click', function() {
    if (active) {
        dropdown.classList.remove('is-active')
    }
})
dropdown.addEventListener('click', function(event) {
    event.stopPropagation();
    this.classList.toggle('is-active');
});