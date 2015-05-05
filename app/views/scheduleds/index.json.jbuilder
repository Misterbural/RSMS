json.array!(@scheduleds) do |scheduled|
  json.extract! scheduled, :id, :content, :prgress
  json.url scheduled_url(scheduled, format: :json)
end
