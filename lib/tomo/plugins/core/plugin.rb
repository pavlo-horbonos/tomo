require_relative "helpers"
require_relative "tasks"

module Tomo::Plugins::Core
  module Plugin
    extend Tomo::Plugin

    helpers Tomo::Plugins::Core::Helpers
    tasks Tomo::Plugins::Core::Tasks

    defaults application:           "default",
             concurrency:           10,
             current_path:          "%<deploy_to>/current",
             deploy_to:             "/var/www/%<application>",
             keep_releases:         10,
             linked_dirs:           [],
             release_path:          "%<current_path>",
             releases_path:         "%<deploy_to>/releases",
             revision_log_path:     "%<deploy_to>/revisions.log",
             shared_path:           "%<deploy_to>/shared",
             run_args:              [],
             ssh_executable:        "ssh",
             ssh_extra_opts:        [
               "-o", "ConnectTimeout=5",
               "-o", "PasswordAuthentication=no",
               "-o", "StrictHostKeyChecking=accept-new"
             ],
             ssh_forward_agent:     true,
             ssh_reuse_connections: true
  end
end