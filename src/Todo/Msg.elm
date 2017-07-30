module Todo.Msg exposing (TodoAction(..))

type TodoAction =
    NewTodo
    | DeleteTodo String
    | UndoDelete
    | EditTodo String
    | ViewTodo String
    | UpdateTodoTitle String String
