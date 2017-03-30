defmodule CliTest do
	use ExUnit.Case

	import Issues.CLI, only: [parse_args: 1]

	test ":help returned with -h and --help" do
		assert parse_args(["-h", "anything"]) == :help
		assert parse_args(["--help", "anything"]) == :help
	end

	test "three values returned if three given" do
		assert parse_args(["user", "project", "1000"]) == {"user", "project", 1000}
	end

	test "uses default value when count not given" do
		assert parse_args(["user", "project"]) == {"user", "project", 4}
	end
end