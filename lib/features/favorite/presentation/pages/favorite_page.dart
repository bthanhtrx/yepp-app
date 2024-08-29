import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yepp/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:yepp/features/favorite/presentation/widgets/favorite_card.dart';
import 'package:yepp/init_dependencies.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>{
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<FavoriteBloc>().add(FavoriteGetAll());

    return Scaffold(
      body: Padding(padding: const EdgeInsets.all(10),
        child: BlocBuilder<FavoriteBloc, FavoriteState>(
          // buildWhen: (previous, current) =>previous.runtimeType != current.runtimeType && current is FavoriteLoadSuccess,
          builder: (context, state) {
            if (state is FavoriteLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FavoriteFailure) {
              return Text('Error: ${state.message}');
            }

            if (state is! FavoriteLoadSuccess) {
              return const SizedBox.shrink();
            }

            return state.list.isEmpty
                ? const Center(child: Text('No Favorites.'))
                : ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) =>
                  FavoriteCard(localPlace: state.list[index]),
              itemCount: state.list.length,
            );
          },
        ),
      ),
    );
  }
}
