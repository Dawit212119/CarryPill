-- Run this in Supabase Dashboard → SQL Editor

-- Patients (doc id = auth user id)
create table if not exists public.patients (
  uid uuid primary key references auth.users (id) on delete cascade,
  name text not null,
  ic_num text not null,
  phone_num text not null,
  patient_id text,
  address text,
  clinic_list jsonb not null default '[]'::jsonb,
  appointment timestamptz,
  geo_lat double precision,
  geo_lng double precision,
  profile_image_url text,
  created_at timestamptz not null default now()
);

-- Healthcare facilities for booking dropdown
create table if not exists public.healthcare_facilities (
  id uuid primary key default gen_random_uuid(),
  facility_name text not null,
  full_address text not null,
  geo_lat double precision not null,
  geo_lng double precision not null
);

-- Orders
create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  facility jsonb,
  status_order text not null default 'noOrder',
  service_type text,
  payment_type text,
  total_pay double precision not null default 0,
  order_date timestamptz,
  order_date_complete timestamptz,
  order_query_status text,
  patient_ref uuid references auth.users (id),
  rider_ref uuid,
  rider_cancel_id jsonb,
  rider_pending boolean default false,
  token_num integer,
  token_url_image text
);

-- Riders (used with CarryPillRider app)
create table if not exists public.riders (
  id uuid primary key,
  first_name text not null,
  last_name text not null,
  phone_num text not null,
  vehicle_type text not null,
  working_status text not null default 'offline',
  is_working boolean not null default false,
  auto_accept boolean not null default false,
  current_lat double precision,
  current_lng double precision,
  is_profile_complete boolean,
  current_order_id uuid,
  start_working_date timestamptz,
  order_cancel_id jsonb,
  profile jsonb,
  vehicle jsonb,
  earning double precision not null default 0
);

-- Row Level Security
alter table public.patients enable row level security;
alter table public.healthcare_facilities enable row level security;
alter table public.orders enable row level security;
alter table public.riders enable row level security;

-- Patients: users manage their own row
create policy "Users read own patient profile"
  on public.patients for select
  using (auth.uid() = uid);

create policy "Users insert own patient profile"
  on public.patients for insert
  with check (auth.uid() = uid);

create policy "Users update own patient profile"
  on public.patients for update
  using (auth.uid() = uid);

-- Facilities: readable by any signed-in user
create policy "Authenticated users read facilities"
  on public.healthcare_facilities for select
  to authenticated
  using (true);

-- Orders: patients manage their own orders
create policy "Users read own orders"
  on public.orders for select
  using (auth.uid() = patient_ref);

create policy "Users insert own orders"
  on public.orders for insert
  with check (auth.uid() = patient_ref);

create policy "Users update own orders"
  on public.orders for update
  using (auth.uid() = patient_ref);

-- Riders: readable by authenticated users (patient app finds drivers)
create policy "Authenticated users read riders"
  on public.riders for select
  to authenticated
  using (true);

create policy "Riders update own row"
  on public.riders for update
  using (auth.uid() = id);

-- Realtime (required for live streams in the app)
alter publication supabase_realtime add table public.patients;
alter publication supabase_realtime add table public.orders;
alter publication supabase_realtime add table public.riders;

-- Sample facility (optional — remove or edit)
insert into public.healthcare_facilities (facility_name, full_address, geo_lat, geo_lng)
values ('City General Clinic', '123 Main Street', 3.139, 101.6869)
on conflict do nothing;

-- Storage buckets (Dashboard → Storage → New bucket, Public: yes)
-- 1. patient-profiles  — profile photos (path: {uid}/profilepic)
-- 2. order-tokens      — pharmacy queue token slips (path: {uid}/{filename})
-- Policies: authenticated users can INSERT/UPDATE objects where (storage.foldername(name))[1] = auth.uid()::text
