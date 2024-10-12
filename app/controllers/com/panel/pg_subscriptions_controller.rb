module Com
  class Panel::PgSubscriptionsController < Panel::BaseController
    before_action :set_tables
    before_action :set_pg_subscription, only: [:show, :edit, :update, :destroy, :refresh]

    def index
      @pg_subscriptions = PgSubscription.page(params[:page])
    end

    def new
      @pg_subscription = PgSubscription.new
    end

    def create
      conninfo = conninfo_params.to_h.each_with_object([]) { |(k, v), h| h << "#{k}=#{v}" }.join(' ')
      PgSubscription.connection.exec_query "CREATE SUBSCRIPTION #{pg_subscription_params[:subname]} CONNECTION '#{conninfo}' PUBLICATION #{pg_subscription_params[:pubname]}"
    end

    def update
      PgSubscription.connection.exec_query "ALTER SUBSCRIPTION #{@pg_subscription.pubname} SET TABLE #{allow_tables.join(', ')}"
    end

    def refresh
      PgSubscription.connection.exec_query "ALTER SUBSCRIPTION #{@pg_subscription.subname} REFRESH PUBLICATION"
    end

    def destroy
      PgSubscription.connection.exec_query "DROP SUBSCRIPTION #{@pg_subscription.subname}"
    end

    private
    def set_tables
      @tables = ApplicationRecord.connection.tables
    end

    def set_pg_subscription
      @pg_subscription = PgSubscription.find(params[:id])
    end

    def conninfo_params
      params.fetch(:pg_subscription, {}).permit(
        :host,
        :port,
        :dbname,
        :user,
        :password
      )
    end

    def pg_subscription_params
      params.fetch(:pg_subscription, {}).permit(
        :subname,
        :pubname
      )
    end

  end
end
