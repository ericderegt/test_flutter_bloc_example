import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:q_and_a_mobile/blocs/expert_onboarding/expert_onboarding.dart';
import 'package:q_and_a_mobile/blocs/user_questions/user_questions_bloc.dart';
import 'package:q_and_a_mobile/blocs/user_questions/user_questions_event.dart';
import 'package:q_and_a_mobile/models/que_register_expert.dart';
import 'package:q_and_a_mobile/repositories/expert_onboarding_repository.dart';

class ExpertOnboardingBloc
    extends Bloc<ExpertOnboardingEvent, ExpertOnboardingState> {
  final ExpertOnboardingRepository expertOnboardingRepository;
  final UserQuestionsBloc _userQuestionsBloc;

  ExpertOnboardingBloc({
    @required this.expertOnboardingRepository,
    @required UserQuestionsBloc userQuestionsBloc,
  })  : _userQuestionsBloc = userQuestionsBloc,
        super(ExpertOnboardingInitial());

  @override
  Stream<ExpertOnboardingState> mapEventToState(
      ExpertOnboardingEvent event) async* {
    if (event is LoadExpertProfile) {
      yield* _mapLoadExpertProfileToState(event);
    } else if (event is UpdateFirstLastNameEvent) {
      yield* _mapUpdateFirstLastNameEventToState(event);
    }
  }

  Stream<ExpertOnboardingState> _mapLoadExpertProfileToState(
      LoadExpertProfile event) async* {
    try {
      final profile = await this.expertOnboardingRepository.loadExpertProfile();
      final expertUser = QueRegisterExpert.fromEntity(profile);
      // TODO - create expert-onboarding/title, etc for each step, which calls update user profile and updates onboarding step, saving roundtrip to server
      yield ExpertProfileLoaded(expertUser: expertUser);
    } catch (e) {
      yield ExpertProfileNotLoaded();
    }
  }

  Stream<ExpertOnboardingState> _mapUpdateFirstLastNameEventToState(
      UpdateFirstLastNameEvent event) async* {
    try {
      yield UpdateFirstLastNameLoading();
      final didUpdate = await this
          .expertOnboardingRepository
          .updateFirstLastName(event.firstName, event.lastName);

      if (!didUpdate) {
        yield UpdateFirstLastNameFailure();
      }

      yield UpdateFirstLastNameSuccess();
    } catch (e) {
      yield UpdateFirstLastNameFailure();
    }
  }
}
