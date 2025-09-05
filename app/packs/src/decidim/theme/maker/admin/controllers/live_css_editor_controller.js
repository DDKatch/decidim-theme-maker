import { Controller } from "@hotwired/stimulus";
import "ace-builds/src-noconflict/ace";
import "ace-builds/src-noconflict/theme-textmate";
import "ace-builds/src-noconflict/mode-css";

export default class extends Controller {
  static targets = [
    "textarea",
    "iframe",
    "fileInput",
    "form",
    "pageUrl",
    "globalCheckbox",
    "editor",
    // Resize-related targets
    "container",
    "leftPane",
    "rightPane",
    "handle"
  ];
  static values = { filename: String };

  init() {}

  connect() {
    this.send = this.send.bind(this);
    this.prepare = this.prepare.bind(this);
    this.toggleGlobal = this.toggleGlobal.bind(this);
    this.updateIframeFromUrl = this.updateIframeFromUrl.bind(this);
    this.fileSelected = this.fileSelected.bind(this);
    this.setupAce = this.setupAce.bind(this);
    this.handleModalFileChange = this.handleModalFileChange.bind(this);
    this.startResize = this.startResize.bind(this);
    this.onResizeMove = this.onResizeMove.bind(this);
    this.stopResize = this.stopResize.bind(this);

    // Capture initial page URL to allow restore when toggling global off
    this.initialPageUrl = this.hasPageUrlTarget ? (this.pageUrlTarget.value || "") : "";

    this.setupAce();
    this.postCSS(this.textareaTarget.value || "");

    // Ensure UI reflects current global state on load
    this.syncGlobalUI();

    // Listen for Decidim upload modal file selections (hidden input inside modal)
    // Use capture to catch events from hidden inputs before they are possibly stopped
    document.addEventListener("change", this.handleModalFileChange, true);

    // Initialize splitter positions if both panes exist
    this.initializeSplitter();
  }

  disconnect() {
    document.removeEventListener("change", this.handleModalFileChange, true);
    this.detachResizeListeners();
  }

  send() {
    const css = this.editor ? this.editor.getValue() : (this.textareaTarget.value || "");
    this.postCSS(css);
  }

  prepare(event) {
    try {
      const css = this.editor ? this.editor.getValue() : (this.textareaTarget.value || "");
      const filename = this.hasFilenameValue && this.filenameValue ? this.filenameValue : "theme.css";
      const file = new File([css], filename, { type: "text/css" });

      // Build a DataTransfer to assign a File to a hidden file input
      const dt = new DataTransfer();
      dt.items.add(file);
      this.fileInputTarget.files = dt.files;
    } catch (e) {
      // If anything goes wrong, avoid blocking submit
      // eslint-disable-next-line no-console
      console.error("Failed to prepare file from textarea", e);
    }
  }

  setupAce() {
    if (!this.hasEditorTarget) return;
    const initial = this.textareaTarget ? (this.textareaTarget.value || "") : "";
    this.editor = ace.edit(this.editorTarget);
    this.editor.setTheme("ace/theme/textmate");
    this.editor.session.setMode("ace/mode/css");
    this.editor.setShowPrintMargin(false);
    this.editor.session.setUseWrapMode(true);
    this.editor.setValue(initial, -1);
    this.editor.session.on("change", () => {
      const val = this.editor.getValue();
      if (this.textareaTarget) this.textareaTarget.value = val;
      this.send();
    });
  }

  toggleGlobal() {
    this.syncGlobalUI();
  }

  syncGlobalUI() {
    if (!this.hasPageUrlTarget || !this.hasGlobalCheckboxTarget) return;

    if (this.globalCheckboxTarget.checked) {
      // Store the original only the first time we flip to global
      if (typeof this.originalPageUrl === "undefined") {
        this.originalPageUrl = this.pageUrlTarget.value || this.initialPageUrl || "";
      }
      this.pageUrlTarget.value = document.location.origin;
      // Make it read-only so it submits but cannot be edited
      this.pageUrlTarget.setAttribute("readonly", "readonly");
      this.pageUrlTarget.setAttribute("aria-disabled", "true");
    } else {
      // Restore previously stored value when leaving global mode
      const restore = typeof this.originalPageUrl !== "undefined" ? this.originalPageUrl : this.initialPageUrl;
      this.pageUrlTarget.removeAttribute("readonly");
      this.pageUrlTarget.removeAttribute("aria-disabled");
      this.pageUrlTarget.value = restore || "";
    }

    this.updateIframe();
  }

  postCSS(css) {
    console.log("POST CSS")
    const iframe = this.iframeTarget;
    if (!iframe || !iframe.contentWindow) return;
    iframe.contentWindow.postMessage({ type: "live-css", css }, "*");
  }

  updateIframeFromUrl(event) {
    if (event && typeof event.preventDefault === "function") {
      event.preventDefault();
    }
    if (!this.hasIframeTarget || !this.hasPageUrlTarget) return;

    this.updateIframe();
  }

  updateIframe() {
    const raw = this.pageUrlTarget.value || "/";
    const previewUrl = raw.includes("?") ? `${raw}&live_preview=1` : `${raw}?live_preview=1`;
    this.iframeTarget.src = previewUrl;
  }

  fileSelected(event) {
    try {
      const input = event?.target || this.fileInputTarget;
      if (!input) return;
      const file = input.files && input.files[0];
      if (!file) {
        if (this.hasTextareaTarget) this.textareaTarget.value = "";
        return;
      }
      const reader = new FileReader();
      reader.onload = () => {
        if (this.hasTextareaTarget) {
          this.textareaTarget.value = reader.result || "";
          // Optionally update live preview if available
          this.send();
        }
      };
      reader.readAsText(file);
    } catch (e) {
      // eslint-disable-next-line no-console
      console.error("Failed to read selected file", e);
    }
  }

  // Capture file selection from Decidim's upload modal (file input inside the modal)
  handleModalFileChange(event) {
    try {
      const target = event.target;
      if (!target || target.tagName !== "INPUT" || target.type !== "file") return;

      // Ensure this is the Decidim upload modal input for our :file attribute
      const dropzone = target.closest('[data-dropzone]');
      if (!dropzone) return;
      const attributeName = dropzone.dataset.name;
      if (attributeName !== "file") return;

      const file = target.files && target.files[0];
      if (!file) return;
      // Only process CSS files
      const isCss = (file.type === "text/css") || (/\.css$/i).test(file.name || "");
      if (!isCss) return;

      const reader = new FileReader();
      reader.onload = () => {
        const content = reader.result || "";
        if (this.editor) {
          this.editor.setValue(content, -1);
        }
        if (this.hasTextareaTarget) {
          this.textareaTarget.value = content;
        }
        this.send();
      };
      reader.readAsText(file);
    } catch (e) {
      // eslint-disable-next-line no-console
      console.error("Failed to handle modal file change", e);
    }
  }

  // --- Splitter / Resize logic ---
  initializeSplitter() {
    if (!this.hasContainerTarget || !this.hasLeftPaneTarget || !this.hasRightPaneTarget || !this.hasHandleTarget) return;

    // Ensure container is positioned for correct calculations
    const container = this.containerTarget;
    if (getComputedStyle(container).position === "static") {
      container.style.position = "relative";
    }

    // Set initial widths based on existing layout
    // Left is 30% by default per view; ensure right takes remaining space
    this.leftPaneTarget.style.flex = "0 0 30%";
    this.rightPaneTarget.style.flex = "1 1 auto";

    // Clean any inline widths that might conflict
    this.leftPaneTarget.style.width = "auto";
    this.rightPaneTarget.style.width = "auto";
  }

  startResize(event) {
    if (!this.hasContainerTarget || !this.hasLeftPaneTarget || !this.hasRightPaneTarget) return;
    event.preventDefault();

    const isTouch = event.type === "touchstart";
    const point = isTouch ? event.touches[0] : event;

    const rect = this.containerTarget.getBoundingClientRect();
    this._resizeState = {
      containerLeft: rect.left,
      containerWidth: rect.width,
      startX: point.clientX
    };

    // Attach listeners to window to track outside container
    window.addEventListener("mousemove", this.onResizeMove, { passive: false });
    window.addEventListener("touchmove", this.onResizeMove, { passive: false });
    window.addEventListener("mouseup", this.stopResize);
    window.addEventListener("touchend", this.stopResize);
  }

  onResizeMove(event) {
    if (!this._resizeState) return;
    const isTouch = event.type === "touchmove";
    const point = isTouch ? event.touches[0] : event;

    // Prevent page scroll while resizing on touch
    if (isTouch) {
      event.preventDefault();
    }

    const { containerLeft, containerWidth } = this._resizeState;
    const x = point.clientX - containerLeft;
    const minLeftPct = 10; // minimum 10%
    const maxLeftPct = 80; // maximum 80%
    let leftPct = (x / containerWidth) * 100;
    if (leftPct < minLeftPct) leftPct = minLeftPct;
    if (leftPct > maxLeftPct) leftPct = maxLeftPct;

    this.leftPaneTarget.style.flex = `0 0 ${leftPct}%`;
    this.rightPaneTarget.style.flex = "1 1 auto";

    // Trigger layout for Ace editor to adapt
    if (this.editor) {
      this.editor.resize();
    }
  }

  stopResize() {
    this.detachResizeListeners();
    this._resizeState = null;
    if (this.editor) {
      this.editor.resize();
    }
  }

  detachResizeListeners() {
    window.removeEventListener("mousemove", this.onResizeMove, { passive: false });
    window.removeEventListener("touchmove", this.onResizeMove, { passive: false });
    window.removeEventListener("mouseup", this.stopResize);
    window.removeEventListener("touchend", this.stopResize);
  }
}
