import { Application } from "@hotwired/stimulus";
import LiveCssEditorController from "./live_css_editor_controller";
import SplitPaneController from "./split_pane_controller";

const application = Application.start();
application.register("live-css-editor", LiveCssEditorController);
application.register("split-pane", SplitPaneController);
