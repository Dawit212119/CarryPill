/// Supabase project credentials.
/// Prefer passing at build time (keeps keys out of git):
/// `flutter run --dart-define=SUPABASE_URL=https://xxx.supabase.co --dart-define=SUPABASE_ANON_KEY=your_anon_key`
class SupabaseConfig {
  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://jlexzeqqaxphdsgmpuxw.supabase.co',
  );

  static const anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpsZXh6ZXFxYXhwaGRzZ21wdXh3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAwODIyNTAsImV4cCI6MjA5NTY1ODI1MH0.SBY81U9lB2SPMTSh-H9YvB44eZQ9xwsiFIR157swXj4',
  );
}
