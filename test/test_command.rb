require 'minitest_helper'
require 'command'

class TestCommand < Minitest::Test

  def test_command_output_parsing
    output = <<-EOF
  Reported at: Fri Jun 16 11:00:30 +08 2023 
 -----------------------------------------------------------------
  Disk space for HPC home directory
 -----------------------------------------------------------------
     HPC Home Dir        Usage      Quota      Limit    Status
  /home/svu/e0775105    1.57GB,      20GB,      20GB,   7.8%
 =================================================================

 -----------------------------------------------------------------
  Disk space for HPC WorkSpace
 -----------------------------------------------------------------
     HPC WorkSpace            Usage,            Limit,  Status
  /hpctmp/e0775105             0.00,          500.00G,   0.00%
 =================================================================
EOF
    quotas = Command.new.parse(output)

    assert_equal 1, quotas.count, "number of structs parsed should equal 1"

    q = quotas.first

    assert_equal "/home/svu/e0775105", q.homedir, "expected homedir value not correct"
    assert_equal "1.57GB,", q.home_usage, "expected home_usage value not correct"
    assert_equal "20GB,", q.home_limit, "expected home_limit value not correct"
    assert_equal "7.8%", q.home_status, "expected home_status value not correct"
    assert_equal "/hpctmp/e0775105", q.hpctmpdir, "expected hpctmpdir value not correct"
    assert_equal "0.00,", q.hpctmp_usage, "expected hpctmp_usage value not correct"
    assert_equal "500.00G,", q.hpctmp_limit, "expected hpctmp_limit value not correct"
    assert_equal "0.00%", q.hpctmp_status, "expected hpctmp_status value not correct"
  end
end
