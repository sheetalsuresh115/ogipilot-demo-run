import consumer from "./consumer"

consumer.subscriptions.create({ channel: "MeasurementChannel" }, {
  connected() {
    notify("Inside Consumer Connected")
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    notify("Disconnected Consumer")
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log("Received measurement:", data);
    addMeasurementsToChart(data);
  }
})

function addMeasurementsToChart(data) {
  const chart = window.vibrationsChart;
  chart.data.labels.push(new Date(data.created_at).toLocaleTimeString());
  chart.data.datasets[0].data.push(data.value);
  chart.update();
}