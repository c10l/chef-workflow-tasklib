begin
  Rake::Task["cookbook:resolve"].clear
  Rake::Task["cookbook:update"].clear
rescue
end

require 'chef-workflow/tasks/bootstrap/knife'
require 'chef-workflow/tasks/cookbook/resolve_and_upload'

# Both berkshelf and librarian have ... aggressive dependencies. They usually are
# a great way to break your Gemfile if you have chef in it.
namespace :cookbook do
  desc "Resolve cookbooks and populate #{$knife_support.cookbooks_path} using Berkshelf"
  task :resolve => [ "bootstrap:knife" ] do
    Bundler.with_clean_env do
      sh "berks install --shims #{$knife_support.cookbooks_path} -c #{$knife_support.knife_config_path}"
    end
  end

  desc "Update your locked cookbooks with Berkshelf"
  task :update => [ "bootstrap:knife" ] do
    Bundler.with_clean_env do
      sh "berks update -c #{$knife_support.knife_config_path}"
    end
  end
end