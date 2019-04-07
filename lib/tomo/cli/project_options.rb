module Tomo
  class CLI
    module ProjectOptions
      def self.included(mod)
        mod.class_eval do
          option :project,
                 "-p, --project PATH",
                 "Location of project config (default: .tomo/project.rb)"
        end
      end

      private

      # rubocop:disable Metrics/AbcSize
      def configure_runtime(options, strict: true)
        config = load_configuration(options)
        env = options[:environment]
        env = config.environments.keys.first if env.nil? && !strict
        config.settings.merge!(settings_from_env)
        config.settings.merge!(settings_from_options(options))
        yield(config) if block_given?
        config.build_runtime(environment: env)
      end
      # rubocop:enable Metrics/AbcSize

      def load_configuration(options)
        path = options[:project] || ".tomo/project.rb"
        @config_cache ||= {}
        @config_cache[path] ||= Configuration.from_project_rb(path)
      end

      def settings_from_options(options)
        options.all(:settings).each_with_object({}) do |arg, settings|
          name, value = arg.split("=", 2)
          settings[name.to_sym] = value
        end
      end

      def settings_from_env
        ENV.each_with_object({}) do |(key, value), result|
          setting_name = key[/^TOMO_(\w+)$/i, 1]&.downcase
          next if setting_name.nil?

          result[setting_name.to_sym] = value
        end
      end
    end
  end
end