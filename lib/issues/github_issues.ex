defmodule Issues.GithubIssues do
	@github_url Application.get_env(:issues, :github_url)
	
	def fetch(user, project) do
		issues_url(user, project)
		|> HTTPoison.get
		|> handle_response
	end

	def issues_url(user, project) do
		"#{@github_url}/repos/#{user}/#{project}/issues"
	end

	def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}), do: {:ok, body|>Poison.Parser.parse!}
	def handle_response({:ok, %HTTPoison.Response{status_code: _, body: body}}), do: {:error, body|>Poison.Parser.parse!}

end