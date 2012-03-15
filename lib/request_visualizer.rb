require 'colored'
class RequestVisualizer
  def initialize(app, &lookup)
    @app = app
    @lookup = lookup
  end

  def parse(string)
    ((@lookup && @lookup.call(string.to_s)) || string.to_s).black_on_cyan
  end

  def indent
    " "*@@indent
  end

  def log_request(request)
    from = parse(request.user_agent.to_s)
    to = parse(request.url.to_s)
    puts "#{self.indent}#{from} -> #{request.request_method.upcase.bold} (#{request.url.underline}) -> #{to}"
    request.body.rewind
    req_body = request.body.read
    begin
      json = JSON.parse(req_body)
      indent_prefix = self.indent
      puts indent_prefix + json.pretty_inspect.gsub("\n","\n#{indent_prefix}")
    rescue => e
      # puts "WARN: JSON request with non-json body! (#{req_body})"
    end
    request.body.rewind
    [from, to]
  end

  def log_response(from, to, headers, body, status)
    location = headers["Location"]
    if location
      puts "#{self.indent}#{from} <--#{status}-- #{location.underline} <- #{to}"
    else
      puts "#{self.indent}#{from} <--#{status}-- #{to}"
    end
    do_inspect = true
    if headers["Content-Type"].to_s.match(/json/) && do_inspect
      body.each do |bod|
        begin
          json = JSON.parse(bod)
          indent_prefix = self.indent
          puts indent_prefix + json.pretty_inspect.gsub("\n","\n#{indent_prefix}")
        rescue => e
          puts "WARN: JSON response with non-json body! (#{bod})"
        end
      end
    end
  end

  def call(env)
    @@indent ||= 0
    @@indent += 5
    from, to = log_request(Rack::Request.new(env))
    status, headers, body = @app.call(env)
    log_response(from, to, headers, body, status)
    @@indent -= 5
    [status, headers, body]
  end
end
