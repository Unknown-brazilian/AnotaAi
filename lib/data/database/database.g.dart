// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $WorkEntriesTable extends WorkEntries
    with TableInfo<$WorkEntriesTable, WorkEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workerNameMeta = const VerificationMeta(
    'workerName',
  );
  @override
  late final GeneratedColumn<String> workerName = GeneratedColumn<String>(
    'worker_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _employerNameMeta = const VerificationMeta(
    'employerName',
  );
  @override
  late final GeneratedColumn<String> employerName = GeneratedColumn<String>(
    'employer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _placeNameMeta = const VerificationMeta(
    'placeName',
  );
  @override
  late final GeneratedColumn<String> placeName = GeneratedColumn<String>(
    'place_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _serviceTypeMeta = const VerificationMeta(
    'serviceType',
  );
  @override
  late final GeneratedColumn<String> serviceType = GeneratedColumn<String>(
    'service_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<PaymentMode, int> paymentMode =
      GeneratedColumn<int>(
        'payment_mode',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<PaymentMode>($WorkEntriesTable.$converterpaymentMode);
  static const VerificationMeta _dailyRateMeta = const VerificationMeta(
    'dailyRate',
  );
  @override
  late final GeneratedColumn<double> dailyRate = GeneratedColumn<double>(
    'daily_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hourlyRateMeta = const VerificationMeta(
    'hourlyRate',
  );
  @override
  late final GeneratedColumn<double> hourlyRate = GeneratedColumn<double>(
    'hourly_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Currency, int> currency =
      GeneratedColumn<int>(
        'currency',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<Currency>($WorkEntriesTable.$convertercurrency);
  static const VerificationMeta _startMinutesMeta = const VerificationMeta(
    'startMinutes',
  );
  @override
  late final GeneratedColumn<int> startMinutes = GeneratedColumn<int>(
    'start_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endMinutesMeta = const VerificationMeta(
    'endMinutes',
  );
  @override
  late final GeneratedColumn<int> endMinutes = GeneratedColumn<int>(
    'end_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountDueMeta = const VerificationMeta(
    'amountDue',
  );
  @override
  late final GeneratedColumn<double> amountDue = GeneratedColumn<double>(
    'amount_due',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _amountPaidMeta = const VerificationMeta(
    'amountPaid',
  );
  @override
  late final GeneratedColumn<double> amountPaid = GeneratedColumn<double>(
    'amount_paid',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isPaidMeta = const VerificationMeta('isPaid');
  @override
  late final GeneratedColumn<bool> isPaid = GeneratedColumn<bool>(
    'is_paid',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_paid" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _paidDateMeta = const VerificationMeta(
    'paidDate',
  );
  @override
  late final GeneratedColumn<DateTime> paidDate = GeneratedColumn<DateTime>(
    'paid_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attachmentPathsMeta = const VerificationMeta(
    'attachmentPaths',
  );
  @override
  late final GeneratedColumn<String> attachmentPaths = GeneratedColumn<String>(
    'attachment_paths',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    workerName,
    employerName,
    placeName,
    serviceType,
    paymentMode,
    dailyRate,
    hourlyRate,
    currency,
    startMinutes,
    endMinutes,
    amountDue,
    amountPaid,
    isPaid,
    paidDate,
    latitude,
    longitude,
    address,
    attachmentPaths,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('worker_name')) {
      context.handle(
        _workerNameMeta,
        workerName.isAcceptableOrUnknown(data['worker_name']!, _workerNameMeta),
      );
    }
    if (data.containsKey('employer_name')) {
      context.handle(
        _employerNameMeta,
        employerName.isAcceptableOrUnknown(
          data['employer_name']!,
          _employerNameMeta,
        ),
      );
    }
    if (data.containsKey('place_name')) {
      context.handle(
        _placeNameMeta,
        placeName.isAcceptableOrUnknown(data['place_name']!, _placeNameMeta),
      );
    }
    if (data.containsKey('service_type')) {
      context.handle(
        _serviceTypeMeta,
        serviceType.isAcceptableOrUnknown(
          data['service_type']!,
          _serviceTypeMeta,
        ),
      );
    }
    if (data.containsKey('daily_rate')) {
      context.handle(
        _dailyRateMeta,
        dailyRate.isAcceptableOrUnknown(data['daily_rate']!, _dailyRateMeta),
      );
    }
    if (data.containsKey('hourly_rate')) {
      context.handle(
        _hourlyRateMeta,
        hourlyRate.isAcceptableOrUnknown(data['hourly_rate']!, _hourlyRateMeta),
      );
    }
    if (data.containsKey('start_minutes')) {
      context.handle(
        _startMinutesMeta,
        startMinutes.isAcceptableOrUnknown(
          data['start_minutes']!,
          _startMinutesMeta,
        ),
      );
    }
    if (data.containsKey('end_minutes')) {
      context.handle(
        _endMinutesMeta,
        endMinutes.isAcceptableOrUnknown(data['end_minutes']!, _endMinutesMeta),
      );
    }
    if (data.containsKey('amount_due')) {
      context.handle(
        _amountDueMeta,
        amountDue.isAcceptableOrUnknown(data['amount_due']!, _amountDueMeta),
      );
    }
    if (data.containsKey('amount_paid')) {
      context.handle(
        _amountPaidMeta,
        amountPaid.isAcceptableOrUnknown(data['amount_paid']!, _amountPaidMeta),
      );
    }
    if (data.containsKey('is_paid')) {
      context.handle(
        _isPaidMeta,
        isPaid.isAcceptableOrUnknown(data['is_paid']!, _isPaidMeta),
      );
    }
    if (data.containsKey('paid_date')) {
      context.handle(
        _paidDateMeta,
        paidDate.isAcceptableOrUnknown(data['paid_date']!, _paidDateMeta),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('attachment_paths')) {
      context.handle(
        _attachmentPathsMeta,
        attachmentPaths.isAcceptableOrUnknown(
          data['attachment_paths']!,
          _attachmentPathsMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      workerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}worker_name'],
      )!,
      employerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employer_name'],
      )!,
      placeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_name'],
      )!,
      serviceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_type'],
      )!,
      paymentMode: $WorkEntriesTable.$converterpaymentMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}payment_mode'],
        )!,
      ),
      dailyRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}daily_rate'],
      )!,
      hourlyRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hourly_rate'],
      )!,
      currency: $WorkEntriesTable.$convertercurrency.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}currency'],
        )!,
      ),
      startMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minutes'],
      ),
      endMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minutes'],
      ),
      amountDue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_due'],
      )!,
      amountPaid: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_paid'],
      )!,
      isPaid: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_paid'],
      )!,
      paidDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_date'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      attachmentPaths: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attachment_paths'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WorkEntriesTable createAlias(String alias) {
    return $WorkEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PaymentMode, int, int> $converterpaymentMode =
      const EnumIndexConverter<PaymentMode>(PaymentMode.values);
  static JsonTypeConverter2<Currency, int, int> $convertercurrency =
      const EnumIndexConverter<Currency>(Currency.values);
}

class WorkEntry extends DataClass implements Insertable<WorkEntry> {
  final int id;

  /// Dia do trabalho (normalizado para meia-noite local).
  final DateTime date;
  final String workerName;
  final String employerName;
  final String placeName;
  final String serviceType;
  final PaymentMode paymentMode;
  final double dailyRate;
  final double hourlyRate;
  final Currency currency;

  /// Hora de entrada/saída como minutos desde a meia-noite (0–1439).
  /// Nulo quando o usuário não registrou horário.
  final int? startMinutes;
  final int? endMinutes;

  /// Valor a receber (derivado e persistido para facilitar agregações).
  final double amountDue;

  /// Valor efetivamente pago (pode ser parcial).
  final double amountPaid;
  final bool isPaid;
  final DateTime? paidDate;
  final double? latitude;
  final double? longitude;
  final String? address;

  /// Caminhos de fotos/comprovantes serializados como JSON (lista de strings).
  final String attachmentPaths;
  final String? notes;
  final DateTime createdAt;
  const WorkEntry({
    required this.id,
    required this.date,
    required this.workerName,
    required this.employerName,
    required this.placeName,
    required this.serviceType,
    required this.paymentMode,
    required this.dailyRate,
    required this.hourlyRate,
    required this.currency,
    this.startMinutes,
    this.endMinutes,
    required this.amountDue,
    required this.amountPaid,
    required this.isPaid,
    this.paidDate,
    this.latitude,
    this.longitude,
    this.address,
    required this.attachmentPaths,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['worker_name'] = Variable<String>(workerName);
    map['employer_name'] = Variable<String>(employerName);
    map['place_name'] = Variable<String>(placeName);
    map['service_type'] = Variable<String>(serviceType);
    {
      map['payment_mode'] = Variable<int>(
        $WorkEntriesTable.$converterpaymentMode.toSql(paymentMode),
      );
    }
    map['daily_rate'] = Variable<double>(dailyRate);
    map['hourly_rate'] = Variable<double>(hourlyRate);
    {
      map['currency'] = Variable<int>(
        $WorkEntriesTable.$convertercurrency.toSql(currency),
      );
    }
    if (!nullToAbsent || startMinutes != null) {
      map['start_minutes'] = Variable<int>(startMinutes);
    }
    if (!nullToAbsent || endMinutes != null) {
      map['end_minutes'] = Variable<int>(endMinutes);
    }
    map['amount_due'] = Variable<double>(amountDue);
    map['amount_paid'] = Variable<double>(amountPaid);
    map['is_paid'] = Variable<bool>(isPaid);
    if (!nullToAbsent || paidDate != null) {
      map['paid_date'] = Variable<DateTime>(paidDate);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['attachment_paths'] = Variable<String>(attachmentPaths);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WorkEntriesCompanion toCompanion(bool nullToAbsent) {
    return WorkEntriesCompanion(
      id: Value(id),
      date: Value(date),
      workerName: Value(workerName),
      employerName: Value(employerName),
      placeName: Value(placeName),
      serviceType: Value(serviceType),
      paymentMode: Value(paymentMode),
      dailyRate: Value(dailyRate),
      hourlyRate: Value(hourlyRate),
      currency: Value(currency),
      startMinutes: startMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(startMinutes),
      endMinutes: endMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(endMinutes),
      amountDue: Value(amountDue),
      amountPaid: Value(amountPaid),
      isPaid: Value(isPaid),
      paidDate: paidDate == null && nullToAbsent
          ? const Value.absent()
          : Value(paidDate),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      attachmentPaths: Value(attachmentPaths),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory WorkEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkEntry(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      workerName: serializer.fromJson<String>(json['workerName']),
      employerName: serializer.fromJson<String>(json['employerName']),
      placeName: serializer.fromJson<String>(json['placeName']),
      serviceType: serializer.fromJson<String>(json['serviceType']),
      paymentMode: $WorkEntriesTable.$converterpaymentMode.fromJson(
        serializer.fromJson<int>(json['paymentMode']),
      ),
      dailyRate: serializer.fromJson<double>(json['dailyRate']),
      hourlyRate: serializer.fromJson<double>(json['hourlyRate']),
      currency: $WorkEntriesTable.$convertercurrency.fromJson(
        serializer.fromJson<int>(json['currency']),
      ),
      startMinutes: serializer.fromJson<int?>(json['startMinutes']),
      endMinutes: serializer.fromJson<int?>(json['endMinutes']),
      amountDue: serializer.fromJson<double>(json['amountDue']),
      amountPaid: serializer.fromJson<double>(json['amountPaid']),
      isPaid: serializer.fromJson<bool>(json['isPaid']),
      paidDate: serializer.fromJson<DateTime?>(json['paidDate']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      address: serializer.fromJson<String?>(json['address']),
      attachmentPaths: serializer.fromJson<String>(json['attachmentPaths']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'workerName': serializer.toJson<String>(workerName),
      'employerName': serializer.toJson<String>(employerName),
      'placeName': serializer.toJson<String>(placeName),
      'serviceType': serializer.toJson<String>(serviceType),
      'paymentMode': serializer.toJson<int>(
        $WorkEntriesTable.$converterpaymentMode.toJson(paymentMode),
      ),
      'dailyRate': serializer.toJson<double>(dailyRate),
      'hourlyRate': serializer.toJson<double>(hourlyRate),
      'currency': serializer.toJson<int>(
        $WorkEntriesTable.$convertercurrency.toJson(currency),
      ),
      'startMinutes': serializer.toJson<int?>(startMinutes),
      'endMinutes': serializer.toJson<int?>(endMinutes),
      'amountDue': serializer.toJson<double>(amountDue),
      'amountPaid': serializer.toJson<double>(amountPaid),
      'isPaid': serializer.toJson<bool>(isPaid),
      'paidDate': serializer.toJson<DateTime?>(paidDate),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'address': serializer.toJson<String?>(address),
      'attachmentPaths': serializer.toJson<String>(attachmentPaths),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WorkEntry copyWith({
    int? id,
    DateTime? date,
    String? workerName,
    String? employerName,
    String? placeName,
    String? serviceType,
    PaymentMode? paymentMode,
    double? dailyRate,
    double? hourlyRate,
    Currency? currency,
    Value<int?> startMinutes = const Value.absent(),
    Value<int?> endMinutes = const Value.absent(),
    double? amountDue,
    double? amountPaid,
    bool? isPaid,
    Value<DateTime?> paidDate = const Value.absent(),
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<String?> address = const Value.absent(),
    String? attachmentPaths,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => WorkEntry(
    id: id ?? this.id,
    date: date ?? this.date,
    workerName: workerName ?? this.workerName,
    employerName: employerName ?? this.employerName,
    placeName: placeName ?? this.placeName,
    serviceType: serviceType ?? this.serviceType,
    paymentMode: paymentMode ?? this.paymentMode,
    dailyRate: dailyRate ?? this.dailyRate,
    hourlyRate: hourlyRate ?? this.hourlyRate,
    currency: currency ?? this.currency,
    startMinutes: startMinutes.present ? startMinutes.value : this.startMinutes,
    endMinutes: endMinutes.present ? endMinutes.value : this.endMinutes,
    amountDue: amountDue ?? this.amountDue,
    amountPaid: amountPaid ?? this.amountPaid,
    isPaid: isPaid ?? this.isPaid,
    paidDate: paidDate.present ? paidDate.value : this.paidDate,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    address: address.present ? address.value : this.address,
    attachmentPaths: attachmentPaths ?? this.attachmentPaths,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  WorkEntry copyWithCompanion(WorkEntriesCompanion data) {
    return WorkEntry(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      workerName: data.workerName.present
          ? data.workerName.value
          : this.workerName,
      employerName: data.employerName.present
          ? data.employerName.value
          : this.employerName,
      placeName: data.placeName.present ? data.placeName.value : this.placeName,
      serviceType: data.serviceType.present
          ? data.serviceType.value
          : this.serviceType,
      paymentMode: data.paymentMode.present
          ? data.paymentMode.value
          : this.paymentMode,
      dailyRate: data.dailyRate.present ? data.dailyRate.value : this.dailyRate,
      hourlyRate: data.hourlyRate.present
          ? data.hourlyRate.value
          : this.hourlyRate,
      currency: data.currency.present ? data.currency.value : this.currency,
      startMinutes: data.startMinutes.present
          ? data.startMinutes.value
          : this.startMinutes,
      endMinutes: data.endMinutes.present
          ? data.endMinutes.value
          : this.endMinutes,
      amountDue: data.amountDue.present ? data.amountDue.value : this.amountDue,
      amountPaid: data.amountPaid.present
          ? data.amountPaid.value
          : this.amountPaid,
      isPaid: data.isPaid.present ? data.isPaid.value : this.isPaid,
      paidDate: data.paidDate.present ? data.paidDate.value : this.paidDate,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      address: data.address.present ? data.address.value : this.address,
      attachmentPaths: data.attachmentPaths.present
          ? data.attachmentPaths.value
          : this.attachmentPaths,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkEntry(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('workerName: $workerName, ')
          ..write('employerName: $employerName, ')
          ..write('placeName: $placeName, ')
          ..write('serviceType: $serviceType, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('dailyRate: $dailyRate, ')
          ..write('hourlyRate: $hourlyRate, ')
          ..write('currency: $currency, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('amountDue: $amountDue, ')
          ..write('amountPaid: $amountPaid, ')
          ..write('isPaid: $isPaid, ')
          ..write('paidDate: $paidDate, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('address: $address, ')
          ..write('attachmentPaths: $attachmentPaths, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    date,
    workerName,
    employerName,
    placeName,
    serviceType,
    paymentMode,
    dailyRate,
    hourlyRate,
    currency,
    startMinutes,
    endMinutes,
    amountDue,
    amountPaid,
    isPaid,
    paidDate,
    latitude,
    longitude,
    address,
    attachmentPaths,
    notes,
    createdAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkEntry &&
          other.id == this.id &&
          other.date == this.date &&
          other.workerName == this.workerName &&
          other.employerName == this.employerName &&
          other.placeName == this.placeName &&
          other.serviceType == this.serviceType &&
          other.paymentMode == this.paymentMode &&
          other.dailyRate == this.dailyRate &&
          other.hourlyRate == this.hourlyRate &&
          other.currency == this.currency &&
          other.startMinutes == this.startMinutes &&
          other.endMinutes == this.endMinutes &&
          other.amountDue == this.amountDue &&
          other.amountPaid == this.amountPaid &&
          other.isPaid == this.isPaid &&
          other.paidDate == this.paidDate &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.address == this.address &&
          other.attachmentPaths == this.attachmentPaths &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class WorkEntriesCompanion extends UpdateCompanion<WorkEntry> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> workerName;
  final Value<String> employerName;
  final Value<String> placeName;
  final Value<String> serviceType;
  final Value<PaymentMode> paymentMode;
  final Value<double> dailyRate;
  final Value<double> hourlyRate;
  final Value<Currency> currency;
  final Value<int?> startMinutes;
  final Value<int?> endMinutes;
  final Value<double> amountDue;
  final Value<double> amountPaid;
  final Value<bool> isPaid;
  final Value<DateTime?> paidDate;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String?> address;
  final Value<String> attachmentPaths;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const WorkEntriesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.workerName = const Value.absent(),
    this.employerName = const Value.absent(),
    this.placeName = const Value.absent(),
    this.serviceType = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.dailyRate = const Value.absent(),
    this.hourlyRate = const Value.absent(),
    this.currency = const Value.absent(),
    this.startMinutes = const Value.absent(),
    this.endMinutes = const Value.absent(),
    this.amountDue = const Value.absent(),
    this.amountPaid = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.paidDate = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.address = const Value.absent(),
    this.attachmentPaths = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WorkEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.workerName = const Value.absent(),
    this.employerName = const Value.absent(),
    this.placeName = const Value.absent(),
    this.serviceType = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.dailyRate = const Value.absent(),
    this.hourlyRate = const Value.absent(),
    this.currency = const Value.absent(),
    this.startMinutes = const Value.absent(),
    this.endMinutes = const Value.absent(),
    this.amountDue = const Value.absent(),
    this.amountPaid = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.paidDate = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.address = const Value.absent(),
    this.attachmentPaths = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : date = Value(date);
  static Insertable<WorkEntry> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? workerName,
    Expression<String>? employerName,
    Expression<String>? placeName,
    Expression<String>? serviceType,
    Expression<int>? paymentMode,
    Expression<double>? dailyRate,
    Expression<double>? hourlyRate,
    Expression<int>? currency,
    Expression<int>? startMinutes,
    Expression<int>? endMinutes,
    Expression<double>? amountDue,
    Expression<double>? amountPaid,
    Expression<bool>? isPaid,
    Expression<DateTime>? paidDate,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? address,
    Expression<String>? attachmentPaths,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (workerName != null) 'worker_name': workerName,
      if (employerName != null) 'employer_name': employerName,
      if (placeName != null) 'place_name': placeName,
      if (serviceType != null) 'service_type': serviceType,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (dailyRate != null) 'daily_rate': dailyRate,
      if (hourlyRate != null) 'hourly_rate': hourlyRate,
      if (currency != null) 'currency': currency,
      if (startMinutes != null) 'start_minutes': startMinutes,
      if (endMinutes != null) 'end_minutes': endMinutes,
      if (amountDue != null) 'amount_due': amountDue,
      if (amountPaid != null) 'amount_paid': amountPaid,
      if (isPaid != null) 'is_paid': isPaid,
      if (paidDate != null) 'paid_date': paidDate,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (address != null) 'address': address,
      if (attachmentPaths != null) 'attachment_paths': attachmentPaths,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WorkEntriesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String>? workerName,
    Value<String>? employerName,
    Value<String>? placeName,
    Value<String>? serviceType,
    Value<PaymentMode>? paymentMode,
    Value<double>? dailyRate,
    Value<double>? hourlyRate,
    Value<Currency>? currency,
    Value<int?>? startMinutes,
    Value<int?>? endMinutes,
    Value<double>? amountDue,
    Value<double>? amountPaid,
    Value<bool>? isPaid,
    Value<DateTime?>? paidDate,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<String?>? address,
    Value<String>? attachmentPaths,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return WorkEntriesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      workerName: workerName ?? this.workerName,
      employerName: employerName ?? this.employerName,
      placeName: placeName ?? this.placeName,
      serviceType: serviceType ?? this.serviceType,
      paymentMode: paymentMode ?? this.paymentMode,
      dailyRate: dailyRate ?? this.dailyRate,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      currency: currency ?? this.currency,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
      amountDue: amountDue ?? this.amountDue,
      amountPaid: amountPaid ?? this.amountPaid,
      isPaid: isPaid ?? this.isPaid,
      paidDate: paidDate ?? this.paidDate,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      attachmentPaths: attachmentPaths ?? this.attachmentPaths,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (workerName.present) {
      map['worker_name'] = Variable<String>(workerName.value);
    }
    if (employerName.present) {
      map['employer_name'] = Variable<String>(employerName.value);
    }
    if (placeName.present) {
      map['place_name'] = Variable<String>(placeName.value);
    }
    if (serviceType.present) {
      map['service_type'] = Variable<String>(serviceType.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<int>(
        $WorkEntriesTable.$converterpaymentMode.toSql(paymentMode.value),
      );
    }
    if (dailyRate.present) {
      map['daily_rate'] = Variable<double>(dailyRate.value);
    }
    if (hourlyRate.present) {
      map['hourly_rate'] = Variable<double>(hourlyRate.value);
    }
    if (currency.present) {
      map['currency'] = Variable<int>(
        $WorkEntriesTable.$convertercurrency.toSql(currency.value),
      );
    }
    if (startMinutes.present) {
      map['start_minutes'] = Variable<int>(startMinutes.value);
    }
    if (endMinutes.present) {
      map['end_minutes'] = Variable<int>(endMinutes.value);
    }
    if (amountDue.present) {
      map['amount_due'] = Variable<double>(amountDue.value);
    }
    if (amountPaid.present) {
      map['amount_paid'] = Variable<double>(amountPaid.value);
    }
    if (isPaid.present) {
      map['is_paid'] = Variable<bool>(isPaid.value);
    }
    if (paidDate.present) {
      map['paid_date'] = Variable<DateTime>(paidDate.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (attachmentPaths.present) {
      map['attachment_paths'] = Variable<String>(attachmentPaths.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkEntriesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('workerName: $workerName, ')
          ..write('employerName: $employerName, ')
          ..write('placeName: $placeName, ')
          ..write('serviceType: $serviceType, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('dailyRate: $dailyRate, ')
          ..write('hourlyRate: $hourlyRate, ')
          ..write('currency: $currency, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('amountDue: $amountDue, ')
          ..write('amountPaid: $amountPaid, ')
          ..write('isPaid: $isPaid, ')
          ..write('paidDate: $paidDate, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('address: $address, ')
          ..write('attachmentPaths: $attachmentPaths, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SavingsGoalsTable extends SavingsGoals
    with TableInfo<$SavingsGoalsTable, SavingsGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _targetAmountMeta = const VerificationMeta(
    'targetAmount',
  );
  @override
  late final GeneratedColumn<double> targetAmount = GeneratedColumn<double>(
    'target_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('month'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Currency, int> currency =
      GeneratedColumn<int>(
        'currency',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<Currency>($SavingsGoalsTable.$convertercurrency);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    targetAmount,
    period,
    currency,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('target_amount')) {
      context.handle(
        _targetAmountMeta,
        targetAmount.isAcceptableOrUnknown(
          data['target_amount']!,
          _targetAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetAmountMeta);
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      targetAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_amount'],
      )!,
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
      currency: $SavingsGoalsTable.$convertercurrency.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}currency'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SavingsGoalsTable createAlias(String alias) {
    return $SavingsGoalsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Currency, int, int> $convertercurrency =
      const EnumIndexConverter<Currency>(Currency.values);
}

class SavingsGoal extends DataClass implements Insertable<SavingsGoal> {
  final int id;
  final double targetAmount;

  /// Período da meta: 'week' | 'month' | 'quarter' | 'semester' | 'year'.
  final String period;
  final Currency currency;
  final DateTime createdAt;
  const SavingsGoal({
    required this.id,
    required this.targetAmount,
    required this.period,
    required this.currency,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['target_amount'] = Variable<double>(targetAmount);
    map['period'] = Variable<String>(period);
    {
      map['currency'] = Variable<int>(
        $SavingsGoalsTable.$convertercurrency.toSql(currency),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SavingsGoalsCompanion toCompanion(bool nullToAbsent) {
    return SavingsGoalsCompanion(
      id: Value(id),
      targetAmount: Value(targetAmount),
      period: Value(period),
      currency: Value(currency),
      createdAt: Value(createdAt),
    );
  }

  factory SavingsGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsGoal(
      id: serializer.fromJson<int>(json['id']),
      targetAmount: serializer.fromJson<double>(json['targetAmount']),
      period: serializer.fromJson<String>(json['period']),
      currency: $SavingsGoalsTable.$convertercurrency.fromJson(
        serializer.fromJson<int>(json['currency']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'targetAmount': serializer.toJson<double>(targetAmount),
      'period': serializer.toJson<String>(period),
      'currency': serializer.toJson<int>(
        $SavingsGoalsTable.$convertercurrency.toJson(currency),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SavingsGoal copyWith({
    int? id,
    double? targetAmount,
    String? period,
    Currency? currency,
    DateTime? createdAt,
  }) => SavingsGoal(
    id: id ?? this.id,
    targetAmount: targetAmount ?? this.targetAmount,
    period: period ?? this.period,
    currency: currency ?? this.currency,
    createdAt: createdAt ?? this.createdAt,
  );
  SavingsGoal copyWithCompanion(SavingsGoalsCompanion data) {
    return SavingsGoal(
      id: data.id.present ? data.id.value : this.id,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      period: data.period.present ? data.period.value : this.period,
      currency: data.currency.present ? data.currency.value : this.currency,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoal(')
          ..write('id: $id, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('period: $period, ')
          ..write('currency: $currency, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, targetAmount, period, currency, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsGoal &&
          other.id == this.id &&
          other.targetAmount == this.targetAmount &&
          other.period == this.period &&
          other.currency == this.currency &&
          other.createdAt == this.createdAt);
}

class SavingsGoalsCompanion extends UpdateCompanion<SavingsGoal> {
  final Value<int> id;
  final Value<double> targetAmount;
  final Value<String> period;
  final Value<Currency> currency;
  final Value<DateTime> createdAt;
  const SavingsGoalsCompanion({
    this.id = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.period = const Value.absent(),
    this.currency = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SavingsGoalsCompanion.insert({
    this.id = const Value.absent(),
    required double targetAmount,
    this.period = const Value.absent(),
    this.currency = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : targetAmount = Value(targetAmount);
  static Insertable<SavingsGoal> custom({
    Expression<int>? id,
    Expression<double>? targetAmount,
    Expression<String>? period,
    Expression<int>? currency,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (period != null) 'period': period,
      if (currency != null) 'currency': currency,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SavingsGoalsCompanion copyWith({
    Value<int>? id,
    Value<double>? targetAmount,
    Value<String>? period,
    Value<Currency>? currency,
    Value<DateTime>? createdAt,
  }) {
    return SavingsGoalsCompanion(
      id: id ?? this.id,
      targetAmount: targetAmount ?? this.targetAmount,
      period: period ?? this.period,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<double>(targetAmount.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (currency.present) {
      map['currency'] = Variable<int>(
        $SavingsGoalsTable.$convertercurrency.toSql(currency.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalsCompanion(')
          ..write('id: $id, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('period: $period, ')
          ..write('currency: $currency, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PriceCachesTable extends PriceCaches
    with TableInfo<$PriceCachesTable, PriceCache> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PriceCachesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _pairMeta = const VerificationMeta('pair');
  @override
  late final GeneratedColumn<String> pair = GeneratedColumn<String>(
    'pair',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _closeMeta = const VerificationMeta('close');
  @override
  late final GeneratedColumn<double> close = GeneratedColumn<double>(
    'close',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [pair, date, close];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'price_caches';
  @override
  VerificationContext validateIntegrity(
    Insertable<PriceCache> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pair')) {
      context.handle(
        _pairMeta,
        pair.isAcceptableOrUnknown(data['pair']!, _pairMeta),
      );
    } else if (isInserting) {
      context.missing(_pairMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('close')) {
      context.handle(
        _closeMeta,
        close.isAcceptableOrUnknown(data['close']!, _closeMeta),
      );
    } else if (isInserting) {
      context.missing(_closeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {pair, date};
  @override
  PriceCache map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PriceCache(
      pair: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pair'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      close: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}close'],
      )!,
    );
  }

  @override
  $PriceCachesTable createAlias(String alias) {
    return $PriceCachesTable(attachedDatabase, alias);
  }
}

class PriceCache extends DataClass implements Insertable<PriceCache> {
  /// Par: 'BTCEUR', 'BTCGBP', 'EURBRL', 'GBPBRL'...
  final String pair;

  /// Dia da cotação (meia-noite UTC). Para "cotação atual" usamos um registro
  /// especial com a data normalizada do dia corrente sobrescrito.
  final DateTime date;

  /// Preço de fechamento daquele dia.
  final double close;
  const PriceCache({
    required this.pair,
    required this.date,
    required this.close,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pair'] = Variable<String>(pair);
    map['date'] = Variable<DateTime>(date);
    map['close'] = Variable<double>(close);
    return map;
  }

  PriceCachesCompanion toCompanion(bool nullToAbsent) {
    return PriceCachesCompanion(
      pair: Value(pair),
      date: Value(date),
      close: Value(close),
    );
  }

  factory PriceCache.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PriceCache(
      pair: serializer.fromJson<String>(json['pair']),
      date: serializer.fromJson<DateTime>(json['date']),
      close: serializer.fromJson<double>(json['close']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'pair': serializer.toJson<String>(pair),
      'date': serializer.toJson<DateTime>(date),
      'close': serializer.toJson<double>(close),
    };
  }

  PriceCache copyWith({String? pair, DateTime? date, double? close}) =>
      PriceCache(
        pair: pair ?? this.pair,
        date: date ?? this.date,
        close: close ?? this.close,
      );
  PriceCache copyWithCompanion(PriceCachesCompanion data) {
    return PriceCache(
      pair: data.pair.present ? data.pair.value : this.pair,
      date: data.date.present ? data.date.value : this.date,
      close: data.close.present ? data.close.value : this.close,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PriceCache(')
          ..write('pair: $pair, ')
          ..write('date: $date, ')
          ..write('close: $close')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(pair, date, close);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PriceCache &&
          other.pair == this.pair &&
          other.date == this.date &&
          other.close == this.close);
}

class PriceCachesCompanion extends UpdateCompanion<PriceCache> {
  final Value<String> pair;
  final Value<DateTime> date;
  final Value<double> close;
  final Value<int> rowid;
  const PriceCachesCompanion({
    this.pair = const Value.absent(),
    this.date = const Value.absent(),
    this.close = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PriceCachesCompanion.insert({
    required String pair,
    required DateTime date,
    required double close,
    this.rowid = const Value.absent(),
  }) : pair = Value(pair),
       date = Value(date),
       close = Value(close);
  static Insertable<PriceCache> custom({
    Expression<String>? pair,
    Expression<DateTime>? date,
    Expression<double>? close,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (pair != null) 'pair': pair,
      if (date != null) 'date': date,
      if (close != null) 'close': close,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PriceCachesCompanion copyWith({
    Value<String>? pair,
    Value<DateTime>? date,
    Value<double>? close,
    Value<int>? rowid,
  }) {
    return PriceCachesCompanion(
      pair: pair ?? this.pair,
      date: date ?? this.date,
      close: close ?? this.close,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (pair.present) {
      map['pair'] = Variable<String>(pair.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (close.present) {
      map['close'] = Variable<double>(close.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PriceCachesCompanion(')
          ..write('pair: $pair, ')
          ..write('date: $date, ')
          ..write('close: $close, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorkEntriesTable workEntries = $WorkEntriesTable(this);
  late final $SavingsGoalsTable savingsGoals = $SavingsGoalsTable(this);
  late final $PriceCachesTable priceCaches = $PriceCachesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    workEntries,
    savingsGoals,
    priceCaches,
  ];
}

typedef $$WorkEntriesTableCreateCompanionBuilder =
    WorkEntriesCompanion Function({
      Value<int> id,
      required DateTime date,
      Value<String> workerName,
      Value<String> employerName,
      Value<String> placeName,
      Value<String> serviceType,
      Value<PaymentMode> paymentMode,
      Value<double> dailyRate,
      Value<double> hourlyRate,
      Value<Currency> currency,
      Value<int?> startMinutes,
      Value<int?> endMinutes,
      Value<double> amountDue,
      Value<double> amountPaid,
      Value<bool> isPaid,
      Value<DateTime?> paidDate,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> address,
      Value<String> attachmentPaths,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$WorkEntriesTableUpdateCompanionBuilder =
    WorkEntriesCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String> workerName,
      Value<String> employerName,
      Value<String> placeName,
      Value<String> serviceType,
      Value<PaymentMode> paymentMode,
      Value<double> dailyRate,
      Value<double> hourlyRate,
      Value<Currency> currency,
      Value<int?> startMinutes,
      Value<int?> endMinutes,
      Value<double> amountDue,
      Value<double> amountPaid,
      Value<bool> isPaid,
      Value<DateTime?> paidDate,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> address,
      Value<String> attachmentPaths,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

class $$WorkEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkEntriesTable> {
  $$WorkEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workerName => $composableBuilder(
    column: $table.workerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employerName => $composableBuilder(
    column: $table.employerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeName => $composableBuilder(
    column: $table.placeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PaymentMode, PaymentMode, int>
  get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get dailyRate => $composableBuilder(
    column: $table.dailyRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Currency, Currency, int> get currency =>
      $composableBuilder(
        column: $table.currency,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountDue => $composableBuilder(
    column: $table.amountDue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountPaid => $composableBuilder(
    column: $table.amountPaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPaid => $composableBuilder(
    column: $table.isPaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidDate => $composableBuilder(
    column: $table.paidDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attachmentPaths => $composableBuilder(
    column: $table.attachmentPaths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkEntriesTable> {
  $$WorkEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workerName => $composableBuilder(
    column: $table.workerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employerName => $composableBuilder(
    column: $table.employerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeName => $composableBuilder(
    column: $table.placeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dailyRate => $composableBuilder(
    column: $table.dailyRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountDue => $composableBuilder(
    column: $table.amountDue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountPaid => $composableBuilder(
    column: $table.amountPaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPaid => $composableBuilder(
    column: $table.isPaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidDate => $composableBuilder(
    column: $table.paidDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attachmentPaths => $composableBuilder(
    column: $table.attachmentPaths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkEntriesTable> {
  $$WorkEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get workerName => $composableBuilder(
    column: $table.workerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get employerName => $composableBuilder(
    column: $table.employerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get placeName =>
      $composableBuilder(column: $table.placeName, builder: (column) => column);

  GeneratedColumn<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PaymentMode, int> get paymentMode =>
      $composableBuilder(
        column: $table.paymentMode,
        builder: (column) => column,
      );

  GeneratedColumn<double> get dailyRate =>
      $composableBuilder(column: $table.dailyRate, builder: (column) => column);

  GeneratedColumn<double> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Currency, int> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amountDue =>
      $composableBuilder(column: $table.amountDue, builder: (column) => column);

  GeneratedColumn<double> get amountPaid => $composableBuilder(
    column: $table.amountPaid,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPaid =>
      $composableBuilder(column: $table.isPaid, builder: (column) => column);

  GeneratedColumn<DateTime> get paidDate =>
      $composableBuilder(column: $table.paidDate, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get attachmentPaths => $composableBuilder(
    column: $table.attachmentPaths,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WorkEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkEntriesTable,
          WorkEntry,
          $$WorkEntriesTableFilterComposer,
          $$WorkEntriesTableOrderingComposer,
          $$WorkEntriesTableAnnotationComposer,
          $$WorkEntriesTableCreateCompanionBuilder,
          $$WorkEntriesTableUpdateCompanionBuilder,
          (
            WorkEntry,
            BaseReferences<_$AppDatabase, $WorkEntriesTable, WorkEntry>,
          ),
          WorkEntry,
          PrefetchHooks Function()
        > {
  $$WorkEntriesTableTableManager(_$AppDatabase db, $WorkEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> workerName = const Value.absent(),
                Value<String> employerName = const Value.absent(),
                Value<String> placeName = const Value.absent(),
                Value<String> serviceType = const Value.absent(),
                Value<PaymentMode> paymentMode = const Value.absent(),
                Value<double> dailyRate = const Value.absent(),
                Value<double> hourlyRate = const Value.absent(),
                Value<Currency> currency = const Value.absent(),
                Value<int?> startMinutes = const Value.absent(),
                Value<int?> endMinutes = const Value.absent(),
                Value<double> amountDue = const Value.absent(),
                Value<double> amountPaid = const Value.absent(),
                Value<bool> isPaid = const Value.absent(),
                Value<DateTime?> paidDate = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String> attachmentPaths = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WorkEntriesCompanion(
                id: id,
                date: date,
                workerName: workerName,
                employerName: employerName,
                placeName: placeName,
                serviceType: serviceType,
                paymentMode: paymentMode,
                dailyRate: dailyRate,
                hourlyRate: hourlyRate,
                currency: currency,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                amountDue: amountDue,
                amountPaid: amountPaid,
                isPaid: isPaid,
                paidDate: paidDate,
                latitude: latitude,
                longitude: longitude,
                address: address,
                attachmentPaths: attachmentPaths,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<String> workerName = const Value.absent(),
                Value<String> employerName = const Value.absent(),
                Value<String> placeName = const Value.absent(),
                Value<String> serviceType = const Value.absent(),
                Value<PaymentMode> paymentMode = const Value.absent(),
                Value<double> dailyRate = const Value.absent(),
                Value<double> hourlyRate = const Value.absent(),
                Value<Currency> currency = const Value.absent(),
                Value<int?> startMinutes = const Value.absent(),
                Value<int?> endMinutes = const Value.absent(),
                Value<double> amountDue = const Value.absent(),
                Value<double> amountPaid = const Value.absent(),
                Value<bool> isPaid = const Value.absent(),
                Value<DateTime?> paidDate = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String> attachmentPaths = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WorkEntriesCompanion.insert(
                id: id,
                date: date,
                workerName: workerName,
                employerName: employerName,
                placeName: placeName,
                serviceType: serviceType,
                paymentMode: paymentMode,
                dailyRate: dailyRate,
                hourlyRate: hourlyRate,
                currency: currency,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                amountDue: amountDue,
                amountPaid: amountPaid,
                isPaid: isPaid,
                paidDate: paidDate,
                latitude: latitude,
                longitude: longitude,
                address: address,
                attachmentPaths: attachmentPaths,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkEntriesTable,
      WorkEntry,
      $$WorkEntriesTableFilterComposer,
      $$WorkEntriesTableOrderingComposer,
      $$WorkEntriesTableAnnotationComposer,
      $$WorkEntriesTableCreateCompanionBuilder,
      $$WorkEntriesTableUpdateCompanionBuilder,
      (WorkEntry, BaseReferences<_$AppDatabase, $WorkEntriesTable, WorkEntry>),
      WorkEntry,
      PrefetchHooks Function()
    >;
typedef $$SavingsGoalsTableCreateCompanionBuilder =
    SavingsGoalsCompanion Function({
      Value<int> id,
      required double targetAmount,
      Value<String> period,
      Value<Currency> currency,
      Value<DateTime> createdAt,
    });
typedef $$SavingsGoalsTableUpdateCompanionBuilder =
    SavingsGoalsCompanion Function({
      Value<int> id,
      Value<double> targetAmount,
      Value<String> period,
      Value<Currency> currency,
      Value<DateTime> createdAt,
    });

class $$SavingsGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Currency, Currency, int> get currency =>
      $composableBuilder(
        column: $table.currency,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavingsGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavingsGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Currency, int> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SavingsGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsGoalsTable,
          SavingsGoal,
          $$SavingsGoalsTableFilterComposer,
          $$SavingsGoalsTableOrderingComposer,
          $$SavingsGoalsTableAnnotationComposer,
          $$SavingsGoalsTableCreateCompanionBuilder,
          $$SavingsGoalsTableUpdateCompanionBuilder,
          (
            SavingsGoal,
            BaseReferences<_$AppDatabase, $SavingsGoalsTable, SavingsGoal>,
          ),
          SavingsGoal,
          PrefetchHooks Function()
        > {
  $$SavingsGoalsTableTableManager(_$AppDatabase db, $SavingsGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> targetAmount = const Value.absent(),
                Value<String> period = const Value.absent(),
                Value<Currency> currency = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SavingsGoalsCompanion(
                id: id,
                targetAmount: targetAmount,
                period: period,
                currency: currency,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double targetAmount,
                Value<String> period = const Value.absent(),
                Value<Currency> currency = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SavingsGoalsCompanion.insert(
                id: id,
                targetAmount: targetAmount,
                period: period,
                currency: currency,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavingsGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsGoalsTable,
      SavingsGoal,
      $$SavingsGoalsTableFilterComposer,
      $$SavingsGoalsTableOrderingComposer,
      $$SavingsGoalsTableAnnotationComposer,
      $$SavingsGoalsTableCreateCompanionBuilder,
      $$SavingsGoalsTableUpdateCompanionBuilder,
      (
        SavingsGoal,
        BaseReferences<_$AppDatabase, $SavingsGoalsTable, SavingsGoal>,
      ),
      SavingsGoal,
      PrefetchHooks Function()
    >;
typedef $$PriceCachesTableCreateCompanionBuilder =
    PriceCachesCompanion Function({
      required String pair,
      required DateTime date,
      required double close,
      Value<int> rowid,
    });
typedef $$PriceCachesTableUpdateCompanionBuilder =
    PriceCachesCompanion Function({
      Value<String> pair,
      Value<DateTime> date,
      Value<double> close,
      Value<int> rowid,
    });

class $$PriceCachesTableFilterComposer
    extends Composer<_$AppDatabase, $PriceCachesTable> {
  $$PriceCachesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get pair => $composableBuilder(
    column: $table.pair,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get close => $composableBuilder(
    column: $table.close,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PriceCachesTableOrderingComposer
    extends Composer<_$AppDatabase, $PriceCachesTable> {
  $$PriceCachesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get pair => $composableBuilder(
    column: $table.pair,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get close => $composableBuilder(
    column: $table.close,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PriceCachesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PriceCachesTable> {
  $$PriceCachesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get pair =>
      $composableBuilder(column: $table.pair, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get close =>
      $composableBuilder(column: $table.close, builder: (column) => column);
}

class $$PriceCachesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PriceCachesTable,
          PriceCache,
          $$PriceCachesTableFilterComposer,
          $$PriceCachesTableOrderingComposer,
          $$PriceCachesTableAnnotationComposer,
          $$PriceCachesTableCreateCompanionBuilder,
          $$PriceCachesTableUpdateCompanionBuilder,
          (
            PriceCache,
            BaseReferences<_$AppDatabase, $PriceCachesTable, PriceCache>,
          ),
          PriceCache,
          PrefetchHooks Function()
        > {
  $$PriceCachesTableTableManager(_$AppDatabase db, $PriceCachesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PriceCachesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PriceCachesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PriceCachesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> pair = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> close = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PriceCachesCompanion(
                pair: pair,
                date: date,
                close: close,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String pair,
                required DateTime date,
                required double close,
                Value<int> rowid = const Value.absent(),
              }) => PriceCachesCompanion.insert(
                pair: pair,
                date: date,
                close: close,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PriceCachesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PriceCachesTable,
      PriceCache,
      $$PriceCachesTableFilterComposer,
      $$PriceCachesTableOrderingComposer,
      $$PriceCachesTableAnnotationComposer,
      $$PriceCachesTableCreateCompanionBuilder,
      $$PriceCachesTableUpdateCompanionBuilder,
      (
        PriceCache,
        BaseReferences<_$AppDatabase, $PriceCachesTable, PriceCache>,
      ),
      PriceCache,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorkEntriesTableTableManager get workEntries =>
      $$WorkEntriesTableTableManager(_db, _db.workEntries);
  $$SavingsGoalsTableTableManager get savingsGoals =>
      $$SavingsGoalsTableTableManager(_db, _db.savingsGoals);
  $$PriceCachesTableTableManager get priceCaches =>
      $$PriceCachesTableTableManager(_db, _db.priceCaches);
}
