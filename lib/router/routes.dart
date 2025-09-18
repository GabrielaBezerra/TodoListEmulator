import "package:copilot_poc/widgets/task_list/task_list_widget.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

/// This class defines the routes for the application.
GoRouter router = GoRouter(
  initialLocation: "/",
  routes: <RouteBase>[
    GoRoute(
      path: "/",
      builder:
          (BuildContext context, GoRouterState state) => const TaskListWidget(),
    ),
  ],
);
