# Flutter-specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class com.google.android.gms.** { *; }

# General Android ProGuard rules
# Ensures that certain classes, methods, and fields are not removed or renamed
-keep class * extends android.app.Activity
-keepclassmembers class * extends android.app.Activity {
   public void *(android.view.View);
}

-keep class * extends android.app.Fragment
-keepclassmembers class * extends android.app.Fragment {
   public void *(android.view.View);
}

-keepclassmembers class * extends android.app.Service {
    public void *(android.content.Intent);
}

-keep class * extends android.content.BroadcastReceiver
-keepclassmembers class * extends android.content.BroadcastReceiver {
    public void *(android.content.Context, android.content.Intent);
}

-keep class * extends android.content.ContentProvider
-keep class * extends android.database.ContentObserver
-keepclassmembers class * extends android.content.ContentProvider {
    public void *(...);
}

# Retain Parcelable implementations
-keepclassmembers class * implements android.os.Parcelable {
  static ** CREATOR;
}

# Keep access to native methods via JNI
-keep class * { native <methods>; }

# Keep the Flutter engine related rules
-keep class io.flutter.embedding.** { *; }

# Optimization settings
-optimizationpasses 5
-dontpreverify
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*
-keepattributes Signature,SourceFile,LineNumberTable,RuntimeVisibleAnnotations,AnnotationDefault,Exceptions,InnerClasses

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# This tells ProGuard not to obfuscate any code, making debugging easier.
-dontobfuscate