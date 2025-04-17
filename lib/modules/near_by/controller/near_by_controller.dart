import '../../../common/common_imports/apis_commons.dart';
import '../../../common/common_imports/common_imports.dart';
import '../../../utility/API/fetch_api.dart';
import '../../profile/model/stories_model.dart';

final nearByCtr = ChangeNotifierProvider((ref) => NearByController());

class NearByController extends ChangeNotifier {
  final ScrollController nearByCardController = ScrollController();
  int selectedEventType = 0;
  int selectedSubEventType = 0;
  List<Stories>? stories;
  int currPage = 0;

  List subEventTypeList = [
    'Weddings',
    'Baby Shower',
    'Birthday',
    'Sports',
    'Startup',
    'Tech',
    'Premier',
  ];

  getMyStory(String? userID, BuildContext context, {bool? isLoader}) async {
    if (userID != null) {
      var url =
          '${ApiUrl.authentication}$userID/${DateTime.now().toIso8601String()}/${ApiUrl.getStories}';
      await ApiService.fetchApi(
        context: context,
        url: url,
        get: true,
        isLoader: isLoader ?? true,
        onSuccess: (res) {
          debugPrint(res.toString());
          if (res['statusCode'].toString() == '1') {
            stories = [];
            for (var element in (res['stories'] as List)) {
              stories?.add(Stories.fromJson(element));
            }
            notifyListeners();
          } else {
            notifyListeners();
            // EasyLoading.showError(res['validationMessage'].toString());
          }
        },
      );
    }
    return false;
  }

  void animateToNearByCard(int index) {
    double itemWidth = 0.34.sw;
    double separatorWidth = 20.w;
    double targetPosition = index * (itemWidth + separatorWidth);

    nearByCardController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

}