# Yellow Flowers 🌼

App Android (Flutter) que, cada vez que se abre, muestra una foto random de
flores amarillas + reproduce una canción random de una playlist de Spotify.
Programa recordatorios locales cada 21 de marzo y 21 de septiembre (día de
las flores amarillas, hemisferio norte/sur).

## Setup pendiente antes de usar

Ver checklist completo en el plan (`~/.claude/plans/melodic-kindling-fox.md`).
Resumen de lo que falta configurar:

### 1. Fotos

Agregar fotos `.jpg`/`.png` de flores amarillas en `assets/images/flowers/`
(la carpeta está vacía salvo un `.gitkeep`). Sin fotos, la app muestra un
mensaje pidiéndolas en vez de crashear.

### 2. Spotify Developer Dashboard

1. Crear app en https://developer.spotify.com/dashboard (cuenta **Premium**
   requerida como owner).
2. Redirect URI: `yellowflowers://callback` (no crítico para el flujo actual,
   que usa solo App Remote, pero el Dashboard lo pide igual).
3. Settings → Android packages: agregar `com.haroldespinoza.yellow_flowers`
   + SHA-1 del debug keystore:
   ```
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
4. Settings → Users and Access: agregar el email/usuario de Spotify de la
   esposa (obligatorio en 2026, o el login da 403).
5. Copiar el **Client ID** (no hace falta Client Secret, PKCE es público).

### 3. Completar `lib/core/config/app_config.dart`

- `spotifyClientId`: el Client ID del paso anterior.
- `spotifyPlaylistId`: el ID de la playlist (segmento final de
  `open.spotify.com/playlist/<ID>` o de `spotify:playlist:<ID>`).

### 4. Dispositivo de prueba

- Debe tener la app oficial de Spotify instalada (cuenta free sirve para
  reproducir).
- App Remote SDK no funciona bien en emulador — usar dispositivo físico.

## Limitación conocida

Los recordatorios anuales se reprograman en cada apertura de la app (no hay
backend). Si la app no se abre nunca entre un 21-marzo/21-sept y el
siguiente, ese ciclo puntual no se reprograma solo.

## Comandos útiles

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
flutter install   # con un dispositivo Android conectado
```
