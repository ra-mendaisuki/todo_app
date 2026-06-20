import sqlight
import gleam/dynamic/decode

pub fn create_todo_table() {
  use connection <- sqlight.with_connection("./file.db")

  let sql = "
  create table todos (name text, create_at string, update_at string);

  insert into todos (name, create_at, update_at) values
  ('Nubi', '2023-01-01', '2023-01-01'),
  ('Biffy', '2023-01-02', '2023-01-02'),
  ('Ginny', '2023-01-03', '2023-01-03');
  "
  let assert Ok(Nil) = sqlight.exec(sql, connection)
}

pub fn select_todo_table() {
  use connection <- sqlight.with_connection("./file.db")
  let todo_decoder = {
    use name <- decode.field(0, decode.string)
    use create_at <- decode.field(1, decode.string)
    use update_at <- decode.field(2, decode.string)
    decode.success(#(name, create_at, update_at))
  }

  let sql = "select name, create_at, update_at from todos"
  sqlight.query(sql, on: connection, with: [sqlight.int(7)], expecting: todo_decoder)
}