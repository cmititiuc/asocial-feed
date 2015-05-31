json.array!(@posts) do |post|
  json.extract! post, :id, :body, :user_id, :topic_id
  json.url post_url(post, format: :json)
end
