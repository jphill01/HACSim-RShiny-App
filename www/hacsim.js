// HACSim Shiny app: small client-side helpers.
// 1. Tells the stylesheet which page is showing, so each page gets its own background.
// 2. Makes any element with data-goto="<tab value>" switch to that tab.
// 3. Scrolls the Result Panel into view when a simulation starts.
// 4. Shows a "Top" button on long pages.
(function () {
  "use strict";

  function setPage(value) {
    document.body.setAttribute("data-page", value || "home");
  }

  document.addEventListener("DOMContentLoaded", function () {
    var active = document.querySelector('.navbar .nav-link.active');
    setPage(active ? active.getAttribute("data-value") : "home");

    // Shiny reports the selected navbar tab as input$nav.
    if (window.jQuery) {
      window.jQuery(document).on("shiny:inputchanged", function (event) {
        if (event.name === "nav") {
          setPage(event.value);
          window.scrollTo(0, 0);
        }
      });
    }

    // Fallback that does not depend on Shiny: Bootstrap fires this when a tab is shown.
    document.addEventListener("shown.bs.tab", function (event) {
      var link = event.target;
      if (link && link.closest && link.closest(".navbar")) {
        setPage(link.getAttribute("data-value"));
      }
    });

    // Buttons and logo that jump to another tab.
    document.addEventListener("click", function (event) {
      var trigger = event.target.closest ? event.target.closest("[data-goto]") : null;
      if (!trigger) return;
      event.preventDefault();
      var target = trigger.getAttribute("data-goto");
      var link = document.querySelector('.navbar a[data-value="' + target + '"]');
      if (link) link.click();
    });

    // Back to top
    var top = document.createElement("button");
    top.type = "button";
    top.className = "hs-top";
    top.setAttribute("aria-label", "Back to top");
    top.textContent = "Top";
    document.body.appendChild(top);
    top.addEventListener("click", function () {
      window.scrollTo({ top: 0, behavior: "auto" });
    });
    window.addEventListener("scroll", function () {
      top.classList.toggle("is-visible", window.scrollY > 400);
    }, { passive: true });
  });

  // Sent by the server when Run is clicked.
  function registerHandlers() {
    if (!window.Shiny || !window.Shiny.addCustomMessageHandler) return;
    window.Shiny.addCustomMessageHandler("hs-scroll", function (selector) {
      var el = document.querySelector(selector);
      if (!el) return;
      var calm = window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches;
      el.scrollIntoView({ behavior: calm ? "auto" : "smooth", block: "start" });
    });
  }
  document.addEventListener("DOMContentLoaded", registerHandlers);
})();
