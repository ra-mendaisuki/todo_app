import gleam/string
import gleam/bit_array
import gleam/result
import mist.{type Connection}
import gleam/http/request.{type Request}

pub fn get(req: Request(Connection), up_to: Int,){
  let a = result.lazy_unwrap(mist.read_body(req, 10000), fn(){

  })
  let req_body = case bit_array.to_string(a.body) {
        Ok(a) -> a
        Error(_nil) -> ""
      }
  string.drop_start(req_body, up_to)
}