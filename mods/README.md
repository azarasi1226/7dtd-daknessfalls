# Mods フォルダ

ここに **Darkness Falls** や他のModを配置します。

## Darkness Falls の入れ方

1. Darkness Falls の ZIP を公式サイトからダウンロード
   - https://7daystodiemods.com/darkness-falls-mod/
2. ZIPを解凍すると、中に **`Mods`** というフォルダが入っています
3. その **`Mods` フォルダの中身**（複数のサブフォルダ）を、このフォルダに直接コピー

## 正しい配置例

```
mods/
├── 0-XNPCCore/
├── 0-SCore/
├── 1-KhaineDF/
├── 2-DarknessFallsCore/
├── A17_CreatureSpawner/
├── ... （他にもたくさん）
└── README.md  ← このファイル
```

## ❌ 間違った配置例

```
mods/
└── Mods/           ← フォルダを丸ごと入れないこと
    ├── 0-XNPCCore/
    └── ...
```

## バニラで動かしたい時

このフォルダを空にしておけば、バニラの7DTDサーバーとして起動します。
