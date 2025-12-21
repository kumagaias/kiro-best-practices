---
inclusion: always
---

# 言語設定

## コミュニケーション標準

- **エージェントチャット**: {{CHAT_LANG}}
- **ドキュメント**: {{DOC_LANG}}
- **コードコメント**: {{COMMENT_LANG}}
- **README ファイル**: 英語（200 行以内）
- **GitHub PR/Issue**: 英語
- **コミットメッセージ**: 英語

## エージェントへの指示

### チャット言語: {{CHAT_LANG}}

{{#if CHAT_LANG_JA}}
- すべてのチャットでの会話は日本語で行ってください
- エラーメッセージの説明も日本語で提供してください
{{else}}
- All chat conversations should be conducted in English
- Provide error message explanations in English
{{/if}}

### ドキュメント言語: {{DOC_LANG}}

{{#if DOC_LANG_JA}}
- プロジェクト内部のドキュメント（steering, specs など）は日本語で記述してください
- ただし、README.md は英語で記述してください（国際標準）
{{else}}
- All project documentation should be written in English
- This includes steering files, specs, and README files
{{/if}}

### コードコメント言語: {{COMMENT_LANG}}

{{#if COMMENT_LANG_JA}}
- コード内のコメントは日本語で記述してください
- 関数やクラスの説明コメントも日本語で記述してください
{{else}}
- All code comments should be written in English
- This includes function, class, and inline comments
{{/if}}

## 固定ルール（変更不可）

以下は常に英語を使用:
- GitHub PR/Issue のタイトルと本文
- コミットメッセージ
- README.md（プロジェクトルート）
- 公開 API ドキュメント

## ファイル命名規則

- すべてのファイル名は英語を使用
- 例: `project.md`, `tech.md`, `structure.md`
