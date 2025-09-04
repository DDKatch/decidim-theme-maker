import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["textarea", "iframe"];

  init() {}

  connect() {
    this.send = this.send.bind(this);
    this.postCSS(this.textareaTarget.value);
  }

  send() {
    this.postCSS(this.textareaTarget.value);
  }

  postCSS(css) {
    const iframe = this.iframeTarget;
    if (!iframe || !iframe.contentWindow) return;
    iframe.contentWindow.postMessage({ type: "live-css", css }, "*");
  }
}
