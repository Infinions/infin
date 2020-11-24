import bulmaCalendar from 'bulma-calendar'
import $ from "jquery";

$(() => {
    bulmaCalendar.attach('.invoice-date-picker', {
        type: 'date',
        dateFormat: 'YYYY-MM-DD',
        displayMode: 'dialog',
        startDate: new Date()
    });
});
