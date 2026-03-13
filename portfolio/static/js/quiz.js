// 1. DATA INITIALIZATION
  const engine = document.getElementById("quiz-engine");
  const allQuestionsPool = JSON.parse(engine.getAttribute("data-questions"));

  let sessionQuestions = [];
  let currentIdx = 0;
  let score = 0;
  let answerKey = null;

  // 2. LIFECYCLE
  document.addEventListener("DOMContentLoaded", () => {
    const nextBtn = document.getElementById("next-btn");
    if (nextBtn) {
      nextBtn.onclick = () => {
        currentIdx++;
        if (currentIdx < sessionQuestions.length) {
          renderQuestion();
        } else {
          showResults();
        }
      };
    }

    const questionsData = engine.getAttribute('data-questions');
        const answersUrl = engine.getAttribute('data-answers'); // No more window object!
        
        allQuestionsPool = JSON.parse(questionsData);
        
        // 2. Store the URL in a local variable for the fetch function
        // We can attach it to our local state instead of 'window'
        quizState.answersUrl = answersUrl;

    showMenu();
  });

  // 3. CORE FUNCTIONS
  function showMenu() {
    const categoryIcons = {
      General: "⚙️",
      Modules: "📦",
      State: "💾",
      Variables: "🔧",
      CLI: "💻",
      Cloud: "☁️",
      Workflow: "🔄",
      Provisioners: "🚀",
      all: "🏁", // For the Full Mixed Exam button
    };

    const qBody = document.getElementById("q-body");
    const qHeader = document.getElementById("q-header");
    const nextBtn = document.getElementById("next-btn");

    if (nextBtn) nextBtn.style.display = "none";
    if (qHeader) qHeader.style.visibility = "hidden";

    const categories = [
      ...new Set(allQuestionsPool.map((q) => q.category || "General")),
    ];

    qBody.innerHTML = `
            <div class="results-screen">
                <h2 style="margin-bottom:20px; color:#844FBA;">Terraform Practice Exam</h2>
                <p style="margin-bottom:20px;">Select a category to begin 10 random questions:</p>
                <div class="options-grid">
                    <button class="opt-btn" onclick="startQuiz(10, 'all')" style="text-align:center; font-weight:bold; border-color:#844FBA;">🚀 Full Mixed Exam</button>
                    ${categories
                      .map(
                        (cat) => {
                            const icon = categoryIcons[cat] || "📄";
                            return `
                            <button class="opt-btn" onclick="startQuiz(10, '${cat}')" style="text-align:center; ">
                                <span style="display:block;">${icon} ${cat}</span>
                                </button>
                                `;
                                }
                    ,
                      )
                      .join("")}
                </div>
            </div>
        `;
  }

  async function startQuiz(count, category) {
    currentIdx = 0;
    score = 0;
    document.getElementById("q-score").innerText = `Score: 0`;
    document.getElementById("q-header").style.visibility = "visible";

    if (!answerKey) {
      try {
        const response = await fetch('{{ "answers_master.json" | absURL }}');
        if (!response.ok) throw new Error("Answer key not found");
        answerKey = await response.json();
      } catch (err) {
        document.getElementById("q-body").innerHTML =
          `<p style="color:red">Error loading quiz data.</p>`;
        return;
      }
    }

    let pool =
      category === "all"
        ? allQuestionsPool
        : allQuestionsPool.filter((q) => q.category === category);

    sessionQuestions = [...pool]
      .sort(() => 0.5 - Math.random())
      .slice(0, count);

    renderQuestion();
  }

  function renderQuestion() {
    const q = sessionQuestions[currentIdx];
    const qBody = document.getElementById("q-body");
    const nextBtn = document.getElementById("next-btn");
    const progressFill = document.getElementById("progress-fill");

    nextBtn.style.display = "none";
    document.getElementById("q-feedback").innerHTML = "";

    const progressPercent = (currentIdx / sessionQuestions.length) * 100;
    progressFill.style.width = `${progressPercent}%`;
    document.getElementById("q-progress-text").innerText =
      `Question ${currentIdx + 1} of ${sessionQuestions.length}`;

    qBody.innerHTML = `
            <p class="question-text"><strong>${q.question}</strong></p>
            <div class="options-grid">
                ${q.options.map((o) => `<button class="opt-btn" onclick="handleSelection(this, '${q.id}')">${o}</button>`).join("")}
            </div>
        `;
  }

  function handleSelection(btn, qId) {
    const truth = answerKey[qId];
    const isCorrect = btn.innerText
      .trim()
      .toUpperCase()
      .startsWith(truth.a.toUpperCase());
    const qBody = document.getElementById("q-body");

    qBody.querySelectorAll(".opt-btn").forEach((b) => (b.disabled = true));

    if (isCorrect) {
      btn.classList.add("correct");
      score++;
    } else {
      btn.classList.add("incorrect");
    }

    document.getElementById("q-feedback").innerHTML = `
            <div class="explanation-box ${isCorrect ? "border-correct" : "border-incorrect"}">
                <strong style="color: ${isCorrect ? "#2ecc71" : "#e74c3c"}">
                    ${isCorrect ? "✓ Correct!" : "✗ Incorrect. Answer: " + truth.a}
                </strong>
                <p class="explanation-text">${truth.e}</p>
            </div>
        `;

    document.getElementById("q-score").innerText = `Score: ${score}`;
    const nextBtn = document.getElementById("next-btn");
    nextBtn.style.display = "block";
    if (currentIdx === sessionQuestions.length - 1)
      nextBtn.innerText = "Show Final Results";
  }

  function showResults() {
    document.getElementById("progress-fill").style.width = `100%`;
    document.getElementById("q-header").style.display = "none";
    const percentage = Math.round((score / sessionQuestions.length) * 100);

    document.getElementById("q-body").innerHTML = `
            <div class="results-screen">
                <h2>Quiz Complete!</h2>
                <div class="final-score">${score} / ${sessionQuestions.length}</div>
                <p>${percentage}% - ${percentage >= 70 ? "Ready for Exam!" : "Keep practicing!"}</p>
                <button onclick="location.reload()" class="btn-primary">Restart Quiz</button>
            </div>
        `;
    document.getElementById("q-feedback").innerHTML = "";
    document.getElementById("next-btn").style.display = "none";
  }
