require 'open3'

class Command
  def to_s
    "/home/svu/e0775105/bin/hpcs"
  end

  Quota = Struct.new(:homedir, :home_usage, :home_quota, :home_limit, :home_status, :hpctmpdir, :hpctmp_usage, :hpctmp_limit, :hpctmp_status)

  # Parse a string output from the `ps aux` command and return an array of
  # AppProcess objects, one per process
  def parse(output)
    lines = output.strip.split("\n")
    line5 = lines[5].tr(',', ' ')
    line12 = lines[12].tr(',', ' ')
    [Quota.new(*(line5.split + line12.split))]
  end

  # Execute the command, and parse the output, returning and array of
  # AppProcesses and nil for the error string.
  #
  # returns [Array<Array<AppProcess>, String] i.e.[processes, error]
  def exec
    processes, error = [], nil

    stdout_str, stderr_str, status = Open3.capture3(to_s)
    if status.success?
      processes = parse(stdout_str)
    else
      error = "Command '#{to_s}' exited with error: #{stderr_str}"
    end

    [processes, error]
  end
end
