import { Application } from "@hotwired/stimulus";
import LiveCssEditorController from "./live_css_editor_controller";

const application = Application.start();
application.register("live-css-editor", LiveCssEditorController);
