class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  throttle('req/ip', limit: 300, period: 5.minutes) do |req|
    req.ip
  end

  throttle('session/ip', limit: 10, period: 60.seconds) do |req|
    if req.path == '/session' && req.post?
      req.ip
    end
  end

  throttle('session/email', limit: 10, period: 60.seconds) do |req|
    if req.path == '/session' && req.post?
      req.params['email'].presence
    end
  end

  throttle('users/ip', limit: 10, period: 60.seconds) do |req|
    if req.path == '/users' && req.post?
      req.ip
    end
  end
end
