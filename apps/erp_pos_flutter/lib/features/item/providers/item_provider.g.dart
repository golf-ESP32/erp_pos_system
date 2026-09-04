// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ItemNotifier)
final itemProvider = ItemNotifierProvider._();

final class ItemNotifierProvider
    extends $AsyncNotifierProvider<ItemNotifier, List<ItemModel>> {
  ItemNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'itemProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$itemNotifierHash();

  @$internal
  @override
  ItemNotifier create() => ItemNotifier();
}

String _$itemNotifierHash() => r'e44a09020365fbc4fc1fd35c3fb906c3c700c994';

abstract class _$ItemNotifier extends $AsyncNotifier<List<ItemModel>> {
  FutureOr<List<ItemModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<ItemModel>>, List<ItemModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ItemModel>>, List<ItemModel>>,
              AsyncValue<List<ItemModel>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
