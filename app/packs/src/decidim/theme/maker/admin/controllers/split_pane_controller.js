import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["container", "left", "right", "handle", "iframe"];

  connect() {
    this.startResize = this.startResize.bind(this);
    this.onResizeMove = this.onResizeMove.bind(this);
    this.stopResize = this.stopResize.bind(this);

    this.initializeSplitter();
  }

  disconnect() {
    this.detachResizeListeners();
    this.enableIframePointerEvents();
  }

  initializeSplitter() {
    if (!this.hasContainerTarget || !this.hasLeftTarget || !this.hasRightTarget) return;
    const container = this.containerTarget;
    if (getComputedStyle(container).position === "static") {
      container.style.position = "relative";
    }

    // Default layout: left 30%, right grows
    this.leftTarget.style.flex = "0 0 30%";
    this.rightTarget.style.flex = "1 1 auto";
    this.leftTarget.style.width = "auto";
    this.rightTarget.style.width = "auto";
  }

  startResize(event) {
    if (!this.hasContainerTarget) return;
    event.preventDefault();

    const isTouch = event.type === "touchstart";
    const point = isTouch ? event.touches[0] : event;
    const rect = this.containerTarget.getBoundingClientRect();
    this._resizeState = {
      containerLeft: rect.left,
      containerWidth: rect.width,
      startX: point.clientX
    };

    window.addEventListener("mousemove", this.onResizeMove, { passive: false });
    window.addEventListener("touchmove", this.onResizeMove, { passive: false });
    window.addEventListener("mouseup", this.stopResize);
    window.addEventListener("touchend", this.stopResize);

    this.disableIframePointerEvents();
    this.dispatch("start");
  }

  onResizeMove(event) {
    if (!this._resizeState) return;
    const isTouch = event.type === "touchmove";
    const point = isTouch ? event.touches[0] : event;
    if (isTouch) event.preventDefault();

    const { containerLeft, containerWidth } = this._resizeState;
    const x = point.clientX - containerLeft;
    const minLeftPct = 10;
    const maxLeftPct = 80;
    let leftPct = (x / containerWidth) * 100;
    if (leftPct < minLeftPct) leftPct = minLeftPct;
    if (leftPct > maxLeftPct) leftPct = maxLeftPct;

    this.leftTarget.style.flex = `0 0 ${leftPct}%`;
    this.rightTarget.style.flex = "1 1 auto";

    this.dispatch("move", { detail: { leftPercent: leftPct } });
  }

  stopResize() {
    this.detachResizeListeners();
    this._resizeState = null;
    this.enableIframePointerEvents();
    this.dispatch("stop");
  }

  detachResizeListeners() {
    window.removeEventListener("mousemove", this.onResizeMove, { passive: false });
    window.removeEventListener("touchmove", this.onResizeMove, { passive: false });
    window.removeEventListener("mouseup", this.stopResize);
    window.removeEventListener("touchend", this.stopResize);
  }

  disableIframePointerEvents() {
    try {
      if (this.hasIframeTarget && this.iframeTarget) {
        this._iframePrevPointerEvents = this.iframeTarget.style.pointerEvents;
        this.iframeTarget.style.pointerEvents = "none";
      }
    } catch (_) {}
  }

  enableIframePointerEvents() {
    try {
      if (this.hasIframeTarget && this.iframeTarget) {
        this.iframeTarget.style.pointerEvents = this._iframePrevPointerEvents || "";
        this._iframePrevPointerEvents = null;
      }
    } catch (_) {}
  }
}
