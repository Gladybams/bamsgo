const CACHE_NAME = 'bamsgo-v1';
const urlsToCache = [
  './',
  './bamsgo-pwa.html',
  './manifest.json'
];

// Installation du Service Worker
self.addEventListener('install', (event) => {
  console.log('🔧 Installation du Service Worker...');
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => {
        console.log('📦 Ouverture du cache');
        // Essayer de mettre en cache, mais ne pas bloquer si échec
        return cache.addAll(urlsToCache).catch(err => {
          console.log('ℹ️ Impossible de mettre certains fichiers en cache (normal en mode fichier local)');
        });
      })
  );
  self.skipWaiting();
});

// Activation et nettoyage des anciens caches
self.addEventListener('activate', (event) => {
  console.log('✅ Activation du Service Worker');
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheName !== CACHE_NAME) {
            console.log('🗑️ Suppression ancien cache:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
  self.clients.claim();
});

// Stratégie: Network First, puis Cache (meilleure pour contenu dynamique)
self.addEventListener('fetch', (event) => {
  // Ignorer les requêtes non-HTTP (comme chrome-extension://)
  if (!event.request.url.startsWith('http')) {
    return;
  }

  event.respondWith(
    fetch(event.request)
      .then((response) => {
        // Si la réponse est OK, la mettre en cache
        if (response && response.status === 200) {
          const responseToCache = response.clone();
          
          caches.open(CACHE_NAME)
            .then((cache) => {
              cache.put(event.request, responseToCache).catch(err => {
                // Ignorer silencieusement les erreurs de cache
              });
            });
        }
        
        return response;
      })
      .catch(() => {
        // Si le réseau échoue, chercher dans le cache
        return caches.match(event.request)
          .then((response) => {
            if (response) {
              return response;
            }
            
            // Page offline par défaut pour les documents
            if (event.request.destination === 'document') {
              return caches.match('./bamsgo-pwa.html');
            }
          });
      })
  );
});

// Gestion des notifications push (optionnel - pour plus tard)
self.addEventListener('push', (event) => {
  const options = {
    body: event.data ? event.data.text() : 'Nouvelle notification BamsGo',
    icon: './icon-192.png',
    badge: './icon-72.png',
    vibrate: [200, 100, 200],
    data: {
      dateOfArrival: Date.now(),
      primaryKey: 1
    },
    actions: [
      {
        action: 'explore',
        title: 'Voir',
        icon: './icon-192.png'
      },
      {
        action: 'close',
        title: 'Fermer',
        icon: './icon-192.png'
      }
    ]
  };

  event.waitUntil(
    self.registration.showNotification('BamsGo', options)
  );
});

// Gestion des clics sur les notifications
self.addEventListener('notificationclick', (event) => {
  event.notification.close();

  if (event.action === 'explore') {
    event.waitUntil(
      clients.openWindow('./')
    );
  }
});

console.log('🚀 Service Worker BamsGo chargé');
