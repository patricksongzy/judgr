require 'open3'

class ConsoleRunner
  def initialize(command)
    @stdin, @stdout, @stderr, @wait_thr = Open3.popen3(command)
  end

  def write_input(input)
    @stdin.puts(input)
  end

  def finish
    output_text, error_text = read_streams
    status = @wait_thr.value

    @stdin.close
    @stdout.close
    @stderr.close

    return output_text, error_text, status
  end

  def kill
    @stdin.close
    @stdout.close
    @stderr.close

    begin
      Process.kill("SIGTERM", @wait_thr.pid)
    rescue Errno::ESRCH
      # the process has terminated normally
    end
  end

  def read_streams
    output_text = ""
    Thread.new do
      output_text = @stdout.read
    end.join

    error_text = ""
    Thread.new do
      error_text = @stderr.read
    end.join

    return output_text, error_text
  end
end
