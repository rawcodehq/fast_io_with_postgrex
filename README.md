# FastIoWithPostgrex

Screencast link: https://www.youtube.com/watch?v=YQyKRXCtq4s

Fast Import and Export with Elixir and Postgrex - Elixir Hex package showcase
Watch us cut the import time from 4 minutes to 1 minute to 1 second and then back to 1.7 seconds :)

# NOTES
    # A connection pool
    elixir      db
      --tcp cx--
      --tcp cx--
      --tcp cx--
      --tcp cx--
      --tcp cx--
      --tcp cx--
      --tcp cx--
      --tcp cx--
      --tcp cx--

## Dataset size ~100_000

## INSERT/IMPORT into postgresql

    on a single process using INSERT
    real    3m41.377s
    user    0m29.380s
    sys     0m8.996s

    on 8 processes using INSERT
    real    1m8.839s
    user    0m38.316s
    sys     0m11.332s

    on 8 processes using COPY
    real    0m1.162s
    user    0m1.500s
    sys     0m0.220s

    on a single process using COPY
    real    0m1.747s
    user    0m1.460s
    sys     0m0.460s

## EXPORT from postgresql

    real    0m0.640s
    user    0m0.644s
    sys     0m0.176s

## Configuration

One thing I didn't cover in this episode was using the `config` for configuration, you can do it using:

    {:ok, pid} = Application.get_env(:fast_io_with_postgrex, :postgrex)
                  |> Postgrex.start_link
