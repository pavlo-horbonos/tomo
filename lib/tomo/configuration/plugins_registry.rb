module Tomo
  class Configuration
    class PluginsRegistry
      attr_reader :helper_modules

      def initialize(settings_registry:, tasks_registry:)
        @helper_modules = []
        @settings_registry = settings_registry
        @tasks_registry = tasks_registry
      end

      def core_loaded?
        return false unless defined?(Tomo::Plugin::Core::Plugin)

        helper_modules.include?(Tomo::Plugin::Core::Plugin)
      end

      def load_plugins_by_name(names)
        names.each { |name| load_plugin_by_name(name) }
      end

      def load_plugin_by_name(name)
        plugin = PluginResolver.resolve(name)
        load_plugin(name, plugin)
      end

      def load_plugin(namespace, plugin_class)
        Tomo.logger.debug("Loading plugin #{plugin_class}")

        helper_modules.push(*plugin_class.helper_modules)
        settings_registry.define_settings(plugin_class.default_settings)
        tasks_registry.register_task_libraries(
          namespace,
          *plugin_class.tasks_classes
        )
      end

      private

      attr_reader :settings_registry, :tasks_registry
    end
  end
end