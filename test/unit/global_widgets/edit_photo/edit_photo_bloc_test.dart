import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/global_widgets/edit_photo/bloc/edit_photo_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/photo_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

class MockPhotoRepository extends Mock implements PhotoRepository {}
class MockCustomerBloc extends Mock implements CustomerBloc {}
class MockCustomer extends Mock implements Customer {}
class MockXFile extends Mock implements XFile {}

void main() {
  group("Edit Photo Bloc Tests", () {
    late PhotoRepository photoRepository;
    late CustomerBloc customerBloc;

    late EditPhotoBloc editPhotoBloc;

    setUp(() {
      registerFallbackValue(CustomerUpdated(customer: MockCustomer()));
      registerFallbackValue(XFile("path"));
      photoRepository = MockPhotoRepository();
      customerBloc = MockCustomerBloc();

      editPhotoBloc = EditPhotoBloc(photoRepository: photoRepository, customerBloc: customerBloc);
    });

    tearDown(() {
      editPhotoBloc.close();
    });

    test("Initial state of EditPhotoBloc is PhotoUnchanged()", () {
      expect(editPhotoBloc.state, PhotoUnchanged());
    });

    blocTest<EditPhotoBloc, EditPhotoState>(
      "EditPhotoBloc ChangePhoto event on success changes state: [Submitting], [SubmitSuccess()]",
      build: () {
        when(() => photoRepository.upload(photo: any(named: "photo"), profileIdentifier: any(named: "profileIdentifier")))
          .thenAnswer((_) async => MockCustomer());

        when(() => customerBloc.add(any(that: isA<CustomerUpdated>())))
          .thenReturn(null);
        
        return editPhotoBloc;
      },
      act: (bloc) {
        bloc.add(ChangePhoto(photo: XFile("path"), profileIdentifier: "profileIdentifier"));
      },
      expect: () => [isA<Submitting>(), isA<SubmitSuccess>()]
    );

    blocTest<EditPhotoBloc, EditPhotoState>(
      "EditPhotoBloc ChangePhoto event on fail changes state: [Submitting], [SubmitFailed()]",
      build: () {
        when(() => photoRepository.upload(photo: any(named: "photo"), profileIdentifier: any(named: "profileIdentifier")))
          .thenThrow(ApiException(error: "error"));
        
        return editPhotoBloc;
      },
      act: (bloc) {
        bloc.add(ChangePhoto(photo: XFile("path"), profileIdentifier: "profileIdentifier"));
      },
      expect: () => [isA<Submitting>(), isA<SubmitFailed>()]
    );

    blocTest<EditPhotoBloc, EditPhotoState>(
      "EditPhotoBloc ChangePhoto event on success calls photoRepository.upload and customerBloc.add",
      build: () {
        when(() => photoRepository.upload(photo: any(named: "photo"), profileIdentifier: any(named: "profileIdentifier")))
          .thenAnswer((_) async => MockCustomer());

        when(() => customerBloc.add(any(that: isA<CustomerUpdated>())))
          .thenReturn(null);
        
        return editPhotoBloc;
      },
      act: (bloc) {
        bloc.add(ChangePhoto(photo: XFile("path"), profileIdentifier: "profileIdentifier"));
      },
      verify: (_) {
        verify(() => photoRepository.upload(photo: any(named: "photo"), profileIdentifier: any(named: "profileIdentifier"))).called(1);
        verify(() => customerBloc.add(any(that: isA<CustomerUpdated>()))).called(1);
      }
    );

    blocTest<EditPhotoBloc, EditPhotoState>(
      "EditPhotoBloc ResetPhotoForm event changes state: [PhotoUnchanged]",
      build: () => editPhotoBloc,
      seed: () => SubmitSuccess(photo: XFile("path")),
      act: (bloc) {
        bloc.add(ResetPhotoForm());
      },
      expect: () => [isA<PhotoUnchanged>()]
    );
  });
}