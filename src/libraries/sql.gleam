import sqlight
import gleam/dynamic/decode
import logging
import gleam/list
import gleam/result
import models/todo_model.{type Todo}

pub fn create_todo_table() {
  use connection <- sqlight.with_connection("src/libraries/sqlite/file.db")

  let sql = "
  create table todos (name text, create_at string, update_at string);
  "
  let assert Ok(Nil) = sqlight.exec(sql, connection)
}

pub fn insert_todo(value: Todo) {
  use connection <- sqlight.with_connection("src/libraries/sqlite/file.db")

  let sql = "insert into todos (name, create_at, update_at) values ("<>value.name<>", "<>value.create_at<>", "<>value.update_at<>")"
  let assert Ok(Nil) = sqlight.exec(sql, connection)
}

pub fn select_todo_table() {
  use connection <- sqlight.with_connection("src/libraries/sqlite/file.db")
  let todo_decoder = {
    use name <- decode.field(0, decode.string)
    use create_at <- decode.field(1, decode.string)
    use update_at <- decode.field(2, decode.string)
    decode.success(#(name, create_at, update_at))
  }

  let sql = "select name, create_at, update_at from todos"
  sqlight.query(sql, on: connection, with: [], expecting: todo_decoder)
}