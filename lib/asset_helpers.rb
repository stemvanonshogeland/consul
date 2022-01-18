module AssetHelpers
  def theme_asset_path(theme_name)
    load_path = Rails.application.config.x.theme.load_path

    theme_path = load_path.join("#{theme_name}.scss")
    theme_path if theme_path.exist?
  end

  def current_theme_name
    Rails.application.config.x.theme.current
  end
end
