import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Priority Filter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TaskPriorityScreen(),
    );
  }
}

enum Priority { low, medium, high }

class TaskPriorityScreen extends StatefulWidget {
  const TaskPriorityScreen({super.key});

  @override
  State<TaskPriorityScreen> createState() => _TaskPriorityScreenState();
}

class _TaskPriorityScreenState extends State<TaskPriorityScreen> {
  Set<Priority> selectedPriorities = <Priority>{Priority.medium};

  // Sample tasks with priorities
  final List<Map<String, dynamic>> allTasks = [
    {'title': 'Review pull requests', 'priority': Priority.high},
    {'title': 'Update documentation', 'priority': Priority.low},
    {'title': 'Fix critical bug', 'priority': Priority.high},
    {'title': 'Team meeting preparation', 'priority': Priority.medium},
    {'title': 'Code refactoring', 'priority': Priority.low},
    {'title': 'Client presentation', 'priority': Priority.high},
    {'title': 'Weekly report', 'priority': Priority.medium},
    {'title': 'Clean up old files', 'priority': Priority.low},
  ];

  List<Map<String, dynamic>> get filteredTasks {
    return allTasks
        .where((task) => selectedPriorities.contains(task['priority']))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Task Priority Filter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter by Priority:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // SEGMENTED BUTTON WIDGET
            Center(
              child: SegmentedButton<Priority>(
                // Property 1: segments - defines the buttons to display
                segments: const <ButtonSegment<Priority>>[
                  ButtonSegment<Priority>(
                    value: Priority.low,
                    label: Text('Low'),
                    icon: Icon(Icons.arrow_downward),
                  ),
                  ButtonSegment<Priority>(
                    value: Priority.medium,
                    label: Text('Medium'),
                    icon: Icon(Icons.remove),
                  ),
                  ButtonSegment<Priority>(
                    value: Priority.high,
                    label: Text('High'),
                    icon: Icon(Icons.arrow_upward),
                  ),
                ],
                
                // Property 2: multiSelectionEnabled - allows multiple selections
                multiSelectionEnabled: true,
                
                // Property 3: showSelectedIcon - shows checkmark on selected items
                showSelectedIcon: true,
                
                selected: selectedPriorities,
                onSelectionChanged: (Set<Priority> newSelection) {
                  setState(() {
                    selectedPriorities = newSelection;
                  });
                },
              ),
            ),
            
            const SizedBox(height: 24),
            Text(
              'Tasks (${filteredTasks.length}):',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            
            Expanded(
              child: filteredTasks.isEmpty
                  ? const Center(
                      child: Text(
                        'No tasks found.\nSelect at least one priority filter.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        final priority = task['priority'] as Priority;
                        
                        Color priorityColor;
                        switch (priority) {
                          case Priority.low:
                            priorityColor = Colors.green;
                            break;
                          case Priority.medium:
                            priorityColor = Colors.orange;
                            break;
                          case Priority.high:
                            priorityColor = Colors.red;
                            break;
                        }
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: priorityColor.withOpacity(0.2),
                              child: Icon(
                                priority == Priority.high
                                    ? Icons.arrow_upward
                                    : priority == Priority.medium
                                        ? Icons.remove
                                        : Icons.arrow_downward,
                                color: priorityColor,
                              ),
                            ),
                            title: Text(task['title']),
                            trailing: Chip(
                              label: Text(
                                priority.name.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: priorityColor.withOpacity(0.2),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}