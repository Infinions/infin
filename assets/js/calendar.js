import bulmaCalendar from 'bulma-calendar'

document.addEventListener('DOMContentLoaded', function () {

    // Initialize all input of type date
    bulmaCalendar.attach('.invoice-date-picker', {
        type: 'date',
        dateFormat: 'DD/MM/YYYY',
        displayMode: 'dialog',
        startDate: new Date()
    });
});
