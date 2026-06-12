# AnotAí — Controle de Diárias

App móvel em **Flutter** para trabalhadores que recebem por **diária** — pensado
para migrantes brasileiros na Europa (construção, limpeza, reformas, serviços
gerais). Funciona **offline-first**; só usa internet para a cotação de Bitcoin e
o câmbio do Real.

Identidade: **laranja `#F7931A` sobre preto `#0D0D0D`**, texto branco `#F4F4F5`.

---

## Funcionalidades

- **Home / Dashboard** — resumo do mês (dias trabalhados, a receber, recebido,
  pendente) com toggle "ver em Real (BRL)".
- **Cadastro de diária** — modo por diária ou por hora (cálculo automático de
  horas a partir de entrada/saída), seletor de moeda (EUR/GBP), autocomplete de
  patrão/lugar/serviço pelo histórico, foto de comprovante, geolocalização da
  obra.
- **Detalhe** — fotos ampliáveis, "Abrir no Google Maps", "Compartilhar local"
  (WhatsApp), marcar como pago.
- **Extrato / Relatório** — por Semana, Mês, Trimestre, Semestre ou Ano, com
  navegação entre períodos; totais separados por moeda (nunca soma EUR + GBP);
  marcação de recebimentos em lote (selecionar várias diárias e marcar como
  pagas de uma vez).
- **Quem me deve** — saldo pendente agrupado por patrão, com extrato em PDF
  para cobrar.
- **Calendário** — dias trabalhados marcados (verde = pago, âmbar = pendente).
- **Exportação** — PDF (layout limpo, cabeçalho com logo) e XLS, com
  compartilhamento direto.
- **Comparativo Bitcoin + Meta** — quanto o trabalhador teria poupando uma % dos
  ganhos em Bitcoin (cotação de fechamento do dia de cada diária, via Binance),
  e acompanhamento de meta de poupança.
- **Configurações** — tema claro/escuro/sistema, moeda padrão, mostrar BRL, nome
  padrão, % de poupança Bitcoin, PIN/biometria, lembretes, backup/restauração.
- **Abertura animada** com dica rotativa (laranja sobre preto, ~5s, toque para
  pular).

---

## Como rodar

Pré-requisitos: **Flutter 3.44+** (Dart 3.12+) e Android SDK.

```bash
flutter pub get

# Gerar o código do banco (drift) — necessário após clonar:
dart run build_runner build --delete-conflicting-outputs

# Rodar em um dispositivo/emulador Android conectado:
flutter run
```

> O projeto já inclui o código gerado (`lib/data/database/database.g.dart`).
> Rode o `build_runner` novamente sempre que alterar as tabelas do drift.

---

## Como gerar o ícone e a splash

Os assets de marca ficam em `assets/icon/` e `assets/splash/` e já estão
referenciados no `pubspec.yaml`. Para regenerar:

```bash
dart run flutter_launcher_icons          # ícone adaptativo (laranja sobre preto)
dart run flutter_native_splash:create    # splash nativa instantânea (fundo preto)
```

A **splash nativa** (estática) aparece no boot, sem flash branco. Logo em
seguida, a **tela de abertura animada em Flutter** (`AnimatedSplash`) mostra o
logo com animação laranja e uma dica rotativa.

---

## Como gerar o APK de release

```bash
# Build de release (assinado com a chave de debug por padrão — veja abaixo):
flutter build apk --release

# APK por ABI (arquivos menores):
flutter build apk --release --split-per-abi
```

O APK sai em `build/app/outputs/flutter-apk/`.

### Assinatura de produção

O `android/app/build.gradle.kts` usa a chave de **debug** no release para
facilitar testes. Para publicar, crie um keystore e configure o `signingConfig`:

```bash
keytool -genkey -v -keystore ~/anotai-release.jks -keyalg RSA -keysize 2048 \
  -validity 10000 -alias anotai
```

Depois aponte o `signingConfigs.release` no Gradle para esse keystore (via
`android/key.properties`, conforme a documentação do Flutter).

---

## Permissões Android

Declaradas em `android/app/src/main/AndroidManifest.xml`:

- **Localização** (`ACCESS_FINE/COARSE_LOCATION`) — capturar coordenadas da obra.
- **Câmera / fotos** (`CAMERA`, `READ_MEDIA_IMAGES`, `READ_EXTERNAL_STORAGE`) —
  anexar comprovantes.
- **Notificações** (`POST_NOTIFICATIONS`, alarmes exatos) — lembretes.
- **Biometria** (`USE_BIOMETRIC`) — bloqueio do app.

`MainActivity` estende `FlutterFragmentActivity` (exigido pelo `local_auth`) e o
Gradle habilita *core library desugaring* (exigido pelo
`flutter_local_notifications`).

---

## Backup e restauração

Em **Configurações → Backup e restauração**:

- **Fazer backup** gera um arquivo **ZIP** contendo o banco de dados completo
  (`anotai.sqlite`), todas as fotos anexadas (`attachments/`) e um
  `manifest.json`. O ZIP é compartilhado via `share_plus` — dá para salvar ou
  mandar pra si mesmo no WhatsApp.
- **Restaurar backup** seleciona um ZIP do AnotAí (`file_picker`), substitui o
  banco e as fotos, e fecha o app para reabrir com os dados restaurados.

As fotos são gravadas em `appDocs/attachments/` e os registros guardam apenas o
**nome** do arquivo (não o caminho absoluto), tornando o backup **portátil** —
pode ser restaurado em outro aparelho.

---

## Link de referral (Binance)

O botão **"Comece a poupar em Bitcoin"** (tela Bitcoin e Configurações) abre o
link de referral, definido em `lib/core/brand.dart` → `AppConfig.binanceReferralUrl`:

```
https://account.binance.com/register?ref=LNBOT&?registerChannel=user_center
```

---

## Arquitetura

```
lib/
  core/         enums, marca/cores, formatação, textos (i18n pt-BR)
  data/         drift (banco SQLite tipado) + código gerado
  domain/       períodos, cálculos, resumos e serviços
    services/   Binance, câmbio BRL, comparativo Bitcoin, PDF/XLS,
                backup, localização, notificações, autenticação, settings
  presentation/ Riverpod providers, tema Material 3, telas e widgets
  l10n/         textos centralizados (estrutura pronta para EN/ES)
```

- **Estado:** Riverpod.
- **Banco:** drift/SQLite (necessário pelas agregações por período).
- **i18n:** `flutter_localizations` + `intl` no locale **pt-BR**; os textos da UI
  ficam centralizados em `lib/l10n/strings.dart` para facilitar adicionar Inglês
  e Espanhol depois.

### Pontos comentados no código

- Comparativo Bitcoin: `lib/domain/services/bitcoin_compare_service.dart`
- Conversão de câmbio para BRL (derivada da Binance): `lib/domain/services/fx_service.dart`
- Cálculo de horas: `lib/domain/calc.dart`
- Agregações por período: `lib/domain/period.dart` e `lib/domain/summary.dart`
- Backup/restauração: `lib/domain/services/backup_service.dart`

---

> **Aviso:** o comparativo de Bitcoin é **ilustrativo**, baseado em dados
> passados, e **não** é recomendação de investimento.
