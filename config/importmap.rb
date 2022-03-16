# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "fetch"
pin "trix"
pin "@rails/actiontext", to: "actiontext.js"
pin "popper", to: "popper.js", preload: true
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "handsontable", to: "handsontable.full.min.js"
pin "tom-select" # @2.0.1
pin "pikaday" # @1.8.2
pin "moment" # @2.29.1
pin "@splidejs/splide", to: "@splidejs--splide.js" # @3.6.11
pin "clipboard" # @2.0.10
