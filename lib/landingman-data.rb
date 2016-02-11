require "middleman-core"

Middleman::Extensions.register :landingman_data do
  require "landingman-data/extension"
  ::Landingman::DataExtension
end
