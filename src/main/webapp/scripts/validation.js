/**
 * Retropia - Client-side Validation Script
 */

document.addEventListener('DOMContentLoaded', () => {

    // =========================================================
    // FORM DI REGISTRAZIONE
    // =========================================================
    const registrationForm = document.getElementById('registrationForm');

    if (registrationForm) {
        const fields = {
            nome: {
                element: document.getElementById('nome'),
                error: document.getElementById('nomeError'),
                regex: /^[A-Za-zÀ-ÿ\s']{2,30}$/
            },
            cognome: {
                element: document.getElementById('cognome'),
                error: document.getElementById('cognomeError'),
                regex: /^[A-Za-zÀ-ÿ\s']{2,30}$/
            },
            email: {
                element: document.getElementById('reg-email'),
                error: document.getElementById('emailError'),
                regex: /^[^\s@]+@[^\s@]+\.[^\s@]+$/
            },
            password: {
                element: document.getElementById('reg-password'),
                error: document.getElementById('passwordError'),
                regex: /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d!@#$%^&*]{8,}$/
            },
            confirmPassword: {
                element: document.getElementById('conferma-password'),
                error: document.getElementById('confirmError')
            }
        };

        // Validate individual fields on input
        Object.keys(fields).forEach(key => {
            const field = fields[key];
            if (field.element) {
                field.element.addEventListener('input', () => {
                    validateField(key, fields);
                });
                
                // Also validate when leaving the field (blur)
                field.element.addEventListener('blur', () => {
                    validateField(key, fields);
                });
            }
        });

        // Form submission handling
        registrationForm.addEventListener('submit', (event) => {
            // FERMIAMO SEMPRE L'INVIO DI DEFAULT per poter fare i controlli
            event.preventDefault(); 
            
            let isFormValid = true;

            // Controlla tutti i campi (sincrono)
            Object.keys(fields).forEach(key => {
                if (!validateField(key, fields)) {
                    isFormValid = false;
                }
            });

            // Se ci sono errori locali (password corta, nome vuoto, ecc.), ci fermiamo!
            if (!isFormValid) {
                console.log('Form non valido localmente. Invio annullato.');
                return;
            }

            // Se tutto sembra valido, facciamo l'ultimo controllo sul server per l'email!
            const emailValue = fields.email.element.value.trim();
            fetch('CheckEmail?email=' + encodeURIComponent(emailValue))
                .then(response => response.json())
                .then(data => {
                    if (data.esiste) {
                        // L'email esiste già, sblocchiamo l'errore e NON inviamo
                        fields.email.element.style.borderColor = '#e74c3c'; // Rosso
                        fields.email.error.textContent = "Questa email è già in uso!";
                        fields.email.error.style.display = 'block';
                    } else {
                        // Tutto perfetto! L'email è libera. Inviamo fisicamente il form.
                        registrationForm.submit();
                    }
                })
                .catch(error => {
                    console.error("Errore server:", error);
                    registrationForm.submit(); // Fallback in caso di server down
                });
        });
    }

    // =========================================================
    // FORM DI LOGIN
    // =========================================================
    const loginForm = document.getElementById('loginForm');

    if (loginForm) {
        const loginFields = {
            email: {
                element: document.getElementById('login-email'),
                error: document.getElementById('loginEmailError'),
                regex: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
                emptyMsg: 'Inserisci il tuo indirizzo email.',
                invalidMsg: "Formato email non valido."
            },
            password: {
                element: document.getElementById('login-password'),
                error: document.getElementById('loginPasswordError'),
                emptyMsg: 'Inserisci la tua password.',
                invalidMsg: 'La password non può essere vuota.'
            }
        };

        // Validazione live su blur
        Object.keys(loginFields).forEach(key => {
            const field = loginFields[key];
            if (field.element) {
                field.element.addEventListener('blur', () => validateLoginField(key, loginFields));
                field.element.addEventListener('input', () => {
                    // Rimuove l'errore mentre l'utente digita
                    if (field.element.value.trim().length > 0) {
                        field.element.style.borderColor = '#2ecc71';
                        field.error.style.display = 'none';
                    }
                });
            }
        });

        loginForm.addEventListener('submit', (event) => {
            event.preventDefault();
            let isValid = true;
            Object.keys(loginFields).forEach(key => {
                if (!validateLoginField(key, loginFields)) isValid = false;
            });
            if (isValid) loginForm.submit();
        });
    }

    // =========================================================
    // FORM DI CHECKOUT
    // =========================================================
    const checkoutForm = document.getElementById('checkoutForm');

    if (checkoutForm) {
        const checkoutFields = {
            via: {
                element: document.getElementById('via'),
                error: document.getElementById('viaError'),
                minLength: 3,
                emptyMsg: "Inserisci l'indirizzo di spedizione.",
                invalidMsg: "L'indirizzo deve contenere almeno 3 caratteri."
            },
            citta: {
                element: document.getElementById('citta'),
                error: document.getElementById('cittaError'),
                regex: /^[A-Za-zÀ-ÿ\s']{2,}$/,
                emptyMsg: 'Inserisci la città.',
                invalidMsg: 'Inserisci una città valida (solo lettere).'
            },
            cap: {
                element: document.getElementById('cap'),
                error: document.getElementById('capError'),
                regex: /^\d{5}$/,
                emptyMsg: 'Inserisci il CAP.',
                invalidMsg: 'Il CAP deve essere composto da esattamente 5 cifre.'
            }
        };

        // Validazione live su blur
        Object.keys(checkoutFields).forEach(key => {
            const field = checkoutFields[key];
            if (field.element) {
                field.element.addEventListener('blur', () => validateCheckoutField(key, checkoutFields));
                field.element.addEventListener('input', () => {
                    if (field.element.value.trim().length > 0) {
                        field.element.style.borderColor = '#2ecc71';
                        field.error.style.display = 'none';
                    }
                });
            }
        });

        checkoutForm.addEventListener('submit', (event) => {
            event.preventDefault();
            let isValid = true;
            Object.keys(checkoutFields).forEach(key => {
                if (!validateCheckoutField(key, checkoutFields)) isValid = false;
            });
            if (isValid) checkoutForm.submit();
        });
    }

}); // Fine DOMContentLoaded


// =========================================================
// FUNZIONI DI VALIDAZIONE
// =========================================================

/**
 * Validates a single field of the registration form and updates the UI
 */
function validateField(key, fields) {
    const field = fields[key];
    const value = field.element.value.trim();
    let isValid = true;

    if (key === 'confirmPassword') {
        // Special case: Password matching
        const passwordValue = fields.password.element.value;
        isValid = (value === passwordValue && value !== '');
    } else if (key === 'password') {
        // Feedback dinamico specifico per la password
        let messaggiErrore = [];
        if (value.length < 8) {
            messaggiErrore.push("Almeno 8 caratteri.");
        }
        if (!/[A-Za-z]/.test(value)) {
            messaggiErrore.push("Manca una lettera.");
        }
        if (!/\d/.test(value)) {
            messaggiErrore.push("Manca un numero.");
        }
        
        if (messaggiErrore.length > 0) {
            isValid = false;
            field.error.textContent = "Errore: " + messaggiErrore.join(" ");
        } else {
            isValid = true;
            field.error.textContent = "Deve contenere almeno 8 caratteri e un numero."; // reset default
        }
    } else if (field.regex) {
        // Regex validation
        isValid = field.regex.test(value);
    } else {
        // General non-empty validation
        isValid = value.length > 0;
    }

    // Aggiunta Logica AJAX per l'email (Controllo duplicati dal server)
    if (key === 'email' && isValid) {
        // L'email ha superato la regex, ora chiediamo al server se esiste già
        // Usiamo la Fetch API (come da requisito della checklist)
        fetch('CheckEmail?email=' + encodeURIComponent(value))
            .then(response => response.json())
            .then(data => {
                if (data.esiste) {
                    field.element.style.borderColor = '#e74c3c'; // Rosso
                    field.error.textContent = "Questa email è già in uso!";
                    field.error.style.display = 'block';
                    isValid = false; // Forza l'invalidità anche se la regex era corretta
                } else {
                    field.element.style.borderColor = '#2ecc71'; // Verde
                    field.error.textContent = "Formato email non valido."; // Ripristina il messagio di default
                    field.error.style.display = 'none';
                }
            })
            .catch(error => console.error("Errore AJAX controllo email:", error));
            
        // Siccome la fetch è asincrona, nel frattempo restituiamo lo stato corrente della regex
        return isValid; 
    }

    // Update UI standard per tutti gli altri campi
    if (isValid) {
        field.element.style.borderColor = '#2ecc71'; // Green
        field.error.style.display = 'none';
    } else {
        field.element.style.borderColor = '#e74c3c'; // Red
        // Se è l'email che fallisce la regex, assicuro il messaggio originale
        if (key === 'email') field.error.textContent = "Formato email non valido.";
        field.error.style.display = 'block';
    }

    return isValid;
}

/**
 * Validates a single field of the login form
 */
function validateLoginField(key, fields) {
    const field = fields[key];
    const value = field.element.value.trim();
    let isValid = true;

    if (value.length === 0) {
        isValid = false;
        field.error.textContent = field.emptyMsg;
    } else if (field.regex && !field.regex.test(value)) {
        isValid = false;
        field.error.textContent = field.invalidMsg;
    }

    if (isValid) {
        field.element.style.borderColor = '#2ecc71';
        field.error.style.display = 'none';
    } else {
        field.element.style.borderColor = '#e74c3c';
        field.error.style.display = 'block';
    }
    return isValid;
}

/**
 * Validates a single field of the checkout form
 */
function validateCheckoutField(key, fields) {
    const field = fields[key];
    const value = field.element.value.trim();
    let isValid = true;

    if (value.length === 0) {
        isValid = false;
        field.error.textContent = field.emptyMsg;
    } else if (field.minLength && value.length < field.minLength) {
        isValid = false;
        field.error.textContent = field.invalidMsg;
    } else if (field.regex && !field.regex.test(value)) {
        isValid = false;
        field.error.textContent = field.invalidMsg;
    }

    if (isValid) {
        field.element.style.borderColor = '#2ecc71';
        field.error.style.display = 'none';
    } else {
        field.element.style.borderColor = '#e74c3c';
        field.error.style.display = 'block';
    }
    return isValid;
}

