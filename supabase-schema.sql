-- ============================================
-- BAMSGO - SCHEMA SUPABASE
-- À exécuter dans : Supabase Dashboard > SQL Editor > New Query
-- ============================================

-- 1. TABLE USERS
-- Remplace bamsgo_user (localStorage)
create table if not exists users (
  id uuid primary key default gen_random_uuid(),
  phone text unique not null,
  name text not null,
  type text not null check (type in ('client', 'prestataire')),
  specialty text,
  created_at timestamptz default now()
);

-- 2. TABLE LISTINGS
-- Remplace bamsgo_listings (localStorage)
create table if not exists listings (
  id bigint generated always as identity primary key,
  type text not null check (type in ('service', 'location')),
  city text not null,
  category text not null,
  name text not null,
  service text,
  description text not null,
  quartier text not null,
  phone text not null,
  price text not null,
  icon text,
  user_id text not null, -- correspond au phone du créateur (currentUser.phone)
  created_at timestamptz default now()
);

-- 3. TABLE RATINGS
-- Remplace bamsgo_ratings_[listingId] (localStorage)
create table if not exists ratings (
  id bigint generated always as identity primary key,
  listing_id bigint not null references listings(id) on delete cascade,
  user_id text not null, -- phone de la personne qui note
  user_name text not null,
  criterion1 int check (criterion1 between 0 and 5),
  criterion2 int check (criterion2 between 0 and 5),
  criterion3 int check (criterion3 between 0 and 5),
  criterion4 int check (criterion4 between 0 and 5),
  average numeric(2,1) not null,
  comment text,
  tags text[],
  created_at timestamptz default now(),
  unique (listing_id, user_id) -- un seul avis par personne par annonce
);

-- 4. TABLE CONTACTS
-- Remplace bamsgo_contacts_[userId] (localStorage)
create table if not exists contacts (
  id bigint generated always as identity primary key,
  user_id text not null, -- phone de la personne qui contacte
  listing_id bigint not null references listings(id) on delete cascade,
  created_at timestamptz default now()
);

-- 5. TABLE NOTIFICATIONS
-- Remplace bamsgo_notifications_[userId] (localStorage)
create table if not exists notifications (
  id bigint generated always as identity primary key,
  user_id text not null, -- phone du destinataire
  type text not null,
  icon text,
  title text not null,
  message text not null,
  read boolean default false,
  created_at timestamptz default now()
);

-- ============================================
-- INDEX (pour accélérer les requêtes fréquentes)
-- ============================================
create index if not exists idx_listings_city on listings(city);
create index if not exists idx_listings_category on listings(category);
create index if not exists idx_listings_user on listings(user_id);
create index if not exists idx_ratings_listing on ratings(listing_id);
create index if not exists idx_contacts_user on contacts(user_id);
create index if not exists idx_notifications_user on notifications(user_id);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================
alter table users enable row level security;
alter table listings enable row level security;
alter table ratings enable row level security;
alter table contacts enable row level security;
alter table notifications enable row level security;

-- USERS : tout le monde peut créer un compte et lire les profils (pour affichage nom prestataire)
create policy "users_select_all" on users for select using (true);
create policy "users_insert_all" on users for insert with check (true);
create policy "users_update_own" on users for update using (true);

-- LISTINGS : tout le monde peut lire, tout le monde peut publier (pas d'auth forte en V1)
create policy "listings_select_all" on listings for select using (true);
create policy "listings_insert_all" on listings for insert with check (true);
create policy "listings_update_own" on listings for update using (true);
create policy "listings_delete_own" on listings for delete using (true);

-- RATINGS : tout le monde peut lire et noter
create policy "ratings_select_all" on ratings for select using (true);
create policy "ratings_insert_all" on ratings for insert with check (true);
create policy "ratings_update_own" on ratings for update using (true);

-- CONTACTS : tout le monde peut créer un log de contact, chacun lit le sien
create policy "contacts_select_all" on contacts for select using (true);
create policy "contacts_insert_all" on contacts for insert with check (true);

-- NOTIFICATIONS : tout le monde peut lire/écrire (filtré côté app par user_id)
create policy "notifications_select_all" on notifications for select using (true);
create policy "notifications_insert_all" on notifications for insert with check (true);
create policy "notifications_update_all" on notifications for update using (true);

-- ============================================
-- NOTE IMPORTANTE SUR LA SÉCURITÉ (V1)
-- ============================================
-- Ces règles sont volontairement permissives car BamsGo V1 n'a pas
-- d'authentification forte (pas de mot de passe, juste nom + téléphone).
-- N'importe qui pourrait techniquement modifier/supprimer l'annonce de
-- quelqu'un d'autre en connaissant son ID. C'est un risque accepté pour
-- le MVP, à corriger en V2 avec Supabase Auth (vérification SMS).
