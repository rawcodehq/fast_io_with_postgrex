# FastIoWithPostgrex

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

