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
    rdin, rdout, rderr = IO.select([@stdin], [@stdout], [@stderr])
    if rdin
      results = []
      results.push(rdout.member? @stdout ? @stdout.read : "")
      results.push(rderr.member? @stderr ? @stderr.read : "")

      return results
    end
  end
end
