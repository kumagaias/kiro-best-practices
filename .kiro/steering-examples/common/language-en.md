---
inclusion: always
---

# Language Settings

## Communication Standards

- **Agent chat**: {{CHAT_LANG}}
- **Documentation**: {{DOC_LANG}}
- **Code comments**: {{COMMENT_LANG}}
- **README files**: English (max 200 lines)
- **GitHub PRs/Issues**: English
- **Commit messages**: English

## Instructions for Agent

### Chat Language: {{CHAT_LANG}}

{{#if CHAT_LANG_JA}}
- すべてのチャットでの会話は日本語で行ってください
- エラーメッセージの説明も日本語で提供してください
{{else}}
- All chat conversations should be conducted in English
- Provide error message explanations in English
{{/if}}

### Documentation Language: {{DOC_LANG}}

{{#if DOC_LANG_JA}}
- プロジェクト内部のドキュメント（steering, specs など）は日本語で記述してください
- ただし、README.md は英語で記述してください（国際標準）
{{else}}
- All project documentation should be written in English
- This includes steering files, specs, and README files
{{/if}}

### Code Comment Language: {{COMMENT_LANG}}

{{#if COMMENT_LANG_JA}}
- コード内のコメントは日本語で記述してください
- 関数やクラスの説明コメントも日本語で記述してください
{{else}}
- All code comments should be written in English
- This includes function, class, and inline comments
{{/if}}

## Fixed Rules (Unchangeable)

Always use English for:
- GitHub PR/Issue titles and descriptions
- Commit messages
- README.md (project root)
- Public API documentation

## File Naming Conventions

- All file names should use English
- Examples: `project.md`, `tech.md`, `structure.md`
