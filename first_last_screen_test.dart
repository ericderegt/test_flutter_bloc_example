import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:q_and_a_mobile/blocs/expert_onboarding/expert_onboarding.dart';
import 'package:q_and_a_mobile/blocs/expert_onboarding/expert_onboarding_bloc.dart';

import 'package:q_and_a_mobile/blocs/user_questions/user_questions.dart';
import 'package:q_and_a_mobile/models/que_register_expert.dart';
import 'package:q_and_a_mobile/models/user_question.dart';
import 'package:q_and_a_mobile/repositories/expert_onboarding_repository.dart';
import 'package:q_and_a_mobile/repositories/que_register_expert_entity.dart';
import 'package:q_and_a_mobile/repositories/user_question_entity.dart';
import 'package:q_and_a_mobile/repositories/user_questions_repository.dart';
import 'package:q_and_a_mobile/screens/expert_onboarding/first_last_screen.dart';

class MockExpertOnboardingRepository extends Mock
    implements ExpertOnboardingRepository {}

class MockUserQuestionsRepository extends Mock
    implements UserQuestionsRepository {}

class MockExpertOnboardingBloc
    extends MockBloc<ExpertOnboardingState, ExpertOnboardingEvent>
    implements ExpertOnboardingBloc {}

// // ignore: must_be_immutable
// class MockUser extends Mock implements User {
//   @override
//   String get email => 'test@gmail.com';
// }

void main() {
  // const logoutButtonKey = Key('homePage_logout_iconButton');
  group('FirstLastScreen', () {
    ExpertOnboardingRepository expertOnboardingRepository;
    ExpertOnboardingBloc expertOnboardingBloc;
    UserQuestionsRepository userQuestionsRepository;
    UserQuestionsBloc userQuestionsBloc;

    setUp(() {
      expertOnboardingRepository = MockExpertOnboardingRepository();
      userQuestionsRepository = MockUserQuestionsRepository();
      expertOnboardingBloc = MockExpertOnboardingBloc();
    });

    group('calls', () {
      testWidgets('UpdateFirstLastNameEvent called when button pressed',
          (tester) async {
        final buttonKey = const Key('FirstLastNextButtonKey');
        final mockUser = QueRegisterExpert(
          firstName: "eric",
          lastName: "deregt",
          birthday: DateTime.now(),
          title: "software engineer",
          bio: "i wrote this test",
          questionPrice: "\$1",
          category1: "Education",
          category2: "Philanthropy",
          category3: "Nutrition",
          country: "US",
          introVideoLink: "testlink",
        );
        await tester.pumpWidget(
          BlocProvider.value(
              value: expertOnboardingBloc,
              child: FirstLastScreen(user: mockUser)),
        );
        expect(
            find.byKey(
              buttonKey,
            ),
            findsOneWidget);
        // await tester.tap(find.byKey(
        //   const Key('FirstLastNextButtonKey'),
        // ));
        // verify(
        //   expertOnboardingBloc.add(
        //       UpdateFirstLastNameEvent(firstName: 'eric', lastName: 'deregt')),
        // ).called(1);
      });
    });

    group('renders', () {
      testWidgets('next button is there', (tester) async {
        final mockUser = QueRegisterExpert(
          firstName: "eric",
          lastName: "deregt",
          birthday: DateTime.now(),
          title: "software engineer",
          bio: "i wrote this test",
          questionPrice: "\$1",
          category1: "Education",
          category2: "Philanthropy",
          category3: "Nutrition",
          country: "US",
          introVideoLink: "testlink",
        );
        await tester.pumpWidget(
          BlocProvider.value(
              value: expertOnboardingBloc,
              child: FirstLastScreen(user: mockUser)),
        );
        await tester.pumpAndSettle();
        expect(find.text("What's your name?"), findsOneWidget);
      });
    });
  });
}
