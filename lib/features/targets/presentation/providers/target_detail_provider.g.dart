// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$targetDetailHash() => r'2bb5d751c2049c21e8640baea9fe53e162d5c021';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [targetDetail].
@ProviderFor(targetDetail)
const targetDetailProvider = TargetDetailFamily();

/// See also [targetDetail].
class TargetDetailFamily extends Family<AsyncValue<TargetDetailState>> {
  /// See also [targetDetail].
  const TargetDetailFamily();

  /// See also [targetDetail].
  TargetDetailProvider call(
    int targetId,
  ) {
    return TargetDetailProvider(
      targetId,
    );
  }

  @override
  TargetDetailProvider getProviderOverride(
    covariant TargetDetailProvider provider,
  ) {
    return call(
      provider.targetId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'targetDetailProvider';
}

/// See also [targetDetail].
class TargetDetailProvider
    extends AutoDisposeStreamProvider<TargetDetailState> {
  /// See also [targetDetail].
  TargetDetailProvider(
    int targetId,
  ) : this._internal(
          (ref) => targetDetail(
            ref as TargetDetailRef,
            targetId,
          ),
          from: targetDetailProvider,
          name: r'targetDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$targetDetailHash,
          dependencies: TargetDetailFamily._dependencies,
          allTransitiveDependencies:
              TargetDetailFamily._allTransitiveDependencies,
          targetId: targetId,
        );

  TargetDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.targetId,
  }) : super.internal();

  final int targetId;

  @override
  Override overrideWith(
    Stream<TargetDetailState> Function(TargetDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TargetDetailProvider._internal(
        (ref) => create(ref as TargetDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        targetId: targetId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<TargetDetailState> createElement() {
    return _TargetDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TargetDetailProvider && other.targetId == targetId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, targetId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TargetDetailRef on AutoDisposeStreamProviderRef<TargetDetailState> {
  /// The parameter `targetId` of this provider.
  int get targetId;
}

class _TargetDetailProviderElement
    extends AutoDisposeStreamProviderElement<TargetDetailState>
    with TargetDetailRef {
  _TargetDetailProviderElement(super.provider);

  @override
  int get targetId => (origin as TargetDetailProvider).targetId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
