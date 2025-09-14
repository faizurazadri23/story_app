import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/story_list_provider.dart';

import '../../static/story_list_result_state.dart';

class StoryPage extends StatefulWidget {

  final Function() onLogout;

  const StoryPage({super.key, required this.onLogout});

  @override
  State<StoryPage> createState() => _StateStory();
}

class _StateStory extends State<StoryPage> {
  late var _page = 1;
  late final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<AuthProvider>().getLoginResult().then((value) {
          if (!mounted) return;
          context.read<StoryListProvider>().fetchStories(
            _page,
            10,
            value.token,
          );
          _scrollController.addListener(() {
            if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent) {
              _page++;
              context.read<StoryListProvider>().fetchStories(
                _page,
                10,
                value.token,
              );
            }
          });
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Story'),
        actions: [
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
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async{
                            Navigator.pop(context);
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
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        child: RefreshIndicator(
          child: Consumer<StoryListProvider>(
            builder: (context, value, child) {
              return switch (value.resultState) {
                StoryListLoadingState() => const Center(
                  child: CircularProgressIndicator(),
                ),
                StoryListLoadedState(stories: var storyList) =>
                  ListView.builder(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                              itemCount: storyList.length,
                              controller: _scrollController,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item = storyList[index];
                                return InkWell(
                                  onTap: () {
                                    context.push(
                                      '/detail',
                                      extra: {"id": item.id},
                                    );
                                  },
                                  splashFactory: NoSplash.splashFactory,
                                  splashColor: Colors.transparent,
                                  child: Card(
                                    color: Colors.white,
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: Padding(
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
                                              SizedBox(width: 5),
                                              Text(
                                                item.name,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Image.network(
                                            item.photoUrl,
                                            width: double.infinity,
                                            height: 150,
                                            fit: BoxFit.fitWidth,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Icon(Icons.error);
                                                },
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            item.description,
                                            style: TextStyle(fontSize: 12),
                                            maxLines: 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                StoryListErrorState(error: var message) => Center(
                  child: Text(message),
                ),
                _ => const SizedBox(),
              };
            },
          ),
          onRefresh: () {
            var data = context.read<AuthProvider>().loginResult;
            context.read<StoryListProvider>().fetchStories(
              _page,
              10,
              data!.token,
            );
            return Future.delayed(Duration(seconds: 5));
          },
        ),
        onRefresh: () {
          return Future.delayed(Duration(seconds: 5));
        },
      ),
    );
  }
}
