import lustre/element/html.{html}
import lustre/attribute
import lustre/element
import wisp.{type Request, type Response}
import gleam/http.{Get}

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


pub fn view(req: Request) -> Response {

  use <- wisp.require_method(req, Get)

  wisp.ok()
  |> wisp.html_body(create_html())
}
