require "sinatra"
require "sinatra/json"
require "sequel"

DB = Sequel.connect(ENV['DATABASE_URL'] || "postgres://localhost/joeldb")
DB.extension :pg_array

module JoelMe
  class Joel < Sequel::Model
    def before_save
      self.tags ||= Sequel.pg_array([])
      self.tags = self.tags.collect {|t| t.to_s.downcase.strip}.uniq
      super
    end
  end

  class App < ::Sinatra::Base
    get '/' do
      "Here there be joels"
    end

    get '/random' do
      joel = Joel.order(Sequel.lit('RANDOM()')).first

      return 404 unless joel

      json joel: joel.url
    end

    get '/bomb' do
      count = params[:count].to_i || 5
      count = 5 if count < 1

      joels = Joel.order(Sequel.lit('RANDOM()')).limit(count)
      json joels: joels.collect(&:url)
    end

    get '/count' do
      count = Joel.count
      json joel_count: count
    end

    get '/:name' do
      joel = Joel.where("? = ANY (tags)", params[:name]).first

      return 404 unless joel

      json joel: joel.url
    end
  end
end
