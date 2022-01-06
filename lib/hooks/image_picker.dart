import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

ImagePicker useImagePicker() => useMemoized(ImagePicker.new);
