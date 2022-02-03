import 'package:get/get.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class ImageCropController extends GetxController {
  static ImageCropController get to => Get.find();

  Future seletctImage(images) async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false, // 이미지 선택 전 미리보기
          selectCircleStrokeColor: "#000000",
          
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;
    return resultList;

    // image_picker를 통해 이미지 업로드
    // final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    // if (image == null) return null;

    // List<AssetImage> resultList = await Multiima.pickImages(
    //     maxImages: 10, enableCamera: true, slecetedAsset: imageList);

    // return File(image.path);

    // corp_image 사용
    // return await _cropImage(File(image.path));
  }




  // crop 필요에 따라 사용 => 아마 사용 안할듯?
  // Future _cropImage(File file) async {
  //   File? croppedFile = await ImageCropper.cropImage(
  //       sourcePath: file.path,
  //       aspectRatioPresets: Platform.isAndroid
  //           ? [
  //               CropAspectRatioPreset.square,
  //               CropAspectRatioPreset.ratio3x2,
  //               CropAspectRatioPreset.original,
  //               CropAspectRatioPreset.ratio4x3,
  //               CropAspectRatioPreset.ratio16x9
  //             ]
  //           : [
  //               CropAspectRatioPreset.original,
  //               CropAspectRatioPreset.square,
  //               CropAspectRatioPreset.ratio3x2,
  //               CropAspectRatioPreset.ratio4x3,
  //               CropAspectRatioPreset.ratio5x3,
  //               CropAspectRatioPreset.ratio5x4,
  //               CropAspectRatioPreset.ratio7x5,
  //               CropAspectRatioPreset.ratio16x9
  //             ],
  //       androidUiSettings: AndroidUiSettings(
  //           toolbarTitle: 'Cropper',
  //           toolbarColor: Colors.deepOrange,
  //           toolbarWidgetColor: Colors.white,
  //           initAspectRatio: CropAspectRatioPreset.original,
  //           lockAspectRatio: false),
  //       iosUiSettings: IOSUiSettings(
  //         title: 'Cropper',
  //       ));

  //   return croppedFile;
  // }
}
