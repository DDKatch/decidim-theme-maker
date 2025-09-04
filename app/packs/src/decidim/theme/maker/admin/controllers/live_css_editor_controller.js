import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["textarea", "iframe", "fileInput", "form", "pageUrl", "globalCheckbox"];
  static values = { filename: String };

  init() {}

  connect() {
    this.send = this.send.bind(this);
    this.prepare = this.prepare.bind(this);
    this.toggleGlobal = this.toggleGlobal.bind(this);
    this.updateIframeFromUrl = this.updateIframeFromUrl.bind(this);
    this.fileSelected = this.fileSelected.bind(this);

    // Capture initial page URL to allow restore when toggling global off
    this.initialPageUrl = this.hasPageUrlTarget ? (this.pageUrlTarget.value || "") : "";

    this.postCSS(this.textareaTarget.value);

    // Ensure UI reflects current global state on load
    this.syncGlobalUI();
  }

  send() {
    this.postCSS(this.textareaTarget.value);
  }

  prepare(event) {
    try {
      const css = this.textareaTarget.value || "";
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
}
