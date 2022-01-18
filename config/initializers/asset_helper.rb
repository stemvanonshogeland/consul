
require "asset_helpers"

Rails.application.config.assets.configure do |assets|
  assets.context_class.include(AssetHelpers)
end
