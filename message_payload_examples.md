# Chat Message JSON Payload Specifications

This document outlines the JSON structures used in the Trackyond chat system.

---

## Part 1: Send Message Payloads (Client → Server)

These JSON structures represent the data posted by the client to `/api/v1/common/jobs/<jobId>/chat/messages` (`POST`).

### 1. text
```json
{
  "localId": "loc_txt101",
  "jobId": "job_1025",
  "senderUid": "profile_uid",
  "content": [
    {
      "type": "text",
      "content": "Hello world",
      "metadata": null
    }
  ],
  "type": "message",
  "metadata": null,
  "actionPerformed": null,
  "createdByAuthorAt": "2026-05-30T10:45:00.000Z"
}
```

### 2. text + image
```json
{
  "localId": "loc_timg02",
  "jobId": "job_1025",
  "senderUid": "profile_uid",
  "content": [
    {
      "type": "text",
      "content": "Here is the completed wall painting",
      "metadata": null
    },
    {
      "type": "image",
      "content": "uploads/chat/image.jpg",
      "metadata": {
        "fileName": "image.jpg",
        "size": "1.2 MB",
        "mimeType": "image/jpeg",
        "imageMetadata": {
          "width": 1080,
          "height": 1440,
          "blurHash": "hash"
        }
      }
    }
  ],
  "type": "message",
  "metadata": null,
  "actionPerformed": null,
  "createdByAuthorAt": "2026-05-30T10:45:00.000Z"
}
```

### 3. text + video
```json
{
  "localId": "loc_tvid03",
  "jobId": "job_1025",
  "senderUid": "profile_uid",
  "content": [
    {
      "type": "text",
      "content": "Here is the video proof",
      "metadata": null
    },
    {
      "type": "video",
      "content": "uploads/chat/video.mp4",
      "metadata": {
        "fileName": "video.mp4",
        "size": "12.8 MB",
        "mimeType": "video/mp4",
        "videoMetadata": {
          "aspectRatio": 1.999,
          "duration": 45,
          "thumbnailBlurHash": "hash"
        }
      }
    }
  ],
  "type": "message",
  "metadata": null,
  "actionPerformed": null,
  "createdByAuthorAt": "2026-05-30T10:45:00.000Z"
}
```

### 4. text + doc
```json
{
  "localId": "loc_tdoc04",
  "jobId": "job_1025",
  "senderUid": "profile_uid",
  "content": [
    {
      "type": "text",
      "content": "Updated specifications doc",
      "metadata": null
    },
    {
      "type": "document",
      "content": "uploads/chat/file.docx",
      "metadata": {
        "fileName": "file.docx",
        "size": "245 KB",
        "mimeType": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "documentMetadata": {
          "extension": "docx",
          "pageCount": null
        }
      }
    }
  ],
  "type": "message",
  "metadata": null,
  "actionPerformed": null,
  "createdByAuthorAt": "2026-05-30T10:45:00.000Z"
}
```

### 5. text + pdf
```json
{
  "localId": "loc_tpdf05",
  "jobId": "job_1025",
  "senderUid": "profile_uid",
  "content": [
    {
      "type": "text",
      "content": "Layout blueprint",
      "metadata": null
    },
    {
      "type": "pdf",
      "content": "uploads/chat/file.pdf",
      "metadata": {
        "fileName": "file.pdf",
        "size": "1.8 MB",
        "mimeType": "application/pdf",
        "pdfMetadata": {
          "extension": "pdf",
          "pageCount": 12
        }
      }
    }
  ],
  "type": "message",
  "metadata": null,
  "actionPerformed": null,
  "createdByAuthorAt": "2026-05-30T10:45:00.000Z"
}
```

### 6. image
```json
{
  "localId": "loc_img06",
  "jobId": "job_1025",
  "senderUid": "profile_uid",
  "content": [
    {
      "type": "image",
      "content": "uploads/chat/image.jpg",
      "metadata": {
        "fileName": "image.jpg",
        "size": "1.2 MB",
        "mimeType": "image/jpeg",
        "imageMetadata": {
          "width": 1080,
          "height": 1440,
          "blurHash": "hash"
        }
      }
    }
  ],
  "type": "message",
  "metadata": null,
  "actionPerformed": null,
  "createdByAuthorAt": "2026-05-30T10:45:00.000Z"
}
```

### 7. video
```json
{
  "localId": "loc_vid07",
  "jobId": "job_1025",
  "senderUid": "profile_uid",
  "content": [
    {
      "type": "video",
      "content": "uploads/chat/video.mp4",
      "metadata": {
        "fileName": "video.mp4",
        "size": "12.8 MB",
        "mimeType": "video/mp4",
        "videoMetadata": {
          "aspectRatio": 1.999,
          "duration": 45,
          "thumbnailBlurHash": "hash"
        }
      }
    }
  ],
  "type": "message",
  "metadata": null,
  "actionPerformed": null,
  "createdByAuthorAt": "2026-05-30T10:45:00.000Z"
}
```

### 8. doc
```json
{
  "localId": "loc_doc08",
  "jobId": "job_1025",
  "senderUid": "profile_uid",
  "content": [
    {
      "type": "document",
      "content": "uploads/chat/file.docx",
      "metadata": {
        "fileName": "file.docx",
        "size": "245 KB",
        "mimeType": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "documentMetadata": {
          "extension": "docx",
          "pageCount": null
        }
      }
    }
  ],
  "type": "message",
  "metadata": null,
  "actionPerformed": null,
  "createdByAuthorAt": "2026-05-30T10:45:00.000Z"
}
```

### 9. pdf
```json
{
  "localId": "loc_pdf09",
  "jobId": "job_1025",
  "senderUid": "profile_uid",
  "content": [
    {
      "type": "pdf",
      "content": "uploads/chat/file.pdf",
      "metadata": {
        "fileName": "file.pdf",
        "size": "1.8 MB",
        "mimeType": "application/pdf",
        "pdfMetadata": {
          "extension": "pdf",
          "pageCount": 12
        }
      }
    }
  ],
  "type": "message",
  "metadata": null,
  "actionPerformed": null,
  "createdByAuthorAt": "2026-05-30T10:45:00.000Z"
}
```

### 10. doc + pdf
```json
{
  "localId": "loc_dpdf10",
  "jobId": "job_1025",
  "senderUid": "profile_uid",
  "content": [
    {
      "type": "document",
      "content": "uploads/chat/file.docx",
      "metadata": {
        "fileName": "file.docx",
        "size": "245 KB",
        "mimeType": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "documentMetadata": {
          "extension": "docx",
          "pageCount": null
        }
      }
    },
    {
      "type": "pdf",
      "content": "uploads/chat/file.pdf",
      "metadata": {
        "fileName": "file.pdf",
        "size": "1.8 MB",
        "mimeType": "application/pdf",
        "pdfMetadata": {
          "extension": "pdf",
          "pageCount": 12
        }
      }
    }
  ],
  "type": "message",
  "metadata": null,
  "actionPerformed": null,
  "createdByAuthorAt": "2026-05-30T10:45:00.000Z"
}
```

### 11. reply
```json
{
  "localId": "loc_rep11",
  "jobId": "job_1025",
  "senderUid": "profile_uid",
  "content": [
    {
      "type": "reply",
      "content": "Hello, how is the work going?",
      "metadata": {
        "messageUid": "msg_uid",
        "senderName": "Jane Doe",
        "senderUid": "profile_uid",
        "type": "message",
        "mediaType": "text",
        "mediaUrl": null,
        "blurHash": null,
        "pageCount": null,
        "remainingMediaCount": 0
      }
    },
    {
      "type": "text",
      "content": "It is going great!",
      "metadata": null
    }
  ],
  "type": "message",
  "metadata": null,
  "actionPerformed": null,
  "createdByAuthorAt": "2026-05-30T10:45:00.000Z"
}
```

### 12. reply + image
```json
{
  "localId": "loc_repimg12",
  "jobId": "job_1025",
  "senderUid": "profile_uid",
  "content": [
    {
      "type": "reply",
      "content": "Hello, how is the work going?",
      "metadata": {
        "messageUid": "msg_uid",
        "senderName": "Jane Doe",
        "senderUid": "profile_uid",
        "type": "message",
        "mediaType": "text",
        "mediaUrl": null,
        "blurHash": null,
        "pageCount": null,
        "remainingMediaCount": 0
      }
    },
    {
      "type": "image",
      "content": "uploads/chat/image.jpg",
      "metadata": {
        "fileName": "image.jpg",
        "size": "1.2 MB",
        "mimeType": "image/jpeg",
        "imageMetadata": {
          "width": 1080,
          "height": 1440,
          "blurHash": "hash"
        }
      }
    }
  ],
  "type": "message",
  "metadata": null,
  "actionPerformed": null,
  "createdByAuthorAt": "2026-05-30T10:45:00.000Z"
}
```

### 14. reply + video
```json
{
  "localId": "loc_repvid14",
  "jobId": "job_1025",
  "senderUid": "profile_uid",
  "content": [
    {
      "type": "reply",
      "content": "Hello, how is the work going?",
      "metadata": {
        "messageUid": "msg_uid",
        "senderName": "Jane Doe",
        "senderUid": "profile_uid",
        "type": "message",
        "mediaType": "text",
        "mediaUrl": null,
        "blurHash": null,
        "pageCount": null,
        "remainingMediaCount": 0
      }
    },
    {
      "type": "video",
      "content": "uploads/chat/video.mp4",
      "metadata": {
        "fileName": "video.mp4",
        "size": "12.8 MB",
        "mimeType": "video/mp4",
        "videoMetadata": {
          "aspectRatio": 1.999,
          "duration": 45,
          "thumbnailBlurHash": "hash"
        }
      }
    }
  ],
  "type": "message",
  "metadata": null,
  "actionPerformed": null,
  "createdByAuthorAt": "2026-05-30T10:45:00.000Z"
}
```

### 15. reply + doc
```json
{
  "localId": "loc_repdoc15",
  "jobId": "job_1025",
  "senderUid": "profile_uid",
  "content": [
    {
      "type": "reply",
      "content": "Hello, how is the work going?",
      "metadata": {
        "messageUid": "msg_uid",
        "senderName": "Jane Doe",
        "senderUid": "profile_uid",
        "type": "message",
        "mediaType": "text",
        "mediaUrl": null,
        "blurHash": null,
        "pageCount": null,
        "remainingMediaCount": 0
      }
    },
    {
      "type": "document",
      "content": "uploads/chat/file.docx",
      "metadata": {
        "fileName": "file.docx",
        "size": "245 KB",
        "mimeType": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "documentMetadata": {
          "extension": "docx",
          "pageCount": null
        }
      }
    }
  ],
  "type": "message",
  "metadata": null,
  "actionPerformed": null,
  "createdByAuthorAt": "2026-05-30T10:45:00.000Z"
}
```

### 16. reply + pdf
```json
{
  "localId": "loc_reppdf16",
  "jobId": "job_1025",
  "senderUid": "profile_uid",
  "content": [
    {
      "type": "reply",
      "content": "Hello, how is the work going?",
      "metadata": {
        "messageUid": "msg_uid",
        "senderName": "Jane Doe",
        "senderUid": "profile_uid",
        "type": "message",
        "mediaType": "text",
        "mediaUrl": null,
        "blurHash": null,
        "pageCount": null,
        "remainingMediaCount": 0
      }
    },
    {
      "type": "pdf",
      "content": "uploads/chat/file.pdf",
      "metadata": {
        "fileName": "file.pdf",
        "size": "1.8 MB",
        "mimeType": "application/pdf",
        "pdfMetadata": {
          "extension": "pdf",
          "pageCount": 12
        }
      }
    }
  ],
  "type": "message",
  "metadata": null,
  "actionPerformed": null,
  "createdByAuthorAt": "2026-05-30T10:45:00.000Z"
}
```

### 18. reply + doc + pdf
```json
{
  "localId": "loc_repdp18",
  "jobId": "job_1025",
  "senderUid": "profile_uid",
  "content": [
    {
      "type": "reply",
      "content": "Hello, how is the work going?",
      "metadata": {
        "messageUid": "msg_uid",
        "senderName": "Jane Doe",
        "senderUid": "profile_uid",
        "type": "message",
        "mediaType": "text",
        "mediaUrl": null,
        "blurHash": null,
        "pageCount": null,
        "remainingMediaCount": 0
      }
    },
    {
      "type": "document",
      "content": "uploads/chat/file.docx",
      "metadata": {
        "fileName": "file.docx",
        "size": "245 KB",
        "mimeType": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "documentMetadata": {
          "extension": "docx",
          "pageCount": null
        }
      }
    },
    {
      "type": "pdf",
      "content": "uploads/chat/file.pdf",
      "metadata": {
        "fileName": "file.pdf",
        "size": "1.8 MB",
        "mimeType": "application/pdf",
        "pdfMetadata": {
          "extension": "pdf",
          "pageCount": 12
        }
      }
    }
  ],
  "type": "message",
  "metadata": null,
  "actionPerformed": null,
  "createdByAuthorAt": "2026-05-30T10:45:00.000Z"
}
```

### 19. text + doc + pdf
```json
{
  "localId": "loc_tdocpdf19",
  "jobId": "job_1025",
  "senderUid": "profile_uid",
  "content": [
    {
      "type": "text",
      "content": "Here are the files",
      "metadata": null
    },
    {
      "type": "document",
      "content": "uploads/chat/file.docx",
      "metadata": {
        "fileName": "file.docx",
        "size": "245 KB",
        "mimeType": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "documentMetadata": {
          "extension": "docx",
          "pageCount": null
        }
      }
    },
    {
      "type": "pdf",
      "content": "uploads/chat/file.pdf",
      "metadata": {
        "fileName": "file.pdf",
        "size": "1.8 MB",
        "mimeType": "application/pdf",
        "pdfMetadata": {
          "extension": "pdf",
          "pageCount": 12
        }
      }
    }
  ],
  "type": "message",
  "metadata": null,
  "actionPerformed": null,
  "createdByAuthorAt": "2026-05-30T10:45:00.000Z"
}
```

### 20. when a activity requested
```json
{
  "localId": "loc_actreq20",
  "jobId": "job_1025",
  "senderUid": "system",
  "content": [
    {
      "type": "text",
      "content": "Please share your current location.",
      "metadata": null
    }
  ],
  "type": "activity",
  "metadata": {
    "activity_type": "askLocation"
  },
  "actionPerformed": null,
  "createdByAuthorAt": "2026-05-30T10:45:00.000Z"
}
```

### 21. when a action performed (actionPerformed when we are sending this one example)
```json
{
  "localId": "loc_actperf21",
  "jobId": "job_1025",
  "senderUid": "profile_uid",
  "content": [
    {
      "type": "text",
      "content": "I have reached the worksite location.",
      "metadata": null
    }
  ],
  "type": "activity",
  "metadata": {
    "activity_type": "reachedLocation",
    "latitude": 37.7749,
    "longitude": -122.4194,
    "address": "123 Main St, Springfield"
  },
  "actionPerformed": "reachedLocation",
  "createdByAuthorAt": "2026-05-30T10:45:00.000Z"
}
```

### 22. when a reply to a activity
```json
{
  "localId": "loc_repact22",
  "jobId": "job_1025",
  "senderUid": "profile_uid",
  "content": [
    {
      "type": "reply",
      "content": "Please share your current location.",
      "metadata": {
        "messageUid": "msg_uid_of_activity",
        "senderName": "System",
        "senderUid": "system",
        "type": "activity",
        "mediaType": "text",
        "mediaUrl": null,
        "blurHash": null,
        "pageCount": null,
        "remainingMediaCount": 0
      }
    },
    {
      "type": "text",
      "content": "Here is my location",
      "metadata": null
    }
  ],
  "type": "activity",
  "metadata": {
    "activity_type": "sendLocation",
    "latitude": 37.7749,
    "longitude": -122.4194,
    "address": "123 Main St, Springfield"
  },
  "actionPerformed": "sendLocation",
  "createdByAuthorAt": "2026-05-30T10:45:00.000Z"
}
```

---

## Part 2: Received Message Payloads (Server → Client)

These JSON structures represent the wrapped responses returned by the server containing message metadata fields.

### 1. Received Text Message Response Wrap
```json
{
  "message": {
    "uid": "msg_01h3x8f4d89a2b5c7e9f012345",
    "localId": "loc_txt101",
    "jobId": "job_1025",
    "senderUid": "profile_uid",
    "content": [
      {
        "type": "text",
        "content": "Hello world",
        "metadata": null
      }
    ],
    "type": "message",
    "metadata": null,
    "actionPerformed": null,
    "createdByAuthorAt": "2026-05-30T10:45:00.000Z",
    "createdAt": "2026-05-30T10:45:01.234Z",
    "updatedAt": "2026-05-30T10:45:01.234Z",
    "seenAt": null,
    "deliveredAt": "2026-05-30T10:45:02.100Z",
    "active": true,
    "deleted": false
  },
  "allowedActions": [
    "delete",
    "edit"
  ],
  "job": null
}
```

### 2. Received Text + Image Message Response Wrap
```json
{
  "message": {
    "uid": "msg_01h3x8f4d89a2b5c7e9f012346",
    "localId": "loc_timg02",
    "jobId": "job_1025",
    "senderUid": "profile_uid",
    "content": [
      {
        "type": "text",
        "content": "Here is the completed wall painting",
        "metadata": null
      },
      {
        "type": "image",
        "content": "uploads/chat/image.jpg",
        "metadata": {
          "fileName": "image.jpg",
          "size": "1.2 MB",
          "mimeType": "image/jpeg",
          "imageMetadata": {
            "width": 1080,
            "height": 1440,
            "blurHash": "hash"
          }
        }
      }
    ],
    "type": "message",
    "metadata": null,
    "actionPerformed": null,
    "createdByAuthorAt": "2026-05-30T10:45:00.000Z",
    "createdAt": "2026-05-30T10:45:01.554Z",
    "updatedAt": "2026-05-30T10:45:01.554Z",
    "seenAt": null,
    "deliveredAt": "2026-05-30T10:46:03.112Z",
    "active": true,
    "deleted": false
  },
  "allowedActions": [
    "delete"
  ],
  "job": null
}
```

## Part 3: API Endpoint Response Structures

This section defines the top-level envelopes returned by the REST endpoints.

### 1. Fetch Messages Endpoint (`GET /api/v1/common/job-chat/{jobId}/messages`)
Returns a list of messages under the `data` key.

```json
{
  "success": true,
  "message": "Messages fetched successfully",
  "data": [
    {
      "uid": "msg_01h3x8f4d89a2b5c7e9f012345",
      "localId": "loc_txt101",
      "jobId": "job_1025",
      "senderUid": "profile_uid",
      "content": [
        {
          "type": "text",
          "content": "Hello world",
          "metadata": null
        }
      ],
      "type": "message",
      "metadata": null,
      "actionPerformed": null,
      "createdByAuthorAt": "2026-05-30T10:45:00.000Z",
      "createdAt": "2026-05-30T10:45:01.234Z",
      "updatedAt": "2026-05-30T10:45:01.234Z",
      "seenAt": null,
      "deliveredAt": "2026-05-30T10:45:02.100Z",
      "active": true,
      "deleted": false
    }
  ]
}
```

### 2. Send Message Endpoint (`POST /api/v1/common/job-chat/{jobId}/messages`)
Returns the message wrap under the `data` key, containing the created message, allowed user actions, and the updated job details.

```json
{
  "success": true,
  "message": "Message sent successfully",
  "data": {
    "message": {
      "uid": "msg_01h3x8f4d89a2b5c7e9f012345",
      "localId": "loc_txt101",
      "jobId": "job_1025",
      "senderUid": "profile_uid",
      "content": [
        {
          "type": "text",
          "content": "Hello world",
          "metadata": null
        }
      ],
      "type": "message",
      "metadata": null,
      "actionPerformed": null,
      "createdByAuthorAt": "2026-05-30T10:45:00.000Z",
      "createdAt": "2026-05-30T10:45:01.234Z",
      "updatedAt": "2026-05-30T10:45:01.234Z",
      "seenAt": null,
      "deliveredAt": "2026-05-30T10:45:02.100Z",
      "active": true,
      "deleted": false
    },
    "allowedActions": [
      "delete",
      "edit"
    ],
    "job": {
      "jobId": "job_1025",
      "jobTitle": "Wall Painting",
      "customerName": "John Doe",
      "customerPhone": "+1234567890",
      "customerAddress": "123 Main St, Springfield",
      "workerProfileUid": "profile_uid",
      "workerName": "Jane Worker",
      "workerImage": "uploads/profiles/worker.jpg",
      "createdByProfileUid": "admin_uid",
      "createdByName": "Admin User",
      "status": "in_progress",
      "requirePhotoOnStart": true,
      "requirePhotoOnComplete": true,
      "captureLocation": true,
      "createdAt": "2026-05-30T10:00:00.000Z",
      "assignedAt": "2026-05-30T10:05:00.000Z",
      "startedAt": "2026-05-30T10:15:00.000Z",
      "updatedAt": "2026-05-30T10:45:01.234Z",
      "completedAt": null,
      "lastMessage": "Hello world",
      "lastMessageAt": "2026-05-30T10:45:01.234Z",
      "lastActivityType": "reachedLocation",
      "lastActivityMessage": "I have reached the worksite location.",
      "lastActivityAt": "2026-05-30T10:30:00.000Z",
      "allowedActions": [
        "complete_job",
        "take_break"
      ]
    }
  }
}
```

### 3. Fetch Jobs Endpoint (`GET /api/v1/admin/jobs` or `GET /api/v1/employee/jobs`)
Returns paginated job data and metadata under the `data` key.

```json
{
  "success": true,
  "message": "Jobs fetched successfully",
  "data": {
    "totalCount": 1,
    "totalPages": 1,
    "itemCount": 1,
    "limit": 20,
    "offset": 0,
    "jobs": [
      {
        "jobId": "job_1025",
        "jobTitle": "Wall Painting",
        "customerName": "John Doe",
        "customerPhone": "+1234567890",
        "customerAddress": "123 Main St, Springfield",
        "workerProfileUid": "profile_uid",
        "workerName": "Jane Worker",
        "workerImage": "uploads/profiles/worker.jpg",
        "createdByProfileUid": "admin_uid",
        "createdByName": "Admin User",
        "status": "in_progress",
        "requirePhotoOnStart": true,
        "requirePhotoOnComplete": true,
        "captureLocation": true,
        "createdAt": "2026-05-30T10:00:00.000Z",
        "assignedAt": "2026-05-30T10:05:00.000Z",
        "startedAt": "2026-05-30T10:15:00.000Z",
        "updatedAt": "2026-05-30T10:45:01.234Z",
        "completedAt": null,
        "lastMessage": "Hello world",
        "lastMessageAt": "2026-05-30T10:45:01.234Z",
        "lastActivityType": "reachedLocation",
        "lastActivityMessage": "I have reached the worksite location.",
        "lastActivityAt": "2026-05-30T10:30:00.000Z",
        "allowedActions": [
          "complete_job",
          "take_break"
        ]
      }
    ]
  }
}
```
