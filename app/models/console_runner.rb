require 'open3'

class ConsoleRunner
  def initialize(command)
    @stdin, @stdout, @stderr, @wait_thr = Open3.popen3(command)
  end

  def write_input(input)
    @stdin.puts(input)
  end

  def run
    output_text = @stdout.read
    error_text = @stderr.read
    status = @wait_thr.value

    @stdin.close
    @stdout.close
    @stderr.close

    return output_text, error_text, status
  end
end
