module SwaggerRoutes
  def self.registered(app)
    return unless ENV['APP_ENV'] == 'development'

    app.get '/swagger' do
      send_file File.join(app.settings.public_folder, 'swagger/index.html')
    end

    app.get '/openapi.yml' do
      send_file File.join(app.settings.root, 'docs/openapi.yml')
    end
  end
end
