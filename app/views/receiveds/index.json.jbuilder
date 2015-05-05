json.array!(@receiveds) do |received|
  json.extract! received, :id, :send_by, :content, :is_command
  json.url received_url(received, format: :json)
end
