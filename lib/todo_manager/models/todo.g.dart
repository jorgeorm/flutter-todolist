// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TodoImpl _$$TodoImplFromJson(Map<String, dynamic> json) => _$TodoImpl(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      notes: json['notes'] as String?,
      tags: json['tags'] == null
          ? const []
          : _tagsFromJson(json['tags'] as String),
      dueDate: const MillisecondsConverter()
          .fromJson((json['due_date'] as num?)?.toInt()),
      priority: json['priority'] == null
          ? TodoPriority.medium
          : _priorityFromDb((json['priority'] as num).toInt()),
      isCompleted: json['is_completed'] == null
          ? false
          : const SqliteBooleanConverter()
              .fromJson((json['is_completed'] as num).toInt()),
      createdAt: const MillisecondsConverter()
          .fromJson((json['created_at'] as num?)?.toInt()),
      updatedAt: const MillisecondsConverter()
          .fromJson((json['updated_at'] as num?)?.toInt()),
    );

Map<String, dynamic> _$$TodoImplToJson(_$TodoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'notes': instance.notes,
      'tags': _tagsToJson(instance.tags),
      'due_date': const MillisecondsConverter().toJson(instance.dueDate),
      'priority': _priorityToDb(instance.priority),
      'is_completed':
          const SqliteBooleanConverter().toJson(instance.isCompleted),
      'created_at': const MillisecondsConverter().toJson(instance.createdAt),
      'updated_at': const MillisecondsConverter().toJson(instance.updatedAt),
    };
