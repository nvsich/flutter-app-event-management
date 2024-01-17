import 'package:cursach_app/core/res/media_res.dart';
import 'package:equatable/equatable.dart';

class PageContent extends Equatable {
  const PageContent({
    required this.image,
    required this.text,
    required this.title,
  });

  // TODO: fill in the info
  const PageContent.first()
      : this(
          image: MediaRes.onboardingFirst,
          text: 'onboarding text 1',
          title: 'onboarding title 1',
        );

  const PageContent.second()
      : this(
          image: MediaRes.onboardingSecond,
          text: 'onboarding text 2',
          title: 'onboarding title 2',
        );

  final String image;
  final String text;
  final String title;

  @override
  List<Object?> get props => [image, text, title];
}
