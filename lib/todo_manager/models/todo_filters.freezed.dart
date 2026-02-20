// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo_filters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TodoFilters {
  bool? get isCompleted => throw _privateConstructorUsedError;
  TodoPriority? get priority => throw _privateConstructorUsedError;
  String? get tag => throw _privateConstructorUsedError;
  TodoSortBy get sortBy => throw _privateConstructorUsedError;
  bool get sortAscending => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TodoFiltersCopyWith<TodoFilters> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodoFiltersCopyWith<$Res> {
  factory $TodoFiltersCopyWith(
          TodoFilters value, $Res Function(TodoFilters) then) =
      _$TodoFiltersCopyWithImpl<$Res, TodoFilters>;
  @useResult
  $Res call(
      {bool? isCompleted,
      TodoPriority? priority,
      String? tag,
      TodoSortBy sortBy,
      bool sortAscending});
}

/// @nodoc
class _$TodoFiltersCopyWithImpl<$Res, $Val extends TodoFilters>
    implements $TodoFiltersCopyWith<$Res> {
  _$TodoFiltersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCompleted = freezed,
    Object? priority = freezed,
    Object? tag = freezed,
    Object? sortBy = null,
    Object? sortAscending = null,
  }) {
    return _then(_value.copyWith(
      isCompleted: freezed == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TodoPriority?,
      tag: freezed == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String?,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as TodoSortBy,
      sortAscending: null == sortAscending
          ? _value.sortAscending
          : sortAscending // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TodoFiltersImplCopyWith<$Res>
    implements $TodoFiltersCopyWith<$Res> {
  factory _$$TodoFiltersImplCopyWith(
          _$TodoFiltersImpl value, $Res Function(_$TodoFiltersImpl) then) =
      __$$TodoFiltersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool? isCompleted,
      TodoPriority? priority,
      String? tag,
      TodoSortBy sortBy,
      bool sortAscending});
}

/// @nodoc
class __$$TodoFiltersImplCopyWithImpl<$Res>
    extends _$TodoFiltersCopyWithImpl<$Res, _$TodoFiltersImpl>
    implements _$$TodoFiltersImplCopyWith<$Res> {
  __$$TodoFiltersImplCopyWithImpl(
      _$TodoFiltersImpl _value, $Res Function(_$TodoFiltersImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCompleted = freezed,
    Object? priority = freezed,
    Object? tag = freezed,
    Object? sortBy = null,
    Object? sortAscending = null,
  }) {
    return _then(_$TodoFiltersImpl(
      isCompleted: freezed == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TodoPriority?,
      tag: freezed == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String?,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as TodoSortBy,
      sortAscending: null == sortAscending
          ? _value.sortAscending
          : sortAscending // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$TodoFiltersImpl implements _TodoFilters {
  const _$TodoFiltersImpl(
      {this.isCompleted,
      this.priority,
      this.tag,
      this.sortBy = TodoSortBy.createdAt,
      this.sortAscending = true});

  @override
  final bool? isCompleted;
  @override
  final TodoPriority? priority;
  @override
  final String? tag;
  @override
  @JsonKey()
  final TodoSortBy sortBy;
  @override
  @JsonKey()
  final bool sortAscending;

  @override
  String toString() {
    return 'TodoFilters(isCompleted: $isCompleted, priority: $priority, tag: $tag, sortBy: $sortBy, sortAscending: $sortAscending)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TodoFiltersImpl &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.tag, tag) || other.tag == tag) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.sortAscending, sortAscending) ||
                other.sortAscending == sortAscending));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, isCompleted, priority, tag, sortBy, sortAscending);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TodoFiltersImplCopyWith<_$TodoFiltersImpl> get copyWith =>
      __$$TodoFiltersImplCopyWithImpl<_$TodoFiltersImpl>(this, _$identity);
}

abstract class _TodoFilters implements TodoFilters {
  const factory _TodoFilters(
      {final bool? isCompleted,
      final TodoPriority? priority,
      final String? tag,
      final TodoSortBy sortBy,
      final bool sortAscending}) = _$TodoFiltersImpl;

  @override
  bool? get isCompleted;
  @override
  TodoPriority? get priority;
  @override
  String? get tag;
  @override
  TodoSortBy get sortBy;
  @override
  bool get sortAscending;
  @override
  @JsonKey(ignore: true)
  _$$TodoFiltersImplCopyWith<_$TodoFiltersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
