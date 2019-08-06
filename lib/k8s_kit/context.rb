require 'open3'

module K8sKit
  class Context
    attr_reader :namespace

    def initialize(namespace: nil)
      @namespace = namespace
    end

    def kubectl
      ns = namespace ? "-n #{namespace}" : ''
      "kubectl #{ns}"
    end

    def run(cmd, silent: true)
      cmd = "#{kubectl} #{cmd}"

      out = []
      Open3.popen2e(cmd) do |stdin, stdout_err, wait_thr|
        while line = stdout_err.gets
          puts line unless silent
          out << line
        end

        exit_status = wait_thr.value
        unless exit_status.success?
          abort "Failed: #{cmd}"
        end
      end

      out.join("\n").chomp
    end

    def pod(name)
      Pod.new(self, name)
    end

    def job(name)
      Job.new(self, name)
    end

    def wait_for_all_pods_ready(timeout: 300)
      t0 = Time.now

      loop do
        statuses = run('get pods -o jsonpath="{.items.*.status.containerStatuses[*].ready}"')
        return unless statuses.include?('false')

        raise StandardError, 'Timeout while waiting for pods to become ready' if t0 + timeout < Time.now

        puts 'Some pods are not ready yet, retrying...'
        sleep 5
      end
    end
  end
end
