import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import logging
import mist.{type Connection, type ResponseData}
import controllers/hello_world
import controllers/not_found
import controllers/todo_view
import controllers/lustre_view

pub fn router(req: Request(Connection)) -> Response(ResponseData) {
      let _ = get_connection(req)
      echo request.path_segments(req)
      case request.path_segments(req) {
        [] ->todo_view.list()
        ["hello"] -> hello_world.view()
        ["create"] ->todo_view.create(req)
        ["write"] -> todo_view.write(req)
        ["test"] ->lustre_view.view()
        _ -> not_found.view()
      }
    }

fn get_connection(req: Request(Connection)) -> Nil{
  case mist.get_connection_info(req.body) {
          Ok(info) -> {
            logging.log(
              logging.Info,
              "Got a request from: " <> mist.connection_info_to_string(info),
            )
          }
          Error(_nil) -> {
            logging.log(logging.Info, "Failed to get connection info")
          }
        }
}