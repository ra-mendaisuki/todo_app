import gleam/erlang/process
import logging
import mist
import routes/router

pub fn main() {
  logging.configure()
  logging.set_level(logging.Debug)

  let assert Ok(_) =
    router.router
    |> mist.new
    |> mist.bind("0.0.0.0")
    |> mist.port(8080)
    |> mist.start

  process.sleep_forever()
}
