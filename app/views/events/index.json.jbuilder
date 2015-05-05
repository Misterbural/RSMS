json.array!(@events) do |event|
  json.extract! event, :id, :type, :text
  json.url event_url(event, format: :json)
end
