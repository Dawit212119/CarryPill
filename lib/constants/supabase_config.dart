/// Supabase project credentials.
/// Prefer passing at build time (keeps keys out of git):
/// `flutter run --dart-define=SUPABASE_URL=https://xxx.supabase.co --dart-define=SUPABASE_ANON_KEY=your_anon_key`
class SupabaseConfig {
  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://hjugpdkxsmbbzekdllqw.supabase.co',
  );

  static const anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_-L4mw8jFqdh8eEPjTNJvKg_JO5XY4nK',
  );
}
