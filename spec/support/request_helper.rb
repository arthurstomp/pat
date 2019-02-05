module RequestHelper
  def login(user)
    json_headers.merge(login_headers(user))
  end

  def login_headers(user)
    {"authorization" => "Bearer: #{user.jwt}"}
  end

  def json_headers
    {"content_type" => "application/json"}
  end
end
