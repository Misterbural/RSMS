json.array!(@scheduleds) do |scheduled|
  json.extract! scheduled, :id, :content, :progress, :send_at
  json.url scheduled_url(scheduled, format: :json)
end
