import "package:copilot_poc/model/task_model.dart";
import "package:copilot_poc/widgets/task_list/task_list_cubit.dart";
import "package:copilot_poc/widgets/task_list/task_list_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:nested/nested.dart";

/// This widget displays the task list and allows interaction with it.
class TaskListWidget extends StatefulWidget {
  /// Creates a TaskListWidget.
  const TaskListWidget({super.key});

  @override
  State<TaskListWidget> createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  @override
  Widget build(BuildContext context) => MultiBlocListener(
    listeners: <SingleChildWidget>[
      BlocListener<TaskListCubit, TaskListState>(
        listener: (BuildContext context, TaskListState state) {
          if (state.status == TaskListStateStatus.loading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Carregando..."),
                duration: Duration(seconds: 1),
              ),
            );
          } else if (state.status == TaskListStateStatus.loaded) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
          if (state.status == TaskListStateStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Erro. Tente novamente."),
                duration: Duration(seconds: 1),
              ),
            );
          }
        },
      ),
    ],
    child: Scaffold(
      appBar: AppBar(title: const Text("Lista de Tarefas")),
      body: Center(
        child: BlocBuilder<TaskListCubit, TaskListState>(
          builder:
              (BuildContext context, TaskListState state) => Column(
                children: <Widget>[
                  if (state.tasks.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.task_alt, size: 64, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              "Você não tem tarefas.",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.tasks.length,
                        itemBuilder: (BuildContext context, int index) {
                          final TaskModel task = state.tasks[index];
                          return ListTile(
                            title: Text(task.title),
                            leading: Checkbox(
                              value: task.status == TaskStatus.completed,
                              onChanged: (bool? value) async {
                                await context.read<TaskListCubit>().check(task);
                              },
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await context.read<TaskListCubit>().remove(
                                  task,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton.icon(
                          onPressed: () async {
                            context
                                .read<TaskListCubit>()
                                .throwErrorForDemonstration();
                          },
                          icon: const Icon(Icons.error_outline_outlined),
                          label: const Text("Simular Erro"),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red.shade100,
                            backgroundColor: const Color(0xFF640F22),
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () async {
                            await context.read<TaskListCubit>().add(
                              "Nova Tarefa ${state.tasks.length + 1}",
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("Nova Tarefa"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        ),
      ),
    ),
  );
}
