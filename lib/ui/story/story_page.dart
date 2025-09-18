import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/story_list_provider.dart';
import 'package:story_app/provider/theme_provider.dart';
import 'package:story_app/ui/component/response_error.dart';
import 'package:story_app/ui/component/response_no_item.dart';
import 'package:story_app/ui/component/shimmer_loading.dart';
import '../../provider/shared_preferences_provider.dart';
import '../../static/story_list_result_state.dart';

class StoryPage extends StatefulWidget {
  final Function() onLogout;

  const StoryPage({super.key, required this.onLogout});

  @override
  State<StoryPage> createState() => _StateStory();
}

class _StateStory extends State<StoryPage> {
  late final ScrollController _scrollController = ScrollController();
  late String _token;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (mounted) {
        final login = await context.read<AuthProvider>().getLoginResult();
        if (!mounted) return;
        _token = login.token;

        context.read<StoryListProvider>().fetchStories(_token);
        _scrollController.addListener(() {
          if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent) {
            context.read<StoryListProvider>().fetchStories(_token);
          }
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final shouldRefresh = GoRouterState.of(context).extra as bool?;
    if (shouldRefresh == true) {
      context.read<StoryListProvider>().fetchStories(_token);
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
      appBar: AppBar(
        title: Text('Story'),
        actions: [
          //switch theme mode
          Consumer<ThemeProvider>(
            builder: (context, value, child) {
              return IconButton(
                icon: Icon(
                  value.selectedThemeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  color: value.selectedThemeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),

                onPressed: () {
                  final newTheme = value.selectedThemeMode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;

                  value.setSelectedThemeMode(newTheme);

                  context.read<SharedPreferencesProvider>().saveThemeMode(
                    newTheme,
                  );
                },
              );
            },
          ),
          SizedBox(width: 10),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'new_post') {
                context.push('/story/form');
              } else if (value == 'logout') {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Logout'),
                      content: Text('Are you sure want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            context.pop();
                            widget.onLogout();
                          },
                          child: Text('Logout'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'new_post',
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('New Post'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        child: Consumer<StoryListProvider>(
          builder: (context, value, child) {
            return switch (value.resultState) {
              StoryListLoadingState() => ShimmerLoading(
                isLoading: true,
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[300],
                        ),
                      ),
                    );
                  },
                ),
              ),
              StoryListLoadedState(stories: var storyList) => Padding(
                padding: EdgeInsets.all(10),
                child: storyList.isEmpty
                    ? Center(child: ResponseNoItem(message: "Empty Data"))
                    : ListView.builder(
                        itemCount:
                            storyList.length +
                            (value.pageItems != null ? 1 : 0),
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (index == storyList.length &&
                              value.pageItems != null) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          final item = storyList[index];
                          return InkWell(
                            onTap: () {
                              context.push('/story/detail', extra: item.id);
                            },
                            splashFactory: NoSplash.splashFactory,
                            splashColor: Colors.transparent,
                            child: Card(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    item.photoUrl,
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.fitWidth,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/no_image_available.jpg',
                                        width: double.infinity,
                                        height: 150,
                                      );
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.grey,
                                              child: Icon(
                                                Icons.person_2_rounded,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                item.name,
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.titleLarge,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: false,
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          item.description,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelMedium,
                                          maxLines: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              StoryListErrorState(error: var message) => Center(
                child: ResponseError(message: message),
              ),
              _ => const SizedBox(),
            };
          },
        ),
        onRefresh: () async {
          await context.read<StoryListProvider>().fetchStories(_token);
          return Future.delayed(Duration(seconds: 5));
        },
      ),
    );
  }
}
