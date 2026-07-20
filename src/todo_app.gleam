import gleam/erlang/process
import mist
import routes/router
import wisp
import wisp/wisp_mist

pub fn main() {
  wisp.configure_logger()
  let secret_key_base = wisp.random_string(64)

  let assert Ok(_) =
    wisp_mist.handler(router.handle_request, secret_key_base)
    |> mist.new
    |> mist.bind("0.0.0.0")
    |> mist.port(8080)
    |> mist.start

  process.sleep_forever()
}

// import gleam/erlang/process
// import logging
// import mist
// import routes/router

// pub fn main() {
//   logging.configure()
//   logging.set_level(logging.Debug)

//   let assert Ok(_) =
//     router.router
//     |> mist.new
//     |> mist.bind("0.0.0.0")
//     |> mist.port(8080)
//     |> mist.start

//   process.sleep_forever()
// }
