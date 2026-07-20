import controllers/hello_world
import controllers/not_found
import controllers/todo_view
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
    ["write"] -> todo_view.write(req)
    ["hello"] -> hello_world.view(req)
    _ -> not_found.view(req)
  }
}
