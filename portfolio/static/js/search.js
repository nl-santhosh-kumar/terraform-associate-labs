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

        input.addEventListener('input', () => {
            const query = input.value.trim();

            if (query.length > 0) {
                // 1. Perform the search
                const searchResults = fuse.search(query);

                // 2. Clear previous results and hide roadmap
                results.innerHTML = '';
                roadmap.style.opacity = '0.1';
                roadmap.style.pointerEvents = 'none';

                if (searchResults.length > 0) {
                    // 3. Draw the new results
                    searchResults.slice(0, 5).forEach(result => {
                        const item = result.item;
                        const li = document.createElement('li');
                        li.innerHTML = `<a href="${item.permalink}">${item.title}</a>`;
                        results.appendChild(li);
                    });
                    results.style.display = 'block';
                } else {
                    // No matches found
                    results.innerHTML = '<li style="padding:1rem; opacity:0.5;">No labs found...</li>';
                    results.style.display = 'block';
                }
            } else {
                // 4. Search is empty: Reset the view
                results.style.display = 'none';
                roadmap.style.opacity = '1';
                roadmap.style.pointerEvents = 'auto';
            }
        });
    } catch (err) {
        console.error("Search index failed to load:", err);
    }
}

if (typeof Fuse !== "undefined") {
    initSearch();
}