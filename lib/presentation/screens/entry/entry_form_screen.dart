import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import '../../../core/enums.dart';
import '../../../core/format.dart';
import '../../../data/database/database.dart';
import '../../../domain/calc.dart';
import '../../../domain/services/location_service.dart';
import '../../providers/providers.dart';
import '../../widgets/autocomplete_field.dart';

/// Cadastro/edição de uma diária.
class EntryFormScreen extends ConsumerStatefulWidget {
  /// Quando informado, a tela edita a diária existente.
  final WorkEntry? existing;
  const EntryFormScreen({super.key, this.existing});

  @override
  ConsumerState<EntryFormScreen> createState() => _EntryFormScreenState();
}

class _EntryFormScreenState extends ConsumerState<EntryFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _worker;
  late final TextEditingController _employer;
  late final TextEditingController _place;
  late final TextEditingController _service;
  late final TextEditingController _dailyRate;
  late final TextEditingController _hourlyRate;
  late final TextEditingController _amountPaid;
  late final TextEditingController _notes;

  DateTime _date = DateTime.now();
  PaymentMode _mode = PaymentMode.diaria;
  Currency _currency = Currency.eur;
  TimeOfDay? _start;
  TimeOfDay? _end;
  bool _isPaid = false;
  double? _lat;
  double? _lng;
  String? _address;
  List<String> _attachments = [];
  String? _attachDir;
  bool _capturingLocation = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    final settings = ref.read(settingsProvider);

    _worker = TextEditingController(
        text: e?.workerName ?? settings.defaultWorkerName);
    _employer = TextEditingController(text: e?.employerName ?? '');
    _place = TextEditingController(text: e?.placeName ?? '');
    _service = TextEditingController(text: e?.serviceType ?? '');
    _dailyRate = TextEditingController(
        text: e != null && e.dailyRate > 0 ? _numText(e.dailyRate) : '');
    _hourlyRate = TextEditingController(
        text: e != null && e.hourlyRate > 0 ? _numText(e.hourlyRate) : '');
    _amountPaid = TextEditingController(
        text: e != null && e.amountPaid > 0 ? _numText(e.amountPaid) : '');
    _notes = TextEditingController(text: e?.notes ?? '');

    if (e != null) {
      _date = e.date;
      _mode = e.paymentMode;
      _currency = e.currency;
      _start = _toTod(e.startMinutes);
      _end = _toTod(e.endMinutes);
      _isPaid = e.isPaid;
      _lat = e.latitude;
      _lng = e.longitude;
      _address = e.address;
      _attachments = (jsonDecode(e.attachmentPaths) as List).cast<String>();
    } else {
      _currency = settings.defaultCurrency;
    }

    ref.read(attachmentServiceProvider).dir().then((dir) {
      if (mounted) setState(() => _attachDir = dir.path);
    });
  }

  String _numText(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();

  TimeOfDay? _toTod(int? minutes) =>
      minutes == null ? null : TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);

  int? _toMinutes(TimeOfDay? t) => t == null ? null : t.hour * 60 + t.minute;

  double get _hours {
    final s = _toMinutes(_start);
    final e = _toMinutes(_end);
    return WorkCalc.hoursWorked(s, e);
  }

  double _parseNum(TextEditingController c) =>
      double.tryParse(c.text.replaceAll(',', '.').trim()) ?? 0;

  @override
  void dispose() {
    for (final c in [
      _worker, _employer, _place, _service, _dailyRate, _hourlyRate, _amountPaid, _notes
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime(bool start) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: (start ? _start : _end) ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => start ? _start = picked : _end = picked);
    }
  }

  Future<void> _captureLocation() async {
    setState(() => _capturingLocation = true);
    try {
      final loc = await ref.read(locationServiceProvider).capture();
      setState(() {
        _lat = loc.latitude;
        _lng = loc.longitude;
        _address = loc.address;
      });
    } on LocationFailure catch (f) {
      _snack(f.message);
    } catch (e) {
      _snack('Não foi possível obter a localização.');
    } finally {
      if (mounted) setState(() => _capturingLocation = false);
    }
  }

  Future<void> _addPhoto(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: source, imageQuality: 75);
      if (picked == null) return;
      final name = await ref
          .read(attachmentServiceProvider)
          .import(File(picked.path));
      setState(() => _attachments = [..._attachments, name]);
    } catch (e) {
      _snack('Não foi possível anexar a foto.');
    }
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final amountDue = WorkCalc.amountDue(
      mode: _mode,
      dailyRate: _parseNum(_dailyRate),
      hourlyRate: _parseNum(_hourlyRate),
      startMinutes: _toMinutes(_start),
      endMinutes: _toMinutes(_end),
    );
    final amountPaid =
        _amountPaid.text.trim().isEmpty ? (_isPaid ? amountDue : 0.0) : _parseNum(_amountPaid);

    final db = ref.read(databaseProvider);
    final companion = WorkEntriesCompanion(
      id: widget.existing == null ? const d.Value.absent() : d.Value(widget.existing!.id),
      date: d.Value(DateTime(_date.year, _date.month, _date.day)),
      workerName: d.Value(_worker.text.trim()),
      employerName: d.Value(_employer.text.trim()),
      placeName: d.Value(_place.text.trim()),
      serviceType: d.Value(_service.text.trim()),
      paymentMode: d.Value(_mode),
      dailyRate: d.Value(_parseNum(_dailyRate)),
      hourlyRate: d.Value(_parseNum(_hourlyRate)),
      currency: d.Value(_currency),
      startMinutes: d.Value(_toMinutes(_start)),
      endMinutes: d.Value(_toMinutes(_end)),
      amountDue: d.Value(amountDue),
      amountPaid: d.Value(amountPaid),
      isPaid: d.Value(_isPaid),
      paidDate: d.Value(_isPaid ? (widget.existing?.paidDate ?? DateTime.now()) : null),
      latitude: d.Value(_lat),
      longitude: d.Value(_lng),
      address: d.Value(_address),
      attachmentPaths: d.Value(jsonEncode(_attachments)),
      notes: d.Value(_notes.text.trim().isEmpty ? null : _notes.text.trim()),
    );

    if (widget.existing == null) {
      await db.insertEntry(companion);
    } else {
      await (db.update(db.workEntries)
            ..where((t) => t.id.equals(widget.existing!.id)))
          .write(companion);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final employers = ref.watch(employerSuggestionsProvider).value ?? const [];
    final places = ref.watch(placeSuggestionsProvider).value ?? const [];
    final services = ref.watch(serviceSuggestionsProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Nova diária' : 'Editar diária'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          children: [
            // Data
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Data do trabalho'),
              subtitle: Text(Fmt.weekday(_date)),
              trailing: TextButton(onPressed: _pickDate, child: const Text('Alterar')),
            ),
            const SizedBox(height: 8),

            TextFormField(
              controller: _worker,
              decoration: const InputDecoration(
                  labelText: 'Seu nome', prefixIcon: Icon(Icons.person)),
            ),
            const SizedBox(height: 12),
            AutocompleteField(
              controller: _employer,
              label: 'Nome do patrão / empresa',
              icon: Icons.badge_outlined,
              options: employers,
            ),
            const SizedBox(height: 12),
            AutocompleteField(
              controller: _place,
              label: 'Lugar / obra',
              icon: Icons.location_city,
              options: places,
            ),
            const SizedBox(height: 12),
            AutocompleteField(
              controller: _service,
              label: 'Tipo de serviço',
              icon: Icons.handyman,
              options: services,
            ),
            const SizedBox(height: 20),

            // Modo de pagamento
            Text('Forma de pagamento', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<PaymentMode>(
              segments: const [
                ButtonSegment(value: PaymentMode.diaria, label: Text('Por diária'), icon: Icon(Icons.today)),
                ButtonSegment(value: PaymentMode.hora, label: Text('Por hora'), icon: Icon(Icons.timelapse)),
              ],
              selected: {_mode},
              onSelectionChanged: (s) => setState(() => _mode = s.first),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _mode == PaymentMode.diaria
                      ? TextFormField(
                          controller: _dailyRate,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: 'Valor da diária',
                            prefixText: '${_currency.symbol} ',
                          ),
                          validator: _rateValidator,
                        )
                      : TextFormField(
                          controller: _hourlyRate,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: 'Valor por hora',
                            prefixText: '${_currency.symbol} ',
                          ),
                          validator: _rateValidator,
                        ),
                ),
                const SizedBox(width: 12),
                _currencySelector(),
              ],
            ),
            const SizedBox(height: 16),

            // Entrada/saída → horas
            Row(
              children: [
                Expanded(child: _timeTile('Entrada', _start, () => _pickTime(true))),
                const SizedBox(width: 12),
                Expanded(child: _timeTile('Saída', _end, () => _pickTime(false))),
              ],
            ),
            if (_hours > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 18),
                    const SizedBox(width: 6),
                    Text('Horas trabalhadas: ${Fmt.hours(_hours)}',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    if (_mode == PaymentMode.hora && _parseNum(_hourlyRate) > 0) ...[
                      const Spacer(),
                      Text('= ${Fmt.money(_hours * _parseNum(_hourlyRate), _currency)}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Pagamento
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Já recebi este valor'),
              value: _isPaid,
              onChanged: (v) => setState(() => _isPaid = v),
            ),
            if (_isPaid)
              TextFormField(
                controller: _amountPaid,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Valor recebido (deixe vazio = valor cheio)',
                  prefixText: '${_currency.symbol} ',
                ),
              ),
            const SizedBox(height: 16),

            // Localização
            _locationCard(),
            const SizedBox(height: 16),

            // Fotos
            _attachmentsCard(),
            const SizedBox(height: 16),

            TextFormField(
              controller: _notes,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Observações',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.notes),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check),
              label: const Text('Salvar diária'),
            ),
          ],
        ),
      ),
    );
  }

  String? _rateValidator(String? v) {
    final n = double.tryParse((v ?? '').replaceAll(',', '.').trim());
    if (n == null || n <= 0) return 'Informe um valor válido';
    return null;
  }

  Widget _currencySelector() {
    return DropdownButton<Currency>(
      value: _currency,
      onChanged: (c) => setState(() => _currency = c!),
      items: Currency.values
          .map((c) => DropdownMenuItem(value: c, child: Text('${c.symbol} ${c.code}')))
          .toList(),
    );
  }

  Widget _timeTile(String label, TimeOfDay? value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(labelText: label, prefixIcon: const Icon(Icons.access_time)),
        child: Text(value == null ? '--:--' : value.format(context)),
      ),
    );
  }

  Widget _locationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.place_outlined),
                const SizedBox(width: 8),
                const Text('Localização da obra'),
                const Spacer(),
                if (_lat != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => setState(() {
                      _lat = null;
                      _lng = null;
                      _address = null;
                    }),
                  ),
              ],
            ),
            if (_address != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(_address!, style: Theme.of(context).textTheme.bodySmall),
              )
            else if (_lat != null)
              Text('${_lat!.toStringAsFixed(5)}, ${_lng!.toStringAsFixed(5)}'),
            OutlinedButton.icon(
              onPressed: _capturingLocation ? null : _captureLocation,
              icon: _capturingLocation
                  ? const SizedBox(
                      width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.my_location),
              label: Text(_lat == null ? 'Usar minha localização atual' : 'Atualizar localização'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _attachmentsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(children: [
              Icon(Icons.attach_file),
              SizedBox(width: 8),
              Text('Fotos / comprovantes'),
            ]),
            const SizedBox(height: 8),
            if (_attachments.isNotEmpty && _attachDir != null)
              SizedBox(
                height: 86,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _attachments.map((name) {
                    final path = p.join(_attachDir!, name);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(File(path),
                                width: 80, height: 80, fit: BoxFit.cover),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: GestureDetector(
                              onTap: () => setState(
                                  () => _attachments = _attachments.where((a) => a != name).toList()),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.black54, shape: BoxShape.circle),
                                child: const Icon(Icons.close, size: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _addPhoto(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Câmera'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _addPhoto(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galeria'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
