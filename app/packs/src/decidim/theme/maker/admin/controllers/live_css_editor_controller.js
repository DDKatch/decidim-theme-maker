import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["textarea", "iframe", "fileInput", "form"];
  static values = { filename: String };

  init() {}

  connect() {
    this.send = this.send.bind(this);
    this.prepare = this.prepare.bind(this);
    this.postCSS(this.textareaTarget.value);
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

  postCSS(css) {
    const iframe = this.iframeTarget;
    if (!iframe || !iframe.contentWindow) return;
    iframe.contentWindow.postMessage({ type: "live-css", css }, "*");
  }
}
