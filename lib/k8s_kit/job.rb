module K8sKit
  class Job
    attr_reader :context, :name

    def initialize(context, name)
      @context = context
      @name = name
    end

    def attach(container:, delete_on_completion: true, exit_on_completion: true)
      pod.wait_until_ready
      pod.logs(container: container, stream: true)
      exit_code = pod.exit_code(container: container)

      delete if delete_on_completion
      exit exit_code if exit_on_completion

      exit_code
    end

    def delete
      context.run("delete job #{name}")
    end

    def pod
      @pod ||= begin
        pod_name = context.run("get pod -l job-name=#{name} -o jsonpath='{.items[0].metadata.name}'")
        Pod.new(context, pod_name)
      end
    end
  end
end
