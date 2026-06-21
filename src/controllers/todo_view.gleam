import gleam/bytes_tree
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import mist.{type Connection, type ResponseData}
import lustre/element/html.{html}
import lustre/attribute
import lustre/element
// import logging

fn list_html() -> String {
    html([attribute.lang("ja")], [
      html.head([], [
        html.meta([attribute.charset("utf-8")]),
        html.meta([
          attribute.name("viewport"),
          attribute.content("width=device-width, initial-scale=1.0"),
        ]),
        html.title([], "Todoアプリ"),
      ]),
      html.body(
        [],
        [
          html.header([], [
            html.h1([], [html.text("やることリスト")]),
            html.nav([], [
              html.ul([], [
                html.li([], [
                  html.a([attribute.href("/")], [html.text("ホーム")]),
                  html.a([attribute.href("/create")], [html.text("新しいタスクを追加")])
                ])
              ])
            ])
          ]),
          html.main([], [
            html.section([], [
              html.form([attribute.method("GET"), attribute.action("/index")], [
                html.input([
                  attribute.type_("search"),
                  attribute.name("search_word"),
                  attribute.value("")
                ]),
                html.input([attribute.type_("submit"), attribute.value("検索")])
              ])
            ]),
            html.section([], [
              html.h2([], [html.text("完了したタスク")]),
              html.ul([attribute.class("completed-task-list")], [
                // ここに完了したタスクがリストされる
              ]),
              html.h2([], [html.text("未完了のタスク")]),
              html.ul([attribute.class("incomplete-task-list")], [
                // ここに未完了のタスクがリストされる
              ])
            ])
          ]),
        ],
      ),
    ])
    |> element.to_readable_string
}


pub fn list() -> Response(ResponseData) {

  // debugging
  // logging.log(logging.Info, create_html())

  response.new(200)
  |> response.set_body(mist.Bytes(bytes_tree.from_string(list_html())))
  |> response.set_header("content-type", "text/html")
}

fn create_html(req: Request(Connection)) -> String {
    html([attribute.lang("ja")], [
      html.head([], [
        html.meta([attribute.charset("utf-8")]),
        html.meta([
          attribute.name("viewport"),
          attribute.content("width=device-width, initial-scale=1.0"),
        ]),
        html.title([], "Todoアプリ"),
      ]),
      html.body(
        [],
        [
          html.header([], [
            html.h1([], [html.text("やること書き込みページ")]),
            html.nav([], [
              html.ul([], [
                html.li([], [
                  html.a([attribute.href("/")], [html.text("ホーム")]),
                  html.a([attribute.href("/create")], [html.text("新しいタスクを追加")])
                ])
              ])
            ])
          ]),
          html.main([], [
            html.form([attribute.method("POST"), attribute.action("/write")], [
              html.p([], [
                 html.textarea([attribute.name("contents"), attribute.rows(5), attribute.cols(60)], "")
              ]),
              html.input([
                attribute.type_("hidden"),
                attribute.name("now_datetime"),
                attribute.value("")
              ]),
              html.input([attribute.type_("submit"), attribute.value("書き込み")])
            ])
          ]),
        ],
      ),
    ])
    |> element.to_readable_string
}


pub fn create(req: Request(Connection)) -> Response(ResponseData) {
  response.new(200)
  |> response.set_body(mist.Bytes(bytes_tree.from_string(create_html(req))))
  |> response.set_header("content-type", "text/html")
}
