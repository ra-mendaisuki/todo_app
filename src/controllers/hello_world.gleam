import gleam/bytes_tree
import gleam/http/response.{type Response}
import mist.{type ResponseData}
import lustre/element/html.{html}
import lustre/attribute
import lustre/element
import libraries/sql

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


pub fn view() -> Response(ResponseData) {
  sql.create_todo_table()
  sql.select_todo_table()

  response.new(200)
  |> response.set_body(mist.Bytes(bytes_tree.from_string(create_html())))
  |> response.set_header("content-type", "text/html")
}
