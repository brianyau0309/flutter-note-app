class CloudStorageException implements Exception {
  const CloudStorageException();
}

// Create
class CouldNotCreateNoteException implements CloudStorageException {}

// Read
class CouldNotGetAllNotesException implements CloudStorageException {}

// Update
class CouldNotUpdateNoteException implements CloudStorageException {}

// Delete
class CouldNotDeleteNoteException implements CloudStorageException {}
