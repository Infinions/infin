import Chart from 'chart.js';
import $ from "jquery";

let delta = 'M';
let graph_type = "sum_invoices";
let time = 7;
let is_count = true;

function lineChart(label_values, result){

    new Chart(document.getElementById("lineChart"), {
        type: 'line',
        responsive: true,
        mantainAspectRatio: false,
        data: {
            labels: label_values,
            datasets: result,
        },
        options: {
            responsive: true
        }
    });
}

function barChart(label_values, data){
    $("#progress").hide();
    $("#prevision").show();

    new Chart(document.getElementById("lineChartPrevisions"), {
        type: 'bar',
        data: {
            labels: label_values,
            datasets: [{
                label: 'Predict Cost',
                data: data,
                backgroundColor: "rgba(251, 85, 85, 0.4)",
                borderWidth: 1
            }]
        },
        options: {
            responsive: false,
        }
    });
}

function pieChart(costs, earnings) {
    $("#pieChartError").hide();

    new Chart(document.getElementById("pieChart"), {
        type: 'doughnut',
        responsive: true,
        mantainAspectRatio: false,
        data: {
            datasets: [{
                data: [
                    costs,
                    earnings
                ],
                backgroundColor: [
                    "rgba(251, 85, 85, 0.4)",
                    "rgba(137, 196, 244, 1)",
                ],
            }],
            labels: [
                'Costs',
                'Earnings',
            ]
        },
        options: {
            responsive: true
        }
    });
}

let dynamicColors = function() {
    let r = Math.floor(Math.random() * 255);
    let g = Math.floor(Math.random() * 255);
    let b = Math.floor(Math.random() * 255);

    return "rgb(" + r + "," + g + "," + b + ")";
}

function get_query(type) {
    const nif = $('#nif').data('value');
    let actual_query;

    if (type == "n_invoices_category") {
        actual_query = "{n_invoices_category(nif: \"" + nif + "\", is_count: " + is_count + ", delta: \"" + delta + "\")}"
    } else if (type == "n_invoices_client") {
        actual_query = "{n_invoices_client(nif: \"" + nif + "\", is_count: " + is_count + ", delta: \"" + delta + "\")}"
    } else if (type == "sum_invoices") {
        actual_query = "{sum_invoices(nif: \"" + nif + "\", delta: \"" + delta + "\")}"
    } else if (type == "predict_future") {
        actual_query = "{predict_future(nif: \"" + nif + "\", time: " + time + ", delta: \"D\")}"
    }

    return actual_query;
}

function graphicInvoices(data) {
    let result = [];
    let dict = {};

    if ( data.categories !== undefined ) {
        dict = data.categories
    } else {
        dict = data.companies
    }

    for (var key in dict) {
        result.push({
            data: dict[key],
            label: key,
            fill: false,
            borderColor: dynamicColors(),
            borderWidth: 2
        });
    }

    lineChart(data.dates, result);
}

function graphicSumInvoices(data) {
    $("#generalChartError").hide();

    let result = [];

    result.push({
        data: data.costs_values,
        label: "Costs",
        fill: false,
        borderColor: dynamicColors(),
        borderWidth: 2
    });
    result.push({
        data: data.gains_values,
        label: "Gains",
        fill: false,
        borderColor: dynamicColors(),
        borderWidth: 2
    });

    lineChart(data.dates, result);
}

function show_error() {
    $("#progress").hide();
    $("#prevision").show();
    $("#prevChartError").show();
}

function makeGraphic() {
    const apiAccess = process.env.ANALYTICS_URL;
    let type = graph_type;

    $.ajax({
        url: apiAccess,
        async: true,
        method: "POST",
        headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
        },
        data: JSON.stringify({
            query: get_query(type)
        }),
        dataType: 'json',
        success: function(data) {
            if(type == "n_invoices_category") {
                data = JSON.parse(data.data.n_invoices_category)
                if (data !== null) {
                    graphicInvoices(data)
                }
            } else if(type == "predict_future") {
                data = JSON.parse(data.data.predict_future)
                if (data !== null) {
                    barChart(data.dates, data.total_value);
                } else {
                    show_error();
                }
            } else if (type == "n_invoices_client") {
                data = JSON.parse(data.data.n_invoices_client)
                if (data !== null) {
                    graphicInvoices(data)
                }
            } else if (type == "sum_invoices") {
                data = JSON.parse(data.data.sum_invoices);
                if (data !== null && data.dates.length > 0) {
                    graphicSumInvoices(data)
                    let total_costs = data.costs_values.reduce((a, b) => a + b, 0);
                    let total_gains = data.gains_values.reduce((a, b) => a + b, 0);
                    pieChart(total_costs, total_gains);
                }
            }
        }
    });
}

makeGraphic();

$(function(){
    $("#prev").hide();
    $("#preview").on("click", function(){
        graph_type = 'predict_future';
        makeGraphic();
        $("#prevision").hide();
        $("#prev").show();
        $("#prevChartError").hide();
        $("#preview").hide();
    });
});

let select_type = document.getElementById('dropdown_type');
let select_delta = document.getElementById('dropdown_delta');
let select_time = document.getElementById('dropdown_time');
let select_options = document.getElementById('dropdown_options');

(select_type.onchange = function() {
    var $option = $(this).find('option:selected');
    let value = $option.val();

    if (value !== "") {
        graph_type = value;
        makeGraphic();
    }
});

(select_delta.onchange = function() {
    var $option = $(this).find('option:selected');
    let value = $option.val();

    if (value !== "") {
        delta = value;
        makeGraphic();
    }
});

(select_time.onchange = function() {
    var $option = $(this).find('option:selected');
    let value = $option.val();

    if (value !== "") {
        if (value == 6) {
            time = value * 30;
        } else if (value == 1) {
            time = 365
        }
        makeGraphic();
        $("#progress").show();
        $("#prevision").hide();
    }
});

(select_options.onchange = function() {
    var $option = $(this).find('option:selected');
    let value = $option.val();

    if (value !== "") {
        is_count = value;
        makeGraphic();
    }
});
