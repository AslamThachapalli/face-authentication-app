import 'package:face_auth/model/user_model.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

Future<FaceFeatures> extractFaceFeatures(
    InputImage inputImage, FaceDetector faceDetector) async {
  List<Face> faceList = await faceDetector.processImage(inputImage);
  Face face = faceList.first;

  FaceFeatures faceFeatures = FaceFeatures(
    rightEar: Points(
        x: (face.landmarks[FaceLandmarkType.rightEar])?.position.x,
        y: (face.landmarks[FaceLandmarkType.rightEar])?.position.y),
    leftEar: Points(
        x: (face.landmarks[FaceLandmarkType.leftEar])?.position.x,
        y: (face.landmarks[FaceLandmarkType.leftEar])?.position.y),
    rightMouth: Points(
        x: (face.landmarks[FaceLandmarkType.rightMouth])?.position.x,
        y: (face.landmarks[FaceLandmarkType.rightMouth])?.position.y),
    leftMouth: Points(
        x: (face.landmarks[FaceLandmarkType.leftMouth])?.position.x,
        y: (face.landmarks[FaceLandmarkType.leftMouth])?.position.y),
    rightEye: Points(
        x: (face.landmarks[FaceLandmarkType.rightEye])?.position.x,
        y: (face.landmarks[FaceLandmarkType.rightEye])?.position.y),
    leftEye: Points(
        x: (face.landmarks[FaceLandmarkType.leftEye])?.position.x,
        y: (face.landmarks[FaceLandmarkType.leftEye])?.position.y),
    rightCheek: Points(
        x: (face.landmarks[FaceLandmarkType.rightCheek])?.position.x,
        y: (face.landmarks[FaceLandmarkType.rightCheek])?.position.y),
    leftCheek: Points(
        x: (face.landmarks[FaceLandmarkType.leftCheek])?.position.x,
        y: (face.landmarks[FaceLandmarkType.leftCheek])?.position.y),
    noseBase: Points(
        x: (face.landmarks[FaceLandmarkType.noseBase])?.position.x,
        y: (face.landmarks[FaceLandmarkType.noseBase])?.position.y),
    bottomMouth: Points(
        x: (face.landmarks[FaceLandmarkType.bottomMouth])?.position.x,
        y: (face.landmarks[FaceLandmarkType.bottomMouth])?.position.y),
  );

  return faceFeatures;
}
