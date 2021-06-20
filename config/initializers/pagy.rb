# Be sure to restart your server when you modify this file.
# frozen_string_literal: true

require 'pagy/extras/bootstrap'
require 'pagy/extras/metadata'

Pagy::I18n.load(locale: 'es')
Pagy::VARS[:items] = 20
