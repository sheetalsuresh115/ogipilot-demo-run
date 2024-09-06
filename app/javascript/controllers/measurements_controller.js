import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"
Chart.register(...registerables)

export default class extends Controller {
    connect() {
      measurementSetup();
    }
}

function measurementSetup() {
  document.addEventListener('DOMContentLoaded', () => {
    var ctx = document.getElementById('vibrationsChart');
    if (ctx) {
      const data = {
        labels: [1, 2, 3, 4, 5, 6, 7],
        datasets: [{
          label: ' Vibrations ',
          data: [65, 59, 80, 81, 56, 55, 40],
          fill: false,
          borderColor: "#308af3",
          pointBackgroundColor: "#308af3",
          pointBorderWidth: 2,
          pointHoverBackgroundColor: "#fff",
          pointHoverBorderWidth: 2,
          lineTension: 0.05
        }]
      };

      const options = {
        plugins: {
          legend: { display: false },
        }
      };

      const config = {
        type: 'line',
        data: data,
        options: options,
      };
      new Chart(ctx, config);
    }
  });
}
