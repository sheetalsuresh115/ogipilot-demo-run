import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"
Chart.register(...registerables)

import "moment"
import "chartjs-adapter-moment"

export default class extends Controller {
    connect() {
      measurementSetup();
    }
}

function measurementSetup() {
  let timestamps = JSON.parse(document.getElementById('timestamps-data') ? document.getElementById('timestamps-data').getAttribute('data-timestamps') : null)
  let vibrations = JSON.parse(document.getElementById('vibrations-data') ? document.getElementById('vibrations-data').getAttribute('data-vibrations') : null)
  let chart
  let dataPoints = [];
  vibrations.forEach((number, index) => {
    dataPoints.push({ x: timestamps[index], y:vibrations[index] })
  });
  document.addEventListener('DOMContentLoaded', () => {
    var ctx = document.getElementById('vibrationsChart');
    if (ctx) {
      const data = {
        labels: [],//timestamps,
        datasets: [{
          label: ' Vibrations ',
          fill: false,
          data: dataPoints,
          borderColor: "#308af3",
          pointBackgroundColor: "#308af3",
          pointBorderWidth: 2,
          pointHoverBackgroundColor: "#fff",
          pointHoverBorderWidth: 2,
          lineTension: 0.05
        }]
      };

      const options = {
        scales: {
          x: {
            type: 'time',
            time: {
              unit: 'second'
            }
          },
          y: {
            beginAtZero: true
          },
        },
        plugins: {
          legend: { display: false },
        }
      };

      const config = {  
        type: 'line',
        data: data,
        options: options,
      };
  
      chart = new Chart(ctx, config);
    }


    document.addEventListener("measurementReceived", function (event) {
      chart.data.datasets.forEach((dataset) => {
        if (dataset.data.length >= 10) dataset.data.shift();
        dataset.data.push(JSON.parse(event.detail.value));
      });
      chart.update();
    });
  });
}