require 'sinatra'
require 'rack/handler/puma'
require 'faraday'

set :public_folder, 'public'
set :views, File.expand_path('views', __dir__)

get '/' do
  return redirect to "/#{params['token']}" if params['token']

  response = Faraday.get('http://api:4000/api/tests')

  if response.status == 200
    @tests = JSON.parse(response.body)
    erb :index
  elsif response.status == 404
    erb 'No momento, não há exames em nossa base de dados.'
  else
    erb '<h5>Não foi possível conectar-se com a base de dados</h5>'
  end
end

get '/:test_token' do
  return redirect to "/#{params['token']}" if params['token']

  response = Faraday.get("http://api:4000/api/test/#{params[:test_token]}")
  if response.status == 200
    @test = JSON.parse(response.body)
    erb :show
  else
    erb '<h5>Não foi possível encontrar este exame...</h5>'
  end
end
