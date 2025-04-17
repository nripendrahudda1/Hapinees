import 'package:Happinest/core/api_urls.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';

import '../../utility/API/fetch_api.dart';
import '../profile/model/stories_model.dart';
final exploreCtr = ChangeNotifierProvider((ref) => ExploreController());

class ExploreController extends ChangeNotifier {
  // PageController pageController = PageController(viewportFraction: 0.47);
  final ScrollController scrollController = ScrollController();
  int selectedEventType = 0;
  int selectedSubEventType = 0;
  String locationSearch = '';
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

  locationAdd(String location) {
    locationSearch = location;
    // notifyListeners();
  }

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

  void animateToPage(int index) {
    double itemWidth = 0.34.sw;
    double separatorWidth = 20.w;
    double targetPosition = index * (itemWidth + separatorWidth);

    scrollController.animateTo(
      targetPosition,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

}
