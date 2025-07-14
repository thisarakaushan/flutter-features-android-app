// Packages
import 'package:flutter/material.dart';

// Models
import '../models/user_model.dart';

// Services
import '../services/api_service.dart';

// Screens
import '../widgets/user_list_item.dart';

// Widgets
import '../widgets/loading_indicator.dart';
import '../widgets/error_message.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ApiService _apiService = ApiService();
  int _currentPage = 1;
  List<User> _users = [];
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _errorMessage;
  final ScrollController _scrollController = ScrollController();
  int _totalPages = 2; // Default to 2 pages, will be updated after first fetch

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchUsers();
  }

  // Fetch users from API
  Future<void> _fetchUsers({bool isRefresh = false}) async {
    // Prevents multiple simultaneous API calls and stops fetching when no more data is available.
    if (_isLoadingMore || (!_hasMore && !isRefresh)) return;

    // If refreshing, reset the state
    if (isRefresh) {
      setState(() {
        _users = [];
        _currentPage = 1;
        _hasMore = true;
        _errorMessage = null;
      });
    }

    // Set loading state
    setState(() {
      _isLoadingMore = true;
    });

    try {
      print('Fetching page $_currentPage...');

      // Fetch users from the API
      // final newUsers = await _apiService.fetchUsers(_currentPage);
      final result = await _apiService.fetchUsers(_currentPage);

      // Extract users and total pages from the result
      final List<User> newUsers = result['users'] as List<User>;

      final int totalPages = result['total_pages'] as int;

      // Update the state with the new users
      setState(() {
        _users.addAll(newUsers);
        _totalPages = totalPages; // Update total pages from the API response

        _currentPage++; // Increment AFTER checking for hasMore

        // Update hasMore based on current page and total pages
        _hasMore = _currentPage <= _totalPages;

        // Check if there are more users to load
        // _hasMore = newUsers.isNotEmpty;

        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoadingMore = false;
      });
    }
    print('Total users loaded: ${_users.length}');
  }

  // Handle scroll events to load more users
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      if (!_isLoadingMore && _hasMore) {
        _fetchUsers();
        // print('Fetching page $_currentPage...');
        // print('Scroll position: ${_scrollController.position.pixels}');
      }
    }
    // print('Fetching page $_currentPage...');
    // print('Scroll position: ${_scrollController.position.pixels}');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User List')),
      body: RefreshIndicator(
        onRefresh: () => _fetchUsers(isRefresh: true),
        child: _users.isEmpty && _errorMessage == null && _isLoadingMore
            ? const LoadingIndicator()
            : _errorMessage != null
            ? ErrorMessage(
                message: _errorMessage!,
                onRetry: () => _fetchUsers(isRefresh: true),
              )
            //  : ListView.builder(
            //   controller: _scrollController,
            //   itemCount: _users.length + (_hasMore ? 1 : 0),
            //   itemBuilder: (context, index) {
            //     if (index == _users.length && _hasMore) {
            //       return const LoadingIndicator();
            //     }
            //     return UserListItem(user: _users[index]);
            //   },
            // ),
            : LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight + 1,
                      ),
                      child: Column(
                        children: List.generate(
                          _users.length + (_hasMore ? 1 : 0),
                          (index) {
                            if (index == _users.length && _hasMore) {
                              return const LoadingIndicator();
                            }
                            return UserListItem(user: _users[index]);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
