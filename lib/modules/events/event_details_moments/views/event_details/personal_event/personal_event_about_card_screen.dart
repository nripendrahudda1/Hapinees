import '../../../../../../common/common_imports/apis_commons.dart';
import '../../../../../../common/common_imports/common_imports.dart';
import '../../../../../../common/widgets/cached_retangular_network_image.dart';
import '../../../../event_homepage/personal_event/controller/personal_event_home_controller.dart';
import '../card_webview_widget.dart';

class PersonalEventDetailCardScreen extends ConsumerStatefulWidget {
  const PersonalEventDetailCardScreen({super.key});

  @override
  ConsumerState<PersonalEventDetailCardScreen> createState() => _PersonalEventDetailCardScreenState();
}

class _PersonalEventDetailCardScreenState extends ConsumerState<PersonalEventDetailCardScreen> {



  @override
  Widget build(BuildContext context) {
    return Container(
      color: TAppColors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                return isPDFLink (ref.read(personalEventHomeController).homePersonalEventDetailsModel?.invitationUrl?? '') ? PDFViewer(
                  pdfUrl: ref.read(personalEventHomeController).homePersonalEventDetailsModel?.invitationUrl ?? '',
                ):
                CachedRectangularNetworkImageWidget(
                  image: ref.read(personalEventHomeController).homePersonalEventDetailsModel?.invitationUrl ?? '', width: 1.sw, height: 0.7.sh,radius: 0,);
              },
            ),
          )
          ,
        ],
      ),
    );
  }
  bool isPDFLink(String link) {
    return link.toLowerCase().endsWith('.pdf');
  }

}
