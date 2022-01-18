Setting.add_new_settings
Map.default

WebSection.where(name: "homepage").first_or_create!
WebSection.where(name: "debates").first_or_create!
WebSection.where(name: "proposals").first_or_create!
WebSection.where(name: "budgets").first_or_create!
WebSection.where(name: "help_page").first_or_create!

# Default custom pages
load Rails.root.join("db", "pages.rb")
