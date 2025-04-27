# Firebase Instance ID (needed for ML Kit)
-keep class com.google.firebase.iid.FirebaseInstanceId { *; }

# Keep all Firebase and ML Kit classes
-keep class com.google.firebase.** { *; }
-keep class com.google.mlkit.** { *; }
