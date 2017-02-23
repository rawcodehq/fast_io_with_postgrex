defmodule FastIoWithPostgrex do
  def import(filepath) do

    {:ok, pid} = Postgrex.start_link(name: :pg, pool: DBConnection.Poolboy, pool_size: 8, hostname: "localhost", username: "postgres", password: "postgres", database: "fp")

    File.stream!(filepath)
    |> Stream.map(fn line ->
      [id_str, word] = line |> String.trim |> String.split("\t", trim: true, parts: 2)

      {id, ""} = Integer.parse(id_str)

      [id, word]
    end)
    |> Stream.chunk(10_000, 10_000, [])
    |> Task.async_stream(fn word_rows ->
      Enum.each(word_rows, fn word_sql_params ->
        Postgrex.transaction(:pg, fn conn ->
          IO.inspect Postgrex.query!(conn, "INSERT INTO words(id, word) values($1, $2)", word_sql_params)
        end, pool: DBConnection.Poolboy, pool_timeout: :infinity, timeout: :infinity)
      end)
    end, max_concurrency: 8, timeout: :infinity)
    |> Stream.run
  end

end
