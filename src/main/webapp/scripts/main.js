// Retropia - Main JavaScript file
document.addEventListener('DOMContentLoaded', () => {
    console.log('Retropia: Document Loaded');
});

// Funzione per mostrare le notifiche Toast
function showToast(message, type = 'info') {
    let container = document.getElementById('toast-container');
    if (!container) {
        // Se il container non c'è, lo creiamo al volo (a prova di bomba!)
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
            // Utente non loggato: usiamo il Toast invece del brutto alert()!
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
