# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js", preload: true
# pin "popper", to: "https://cdn.jsdelivr.net/npm/popper@1.0.1/+esm"
pin "popper", to: "https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/esm/popper.js"
pin "jquery-slim-min", to: "https://code.jquery.com/jquery-3.7.1.slim.min.js"

# add the bootstrap dropdown connection here
pin "@rails/actioncable", to: "actioncable.esm.js"
pin_all_from "app/javascript/channels", under: "channels"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "chart.js", to: "https://cdn.jsdelivr.net/npm/chart.js@4.4.0/+esm" # @4.4.0
pin "@kurkle/color", to: "@kurkle--color.js" # @0.3.2
pin "date-fns" # @4.0.0
pin "chartjs-adapter-date-fns" # @3.0.0

# pin "chart.js/helpers", to: "https://cdn.jsdelivr.net/npm/chart.js@3.0.0/dist/helpers.esm.js"
# pin "luxon", to: "https://cdn.jsdelivr.net/npm/luxon@2.0.0/build/node/luxon.js"
# pin "chartjs-adapter-luxon", to: "https://cdn.jsdelivr.net/npm/chartjs-adapter-luxon@1.0.0/dist/chartjs-adapter-luxon.min.js"
# pin "chartjs-plugin-streaming", to: "https://cdn.jsdelivr.net/npm/chartjs-plugin-streaming@2.0.0/dist/chartjs-plugin-streaming.esm.js"
pin "moment" # @2.30.1
pin "chartjs-adapter-moment" # @1.0.1
