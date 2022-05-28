import 'package:flutter/material.dart';
import 'package:to_do/models/todo_model.dart';
import 'package:to_do/repositories/todo_repository.dart';
import 'package:to_do/widgets/todo_list_item_widget.dart';

class ToDoHomeScreen extends StatefulWidget {
  const ToDoHomeScreen({Key? key}) : super(key: key);

  @override
  State<ToDoHomeScreen> createState() => _ToDoHomeScreenState();
}

class _ToDoHomeScreenState extends State<ToDoHomeScreen> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  String? errorText;
  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              const UserAccountsDrawerHeader(
                  accountName: Text('Christian Burgard Trajano'),
                  accountEmail: Text('aluno.senac@senac.com.br')),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Exit'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text('To Do list'),
          actions: [
            TextButton(
              onPressed: () async {
                List retorno = await todoRepository.downloadTodos();
                for (var todo in retorno) {
                  Todo newTodo =
                      Todo(title: todo['title'], dateTime: DateTime.now());
                  setState(() {
                    todos.add(newTodo);
                  });
                }
                todoRepository.saveTodoList(todos);
              },
              child: const Icon(Icons.download, color: Colors.white),
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                          labelText: 'To-Do',
                          errorText: errorText,
                          labelStyle: const TextStyle(
                            fontSize: 20,
                          ),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          String text = todoController.text;
                          if (text.isEmpty) {
                            setState(() {
                              errorText = 'O campo não pode ser vazio';
                            });
                          } else {
                            errorText == null;
                            setState(() {
                              Todo newTodo =
                                  Todo(title: text, dateTime: DateTime.now());
                              todos.add(newTodo);
                            });

                            todoController.clear();
                            todoRepository.saveTodoList(todos);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(60, 60),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 30,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                          onDelete: (Todo todo) {
                            setState(() {
                              todos.remove(todo);
                            });

                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Tarefa ${todo.title} Excluida com sucesso',
                                  style: const TextStyle(
                                    color: Colors.indigo,
                                  ),
                                ),
                                backgroundColor: Colors.white,
                                action: SnackBarAction(
                                  label: 'Desfazer',
                                  textColor: Colors.blue[900],
                                  onPressed: () => {
                                    setState(() {
                                      todos.add(todo);
                                    })
                                  },
                                ),
                                duration: const Duration(seconds: 5),
                              ),
                            );
                            todoRepository.saveTodoList(todos);
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Voce Possui ${todos.length} Tarefas pendentes',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text('Limpar todas as tarefas?'),
                                  content: const Text(
                                      'Você gostaria de excluir todas as tarefas?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          todos.clear();
                                        });
                                        todoRepository.saveTodoList(todos);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Deletar',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancelar'),
                                    ),
                                  ],
                                ));
                        todoRepository.saveTodoList(todos);
                      },
                      child: const Text('Limpar Tarefas'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
