const fileInput = document.querySelector('#file input[type=file]');

fileInput.onchange = () => {
    if (fileInput.files.length > 0) {
        const fileName = document.querySelector('#file .file-name');
        fileName.textContent = fileInput.files[0].name;
    }
}