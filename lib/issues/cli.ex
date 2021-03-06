defmodule Issues.CLI do
	@default_count 4

	@moduledoc """
		Module to parse the commands entered on the command line
		and delegate it to the appropriate functions
	"""
	def run(argv) do
		argv
			|> parse_args
			|> process
			|> convert_to_list_of_hashdicts
			|> sort_into_ascending_order
			|> Enum.take(count)
			|> IO.inspect
	end

	def parse_args(argv) do
		parse = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
		case parse do
			{[help: true], _, _} -> :help
			{_, [user, project, count], _} -> {user, project, String.to_integer(count)}
			{_, [user, project], _} -> {user, project, @default_count}
			_ -> :help
		end
	end

	def process(:help) do
		IO.puts """
			usage: issues <user> <project> [count | #@default_count]
		"""
		System.halt(0)
	end

	def process({user, project, _count}) do
		Issues.GithubIssues.fetch(user, project)
		|>decode_response
	end

	def decode_response({:ok, body}), do: body
	def decode_response({:error, error}) do
		{_, message} = List.keyfind(error, "message", 0)
		IO.puts "Error :: #{message}"
		System.halt(2)
	end

	def convert_to_list_of_hashdicts(list) do
		list
		|> Enum.map(&Enum.into(&1, HashDict.new))
	end

	def sort_into_ascending_order(list) do
		Enum.sort(list, (fn i1, i2 -> i1["created_at"] <= i2["created_at"] end))
	end
end