# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js", preload: true
pin "popper", to: "https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js", preload: true

pin "jquery-slim-min", to: "https://code.jquery.com/jquery-3.7.1.slim.min.js"

# add the bootstrap dropdown connection here
pin "@rails/actioncable", to: "actioncable.esm.js"
pin_all_from "app/javascript/channels", under: "channels"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "chart.js", to: "https://cdn.jsdelivr.net/npm/chart.js@4.4.4/+esm" # @4.4.4
pin "@kurkle/color", to: "@kurkle--color.js" # @0.3.2

pin "chartjs-adapter-moment" # @1.0.1
pin "moment" # @2.30.1
