async function initSearch() {
  try {
    const res = await fetch(window.searchIndex);
    const data = await res.json();

    const options = {
      keys: ["title", "content"],
      threshold: 0.4,
      includeMatches: true,
    };

    const fuse = new Fuse(data, options);
    const input = document.getElementById("searchInput");
    const results = document.getElementById("customResults");
    const buttonContainer = document.querySelector(".button-container");

    document.getElementById("lucky-btn").addEventListener("click", async () => {
        const currentPath = window.location.pathname;
        const newPath = currentPath.endsWith('/') ? currentPath + 'quiz/' : currentPath + '/quiz/';
        window.location.href = newPath;
    });

    input.addEventListener("input", () => {
      const query = input.value.trim();
      if (query.length > 0) {
        // 1. Perform the search
        console.log("Searching for:", query);
        const searchResults = fuse.search(query);

        // 2. Clear previous results and hide roadmap
        results.innerHTML = "";

        // hide the buttons when showing search results
        buttonContainer.style.display = "none";
        // ensure results use the compact search styling 
        results.classList.add("search-results");
        if (searchResults.length > 0) {
          // 3. Draw the new results
          searchResults.slice(0, 12).forEach((result) => {
            const item = result.item;
            const a = document.createElement("li");
            const title = item.title || item.Title || item.name || "";
            a.href = item.permalink || "#";
            a.innerHTML = `<a href="${item.permalink}" class="result-link">
                <span class="result-title">${item.title}</span>
            </a>`;
            results.appendChild(a);
          });
          results.style.display = "flex";
        } else {
          // No matches found
          results.innerHTML =
            '<div style="padding:1rem; opacity:0.5;">No labs found...</div>';
          results.style.display = "block";
        }
      } else {
        // 4. Search is empty: Reset the view
        results.style.display = "none";
        results.classList.remove("search-results");
         buttonContainer.style.display = "block";
      }
    });

    // Allow Escape to clear search and restore roadmap
    input.addEventListener("keydown", (e) => {
      if (e.key === "Escape") {
        input.value = "";
        results.style.display = "none";
        results.classList.remove("search-results");
      }
    });
  } catch (err) {
    console.error("Search index failed to load:", err);
  }
}

if (typeof Fuse !== "undefined") {
  initSearch();
}
