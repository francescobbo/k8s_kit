module K8sKit
  class Pod
    attr_reader :context, :name

    def initialize(context, name)
      @context = context
      @name = name
    end

    def logs(container: nil, stream: false)
      command = "logs #{name}"
      command += " -c #{container}" if container
      command += " -f" if stream

      context.run(command, silent: false)
    end

    def wait_until_ready(timeout: '5m')
      context.run("wait pod/#{name} --for=condition=Ready --timeout=#{timeout}")
    end

    def exit_code(container:)
      json_path = "{ .status.containerStatuses[?(@.name == '#{container}')].state.terminated.exitCode }"
      context.run("get pod #{name} -o jsonpath=\"#{json_path}\"").to_i
    rescue StandardError
      nil
    end
  end
end
