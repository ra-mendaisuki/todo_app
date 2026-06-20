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
    |> mist.bind("localhost")
    |> mist.with_ipv6
    |> mist.port(4000)
    |> mist.start

  process.sleep_forever()
}
