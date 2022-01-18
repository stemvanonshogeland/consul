# Sprockets recompiles an asset file that has been cached, when that file or one
# of its dependencies changes. The theme CSS file can change without any file
# changes because its content are dynamically changed based on the theme. Hence
# we explicitly register the current theme as a dependency for all assets.

Sprockets.register_dependency_resolver "config" do |env, str|
  config = Rails.application.config
  path = str.delete_prefix("config:").split(".")

  path.reduce(config) do |memo, method|
    memo.public_send(method)
  end
end

Sprockets.depend_on "config:x.theme.current"
