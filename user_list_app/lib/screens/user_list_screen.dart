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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchUsers();
  }

  // Fetch users from API
  Future<void> _fetchUsers({bool isRefresh = false}) async {
    // If refreshing, reset the state
    if (isRefresh) {
      setState(() {
        _users = [];
        _currentPage = 1;
        _hasMore = true;
        _errorMessage = null;
      });
    }
    // If already loading more or no more data, return early
    if (_isLoadingMore || !_hasMore) return;

    // Set loading state
    setState(() {
      _isLoadingMore = true;
    });

    try {
      // Fetch users from the API
      final newUsers = await _apiService.fetchUsers(_currentPage);
      // Update the state with the new users
      setState(() {
        _users.addAll(newUsers);
        _currentPage++;
        _hasMore = newUsers.isNotEmpty;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoadingMore = false;
      });
    }
  }

  // Handle scroll events to load more users
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchUsers();
    }
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
            : ListView.builder(
                controller: _scrollController,
                itemCount: _users.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _users.length && _hasMore) {
                    return const LoadingIndicator();
                  }
                  // Return the user list item
                  return UserListItem(user: _users[index]);
                },
              ),
      ),
    );
  }
}
