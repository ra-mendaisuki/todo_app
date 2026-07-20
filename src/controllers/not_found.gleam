import lustre/element
import lustre/element/html.{html}
import lustre/attribute
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
        html.style([], "
        body {
            font-family: sans-serif;
            text-align: center;
            padding: 100px 20px;
            color: #333;
        }
        h1 {
            font-size: 48px;
            margin-bottom: 10px;
        }
        p {
            font-size: 18px;
            line-height: 1.6;
            margin-bottom: 30px;
        }
        a {
            display: inline-block;
            padding: 12px 24px;
            background-color: #007BFF;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
        }
        a:hover {
            background-color: #0056b3;
        }
        "),
      ]),
      html.body(
        [],
        [
            html.h1([], [html.text("404")]),
            html.p([], [
                html.text("お探しのページが見つかりませんでした。"),
                html.br([]),
                html.text("URLが間違っているか、ページが削除または移動された可能性があります。")]),
            html.a([attribute.href("/")], [html.text("トップページへ戻る")])
        ],
      ),
    ])
    |> element.to_readable_string
}

pub fn view(req: Request)->Response {
    use <- wisp.require_method(req, Get)
    wisp.ok()
    |> wisp.html_body(create_html())
}
