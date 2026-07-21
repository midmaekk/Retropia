// Retropia - Main JavaScript file
document.addEventListener('DOMContentLoaded', () => {
    console.log('Retropia: Document Loaded');

    // =========================================================
    // DROPDOWN UTENTE — Avatar con menu a tendina
    // =========================================================
    const avatarBtn = document.getElementById('userAvatarBtn');
    const dropdownMenu = document.getElementById('userDropdownMenu');
    const dropdown = document.getElementById('userDropdown');

    if (avatarBtn && dropdownMenu) {
        // Click sul bottone: apre/chiude. stopPropagation impedisce
        // al listener globale di chiuderlo subito dopo averlo aperto.
        avatarBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            const isOpen = dropdownMenu.classList.toggle('is-open');
            avatarBtn.setAttribute('aria-expanded', isOpen);
        });

        // Click fuori dal dropdown: chiude il menu
        document.addEventListener('click', function(e) {
            if (dropdown && !dropdown.contains(e.target)) {
                dropdownMenu.classList.remove('is-open');
                avatarBtn.setAttribute('aria-expanded', 'false');
            }
        });

        // Tasto Escape: chiude il menu
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' && dropdownMenu.classList.contains('is-open')) {
                dropdownMenu.classList.remove('is-open');
                avatarBtn.setAttribute('aria-expanded', 'false');
                avatarBtn.focus();
            }
        });
    }

    // =========================================================
    // AJAX SEARCH BAR (Suggerimenti dinamici)
    // =========================================================
    const searchInput = document.getElementById('searchInput');
    const searchSuggestions = document.getElementById('searchSuggestions');
    let searchTimeout = null;

    if (searchInput && searchSuggestions) {
        searchInput.addEventListener('input', function() {
            const query = this.value.trim();
            
            clearTimeout(searchTimeout);
            
            if (query.length < 2) {
                searchSuggestions.style.display = 'none';
                searchSuggestions.innerHTML = '';
                return;
            }
            
            // Aspetta 300ms prima di fare la chiamata (debounce) per non intasare il server
            searchTimeout = setTimeout(() => {
                fetch('RicercaAjax?q=' + encodeURIComponent(query))
                    .then(response => {
                        if (!response.ok) throw new Error('Errore nella risposta di rete');
                        return response.json();
                    })
                    .then(data => {
                        searchSuggestions.innerHTML = '';
                        if (data.length > 0) {
                            data.forEach(item => {
                                const li = document.createElement('li');
                                li.innerHTML = `
                                    <a href="DettaglioProdotto?id=${item.id}" class="suggestion-item">
                                        <img src="${item.immagine}" class="suggestion-img" alt="${item.nome}">
                                        <span class="suggestion-name">${item.nome}</span>
                                    </a>
                                `;
                                searchSuggestions.appendChild(li);
                            });
                        } else {
                            searchSuggestions.innerHTML = '<li class="suggestion-empty">Nessun prodotto trovato</li>';
                        }
                        searchSuggestions.style.display = 'block';
                    })
                    .catch(error => {
                        console.error('Errore durante la ricerca:', error);
                    });
            }, 300);
        });

        // Chiudi i suggerimenti se si clicca fuori dalla barra
        document.addEventListener('click', function(e) {
            if (!searchInput.contains(e.target) && !searchSuggestions.contains(e.target)) {
                searchSuggestions.style.display = 'none';
            }
        });
        
        // Riapri i suggerimenti se si torna col focus sulla barra
        searchInput.addEventListener('focus', function() {
            if (this.value.trim().length >= 2 && searchSuggestions.innerHTML !== '') {
                searchSuggestions.style.display = 'block';
            }
        });
    }
});

// Funzione per mostrare le notifiche Toast
function showToast(message, type = 'info') {
    let container = document.getElementById('toast-container');
    if (!container) {
        // Se il container non c'è, lo creiamo al volo
        container = document.createElement('div');
        container.id = 'toast-container';
        container.className = 'toast-container';
        document.body.appendChild(container);
    }

    // Crea l'elemento toast
    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    
    // Scegli l'icona in base al tipo
    let icon = 'ℹ️';
    if (type === 'error') icon = '❌';
    if (type === 'success') icon = '✅';

    toast.innerHTML = `
        <span class="toast-icon">${icon}</span>
        <span class="toast-message">${message}</span>
        <button class="toast-close">&times;</button>
    `;

    // Aggiungi al container
    container.appendChild(toast);

    // Trigger reflow per avviare l'animazione CSS
    toast.offsetHeight;
    toast.classList.add('show');

    // Setup chiusura manuale
    const closeBtn = toast.querySelector('.toast-close');
    closeBtn.addEventListener('click', () => {
        toast.classList.remove('show');
        setTimeout(() => toast.remove(), 400); // Rimuove dal DOM dopo l'animazione
    });

    // Auto chiusura dopo 4 secondi
    setTimeout(() => {
        if (toast.parentElement) {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 400);
        }
    }, 4000);
}

function toggleWishlist(idProdotto, btnElement) {
    // Chiamata AJAX (Fetch API) per aggiornare la wishlist
    fetch('Wishlist', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'idProdotto=' + idProdotto
    })
    .then(response => {
        if (response.status === 401) {
            // Utente non loggato: usiamo il Toast
            showToast("Per aggiungere un prodotto alla Wishlist devi prima accedere o registrarti.", "error");
            throw new Error('Non autorizzato');
        }
        if (!response.ok) {
            throw new Error('Errore di rete');
        }
        return response.json();
    })
    .then(data => {
        if (data.error) {
            console.error(data.error);
            return;
        }
        
        // Aggiorna l'UI in base alla risposta JSON
        const heartIcon = btnElement.querySelector('.heart-icon');
        const countSpan = btnElement.querySelector('.wishlist-count');
        
        if (data.inWishlist) {
            btnElement.classList.add('active');
            heartIcon.innerHTML = '♥';
            showToast("Prodotto aggiunto alla tua Wishlist!", "success");
        } else {
            btnElement.classList.remove('active');
            heartIcon.innerHTML = '♡';
            showToast("Prodotto rimosso dalla Wishlist.", "info");
        }
        
        countSpan.textContent = data.wishlistCount;
    })
    .catch(error => {
        if (error.message !== 'Non autorizzato') {
            console.error('Errore durante l\'aggiornamento della wishlist:', error);
            showToast("Si è verificato un errore.", "error");
        }
    });
}
