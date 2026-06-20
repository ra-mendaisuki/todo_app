// IMPORTS ---------------------------------------------------------------------

import gleam/bytes_tree
import gleam/http/response.{type Response}
import lustre/attribute
import lustre/element
import lustre/element/html.{html}
import mist.{type ResponseData}

// HTML ------------------------------------------------------------------------

pub fn view() -> Response(ResponseData) {
  let html =
    html([attribute.lang("en")], [
      html.head([], [
        html.meta([attribute.charset("utf-8")]),
        html.meta([
          attribute.name("viewport"),
          attribute.content("width=device-width, initial-scale=1"),
        ]),
        html.title([], "06-server-components/01-basic-setup"),
      ]),
      html.body(
        [],
        [
            html.h1([], [html.text("Hello Lustre!")]),
            html.div([], [
                html.p([], [html.text("Hello World")]),
            ])
        ],
      ),
    ])
    |> element.to_readable_string

  // Debug log to check the generated HTML
  // logging.log(logging.Info, html)

  response.new(200)
  |> response.set_body(mist.Bytes(bytes_tree.from_string(html)))
  |> response.set_header("content-type", "text/html")
}