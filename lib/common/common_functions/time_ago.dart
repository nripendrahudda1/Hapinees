String getTimeAgo(DateTime dateTime) {
  final Duration difference = DateTime.now().difference(dateTime);

  if (difference.inDays > 1) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays == 1) {
    return '1 day ago';
  } else if (difference.inHours > 1) {
    return '${difference.inHours} hours ago';
  } else if (difference.inHours == 1) {
    return '1 hour ago';
  } else if (difference.inMinutes > 1) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inMinutes == 1) {
    return '1 minute ago';
  } else {
    return 'just now';
  }
}
