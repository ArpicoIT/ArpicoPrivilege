import 'package:flutter/material.dart';
import 'package:arpicoprivilege/core/extentions/string_extensions.dart';
import 'package:image_picker/image_picker.dart';

Future<dynamic> showImageSourceSelector({
  required BuildContext context,
  int limit = 1,
}) async {
  final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context){
        return const ImageSourceSelector();
      },
      showDragHandle: true,
  );

  final ImagePicker picker = ImagePicker();
  List<XFile> images = [];

  switch(source){
    case null:
      return [];

    case ImageSource.camera:
      final photo = await picker.pickImage(source: ImageSource.camera);
      if(photo == null){
        break;
      }
      images.add(photo);
      break;

    case ImageSource.gallery:
      if(limit > 1){
        final pickedImages = await picker.pickMultiImage(limit: limit);
        if(pickedImages.isEmpty){
          break;
        }
        images.addAll(pickedImages);
      }
      else {
        final pickedImage = await picker.pickImage(source: ImageSource.gallery);
        if(pickedImage == null){
          break;
        }
        images.add(pickedImage);
      }

      break;
  }

  return images;
}

class ImageSourceSelector extends StatelessWidget {
  const ImageSourceSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: const EdgeInsets.all(12.0).copyWith(top: 0),
            margin: const EdgeInsets.only(bottom: 12.0),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant))
            ),
            child: Text("Select Source", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))
        ),

        ListTile(
          title: Text(ImageSource.camera.name.toUpperCaseFirst()),
          leading: const Icon(Icons.camera_alt_outlined),
          onTap: ()=> Navigator.of(context).maybePop(ImageSource.camera),
        ),
        ListTile(
          title: Text(ImageSource.gallery.name.toUpperCaseFirst()),
          leading: const Icon(Icons.photo_library_outlined),
          onTap: ()=> Navigator.of(context).maybePop(ImageSource.gallery),
        ),

        const SizedBox(height: 12.0)
      ],
    );
  }
}
