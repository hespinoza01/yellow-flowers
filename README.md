# Flores Amarillas 🌼

App Android (Flutter) que, cada vez que se abre, muestra una foto random de
flores amarillas + reproduce una canción random de música local + un mensaje
romántico random. Programa recordatorios locales cada 21 de marzo y 21 de
septiembre (día de las flores amarillas, hemisferio norte/sur).

100% local: sin backend, sin login, sin APIs externas en runtime.

## Funciones

- Foto random a pantalla completa (`assets/images/flowers/`, 16 fotos
  generadas con MiniMax).
- Canción random en loop (`assets/audio/`, mp3 propios del usuario — **no
  incluidos en este repo**, ver abajo).
- Mensaje romántico random con botón "Ver mensaje" (`lib/features/messages/`,
  16 mensajes).
- Botón "Cambiar todo": refresca foto + mensaje + canción juntos.
- Notificación local anual el 21 de marzo (hemisferio norte) y 21 de
  septiembre (hemisferio sur) — ambas por default, recordando abrir la app.
- Ícono y nombre de app propios ("Flores Amarillas").

## Setup para correr este repo

### 1. Fotos

Ya incluidas en `assets/images/flowers/` (16 fotos generadas con IA).
Agregar más `.jpg`/`.png` ahí es opcional — se eligen random automático, sin
tocar código.

### 2. Música — **poné tus propios MP3, no están en este repo**

Los archivos de audio no se suben al repo (son música con copyright, no se
puede distribuir públicamente). Para correr la app:

1. Creá la carpeta `assets/audio/` si no existe.
2. Copiá ahí tus mp3 (los que quieras que suenen).
3. `flutter pub get` (por si el pubspec cambió) y compilá normal.

Sin mp3 en esa carpeta, la app muestra "Agrega canciones en assets/audio/"
en vez de crashear.

### 3. Mensajes

Editar/agregar en `lib/features/messages/data/romantic_messages.dart`
— lista simple de strings.

## Comandos útiles

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --debug              # debug, firma debug
flutter build apk --release            # producción, requiere android/key.properties (ver abajo)
flutter install                        # con un dispositivo Android conectado
```

## Firma de release

`android/key.properties` (gitignoreado, nunca se sube) apunta a un keystore
externo al repo. Sin ese archivo, `flutter build apk --release` cae
automático a firma debug (para que el build no se rompa en CI/otros
devs) — no sirve para publicar, pero compila.

Formato de `android/key.properties`:
```
storePassword=...
keyPassword=...
keyAlias=...
storeFile=/ruta/absoluta/al/keystore.jks
```

## Limitación conocida

Los recordatorios anuales se reprograman en cada apertura de la app (no hay
backend). Si la app no se abre nunca entre un 21-marzo/21-sept y el
siguiente, ese ciclo puntual no se reprograma solo.

## Historial de integración de música (por qué es local y no Spotify)

Se intentaron dos integraciones con Spotify antes de llegar a mp3 locales:

1. **Spotify App Remote SDK** — falló con `UserNotAuthorizedException`
   persistente pese a package/SHA1/allowlist/Premium correctos en el
   Dashboard. Límite de la plataforma no resuelto.
2. **Spotify Web Playback SDK** (vía WebView embebido) — falló con
   `EMEError: No supported keysystem was found`. El WebView de Android
   embebido en apps nativas no expone DRM/Widevine, requisito duro del SDK.
   Limitación de plataforma, no de esta implementación.

Reemplazado por reproductor local (`audioplayers`) sin ninguna de esas
limitaciones.
