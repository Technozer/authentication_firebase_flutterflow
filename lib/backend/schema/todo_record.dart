import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'todo_record.g.dart';

abstract class TodoRecord implements Built<TodoRecord, TodoRecordBuilder> {
  static Serializer<TodoRecord> get serializer => _$todoRecordSerializer;

  @nullable
  String get title;

  @nullable
  String get descreption;

  @nullable
  DateTime get date;

  @nullable
  bool get isDone;

  @nullable
  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(TodoRecordBuilder builder) => builder
    ..title = ''
    ..descreption = ''
    ..isDone = false;

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Todo');

  static Stream<TodoRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s)));

  static Future<TodoRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s)));

  TodoRecord._();
  factory TodoRecord([void Function(TodoRecordBuilder) updates]) = _$TodoRecord;

  static TodoRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference});
}

Map<String, dynamic> createTodoRecordData({
  String title,
  String descreption,
  DateTime date,
  bool isDone,
}) =>
    serializers.toFirestore(
        TodoRecord.serializer,
        TodoRecord((t) => t
          ..title = title
          ..descreption = descreption
          ..date = date
          ..isDone = isDone));
