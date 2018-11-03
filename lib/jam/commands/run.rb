module Jam
  module Commands
    class Run
      def parser
        Jam::CLI::Parser.new do |parser|
          parser.banner = <<~BANNER
            Usage: jam run [options] [--] TASK [ARGS...]

            Remotely run one specified TASK, optionally passing ARGS to that task.
            For example, if this project uses the "rails" plugin, you could run:

              jam run -- rails:console --sandbox

            This will run the `rails:console` task on the host specified in
            .jam/project.json, and will pass the `--sandbox` argument to that task.
            The `--` is used to separate jam options from options that are passed
            to the task. If a task does not accept options, the `--` can be omitted.

            Available tasks are those defined by plugins loaded in .jam/project.json,
            or can also be custom tasks defined in .jam/tasks.rb. To see a list of
            available tasks, run:

              jam tasks
          BANNER
          parser.permit_extra_args = true
          parser.add(Jam::CLI::DeployOptions)
        end
      end

      def call(options)
        task, *args = options[:extra_args]

        project = Jam.load_project!(
          environment: options[:environment],
          settings: options[:settings].merge(run_args: args)
        )

        Jam.framework.connect(project["host"]) do
          Jam.framework.invoke_task(task)
        end
      end
    end
  end
end