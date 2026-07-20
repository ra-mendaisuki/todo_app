import gleam/list
import gleam/uri
import gleam/result
import lustre/element/html.{html}
import lustre/attribute
import lustre/element
import libraries/sql
import wisp.{type Request, type Response}
import gleam/http.{Get}
import gleam/http/request

const name = "cont"

fn list_html() -> String {
  let a = case sql.select_todo_table() {
    Ok(res) -> res
    Error(_nil) -> []
  }
  echo a
  let tasks = list.map(
    a,
    fn(select_record){
      let #(a,b,c) = select_record
      html.div([attribute.class("todo-container")], [html.p([], [html.text("やること: " <> a)]) ,html.p([], [html.text("作成日時:" <> b), html.text("  更新日時: " <> c)])])
    }
  )

    html([attribute.lang("ja")], [
      html.head([], [
        html.meta([attribute.charset("utf-8")]),
        html.meta([
          attribute.name("viewport"),
          attribute.content("width=device-width, initial-scale=1.0"),
        ]),
        html.title([], "Todoアプリ"),
        html.style([], "
        head {
              font-family: Arial, sans-serif;
              background-color: #f4f4f9;
              justify-content: center;
              align-items: center;
        }
          body {
              font-family: Arial, sans-serif;
              background-color: #f4f4f9;
              justify-content: center;
              align-items: center;
              height: 100vh;
              margin: 0;
          }
          .todo-container {
              background: white;
              padding: 10px;
              margin: 5px;
              border-radius: 10px;
              box-shadow: 0 4px 6px rgba(0,0,0,0.10);
              width: 400px;
          }
          h2 { margin-top: 0;  color: #333; }
          .input-area { gap: 10px; margin-bottom: 20px; }
          input { flex: 1; padding: 8px; border: 1px solid #ccc; border-radius: 4px; }
          button { padding: 8px 12px; background: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; }
          button:hover { background: #218838; }
          ul { list-style: none; padding: 0; margin: 0; }
          li {
              justify-content: space-between;
              align-items: center;
              padding: 8px;
              border-bottom: 1px solid #eee;
          }
          .delete-btn { background: #dc3545; padding: 4px 8px; font-size: 12px; }
          .delete-btn:hover { background: #c82333; }
        ")
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
              html.h2([], [html.text("タスク")]),
              html.ul([attribute.class("task-list")],
                tasks
              ),
            ])
          ]),
        ],
      ),
    ])
    |> element.to_readable_string
}


pub fn list(req: Request) -> Response {
  use <- wisp.require_method(req, Get)
  wisp.ok()
  |> wisp.html_body(list_html())
}

fn create_html() -> String {
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
                 html.textarea([attribute.name(name), attribute.rows(5), attribute.cols(60)], "")
              ]),
              html.input([attribute.type_("submit"), attribute.value("書き込み")])
            ])
          ]),
        ],
      ),
    ])
    |> element.to_readable_string
}


pub fn create(req: Request) -> Response {
    use <- wisp.require_method(req, Get)
    wisp.ok()
    |> wisp.html_body(create_html())
}

fn write_html(path: String) -> String {
  html([attribute.lang("ja")], [
    html.head([], [
      html.meta([attribute.charset("utf-8")]),
      html.meta([
        attribute.name("viewport"),
        attribute.content("width=device-width, initial-scale=1.0"),
      ]),
      html.meta([attribute.http_equiv("refresh"), attribute.content("0; URL=" <> path <> "/")]),
    ]),
  ])
  |> element.to_readable_string
}

pub fn write(req: Request) -> Response {
  // let a = get_request.get(req, string.length(name)+1)
  use formdata <- wisp.require_form(req)
  let url = result.unwrap(uri.origin(request.to_uri(req)), "http://localhost:8080/")

  let result = {
    use cont <- result.try(list.key_find(formdata.values, name))
    Ok(cont)
  }
  case result {
    Ok(cont) -> {
      sql.insert_todo(cont)
      wisp.ok()
      |> wisp.html_body(write_html(url))
    }
    Error(_) -> {
      echo "Error: No value found for key 'cont'"
      wisp.bad_request("Invalid formdata")
      |> wisp.html_body("Error: No value found for key 'cont'")
    }
  }

}
