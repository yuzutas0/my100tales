json.array!(@tales) do |tale|
  json.extract! tale, :id, :title, :content, :user_id
  json.url tale_url(tale, format: :json)
end
