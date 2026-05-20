import 'dart:io';

void main(List<String> args) {
  final _CliArgs parsed = _CliArgs.parse(args);

  if (parsed.showHelp) {
    _printUsage();
    return;
  }

  if (parsed.featureName == null || parsed.featureName!.trim().isEmpty) {
    stderr.writeln('Missing feature name.');
    _printUsage();
    exitCode = 64;
    return;
  }

  final String normalizedFeature = _normalizeFeatureName(parsed.featureName!);
  if (normalizedFeature.isEmpty) {
    stderr.writeln('Invalid feature name: ${parsed.featureName}');
    exitCode = 64;
    return;
  }

  final String packageName = _readPackageName();
  final String featureClass = _toPascalCase(normalizedFeature);
  final String featureVar = _toCamelCase(normalizedFeature);

  final Map<String, String> files = _buildTemplates(
    packageName: packageName,
    featureName: normalizedFeature,
    featureClass: featureClass,
    featureVar: featureVar,
  );

  final List<String> existing = files.keys
      .where((String path) => File(path).existsSync())
      .toList(growable: false);

  if (existing.isNotEmpty && !parsed.force) {
    stderr.writeln('Feature already has generated files:');
    for (final String path in existing) {
      stderr.writeln('- $path');
    }
    stderr.writeln('Use --force to overwrite.');
    exitCode = 1;
    return;
  }

  for (final MapEntry<String, String> entry in files.entries) {
    final File file = File(entry.key);
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(entry.value);
  }

  stdout.writeln('Feature "$normalizedFeature" created successfully.');
  stdout.writeln('Next steps:');
  stdout.writeln('1) Register route in lib/core/utils/ui/app_router.dart');
  stdout.writeln('2) Implement remote datasource logic');
  stdout.writeln('3) Add localization keys for the new page');
  stdout.writeln('Route snippet:');
  stdout.writeln(
    "GoRoute(path: '/$normalizedFeature', builder: (context, state) => "
    "BlocProvider(create: (_) => getIt<${featureClass}Controller>(), "
    "child: const ${featureClass}Page())),",
  );
}

void _printUsage() {
  stdout.writeln('Usage:');
  stdout.writeln('  dart run tool/create_feature.dart --name <feature_name>');
  stdout.writeln('  dart run tool/create_feature.dart <feature_name>');
  stdout.writeln('Options:');
  stdout.writeln('  --force     Overwrite existing generated files');
  stdout.writeln('  --help      Show this message');
  stdout.writeln('Examples:');
  stdout.writeln('  dart run tool/create_feature.dart --name order_history');
  stdout.writeln('  melos run feature:create -- --name portfolio');
}

String _readPackageName() {
  final File pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    return 'fresh_base_project';
  }

  final List<String> lines = pubspec.readAsLinesSync();
  for (final String line in lines) {
    final String trimmed = line.trim();
    if (trimmed.startsWith('name:')) {
      return trimmed.substring(5).trim();
    }
  }

  return 'fresh_base_project';
}

String _normalizeFeatureName(String raw) {
  final String normalized = raw
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
  return normalized;
}

String _toPascalCase(String snakeCase) {
  return snakeCase
      .split('_')
      .where((String part) => part.isNotEmpty)
      .map(
        (String part) =>
            '${part.substring(0, 1).toUpperCase()}${part.substring(1)}',
      )
      .join();
}

String _toCamelCase(String snakeCase) {
  final String pascal = _toPascalCase(snakeCase);
  if (pascal.isEmpty) {
    return pascal;
  }
  return '${pascal.substring(0, 1).toLowerCase()}${pascal.substring(1)}';
}

Map<String, String> _buildTemplates({
  required String packageName,
  required String featureName,
  required String featureClass,
  required String featureVar,
}) {
  final String base = 'lib/features/$featureName';

  return <String, String>{
    '$base/domain/entities/${featureName}_entity.dart': _entityTemplate(
      featureClass,
    ),
    '$base/domain/repositories/${featureName}_repository.dart':
        _repositoryTemplate(packageName, featureName, featureClass),
    '$base/domain/usecases/get_${featureName}_list_use_case.dart':
        _useCaseTemplate(packageName, featureName, featureClass),
    '$base/data/models/${featureName}_model.dart': _modelTemplate(
      packageName,
      featureName,
      featureClass,
    ),
    '$base/data/datasources/${featureName}_remote_data_source.dart':
        _dataSourceTemplate(packageName, featureName, featureClass),
    '$base/data/repositories/${featureName}_repository_impl.dart':
        _repositoryImplTemplate(packageName, featureName, featureClass),
    '$base/presentation/controllers/${featureName}_state.dart': _stateTemplate(
      packageName,
      featureName,
      featureClass,
    ),
    '$base/presentation/controllers/${featureName}_controller.dart':
        _controllerTemplate(packageName, featureName, featureClass, featureVar),
    '$base/presentation/pages/${featureName}_page.dart': _pageTemplate(
      packageName,
      featureName,
      featureClass,
    ),
    '$base/presentation/widgets/${featureName}_tile.dart': _tileTemplate(
      packageName,
      featureName,
      featureClass,
    ),
  };
}

String _entityTemplate(String featureClass) =>
    '''import 'package:equatable/equatable.dart';

/// Domain entity for $featureClass feature.
class ${featureClass}Entity extends Equatable {
  const ${featureClass}Entity({required this.id, required this.name});

  final int id;
  final String name;

  @override
  List<Object?> get props => <Object?>[id, name];
}
''';

String _repositoryTemplate(
  String packageName,
  String featureName,
  String featureClass,
) => '''import 'package:$packageName/core/types/result.dart';
import 'package:$packageName/features/$featureName/domain/entities/${featureName}_entity.dart';

/// Contract for $featureClass domain operations.
abstract interface class ${featureClass}Repository {
  /// Returns the feature list.
  ResultFuture<List<${featureClass}Entity>> getList();
}
''';

String _useCaseTemplate(
  String packageName,
  String featureName,
  String featureClass,
) => '''import 'package:$packageName/core/types/result.dart';
import 'package:$packageName/features/$featureName/domain/entities/${featureName}_entity.dart';
import 'package:$packageName/features/$featureName/domain/repositories/${featureName}_repository.dart';
import 'package:injectable/injectable.dart';

/// Use case to fetch $featureClass list.
@injectable
class Get${featureClass}ListUseCase {
  const Get${featureClass}ListUseCase(this._repository);

  final ${featureClass}Repository _repository;

  /// Executes the list fetching flow.
  ResultFuture<List<${featureClass}Entity>> call() => _repository.getList();
}
''';

String _modelTemplate(
  String packageName,
  String featureName,
  String featureClass,
) => '''import 'package:equatable/equatable.dart';
import 'package:$packageName/features/$featureName/domain/entities/${featureName}_entity.dart';

/// DTO model for $featureClass payload.
class ${featureClass}Model extends Equatable {
  const ${featureClass}Model({required this.id, required this.name});

  factory ${featureClass}Model.fromJson(Map<String, dynamic> json) {
    return ${featureClass}Model(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }

  final int id;
  final String name;

  ${featureClass}Entity toEntity() {
    return ${featureClass}Entity(id: id, name: name);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'name': name};

  @override
  List<Object?> get props => <Object?>[id, name];
}
''';

String _dataSourceTemplate(
  String packageName,
  String featureName,
  String featureClass,
) =>
    '''import 'package:$packageName/features/$featureName/data/models/${featureName}_model.dart';
import 'package:injectable/injectable.dart';

/// Data source contract for $featureClass.
abstract interface class ${featureClass}RemoteDataSource {
  /// Returns raw models from API/local source.
  Future<List<${featureClass}Model>> getList();
}

/// Remote data source implementation for $featureClass.
@LazySingleton(as: ${featureClass}RemoteDataSource)
class ${featureClass}RemoteDataSourceImpl implements ${featureClass}RemoteDataSource {
  @override
  Future<List<${featureClass}Model>> getList() async {
    throw UnimplementedError('Implement getList for $featureClass.');
  }
}
''';

String _repositoryImplTemplate(
  String packageName,
  String featureName,
  String featureClass,
) => '''import 'package:dartz/dartz.dart';
import 'package:$packageName/core/errors/exceptions.dart';
import 'package:$packageName/core/errors/failure.dart';
import 'package:$packageName/core/types/result.dart';
import 'package:$packageName/features/$featureName/data/datasources/${featureName}_remote_data_source.dart';
import 'package:$packageName/features/$featureName/domain/entities/${featureName}_entity.dart';
import 'package:$packageName/features/$featureName/domain/repositories/${featureName}_repository.dart';
import 'package:injectable/injectable.dart';

/// Repository implementation for $featureClass.
@LazySingleton(as: ${featureClass}Repository)
class ${featureClass}RepositoryImpl implements ${featureClass}Repository {
  ${featureClass}RepositoryImpl({required ${featureClass}RemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final ${featureClass}RemoteDataSource _remoteDataSource;

  @override
  ResultFuture<List<${featureClass}Entity>> getList() async {
    try {
      final models = await _remoteDataSource.getList();
      final entities = models
          .map((model) => model.toEntity())
          .toList(growable: false);
      return Right<Failure, List<${featureClass}Entity>>(entities);
    } on ServerException catch (error) {
      return Left<Failure, List<${featureClass}Entity>>(
        ServerFailure(message: error.message, code: error.code),
      );
    } catch (error) {
      return Left<Failure, List<${featureClass}Entity>>(
        UnknownFailure(message: error.toString()),
      );
    }
  }
}
''';

String _stateTemplate(
  String packageName,
  String featureName,
  String featureClass,
) => '''import 'package:equatable/equatable.dart';
import 'package:$packageName/features/$featureName/domain/entities/${featureName}_entity.dart';

/// UI status for $featureClass page.
enum ${featureClass}Status { initial, loading, success, failure }

/// Immutable state for $featureClass presentation.
class ${featureClass}State extends Equatable {
  const ${featureClass}State({
    this.status = ${featureClass}Status.initial,
    this.items = const <${featureClass}Entity>[],
    this.errorMessage,
  });

  final ${featureClass}Status status;
  final List<${featureClass}Entity> items;
  final String? errorMessage;

  bool get hasData => items.isNotEmpty;

  ${featureClass}State copyWith({
    ${featureClass}Status? status,
    List<${featureClass}Entity>? items,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ${featureClass}State(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => <Object?>[status, items, errorMessage];
}
''';

String _controllerTemplate(
  String packageName,
  String featureName,
  String featureClass,
  String featureVar,
) => '''import 'package:$packageName/core/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:$packageName/core/errors/failure.dart';
import 'package:$packageName/features/$featureName/domain/entities/${featureName}_entity.dart';
import 'package:$packageName/features/$featureName/domain/usecases/get_${featureName}_list_use_case.dart';
import 'package:$packageName/features/$featureName/presentation/controllers/${featureName}_state.dart';
import 'package:injectable/injectable.dart';

/// Cubit that maps domain result to UI state for $featureClass.
@injectable
class ${featureClass}Controller extends Cubit<${featureClass}State> with BaseController {
  ${featureClass}Controller({required Get${featureClass}ListUseCase get${featureClass}ListUseCase})
    : _get${featureClass}ListUseCase = get${featureClass}ListUseCase,
      super(const ${featureClass}State()) {
    fetch$featureClass();
  }

  final Get${featureClass}ListUseCase _get${featureClass}ListUseCase;

  /// Loads the $featureClass list.
  Future<void> fetch$featureClass() async {
    showLoading();
    emit(state.copyWith(
      status: ${featureClass}Status.loading,
      clearErrorMessage: true,
    ));

    final result = await _get${featureClass}ListUseCase();
    result.fold(_handleFailure, _handleSuccess);

    hideLoading();
  }

  Future<void> refresh$featureClass() => fetch$featureClass();

  void on${featureClass}Tap(BuildContext context, ${featureClass}Entity $featureVar) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('You selected: ' + $featureVar.name)),
      );
  }

  void _handleFailure(Failure failure) {
    emit(state.copyWith(
      status: ${featureClass}Status.failure,
      items: const <${featureClass}Entity>[],
      errorMessage: failure.message,
    ));
  }

  void _handleSuccess(List<${featureClass}Entity> items) {
    emit(state.copyWith(
      status: ${featureClass}Status.success,
      items: items,
      clearErrorMessage: true,
    ));
  }

  @override
  Future<void> close() {
    onDisposeController();
    return super.close();
  }
}
''';

String _pageTemplate(
  String packageName,
  String featureName,
  String featureClass,
) => '''import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:$packageName/core/base/base_page.dart';
import 'package:$packageName/features/$featureName/presentation/controllers/${featureName}_controller.dart';
import 'package:$packageName/features/$featureName/presentation/controllers/${featureName}_state.dart';
import 'package:$packageName/features/$featureName/presentation/widgets/${featureName}_tile.dart';

/// Page for $featureClass feature.
class ${featureClass}Page extends BasePage {
  const ${featureClass}Page({super.key});

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$featureClass'),
        actions: <Widget>[
          IconButton(
            onPressed: context.read<${featureClass}Controller>().refresh$featureClass,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<${featureClass}Controller, ${featureClass}State>(
        builder: (BuildContext context, ${featureClass}State state) {

        if (!state.hasData) {
          return Center(
            child: Text(state.errorMessage ?? 'No $featureClass data'),
          );
        }

        return RefreshIndicator(
          onRefresh: context.read<${featureClass}Controller>().refresh$featureClass,
          child: ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = state.items[index];
              return ${featureClass}Tile(
                item: item,
                onTap: () => context.read<${featureClass}Controller>().on${featureClass}Tap(context, item),
              );
            },
          ),
        );
      }),
    );
  }
}
''';

String _tileTemplate(
  String packageName,
  String featureName,
  String featureClass,
) => '''import 'package:flutter/material.dart';
import 'package:$packageName/features/$featureName/domain/entities/${featureName}_entity.dart';

/// Reusable list tile for $featureClass item.
class ${featureClass}Tile extends StatelessWidget {
  const ${featureClass}Tile({super.key, required this.item, this.onTap});

  final ${featureClass}Entity item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text('ID: \${item.id}'),
      onTap: onTap,
    );
  }
}
''';

class _CliArgs {
  _CliArgs({
    required this.featureName,
    required this.force,
    required this.showHelp,
  });

  final String? featureName;
  final bool force;
  final bool showHelp;

  static _CliArgs parse(List<String> args) {
    String? featureName;
    bool force = false;
    bool showHelp = false;

    for (int i = 0; i < args.length; i++) {
      final String arg = args[i];
      if (arg == '--help' || arg == '-h') {
        showHelp = true;
      } else if (arg == '--force') {
        force = true;
      } else if (arg == '--name') {
        if (i + 1 < args.length) {
          featureName = args[i + 1];
          i++;
        }
      } else if (!arg.startsWith('--') && featureName == null) {
        featureName = arg;
      }
    }

    return _CliArgs(featureName: featureName, force: force, showHelp: showHelp);
  }
}
