-- ============================================
-- BAMSGO - DONNÉES DE DÉMO (optionnel)
-- À exécuter APRÈS supabase-schema.sql
-- Dans : Supabase Dashboard > SQL Editor > New Query
-- ============================================
-- Ces 8 annonces donnent un premier contenu à l'app pour que
-- Kolwezi ne paraisse pas vide au tout premier lancement.
-- Tu peux les supprimer plus tard depuis Table Editor > listings.

insert into listings (type, city, category, name, service, description, quartier, phone, price, icon, user_id)
values
('service', 'Kolwezi', 'depannage', 'Jean Électricien Pro', 'Dépannage électrique & plomberie',
 'Intervention rapide à Kolwezi. Dépannage électrique, plomberie, réparations urgentes. 15 ans d''expérience.',
 'Manika', '+243812345678', 'À partir de 50$', '⚡', '+243812345678'),

('service', 'Kolwezi', 'auto', 'Garage Central', 'Mécanique & Transport',
 'Réparation tous véhicules, entretien, diagnostic électronique. Service de chauffeur disponible.',
 'Dilala', '+243812345679', 'Sur devis', '🚗', '+243812345679'),

('location', 'Kolwezi', 'energie', 'Groupe électrogène 10kVA', null,
 'Groupe neuf, très silencieux, économique. Parfait pour maisons et petits événements. Panneaux solaires aussi disponibles.',
 'Musonoi', '+243812345680', '150$ / jour', '🔌', '+243812345680'),

('location', 'Kolwezi', 'evenement', 'Tentes & Chaises Premium', null,
 'Pack complet pour événements: 100 chaises + tentes + tables. Livraison et installation incluses.',
 'Manika', '+243812345681', '500$ / jour', '🎪', '+243812345681'),

('service', 'Kolwezi', 'btp', 'Maçon Expert', 'Construction & Rénovation',
 'Tous travaux de maçonnerie: fondations, murs, dalles, finitions. Équipe qualifiée disponible.',
 'Gécamines', '+243812345682', 'Sur devis', '🧱', '+243812345682'),

('service', 'Kolwezi', 'beaute', 'Bella Coiffure', 'Coiffure & Maquillage',
 'Spécialiste mariages et événements. Tresses, tissages, maquillage professionnel. Déplacement possible.',
 'Dilala', '+243812345683', 'À partir de 30$', '💄', '+243812345683'),

('service', 'Kolwezi', 'maison', 'Services Maison Pro', 'Ménage & Jardinage',
 'Ménage complet, jardinage, entretien de la maison. Personnel qualifié et de confiance.',
 'Manika', '+243812345684', '25$ / jour', '🏠', '+243812345684'),

('location', 'Kolwezi', 'vehicules', 'Location Véhicules', null,
 'Voitures, 4x4, camions disponibles. Avec ou sans chauffeur. Tous documents en règle.',
 'Gécamines', '+243812345685', 'À partir de 80$ / jour', '🚗', '+243812345685');
