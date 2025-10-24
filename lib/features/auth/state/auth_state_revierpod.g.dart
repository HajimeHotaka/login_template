// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state_revierpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userChangesHash() => r'81b2fd28aa8f519fa0fb0fabe57d9facc43d9baf';

///
/// FirebaseのユーザーをAsyncValue型で管理するプロバイダー
///
///
/// Copied from [userChanges].
@ProviderFor(userChanges)
final userChangesProvider = AutoDisposeStreamProvider<User?>.internal(
  userChanges,
  name: r'userChangesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userChangesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserChangesRef = AutoDisposeStreamProviderRef<User?>;
String _$userHash() => r'a3a444c3a1237e5a8c7be72603df1f4290a23f65';

///
/// ユーザー
///
///
/// Copied from [user].
@ProviderFor(user)
final userProvider = AutoDisposeProvider<User?>.internal(
  user,
  name: r'userProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserRef = AutoDisposeProviderRef<User?>;
String _$signedInHash() => r'582365461d843da2946a06b9e7245cfdbb50a00c';

///
/// サインイン中かどうか
///
///
/// Copied from [signedIn].
@ProviderFor(signedIn)
final signedInProvider = AutoDisposeProvider<bool>.internal(
  signedIn,
  name: r'signedInProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$signedInHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignedInRef = AutoDisposeProviderRef<bool>;
String _$userIdHash() => r'7c66c9d37e820f585e1a9cf802edf4c676c96fba';

///
/// ユーザーID
///
///
/// Copied from [userId].
@ProviderFor(userId)
final userIdProvider = AutoDisposeProvider<String?>.internal(
  userId,
  name: r'userIdProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserIdRef = AutoDisposeProviderRef<String?>;
String _$userIdStreamHash() => r'a24d915a79a26deca790251a8dde83798a901d72';

/// See also [userIdStream].
@ProviderFor(userIdStream)
final userIdStreamProvider = AutoDisposeStreamProvider<String?>.internal(
  userIdStream,
  name: r'userIdStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userIdStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserIdStreamRef = AutoDisposeStreamProviderRef<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
