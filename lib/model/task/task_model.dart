import 'package:flutter/material.dart';

class TaskModel {
  final int? id;
  final String name;
  final String location;
  final String permitt;
  final String priority;
  final String status;
  final String estimatedhours;
  final String? userId;
  final String? username;
  final String? createdAt;

  const TaskModel({
    this.id,
    required this.name,
    required this.location,
    required this.permitt,
    required this.priority,
    required this.status,
    required this.estimatedhours,
    this.userId,
    this.username,
    this.createdAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      permitt: json['permitt'] ?? 'none',
      priority: json['priority'] ?? 'medium',
      status: json['status'] ?? 'pending',
      estimatedhours: json['estimatedhours'] ?? '',
      userId: json['user_id'],
      username: json['username'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'location': location,
      'permitt': permitt,
      'priority': priority,
      'status': status,
      'estimatedhours': estimatedhours,
      'user_id': userId,
    };
  }

  // UI Helper for color/label mapping
  Color get priorityColor {
    switch (priority.toLowerCase()) {
      case 'critical': return const Color(0xFFF04438);
      case 'high': return const Color(0xFFF79009);
      case 'medium': return const Color(0xFFFDB022);
      case 'low': return const Color(0xFF12B76A);
      default: return const Color(0xFF169AE6);
    }
  }

  Color get priorityBgColor {
     switch (priority.toLowerCase()) {
      case 'critical': return const Color(0xFFFEF3F2);
      case 'high': return const Color(0xFFFFFAEB);
      case 'medium': return const Color(0xFFFEF9C3);
      case 'low': return const Color(0xFFECFDF3);
      default: return const Color(0xFFF0F9FF);
    }
  }

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'active':
      case 'in progress': return const Color(0xFF0086C9);
      case 'completed': return const Color(0xFF12B76A);
      case 'delayed':
      case 'on hold': return const Color(0xFFF04438);
      default: return const Color(0xFF667085);
    }
  }

   Color get statusBgColor {
    switch (status.toLowerCase()) {
      case 'active':
      case 'in progress': return const Color(0xFFF0F9FF);
      case 'completed': return const Color(0xFFECFDF3);
      case 'delayed':
      case 'on hold': return const Color(0xFFFEF3F2);
      default: return const Color(0xFFF2F4F7);
    }
  }
}
