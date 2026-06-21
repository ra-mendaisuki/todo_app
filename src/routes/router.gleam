// import gleam/http/request.{type Request}
// import gleam/http/response.{type Response}
// import logging
// import mist.{type Connection, type ResponseData}
import lustre/element/html.{html}
import lustre/attribute
import lustre/element
import controllers/hello_world
import controllers/not_found
import controllers/todo_view
import controllers/lustre_view
import gleam/http.{Get, Post}
import wisp.{type Request, type Response}

pub fn middleware(
  req: wisp.Request,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let req = wisp.method_override(req)
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)
  use req <- wisp.csrf_known_header_protection(req)

  handle_request(req)
}
pub fn handle_request(req: Request) -> Response {
  use req <- middleware(req)

  // Wisp doesn't have a special router abstraction, instead we recommend using
  // regular old pattern matching. This is faster than a router, is type safe,
  // and means you don't have to learn or be limited by a special DSL.
  //
  case wisp.path_segments(req) {
    [] ->todo_view.list(req)
    ["create"] ->todo_view.create(req)
    ["hello"] -> hello_world.view(req)
    _ -> not_found.view(req)
  }
}

fn create_html() -> String {
    html([attribute.lang("ja")], [
      html.head([], [
        html.meta([attribute.charset("utf-8")]),
        html.meta([
          attribute.name("viewport"),
          attribute.content("width=device-width, initial-scale=1"),
        ]),
      ]),
      html.body(
        [],
        [
            html.h1([], [html.text("Hello World")]),
        ],
      ),
    ])
    |> element.to_readable_string
}

fn home_page(req: Request) -> Response {
  // The home page can only be accessed via GET requests, so this middleware is
  // used to return a 405: Method Not Allowed response for all other methods.
  use <- wisp.require_method(req, Get)

  wisp.ok()
  |> wisp.html_body("Hello, Joe!")
}

fn comments(req: Request) -> Response {
  // This handler for `/comments` can respond to both GET and POST requests,
  // so we pattern match on the method here.
  case req.method {
    Get -> list_comments()
    Post -> create_comment(req)
    _ -> wisp.method_not_allowed([Get, Post])
  }
}

fn list_comments() -> Response {
  // In a later example we'll show how to read from a database.
  wisp.ok()
  |> wisp.html_body("Comments!")
}

fn create_comment(_req: Request) -> Response {
  // In a later example we'll show how to parse data from the request body.
  wisp.created()
  |> wisp.html_body("Created")
}

fn show_comment(req: Request, id: String) -> Response {
  use <- wisp.require_method(req, Get)

  // The `id` path parameter has been passed to this function, so we could use
  // it to look up a comment in a database.
  // For now we'll just include in the response body.
  wisp.ok()
  |> wisp.html_body("Comment with id " <> id)
}

// pub fn router(req: Request(Connection)) -> Response(ResponseData) {
//       let _ = get_connection(req)
//       echo request.path_segments(req)
//       case request.path_segments(req) {
//         [] ->todo_view.list()
//         ["hello"] -> hello_world.view()
//         ["create"] ->todo_view.create(req)
//         ["write"] -> todo_view.write(req)
//         ["test"] ->lustre_view.view()
//         _ -> not_found.view()
//       }
//     }

// fn get_connection(req: Request(Connection)) -> Nil{
//   case mist.get_connection_info(req.body) {
//           Ok(info) -> {
//             logging.log(
//               logging.Info,
//               "Got a request from: " <> mist.connection_info_to_string(info),
//             )
//           }
//           Error(_nil) -> {
//             logging.log(logging.Info, "Failed to get connection info")
//           }
//         }
// }