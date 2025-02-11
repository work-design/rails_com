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

    def deploy_with
      ENV['HOST'] = host
      ENV['PRIVATE_KEY'] = private_key

      Dir.chdir('work.design') do
        yield
      end
    end

    def release
      deploy_with do
        cli = Kamal::Cli::Lock.new
        cli.release
      end
    end

    def deploy
      deploy_with do
        extra.each do |key, value|
          ENV[key] = value
        end
        cli = Kamal::Cli::Main.new
        cli.deploy
      end
    end

    def deploy_with_log(auth_token)
      deploy_with do
        extra.each do |key, value|
          ENV[key] = value
        end
        cli = Kamal::Cli::Main.new([], ['-v'])
        original_out = SSHKit.config.output
        SSHKit.config.output = SSHKit::Formatter::Pretty.new(LogChannelWriter.new(auth_token))

        cli.deploy

        SSHKit.config.output = original_out
      end
    end

    class_methods do

      def init_project
        cmds = [
          'git clone -b main --depth 1 root@yicanzhiji.com:work.design',
          'git -C work.design submodule update --init',
          'npm install'
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