import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel extends Equatable {
  final String id; // Document ID from Firestore
  final String userId; // ID of the user who owns the note
  final String title;
  final String content;
  final Timestamp timestamp; // Use Timestamp for consistent server-side time

  const NoteModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.timestamp,
  });

  // Convert NoteModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'timestamp': timestamp,
    };
  }

  // Create NoteModel from Firestore DocumentSnapshot or Map
  factory NoteModel.fromMap(Map<String, dynamic> map, String documentId) {
    return NoteModel(
      id: documentId, // Use the actual document ID from Firestore
      userId: map['userId'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      timestamp: map['timestamp'] as Timestamp,
    );
  }

  // Factory constructor for creating from DocumentSnapshot
  factory NoteModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoteModel(
      id: doc.id,
      userId: data['userId'] as String,
      title: data['title'] as String,
      content: data['content'] as String,
      timestamp: data['timestamp'] as Timestamp,
    );
  }

  // Create copy with updated values (useful for immutability)
  NoteModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    Timestamp? timestamp,
  }) {
    return NoteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object> get props => [id, userId, title, content, timestamp];

  @override
  String toString() {
    return 'NoteModel(id: $id, userId: $userId, title: $title, content: $content, timestamp: $timestamp)';
  }
}