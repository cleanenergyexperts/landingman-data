require "middleman-core"

###
# NOTE: There seems to be a bug in Middleman, where try is used
# but not required, causing errors. Including it here should fix
# this
###
require 'active_support/core_ext/object/try'

Middleman::Extensions.register :landingman_data do
  require "landingman-data/extension"
  ::Landingman::DataExtension
end
