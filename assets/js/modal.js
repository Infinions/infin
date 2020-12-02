// written to open or close the modal
const modal =
    document.querySelector('.modal');
const btn =
    document.getElementById('modal-btn')
const close =
    document.getElementById('close-btn')

btn.addEventListener('click',
    function () {
        modal.style.display = 'block'
    })

close.addEventListener('click',
    function () {
        modal.style.display = 'none'
    })

window.addEventListener('click',
    function (event) {
        if (event.target.className ===
            'modal-background') {
            modal.style.display = 'none'
        }
    })