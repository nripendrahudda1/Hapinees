import '../../../common/common_imports/apis_commons.dart';
import '../../../common/common_imports/common_imports.dart';
import '../model/stories_model.dart';

final profileApisController = Provider<ProfileDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ProfileImplements(dioClient: dioClient);
});

abstract class ProfileDatasource {
}

class ProfileImplements implements ProfileDatasource {
  final DioClient dioClient;

  ProfileImplements({required this.dioClient});
}