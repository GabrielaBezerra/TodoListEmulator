import "package:copilot_poc/model/task_model.dart";
import "package:copilot_poc/repository/data/task_local_datasource.dart";
import "package:copilot_poc/repository/task_list_repository.dart";
import "package:copilot_poc/router/routes.dart";
import "package:copilot_poc/service/hive_service.dart";
import "package:copilot_poc/widgets/app_theme.dart";
import "package:copilot_poc/widgets/task_list/task_list_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

/// This is the main application widget.
class App extends StatefulWidget {
  /// Creates a CopilotApp widget.
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) => MultiRepositoryProvider(
    providers: <RepositoryProvider<dynamic>>[
      RepositoryProvider<TaskRepository>(
        create:
            (_) => TaskRepository(
              localDatasource: TaskLocalDatasource(
                localStorageService: HiveService<TaskModel>(),
              ),
            ),
      ),
    ],
    child: MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<TaskListCubit>(
          create:
              (BuildContext context) =>
                  TaskListCubit(repository: context.read<TaskRepository>())
                    ..fetchTasks(),
        ),
      ],
      child: MaterialApp.router(
        theme: AppTheme.theme,
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        builder: (BuildContext context, Widget? widget) => widget!,
      ),
    ),
  );
}
