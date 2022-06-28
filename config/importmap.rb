# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.0.1
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "trix"
pin "@rails/actiontext", to: "actiontext.js"
pin "popper", to: "popper.js", preload: true
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "tom-select" # @2.0.3
pin "clipboard" # @2.0.10
pin "fslightbox" # @3.3.1
pin "storejs" # @2.0.1
pin "@rails/request.js", to: "@rails--request.js.js" # @0.0.6
pin "sortablejs" # @1.15.0
pin "@splidejs/splide", to: "@splidejs--splide.js" # @4.0.1
pin "cropperjs" # @1.5.12, imported manually using the cropper.umd.js file, other dist files did not work.
pin "stimulus-use" # @0.50.0
pin "hotkeys-js" # @3.9.4
pin "vanillajs-datepicker" # @1.2.0
