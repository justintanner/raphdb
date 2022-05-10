# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "trix"
pin "@rails/actiontext", to: "actiontext.js"
pin "popper", to: "popper.js", preload: true
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "tom-select" # @2.0.1
pin "@splidejs/splide", to: "@splidejs--splide.js" # @3.6.11
pin "clipboard" # @2.0.10
pin "fslightbox" # @3.3.1
pin "storejs" # @2.0.1
pin "@rails/request.js", to: "@rails--request.js.js" # @0.0.6
pin "moment" # @2.29.3
pin "pikaday" # @1.8.2
pin "sortablejs" # @1.15.0
