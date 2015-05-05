json.array!(@sendeds) do |sended|
  json.extract! sended, :id, :target, :content
  json.url sended_url(sended, format: :json)
end
