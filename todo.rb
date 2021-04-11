require 'sinatra/reloader'

class Todo < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    file = File.read('./data.json')
    data_hash = JSON.parse(file)
    @items = data_hash.sort_by! { |item| item['completed'] ? 1 : 0 }
    erb :index
  end

  post '/item' do
    new_item = {
      id: SecureRandom.uuid,
      name: params["name"],
      completed: false
    }
    file = File.read('./data.json')
    data_hash = JSON.parse(file)
    data_hash << new_item
    File.write('./data.json', JSON.dump(data_hash))
    redirect '/'
  end

  post '/done' do
    file = File.read('./data.json')
    data_hash = JSON.parse(file)
    element = data_hash.find{ |e| e['id'] == params['id'] }
    element["completed"] = true
    File.write('./data.json', JSON.dump(data_hash))
    redirect '/'
  end

  post '/delete' do
    file = File.read('./data.json')
    data_hash = JSON.parse(file)
    data_hash.delete_if { |element| element["id"] == params["id"] }
    File.write('./data.json', JSON.dump(data_hash))
    redirect '/'
  end
end
