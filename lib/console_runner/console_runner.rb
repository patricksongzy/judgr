require 'open3'

class ConsoleRunner
  def initialize(command)
    @stdin, @stdout, @stderr, @wait_thr = Open3.popen3(command)
  end

  def write_input(input)
    @stdin.puts(input)
  end

  def finish
    @stdin.close

    output_text, error_text = read_streams
    @stdout.close
    @stderr.close

    status = @wait_thr.value

    return output_text, error_text, status
  end

  def kill
    @output_thread.kill if @output_thread
    @error_thread.kill if @error_thread

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
    @output_thread = Thread.new do
      output_text = @stdout.read
    end.join

    error_text = ""
    @error_thread = Thread.new do
      error_text = @stderr.read
    end.join

    return output_text, error_text
  end
end
