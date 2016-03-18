# source docker helpers
. util/docker.sh

@test "Start Container" {
  start_container "pulse-test"
}

@test "Verify pulse installed" {
  # ensure pulse executable exists
  run docker exec "pulse-test" bash -c "[ -f /usr/local/bin/pulse ]"

  [ "$status" -eq 0 ]
}

@test "Stop Container" {
  stop_container "pulse-test"
}
