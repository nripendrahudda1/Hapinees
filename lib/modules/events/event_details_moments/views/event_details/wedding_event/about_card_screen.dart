import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import '../../../../../../common/widgets/cached_retangular_network_image.dart';
import '../card_webview_widget.dart';

class WeddingEventDetailCardScreen extends StatefulWidget {
  const WeddingEventDetailCardScreen({super.key});

  @override
  State<WeddingEventDetailCardScreen> createState() => _WeddingEventDetailCardScreenState();
}

class _WeddingEventDetailCardScreenState extends State<WeddingEventDetailCardScreen> {



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
                return isPDFLink (ref.read(weddingEventHomeController).homeWeddingDetails?.invitationUrl?? '') ? PDFViewer(
                  pdfUrl: ref.read(weddingEventHomeController).homeWeddingDetails?.invitationUrl ?? '',
                ):
                CachedRectangularNetworkImageWidget(
                  image: ref.read(weddingEventHomeController).homeWeddingDetails?.invitationUrl ?? '', width: 1.sw, height: 0.7.sh,radius: 0,);
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
