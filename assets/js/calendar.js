import bulmaCalendar from 'bulma-calendar'
import $ from "jquery";

$(() => {
    bulmaCalendar.attach('[type="date"]', {
        type: 'date',
        dateFormat: 'YYYY-MM-DD',
        displayMode: 'dialog',
        startDate: new Date()
    });
});
