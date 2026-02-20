# Karikorero

A simple flashcard app for learning Te Reo Māori vocabulary. Swipe or tap to match Māori words with their English translations. 258 words, audio pronunciation, listening mode, no accounts, fully offline.

## Building

Requires Xcode 16.3+ and XcodeGen.

```
brew install xcodegen
xcodegen generate
open Karikorero.xcodeproj
```

## Audio Generation

Word pronunciation audio is generated separately using TTS and is not included in this repository.

## License

This project is licensed under the [Mozilla Public License 2.0](https://mozilla.org/MPL/2.0/).

You are free to use, modify, and distribute this software under the terms of the MPL-2.0. Source files are individually marked with the license header.

### Third-party acknowledgements 

- **Ranade** typeface by [Indian Type Foundry](https://www.fontshare.com/fonts/ranade) — used under the Fontshare Free Font License (EULA).
- **Māori TTS** speech synthesis by [KingsleyEng](https://huggingface.co/spaces/KingsleyEng/Maori-TTS).
