class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  throttle('req/ip', limit: 300, period: 5.minutes) do |req|
    req.ip
  end

  throttle('session/ip', limit: 5, period: 60.seconds) do |req|
    if req.path == '/session' and  req.post?
      req.ip
    end
  end

  throttle('session/email', limit: 5, period: 60.seconds) do |req|
    if req.path == '/session' and req.post?
      req.params['email'].presence
    end
  end

  throttle('users/ip', limit: 5, period: 1.day) do |req|
    if req.path == '/users' and req.post?
      req.ip
    end
  end

  throttle('passwords/ip', limit: 5, period: 1.day) do |req|
    if req.path == '/passwords' and req.post?
      req.ip
    end
  end

  LOGGER = Logger.new("#{Rails.root}/log/violations.log")
  ActiveSupport::Notifications.subscribe(/rack_attack/) do |name, start, finish, request_id, payload|
    req = payload[:request]
    msg = [req.env['rack.attack.match_type'], req.ip, req.request_method, req.fullpath, ('"' + req.user_agent.to_s + '"')].join(' ')
    if %i[throttle blocklist].include?(req.env['rack.attack.match_type'])
      LOGGER.error(msg)
    else
      LOGGER.info(msg)
    end
  end
end
