require 'sshkey'
module Com
  module Model::SshKey
    extend ActiveSupport::Concern

    included do
      attribute :host, :string
      attribute :domain, :string
      attribute :private_key, :string
      attribute :public_key, :string
      attribute :fingerprint, :string
      attribute :extra, :json

      encrypts :private_key

      belongs_to :user, class_name: 'Auth::User', optional: true

      before_validation :generate_key_pair, on: :create
      before_save :calculate_fingerprint, if: -> { private_key_changed? }

      validates :host, presence: true
      validates :private_key, presence: true
      validates :public_key, presence: true
    end

    def generate_key_pair
      ssh_key = SSHKey.generate
      self.private_key = ssh_key.private_key
      self.public_key = ssh_key.ssh_public_key
    end

    def calculate_fingerprint
      self.fingerprint = SSHKey.fingerprint(public_key)
    end

    def deploy
      ENV['HOST'] = host
      ENV['PRIVATE_KEY'] = private_key
      extra.each do |key, value|
        ENV[key] = value
      end

      Dir.chdir('work.design') do
        cli = Kamal::Cli::Main.new
        # 重定向标准输出和错误输出到一个StringIO对象
        original_stdout = $stdout
        original_stderr = $stderr
        read_io, write_io = IO.pipe

        $stdout = write_io
        $stderr = write_io

        # 在新线程中执行部署
        deploy_thread = Thread.new do
          begin
            cli.deploy
          ensure
            write_io.close
          end
        end

        # 在主线程中读取并yield输出
        if block_given?
          read_io.each_line do |line|
            yield line
          end
        end

        # 等待部署线程完成
        deploy_thread.join
      ensure
        # 恢复标准输出和错误输出
        $stdout = original_stdout
        $stderr = original_stderr
        read_io.close
      end
    end

    class_methods do

      def init_project
        cmds = [
          'git clone -b main --depth 1 root@yicanzhiji.com:work.design',
          'git -C work.design submodule update --init'
        ]
        cmds.each { |i| exec_cmd(i) }
      end

      def exec_cmd(cmd)
        Open3.popen2e(cmd) do |_, output, thread|
          logger.info "\e[35m  #{cmd} (PID: #{thread.pid})  \e[0m"
          output.each_line do |line|
            logger.info "  #{line.chomp}"
          end
          puts "\n"
        end
      end

    end

  end
end