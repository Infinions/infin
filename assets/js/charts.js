import Chart from 'chart.js';
import $ from "jquery";

var delta = 'M';
var graph_type = "sum_invoices";
var time = 7;
var is_count = true;

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
    var myChart = new Chart(document.getElementById("lineChartPrevisions"), {
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

var dynamicColors = function() {
    var r = Math.floor(Math.random() * 255);
    var g = Math.floor(Math.random() * 255);
    var b = Math.floor(Math.random() * 255);
    return "rgb(" + r + "," + g + "," + b + ")";
}

function makeGraphic() {
    var apiAccess = 'http://localhost:5600/graphql';
    var nif = $('#nif').data('value');
    var actual_query;
    var result = [];
    var type = graph_type
    console.log(delta)
    if(type == "n_invoices_category") {
        actual_query = "{n_invoices_category(nif: \"" + nif + "\", is_count: " + is_count + ", delta: \"" + delta + "\")}"
    } else if (type == "n_invoices_client") {
        actual_query = "{n_invoices_client(nif: \"" + nif + "\", is_count: " + is_count + ", delta: \"" + delta + "\")}"
    } else if (type == "sum_invoices") {
        actual_query = "{sum_invoices(nif: \"" + nif + "\", delta: \"" + delta + "\")}"
    } else if (type == "predict_future") {
        actual_query = "{predict_future(nif: \"" + nif + "\", time: " + time + ", delta: \"D\")}"
    }

    $.ajax({
        url: apiAccess,
        async: true,
        method: "POST",
        headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
        },
        data: JSON.stringify({
            query: actual_query
        }),
        dataType: 'json',
        success: function(data) {
            if(type == "n_invoices_category") {
                data = JSON.parse(data.data.n_invoices_category)
                for (var key in data.categories) {
                    result.push({
                        data: data.categories[key],
                        label: key,
                        fill: false,
                        borderColor: dynamicColors(),
                        borderWidth: 2
                    });
                }
                lineChart(data.dates, result);
                result = [];
            } else if(type == "predict_future") {
                console.log("im in")
                data = JSON.parse(data.data.predict_future)
                barChart(data.dates, data.total_value);
            } else if (type == "n_invoices_client") {
                data = JSON.parse(data.data.n_invoices_client)
                for (var key in data.companies) {
                    result.push({
                        data: data.companies[key],
                        label: key,
                        fill: false,
                        borderColor: dynamicColors(),
                        borderWidth: 2
                    });
                }
                lineChart(data.dates, result);
                result = [];
            } else if (type == "sum_invoices") {
                data = JSON.parse(data.data.sum_invoices);
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
                console.log("line", data)
                lineChart(data.dates, result);
                result = [];
                var total_costs = data.costs_values.reduce((a, b) => a + b, 0);
                var total_gains = data.gains_values.reduce((a, b) => a + b, 0);
                pieChart(total_costs, total_gains);
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
        $("#prev").show();
        $("#preview").hide();
    });
});

$('#dropdown_type').change(function() {
    var $option = $(this).find('option:selected');
    var value = $option.val();
    if(value !== ""){
        graph_type = value;
        makeGraphic();
    }
});

$('#dropdown_delta').change(function() {
    var $option = $(this).find('option:selected');
    var value = $option.val();
    if(value !== ""){
        delta = value;
        makeGraphic();
    }
});

$('#dropdown_time').change(function() {
    var $option = $(this).find('option:selected');
    var value = $option.val();
    if(value !== ""){
        if (value == 6) {
            time = value * 30;
        } else if (value == 1) {
            time = 365
        }
        makeGraphic();
    }
});

$('#dropdown_options').change(function() {
    var $option = $(this).find('option:selected');
    var value = $option.val();
    if(value !== ""){
        is_count = value;
        makeGraphic();
    }
});