async function initSearch() {
    try {
        const res = await fetch(window.searchIndex);
        const data = await res.json();

        const options = {
            keys: ["title", "content"],
            threshold: 0.4,
        };

        const fuse = new Fuse(data, options);
        const input = document.getElementById('searchInput');
        const roadmap = document.querySelector('.roadmap-section'); 
        const results = document.getElementById('searchResults');
        const searchbox = document.getElementById('searchbox');

        input.addEventListener('input', () => {
            const query = input.value.trim();

            if (query.length > 0) {
                // 1. Perform the search
                const searchResults = fuse.search(query);

                // 2. Clear previous results and hide roadmap
                results.innerHTML = '';
                // hide the roadmap section completely while showing results
                if (roadmap) roadmap.style.display = 'none';
                // ensure results use the compact search styling
                results.classList.add('search-results');

                if (searchResults.length > 0) {
                    // 3. Draw the new results
                    searchResults.slice(0, 12).forEach(result => {
                        const item = result.item;
                        const a = document.createElement('a');
                        a.className = 'roadmap-card';
                        const num = item.weight || item.Weight || '';
                        const title = item.title || item.Title || item.name || '';
                        a.href = item.permalink || '#';
                        a.innerHTML = `<span class="roadmap-no">${num}</span><span class="roadmap-label">${title}</span>`;
                        results.appendChild(a);
                    });
                    results.style.display = 'block';
                } else {
                    // No matches found
                    results.innerHTML = '<div style="padding:1rem; opacity:0.5;">No labs found...</div>';
                    results.style.display = 'block';
                }
            } else {
                // 4. Search is empty: Reset the view
                results.style.display = 'none';
                results.classList.remove('search-results');
                if (roadmap) roadmap.style.display = '';
            }
        });

        // Hide roadmap immediately when input gains focus
        input.addEventListener('focus', () => {
            if (roadmap) roadmap.style.display = 'none';
        });

        // Restore roadmap when clicking outside the searchbox
        document.addEventListener('click', (e) => {
            if (!searchbox.contains(e.target)) {
                results.style.display = 'none';
                results.classList.remove('search-results');
                if (roadmap) roadmap.style.display = '';
            }
        });

        // Allow Escape to clear search and restore roadmap
        input.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                input.value = '';
                results.style.display = 'none';
                results.classList.remove('search-results');
                if (roadmap) roadmap.style.display = '';
            }
        });
    } catch (err) {
        console.error("Search index failed to load:", err);
    }
}

if (typeof Fuse !== "undefined") {
    initSearch();
}