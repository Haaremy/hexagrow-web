(function () {
  "use strict";

  var canvas = document.getElementById("unity-canvas");
  var loadingBar = document.getElementById("unity-loading-bar");
  var progressFull = document.getElementById("unity-progress-bar-full");
  var loadingText = document.getElementById("unity-loading-text");
  var fsButton = document.getElementById("unity-fullscreen-button");
  var errorBox = document.getElementById("unity-error");

  if (typeof createUnityInstance !== "function") {
    showError("Unity-Loader nicht verfügbar.");
    return;
  }

  var config = {
    dataUrl: "unity/build.data",
    frameworkUrl: "unity/build.framework.js",
    codeUrl: "unity/build.wasm",
    streamingAssetsUrl: "unity/StreamingAssets",
    companyName: "Haaremy Productions",
    productName: "Hexagrow",
    productVersion: "1.0"
  };

  createUnityInstance(canvas, config, function (progress) {
    var pct = Math.round(progress * 100);
    progressFull.style.width = pct + "%";
    loadingText.textContent = "Wird geladen… (" + pct + " %)";
  }).then(function (unityInstance) {
    loadingBar.classList.add("hidden");
    fsButton.hidden = false;
    fsButton.addEventListener("click", function () {
      unityInstance.SetFullscreen(1);
    });
  }).catch(function (message) {
    showError(typeof message === "string" ? message : "Spiel konnte nicht geladen werden.");
  });

  function showError(msg) {
    loadingBar.classList.add("hidden");
    errorBox.textContent = msg;
    errorBox.hidden = false;
  }
})();
