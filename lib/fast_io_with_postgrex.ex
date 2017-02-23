defmodule FastIoWithPostgrex do
  def import(filepath) do

    {:ok, pid} = Postgrex.start_link(name: :pg, pool: DBConnection.Poolboy, pool_size: 8, hostname: "localhost", username: "postgres", password: "postgres", database: "fp")

    Postgrex.transaction(:pg, fn conn ->
      pg_copy = Postgrex.stream(conn, "COPY words(id, word) FROM STDIN", [])


      File.stream!(filepath)
      |> Enum.map(fn line ->
        [id, word] = line |> String.trim |> String.split("\t", trim: true, parts: 2)
        [id, ?\t, word, ?\n]
      end)
      |> Enum.into(pg_copy)

    end, pool: DBConnection.Poolboy, pool_timeout: :infinity, timeout: :infinity)
  end

  def export(filepath) do

    {:ok, pid} = Postgrex.start_link(name: :pg, pool: DBConnection.Poolboy, pool_size: 8, hostname: "localhost", username: "postgres", password: "postgres", database: "fp")

    Postgrex.transaction(:pg, fn conn ->
      pg_copy = Postgrex.stream(conn, "COPY (SELECT id, word FROM WORDS) TO STDOUT", [])

      pg_copy
      |> Enum.map(fn %Postgrex.Result{rows: rows} -> rows end)
      |> Enum.into(File.stream!(filepath))


    end, pool: DBConnection.Poolboy, pool_timeout: :infinity, timeout: :infinity)
  end
end
