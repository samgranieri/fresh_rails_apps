def nuke_gemfile_comment(comment)
  gsub_file 'Gemfile', comment, ''
end
def add_readme_note(url)
  append_file("README.rdoc", "\nhttps://github.com/#{url}")
end
puts "Installing Bcrypt because we're going to need to use secure passwords"
uncomment_lines('Gemfile',"gem 'bcrypt'")

puts "Turbolinks is one of the worst ideas EVER!"
comment_lines('Gemfile',"gem 'turbolinks'")
gsub_file('Gemfile', "gem 'jbuilder', '~> 2.0'", "gem 'active_model_serializers'")
gsub_file('app/assets/javascripts/application.js', "//= require turbolinks", "")
gsub_file('app/views/layouts/application.html.erb', ", 'data-turbolinks-track' => true", "")

append_file('Gemfile', "# Webservers")
gem 'puma'
add_readme_note('puma/puma')

append_file('Gemfile', "\n\n#Views")
gem 'haml-rails'
add_readme_note('indirect/haml-rails')

append_file('Gemfile', "\n\n## Icon Fonts")

puts "I'm moving files around"
run 'mv app/assets/stylesheets/application.css app/assets/stylesheets/application.css.scss'

gem 'font-awesome-rails'
add_readme_note('bokmann/font-awesome-rails')
inject_into_file 'app/assets/stylesheets/application.css.scss', before: " */" do
  " *= require font-awesome\n"
end

append_file('Gemfile', "\n\n## Bootstrap")

gem 'bootstrap-sass', '~> 3.2.0'
add_readme_note('twbs/bootstrap-sass')
inject_into_file 'app/assets/stylesheets/application.css.scss', after: " */" do
  "\n@import 'bootstrap-sprockets';\n@import 'bootstrap';"
end
inject_into_file 'app/assets/javascripts/application.js', before: "//= require_tree ." do
  "//= require bootstrap-sprockets\n"
end

gem 'autoprefixer-rails'
add_readme_note('ai/autoprefixer-rails')

gem 'bootstrap_form'
add_readme_note('bootstrap-ruby/rails-bootstrap-forms')
inject_into_file 'app/assets/stylesheets/application.css.scss', before: " */" do
  " *= require rails_bootstrap_forms\n"
end

gem 'rails_bootstrap_navbar'
add_readme_note('bootstrap-ruby/rails-bootstrap-navbar')

append_file('Gemfile', "\n\n## Pagination")

gem 'kaminari'
add_readme_note('amatsuda/kaminari')
generate 'kaminari:config'

append_file('Gemfile', "\n\n# SEO")

gem 'meta-tags'
add_readme_note('kpumuk/meta-tags')

gem 'sitemap_generator'
add_readme_note('kjvarga/sitemap_generator')
rake 'sitemap:install'
prepend_file('config/sitemap.rb', "#TODO: change the url!\n")

gem 'rack-rewrite'
add_readme_note('jtrupiano/rack-rewrite')

append_file('Gemfile', "\n\n# Low level performance")

gem 'fast_blank'
add_readme_note('SamSaffron/fast_blank')
initializer "requires.rb", "require 'fast_blank'"

gem 'escape_utils'
add_readme_note('brianmario/escape_utils')
append_to_file('config/initializers/requires.rb', "\n")
append_to_file("config/initializers/requires.rb", "require 'escape_utils/html/rack'\n")
append_to_file("config/initializers/requires.rb","require 'escape_utils/html/erb'\n")
append_to_file("config/initializers/requires.rb","require 'escape_utils/html/cgi'\n")
append_to_file("config/initializers/requires.rb","require 'escape_utils/html/haml'\n")

gem 'oj'
add_readme_note('ohler55/oj')

gem 'oj_mimic_json'
add_readme_note('ohler55/oj_mimic_json')


append_file('Gemfile', "\n\n# Background Tasks")
gem 'sidekiq'
add_readme_note('mperham/sidekiq')
gem 'sinatra', require: false
gem 'slim'
append_to_file("config/initializers/requires.rb","require 'sidekiq/web'\n")
route "mount Sidekiq::Web, at: '/admin/sidekiq'"

uncomment_lines('config/environments/development.rb', "config.action_view.raise_on_missing_translations = true")
gem_group :development do

  gem 'quiet_assets'
  add_readme_note('evrone/quiet_assets')
  inject_into_file('config/environments/development.rb', after: "config.action_view.raise_on_missing_translations = true") do
    "\n  config.quiet_assets = true\n"
  end

  gem 'bullet'
  add_readme_note('flyerhzm/bullet')
  inject_into_file('config/environments/development.rb', after: "config.quiet_assets = true") do <<-'RUBY'

  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.growl = true
    # Bullet.xmpp = { :account  => 'bullets_account@jabber.org',
    #                 :password => 'bullets_password_for_jabber',
    #                 :receiver => 'your_account@jabber.org',
    #                 :show_online_status => true }
    Bullet.rails_logger = true
    # Bullet.bugsnag = true
    # Bullet.airbrake = true
    # Bullet.add_footer = true
    # Bullet.stacktrace_includes = [ 'your_gem', 'your_middleware' ]
  end
  RUBY
  end
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'i18n-tasks'
end
gem_group :development, :test do
end
