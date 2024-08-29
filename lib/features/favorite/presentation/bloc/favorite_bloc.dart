import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yepp/core/common/entity/restaurant.dart';
import 'package:yepp/features/favorite/domain/usecase/toggle_favorite.dart';
import 'package:yepp/features/favorite/domain/usecase/get_favorite_location.dart';
import 'package:yepp/features/favorite/domain/usecase/get_is_favorite.dart';
import 'package:yepp/features/favorite/domain/usecase/remove_from_favorite.dart';

part 'favorite_event.dart';

part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final GetFavoriteLocation _getFavoriteLocation;
  final ToggleFavorite _toggleFavorite;
  final GetIsFavorite _getIsFavorite;

  FavoriteBloc({
    required GetFavoriteLocation getFavoriteLocation,
    required ToggleFavorite addToFavorite,
    required GetIsFavorite getIsFavorite,

  })
      : _getFavoriteLocation = getFavoriteLocation,
        _toggleFavorite = addToFavorite,
        _getIsFavorite = getIsFavorite,

        super(FavoriteInitial()) {
    on<FavoriteEvent>((event, emit) {
      emit(FavoriteLoading());
    });

    on<FavoriteGetAll>(_onGetFavoriteLocation);
    on<FavoriteToggle>(_onFavoriteToggle);
    on<FavoriteGetIsFavoriteEvent>(_onGetIsFavorite);
  }

  @override
  void onTransition(Transition<FavoriteEvent, FavoriteState> transition) {
    super.onTransition(transition);
    print('${transition.currentState} - ${transition.nextState}');
  }

  FutureOr<void> _onGetFavoriteLocation(FavoriteGetAll event,
      Emitter<FavoriteState> emit) async {
    final res = await _getFavoriteLocation(GetFavoriteLocationParams());
    res.fold(
          (l) => emit(FavoriteFailure(l.message)),
          (r) => emit(FavoriteLoadSuccess(r)),
    );
  }

  FutureOr<void> _onFavoriteToggle(FavoriteToggle event,
      Emitter<FavoriteState> emit) async {
    await _toggleFavorite(ToggleFavoriteParams(event.location));
    // res.fold(
    //           (l) => emit(FavoriteFailure(l.message)),
    //           (r) => emit(FavoriteToggleSuccess()),
    //           );
    // final resGet = await _getFavoriteLocation(GetFavoriteLocationParams());
    // resGet.fold(
    //       (l) => emit(FavoriteFailure(l.message)),
    //       (r) => emit(FavoriteLoadSuccess(r)),
    // );

    final res = await _getIsFavorite(LocationParams(event.location));
    res.fold(
          (l) => emit(FavoriteFailure(l.message)),
          (r) => emit(FavoriteSingleItemStatus(r)),
    );

  }

  FutureOr<void> _onGetIsFavorite(FavoriteGetIsFavoriteEvent event, Emitter<FavoriteState> emit) async{
    final res = await _getIsFavorite(LocationParams(event.location));
    res.fold(
        (l) => emit(FavoriteFailure(l.message)),
        (r) => emit(FavoriteSingleItemStatus(r)),
    );
  }
}
