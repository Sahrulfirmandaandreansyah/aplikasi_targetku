// Menunggu seluruh halaman dimuat sebelum menjalankan script
document.addEventListener('DOMContentLoaded', function() {

    // --- LOGIKA ONBOARDING DI INDEX.HTML ---
    const onboardingOverlay = document.getElementById('onboarding-overlay');
    const startButton = document.getElementById('start-button');
    
    // Hanya jalankan jika kita berada di halaman utama (ada elemen onboarding)
    if (onboardingOverlay && startButton) {
        // Cek sessionStorage
        if (sessionStorage.getItem('onboardingCompleted') === 'true') {
            onboardingOverlay.style.display = 'none';
        }

        // Event listener untuk tombol 'Mulai Sekarang'
        startButton.addEventListener('click', function() {
            sessionStorage.setItem('onboardingCompleted', 'true');
            onboardingOverlay.style.opacity = '0';
            setTimeout(() => {
                onboardingOverlay.style.display = 'none';
            }, 500);
        });
    }

    // --- LOGIKA INTERAKTIF UNTUK FREQUENCY SELECTOR ---
    // (Berlaku untuk buat-target.html, edit-target.html, tambah-transaksi.html)
    const frequencySelectors = document.querySelectorAll('.frequency-selector');
    
    frequencySelectors.forEach(selector => {
        const buttons = selector.querySelectorAll('.freq-button');
        
        buttons.forEach(button => {
            button.addEventListener('click', function() {
                // 1. Hapus class 'active' dari semua tombol di dalam grup ini
                buttons.forEach(btn => btn.classList.remove('active'));
                
                // 2. Tambahkan class 'active' ke tombol yang baru saja diklik
                this.classList.add('active');
            });
        });
    });

});