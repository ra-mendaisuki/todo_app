import gleam/bytes_tree
import gleam/http/response.{type Response}
import mist.{type ResponseData}
import lustre/element/html.{html}
import lustre/attribute
import lustre/element
import logging

fn create_html() -> String {
    html([attribute.lang("ja")], [
      html.head([], [
        html.meta([attribute.charset("utf-8")]),
        html.meta([
          attribute.name("viewport"),
          attribute.content("width=device-width, initial-scale=1.0"),
        ]),
        html.title([], "Simple HTML Todo App"),
        html.style([], "
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .todo-container {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            width: 300px;
        }
        h2 { margin-top: 0; text-align: center; color: #333; }
        .input-area { display: flex; gap: 10px; margin-bottom: 20px; }
        input { flex: 1; padding: 8px; border: 1px solid #ccc; border-radius: 4px; }
        button { padding: 8px 12px; background: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; }
        button:hover { background: #218838; }
        ul { list-style: none; padding: 0; margin: 0; }
        li {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px;
            border-bottom: 1px solid #eee;
        }
        .delete-btn { background: #dc3545; padding: 4px 8px; font-size: 12px; }
        .delete-btn:hover { background: #c82333; }
        "),
      ]),
      html.body(
        [],
        [
          html.div([attribute.class("todo-container")], [
            html.h2([], [html.text("My To-Do List")]),
            html.div([attribute.class("input-area")], [
              html.input([
                attribute.type_("text"),
                attribute.id("taskInput"),
                attribute.placeholder("Add a new task...")
                ]),
              html.button([
                attribute.attribute(
                  "onclick",
                  "addTask()"
                ),
              ], [html.text("Add")])
            ]),
            html.ul([attribute.id("taskList")], [])
          ]),
          html.script([], "
              // Load tasks from Local Storage on startup
              document.addEventListener('DOMContentLoaded', loadTasks);

              function addTask() {
                  const taskInput = document.getElementById('taskInput');
                  const text = taskInput.value.trim();
                  if (!text) return alert('Please enter a task!');

                  createTaskElement(text);
                  saveTaskToLocal(text);
                  taskInput.value = '';
              }

              function createTaskElement(text) {
                  const taskList = document.getElementById('taskList');
                  const li = document.createElement('li');
                  li.textContent = text;

                  const deleteBtn = document.createElement('button');
                  deleteBtn.textContent = 'X';
                  deleteBtn.className = 'delete-btn';
                  deleteBtn.onclick = () => {
                      li.remove();
                      removeTaskFromLocal(text);
                  };

                  li.appendChild(deleteBtn);
                  taskList.appendChild(li);
              }

              function saveTaskToLocal(text) {
                  const tasks = JSON.parse(localStorage.getItem('todos')) || [];
                  tasks.push(text);
                  localStorage.setItem('todos', JSON.stringify(tasks));
              }

              function loadTasks() {
                  const tasks = JSON.parse(localStorage.getItem('todos')) || [];
                  tasks.forEach(task => createTaskElement(task));
              }

              function removeTaskFromLocal(text) {
                  const tasks = JSON.parse(localStorage.getItem('todos')) || [];
                  tasks = tasks.filter(task => task !== text);
                  localStorage.setItem('todos', JSON.stringify(tasks));
              }
          ")
        ],
      ),
    ])
    |> element.to_readable_string
}


pub fn view() -> Response(ResponseData) {

  logging.log(logging.Info, create_html())
    response.new(200)
  |> response.set_body(mist.Bytes(bytes_tree.from_string(create_html())))
  |> response.set_header("content-type", "text/html")
}
