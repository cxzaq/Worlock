defmodule Worlock.TMDB do
  @apiKey System.get_env("OMDB_KEY")
  @baseUrl "http://www.omdbapi.com/?apikey=#{@apiKey}&"

  def search(q) do
    url = @baseUrl <> "s=#{URI.encode(q)}"
    res = HTTPoison.get(url)
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.decode!(body)
      {:ok, %HTTPoison.Response{status_code: 404 }} ->
        IO.puts "Not found"
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  def search(q, year) do
    url = @baseUrl <> "s=#{URI.encode(q)}y=#{year}"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.decode!(body)
      {:ok, %HTTPoison.Response{status_code: 404 }} ->
        IO.puts "Not found"
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end
end
