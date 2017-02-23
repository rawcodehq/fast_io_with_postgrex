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
      Postgrex.transaction(:pg, fn conn ->
        pg_copy = Postgrex.stream(conn, "COPY words(id, word) FROM STDIN", [])

        word_rows # => [[1, "Awesome"], [2, "Raw"]]
        |> Enum.map(fn [id, word] ->
          [to_string(id), ?\t, word, ?\n] end)
        |> Enum.into(pg_copy)

      end, pool: DBConnection.Poolboy, pool_timeout: :infinity, timeout: :infinity)
    end, max_concurrency: 8, timeout: :infinity)
    |> Stream.run
  end

end
