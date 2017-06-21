module Todo.Msg exposing (TodoAction(..))

type TodoAction =
    NewTodo
    | DeleteTodo Int
    | UndoDelete
    | EditTodo Int
    | ViewTodo Int
    | UpdateTodoTitle Int String
